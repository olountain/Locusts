## this file was used to generate a random set of plots to be used in the verification app
# section lower down in the script was used to create training data from the verified examples
# to add to the existing training data

all_files <- list.files('processed_data/Desktop/simout_files', ".csv", full.names = T, recursive = T)
sample_indices <- sample(1:length(all_files), size = 50, replace = F)
sample_files <- all_files[sample_indices]
sample_classes <- labeled_data$class[sample_indices]
tibble(sample_classes, files = sample_files, x = as.character(1:50)) %>%
    arrange(x) %>% 
    pull(sample_classes) %>%
    write_rds('Analysis/R/verification_app/sample_classes.rds')

tic()
for (i in 1:50) {
    cur_file <- read_csv(sample_files[i])
    print(i)
    
    my_plot <- cur_file %>%
        filter(z > 10) %>% 
        ggplot(aes(x=x, y=y, fill=z)) +
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
    
    filename <- str_split(sample_files[i], '/')[[1]]
    filename <- filename[length(filename)]
    filename <- str_split(filename, '.csv')[[1]][1]
    filename <- paste('Analysis/R/verification_app/images/image', i, '.png', sep = '')
    
    ggsave(filename = filename, my_plot)
}
toc()



# ---- creating tibble of cerified data ----
my_files <- tibble(sample_classes, files = sample_files, x = as.character(1:50)) %>%
    arrange(x) %>% pull(files)

verified <- read.csv("Analysis/R/data/Label Verification.csv")

new_summaries <- vector(mode = 'list', length = length(my_files))
new_class <- character(length(my_files))
for (i in 1:length(my_files)){
    
    cur_file <- read_csv(my_files[i])
    new_summaries[[i]] <- get_summary(cur_file)
    new_class[i] <- verified$verified_class[i]

    
}
new_summaries <- tibble(class = new_class) %>% bind_cols(bind_rows(new_summaries))
saveRDS(new_summaries, 'Analysis/R/data/verified_data_summary.rds')

# ----quick check that labels and data have been correctly matched up ----
# i <- 5
# cur_file <- read_csv(my_files[i])
# verified$verified_class[i]
# cur_file %>%
#     filter(z > 10) %>% 
#     ggplot(aes(x=x, y=y, fill=z)) +
#     geom_tile() +
#     geom_segment(aes(x=0, xend=0, y=0, yend=size), size = 1)+
#     geom_segment(aes(x=size, xend=size, y=0, yend=size), size = 1)+
#     geom_segment(aes(x=0, xend=size, y=0, yend=0), size = 1)+
#     geom_segment(aes(x=0, xend=size, y=size, yend=size), size = 1)+
#     xlim(c(0,size)) +
#     ylim(c(0,size)) +
#     coord_fixed() +
#     scale_fill_viridis_c() +
#     theme_minimal() +
#     theme(panel.grid = element_blank(),
#           axis.text = element_blank(),
#           axis.ticks = element_blank(),
#           axis.title = element_blank(),
#           legend.position = "none")











    
