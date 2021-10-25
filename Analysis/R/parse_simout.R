pacman::p_load(tidyverse)


## reading and processing
tmp <- read_tsv("simout/rep43/job-fa0.01-fr0.1-fal1-active2700-pause900-rproba0.001-occlu25-jumpD0-replicat43.simout", skip = 1)



tmp2 <- tmp %>%
    filter(PARAM == "GRID") %>% 
    filter(`524288` == max(tmp$`524288`, na.rm = T))

tmp2 <- tmp2[,3:4]
colnames(tmp2) <- c("hash", "count")
tmp2



tmp2 %>% count(count) %>% arrange(count)
tmp2 %>% filter(count > 1500) %>% pull(count) %>% sum()

# tmp2 is density version, tmp3 is replicate version


tmp3 <- tmp2 %>%
    slice(rep(row_number(), count)) %>% 
    select(-count) %>%
    mutate(x = hash %% 512, y = hash %/% 512) %>% 
    select(-hash)


sample(tmp2$hash, size = 20, prob = tmp2$count, replace = T)


## TDA

install.packages("TDA", dependencies=TRUE)
pacman::p_load(TDA)

plot(tmp3)
my_smpl <- sample_n(tmp3, 700)
maxdimension <- 1    # components and loops
maxscale <- 30

my_diag <- ripsDiag(my_smpl,
                    maxdimension,
                    maxscale,
                    library = "GUDHI",
                    printProgress = TRUE)
my_diag$diagram
summary(my_diag$diagram)

plot(my_diag$diagram, barcode = T)

crater = read.table("./Analysis/R/crater.xy")
plot(crater, cex = 0.1,main = "Crater Dataset",xlab = "x",ylab="y")

# fractal dimension stuff

pacman::p_load(fractaldim)

# data must be square matrix (i.e. the grid with count vals)

my_mat <- matrix(0, 512, 512)

for (i in 1:nrow(tmp2)) {
    row <- tmp2$x[i]
    col <- tmp2$y[i]
    my_mat[row,col] <- tmp2$count[i]
}

my_mat

fd1 = fd.estim.isotropic(my_mat, nlags="auto"); fd1$fd
fd2 = fd.estim.squareincr(my_mat, nlags="auto"); fd2$fd

my_mat_1 <- matrix(0, 512, 512)

for (i in 1:nrow(tmp2)) {
    row <- tmp2$x[i]
    col <- tmp2$y[i]
    my_mat_1[row,col] <- 1
}

fd3 = fd.estim.isotropic(my_mat_1, nlags="auto"); fd3$fd
fd4 = fd.estim.squareincr(my_mat_1, nlags="auto"); fd4$fd
