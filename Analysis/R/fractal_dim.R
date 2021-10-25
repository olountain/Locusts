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





















