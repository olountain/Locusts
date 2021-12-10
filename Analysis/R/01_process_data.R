#### Functions required to get summary statistics of individual simulation runs.
# This file is imported by get_summary_stats.R.

# import packages
pacman::p_load(tidyverse,fractaldim,moments)


## Function to calculate fractal dimension
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

## Function to get the x and y rotation and standard deviation of the first
# two principal components
get_pca <- function(data){
    
    my_pca <- prcomp(data[,1:2])
    rot_x <- my_pca$rotation[1,1]
    rot_y <- my_pca$rotation[2,1]
    stdev_1 <- my_pca$sdev[1]
    stdev_2 <- my_pca$sdev[2]
    
    return(tibble(rot_x, rot_y, stdev_1, stdev_2))
}

## Function to get summary statistics of a simulation. Uses get_fd() and get_pca()
get_summary <- function(data, data_thresh = 5, thresh = 10){
    
    data <- data %>% filter(z > data_thresh)
    
    x_spread <- max(data$x) - min(data$x)
    y_spread <- max(data$y) - min(data$y)
    
    num_sqrs <- nrow(data)
    
    above_thresh <- data %>% filter(z > thresh)
    prop_above_thresh <- nrow(above_thresh) / nrow(data)
    
    fd <- get_fd(data)
    
    my_pca <- get_pca(data)
    
    z_skew <- skewness(data$z)
    
    out <- tibble(x_spread, y_spread, x_to_y = x_spread/y_spread,
                  num_sqrs, prop_above_thresh, fractal_dim = fd,  z_skew)
    
    out <- bind_cols(out, my_pca)
    
    return(out)
    
}


#### Driver
