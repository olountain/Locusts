pacman::p_load(tidyverse,
               fractaldim)
## read data


## reading files
## comet
file <- "Analysis/R/data/comet_data.csv"
comet <- read_csv(file)
get_fd(comet)
# 2.716

## compact
file <- "Analysis/R/data/compact_data.csv"
compact <- read_csv(file)
get_fd(compact)
# 2.342

## dense blob
file <- "Analysis/R/data/dense_blob_data.csv"
dense_blob <- read_csv(file)
get_fd(dense_blob)
# 2.681

## dense fanning blob
file <- "Analysis/R/data/dense_fanning_blob_data.csv"
dense_fanning_blob <- read_csv(file)
get_fd(dense_fanning_blob)
# 2.669

## dense squiggly blob
file <- "Analysis/R/data/dense_squiggly_blob_data.csv"
dense_squiggly_blob <- read_csv(file)
get_fd(dense_squiggly_blob)
# 2.45

## dense streams
file <- "Analysis/R/data/dense_streams_data.csv"
dense_streams <- read_csv(file)
get_fd(dense_streams)
# 2.856

## fanning streams
file <- "Analysis/R/data/fanning_streams_data.csv"
fanning_streams <- read_csv(file)
get_fd(fanning_streams)
# 3.097

## loose fan
file <- "Analysis/R/data/loose_fan_data.csv"
loose_fan <- read_csv(file)
get_fd(loose_fan)
# 2.728

## get fractal dimension

get_fd <- function(data, type = "iso") {
    my_mat <- matrix(0, 512, 512)
    
    for (i in 1:nrow(data)) {
        row <- data$x[i]
        col <- data$y[i]
        my_mat[row,col] <- data$z[i]
    }
    
    
    if (type == "iso") {
        fd <- fd.estim.isotropic(my_mat, nlags="auto")    
    } else if (type == "sqrinc") {
        fd <- fd.estim.squareincr(my_mat, nlags="auto")
    }
    
    return(fd$fd %>% round(digits = 3))
}

### other summary stats

get_pca <- function(data){
    
    my_pca <- prcomp(data[,1:2])
    rot_x <- my_pca$rotation[1,1]
    rot_y <- my_pca$rotation[2,1]
    stdev_1 <- my_pca$sdev[1]
    stdev_2 <- my_pca$sdev[2]
    
    return(tibble(rot_x, rot_y, stdev_1, stdev_2))
}


get_summary <- function(data, thresh = 10){
    
    x_spread <- max(data$x) - min(data$x)
    y_spread <- max(data$y) - min(data$y)
    
    num_sqrs <- nrow(data)
    
    above_thresh <- data %>% filter(z > thresh)
    prop_above_thresh <- nrow(above_thresh) / nrow(data)
    
    fd <- get_fd(data)
    
    my_pca <- get_pca(data)
    
    out <- tibble(x_spread, y_spread, x_to_y = x_spread/y_spread,
                  num_sqrs, prop_above_thresh, fractal_dim = fd)
    
    out <- bind_cols(out, my_pca)
    
    return(out)
    
}


data_sets <- list(comet = comet,
                  compact = compact,
                  dense_blob = dense_blob,
                  dense_fanning_blob = dense_fanning_blob,
                  dense_squiggly_blob = dense_squiggly_blob,
                  loose_fan = loose_fan)

get_all_summaries <- function(data_sets) {
    
    out <- vector(mode = "list", length = length(data_sets))
    
    for (i in 1:length(data_sets)) {
        out[[i]] <- get_summary(data_sets[[i]])
    }
    
    tibble(data = names(data_sets)) %>%
        bind_cols(bind_rows(out)) %>%
        return()
    
}

summs <- get_all_summaries(data_sets)

summs$land_norm_0 <- c(402.729, 302.293, 314.377, 263.87, 527.477, 353.717)
summs$land_norm_1 <- c(120.879, 37.158, 47.232, 61.38, 45.091, 90.509)

summs

corrplot::corrplot(cor(summs[,-1]))

### coarsaning grid of data


coarsen_grid <- function(data, scaling_factor = 4, as_matrix = FALSE) {
    
    if(as.integer(log2(scaling_factor)) != log2(scaling_factor)){
        stop()
    }
    
    my_mat <- matrix(0, 512, 512)
    
    for (i in 1:nrow(data)) {
        row <- data$x[i]
        col <- data$y[i]
        my_mat[row,col] <- data$z[i]
    }
    
    new_dim <- 512/scaling_factor
    
    new_mat <- matrix(0, new_dim, new_dim)
    
    for (row in 1:new_dim) {
        
        row_start <- (row-1)*scaling_factor + 1
        row_end <- row * scaling_factor
        
        for (col in 1:new_dim) {
            
            col_start <- (col-1)*scaling_factor + 1
            col_end <- col * scaling_factor
            
            new_mat[row,col] <- sum(my_mat[row_start:row_end, col_start:col_end])
        }
    }
    
    
    if (as_matrix){
        return(new_mat)
    } else {
        
        new_len <- sum(new_mat > 0)
        x <- numeric(new_len)
        y <- numeric(new_len)
        z <- numeric(new_len)
        
       
        count <- 1
        
        for (row in 1:new_dim) {
            for (col in 1:new_dim){
                if(new_mat[row,col] > 0){
                    x[count] <- row
                    y[count] <- col
                    z[count] <- new_mat[row,col]
                    count <- count + 1
                }
            }
        }
        
        return(tibble(x,y,z))
    }
    
    
}


coarsen_all <- function(data_sets, scaling_factor = 4, as_matrix = FALSE){
    coarse_data_sets <- data_sets
    
    for (i in 1:length(data_sets)){
        coarse_data_sets[[i]] <- coarsen_grid(data_sets[[i]], scaling_factor, as_matrix)
    }
    
    return(coarse_data_sets)
}

coarse_data_sets <- coarsen_all(data_sets)
coarse_data_sets

coarse_data_sets %>%
    map_dfr(~ bind_rows(.), .id = "data") %>% 
    ggplot(aes(y =  z, x = data)) +
    geom_boxplot()




coarse_data_sets %>%
    map_dfr(~ bind_rows(.), .id = "data") %>%
    group_by(data) %>% summarise(summary(z)[2])








size <- 128
comet_coarse %>% ggplot(aes(x=x, y=y, fill=z)) +
    geom_tile() +
    geom_segment(aes(x=0, xend=0, y=0, yend=size), size = 1)+
    geom_segment(aes(x=size, xend=size, y=0, yend=size), size = 1)+
    geom_segment(aes(x=0, xend=size, y=0, yend=0), size = 1)+
    geom_segment(aes(x=0, xend=size, y=size, yend=size), size = 1)+
    xlim(c(0,size)) +
    ylim(c(0,size)) +
    coord_fixed() +
    scale_fill_viridis_c() +
    theme_minimal() +
    theme(panel.grid = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          legend.position = "none")

size = 512
comet %>% ggplot(aes(x=x, y=y, fill=z)) +
    geom_tile() +
    geom_segment(aes(x=0, xend=0, y=0, yend=size), size = 1)+
    geom_segment(aes(x=size, xend=size, y=0, yend=size), size = 1)+
    geom_segment(aes(x=0, xend=size, y=0, yend=0), size = 1)+
    geom_segment(aes(x=0, xend=size, y=size, yend=size), size = 1)+
    xlim(c(0,size)) +
    ylim(c(0,size)) +
    coord_fixed() +
    scale_fill_viridis_c() +
    theme_minimal() +
    theme(panel.grid = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          legend.position = "none")




