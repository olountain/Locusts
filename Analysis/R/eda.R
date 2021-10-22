### explorarory analysis
pacman::p_load(tidyverse)


## reading and processing
tmp <- read_tsv("simout/rep43/job-fa0.01-fr0.1-fal1-active2700-pause900-rproba0.001-occlu25-jumpD0-replicat43.simout", skip = 1)



tmp2 <- tmp %>%
    filter(PARAM == "GRID") %>% 
    filter(`524288` == max(tmp$`524288`, na.rm = T))

tmp2 <- tmp2[,3:4]
colnames(tmp2) <- c("hash", "count")
tmp2 <- tmp2 %>%
    mutate(x = hash %% 512, y = hash %/% 512)



## trimming the data
tmp2_trim <- tmp2 %>% filter(count > 5)

opar <- par(mfrow = c(1,2))
plot(tmp2_trim$x, tmp2_trim$y, xlim = c(0,170), ylim = c(190,330))
plot(tmp2$x, tmp2$y, xlim = c(0,170), ylim = c(190,330))
par(opar)

## resampling the data
sampled_rows <- sample(1:nrow(tmp2), size = 2000, prob = tmp2$count, replace = T)
tmp2_smpl <- tmp2[sampled_rows,]

opar <- par(mfrow = c(1,2))
plot(tmp2_smpl$x, tmp2_smpl$y, xlim = c(0,170), ylim = c(190,330))
plot(tmp2$x, tmp2$y, xlim = c(0,170), ylim = c(190,330))
par(opar)




fd.estimate(as.matrix(my_smpl), methods = 'transect.incr1', window.size = 10)