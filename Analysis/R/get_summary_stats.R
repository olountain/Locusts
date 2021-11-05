source("Analysis/R/process_data.R")
pacman::p_load(tidyverse, stringr)


# this is to be used as a second step after the data is parsed in python
# maybe I could add a reticulate call in here to do this...

get_all_summaries <- function(path = "processed_data", persistence = F) {
    csv_files <- list.files(path, ".csv", full.names = T, recursive = T)
    data_names <- list.files(path, ".csv", full.names = F, recursive = T)
    data_names <- map_chr(str_split(data_names, "/"), 2)
    
    n_files <- length(csv_files)
    indices <- as.character(1:n_files)
    
    imported_files <- vector(mode = 'list', length = n_files)
    summaries <- vector(mode = 'list', length = n_files)
    
    for (i in 1:n_files){
        imported_files[[i]] <- read_csv(csv_files[i])
        summaries[[i]] <- get_summary(imported_files[[i]])
    }
    
    summaries <- tibble(class = data_names) %>%
        bind_cols(bind_rows(summaries))
    
    
    if (persistence) {
        persistence_data_files <- list.files(path, ".txt", full.names = T, recursive = T)
        persistence_files <- vector(mode = 'list', length = n_files)
        for (i in 1:n_files){
            tmp <- read_csv(persistence_data_files[i]) %>% pull(`2_norm_0`)
            
            persistence_files[[i]] <- tibble(`2_norm_0` = tmp[1],
                                             sup_norm_0 = tmp[2],
                                             `2_norm_1` = tmp[3],
                                             sup_norm_1 = tmp[4])
            
        }
        
        persistence_summary <- persistence_files %>% map_dfr(~ bind_rows(.))
        
        summaries <- bind_cols(summaries, persistence_summary)
        
    }
    
    return(list(imported_files = imported_files,
                summary = summaries))
    
}


## Driver
my_data <- get_all_summaries(path = "processed_data/simout/all_data", persistence = T)

my_summaries <- my_data$summary
my_data <- my_data$imported_files
