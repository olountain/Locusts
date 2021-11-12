source("Analysis/R/process_data.R")
pacman::p_load(tidyverse, stringr)


# this is to be used as a second step after the data is parsed in python
# maybe I could add a reticulate call in here to do this...

get_all_summaries <- function(path = "processed_data", persistence = F) {
    csv_files <- list.files(path, ".csv", full.names = T, recursive = T)
    data_names <- list.files(path, ".csv", full.names = F, recursive = T)
    data_names <- map_chr(str_split(data_names, "/"), 1)
    
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
        persistence_data_files <- list.files(path, ".tsv", full.names = T, recursive = T)
        persistence_files <- vector(mode = 'list', length = n_files)
        for (i in 1:n_files){
            tmp <- read_csv(persistence_data_files[i])
            
            persistence_files[[i]] <- tibble(`2_norm_0` = as.numeric(tmp[1,1]),
                                             sup_norm_0 = as.numeric(tmp[2,1]),
                                             `2_norm_1` = as.numeric(tmp[3,1]),
                                             sup_norm_1 = as.numeric(tmp[4,1]),)
            
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

my_data_new <- get_all_summaries(path = "processed_data/simout/Data_for_training", persistence = T)
my_summaries_new <- my_data_new$summary
my_data_new <- my_data_new$imported_files


## get parameter values
params <- tibble()

for (i in 1:length(csv_files)) {
    tmp <- csv_files[i]
    
    tmp1 <- str_split(tmp, '/')[[1]][5]
    tmp2 <- str_split(tmp1, '-')[[1]]
    
    fa <- str_split(tmp2[1], "fa")[[1]]
    fa <- fa[length(fa)]
    
    
    
    cur_line <- tibble(
        fa = fa %>% as.numeric(),
        fr = str_split(tmp2[2], "fr")[[1]][2] %>% as.numeric(),
        fal = str_split(tmp2[3], "fal")[[1]][2] %>% as.numeric(),
        active = str_split(tmp2[4], "active")[[1]][2] %>% as.numeric(),
        pause = str_split(tmp2[5], "pause")[[1]][2] %>% as.numeric(),
        rproba = str_split(tmp2[6], "rproba")[[1]][2] %>% as.numeric(),
        occlu = str_split(tmp2[7], "occlu")[[1]][2] %>% as.numeric(),
        jumpD = str_split(tmp2[8], "jumpD")[[1]][2] %>% as.numeric()
    )
    
    params <- bind_rows(params, cur_line)

}

saveRDS(my_summaries_new, file = 'Analysis/R/data/my_summaries_new.rds')


