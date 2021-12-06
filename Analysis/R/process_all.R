#### Script to process the large batches of simulation runs. This should not need to be run again as all of
# the processed data has been saved as an RDS file as can be seen in a commented line below.

# import the functions to produce the summary stats
source("Analysis/R/process_data.R")
source("Analysis/R/get_summary_stats.R")

# tictoc package to time the code
pacman::p_load(tictoc)

# each of the four sets of runs were processed separately to avoid crashing my computer.
tic()
all_data_0 <- get_all_summaries(path = "processed_data/Desktop/simout_files/run-121914-cuspp-couple0")
toc()
# saveRDS(all_data_0, file = 'Analysis/R/data/all_data_0.rds')
all_data_0 <- readRDS(file = 'Analysis/R/data/all_data_0.rds')

tic()
all_data_1 <- get_all_summaries(path = "processed_data/Desktop/simout_files/run-121918-cuspp-couple1")
toc()
# saveRDS(all_data_1, file = 'Analysis/R/data/all_data_1.rds')
all_data_1 <- readRDS(file = 'Analysis/R/data/all_data_1.rds')

tic()
all_data_2 <- get_all_summaries(path = "processed_data/Desktop/simout_files/run-121915-cuspp-couple2")
toc()
# saveRDS(all_data_2, file = 'Analysis/R/data/all_data_2.rds')
all_data_2 <- readRDS(file = 'Analysis/R/data/all_data_2.rds')

tic()
all_data_3 <- get_all_summaries(path = "processed_data/Desktop/simout_files/run-121913-cuspp-couple3")
toc()
# saveRDS(all_data_3, file = 'Analysis/R/data/all_data_3.rds')
all_data_3 <- readRDS(file = 'Analysis/R/data/all_data_3.rds')

# combining the data sets into one variable
all_data <- rbind(all_data_0, all_data_1, all_data_2, all_data_3)
# saveRDS(all_data, file = 'Analysis/R/data/all_data.rds')


## the following code parsed the file names of each simulation in order to determine the parameter combinations
# stringr is required for this
pacman::p_load(stringr)

params <- tibble()

for (i in 1:nrow(all_data)) {
    tmp <- all_data$class[i]

    # tmp1 <- str_split(tmp, '/')[[1]][5]
    tmp2 <- str_split(tmp, '-')[[1]]

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

# view the data with parameters
bind_cols(params, all_data) %>% select(-class)




