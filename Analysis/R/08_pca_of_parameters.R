## in this file we compute PCA on the unique parameter combinations which were classified into each shape of swarm
# this is calculated separately for each class

# ensure that label_all_data script has been run
source("Analysis/R/04_label_all_data.R")

# load packages
pacman::p_load(tidyverse, ggfortify)

## set file type for plots
fig_type <- "pdf"
if (fig_type == "pdf") {
    save_fig <- pdf
} else if (fig_type == "png") {
    save_fig <- png
} else if (fig_type == "eps") {
    save_fig <- postscript
    setEPS()
}

# compute pca for unique parameter combinations in comet class
comet_pca <- my_preds %>%
    filter(class == 'comet') %>% 
    mutate_at(.vars = vars(fa:jumpD), as.numeric) %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp(scale. = T)

# biplot
save_fig(paste("Analysis/Plots/PCA/pca_of_parameters_comet_biplot.", fig_type, sep = ""))
autoplot(comet_pca, loadings = TRUE, loadings.label = TRUE,
         loadings.label.size = 5, loadings.colour = 'blue', loadings.label.colour = 'blue', main = "Comet")
dev.off()


fan_pca <- my_preds %>%
    filter(class == 'fan') %>% 
    mutate_at(.vars = vars(fa:jumpD), as.numeric) %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp()

save_fig(paste("Analysis/Plots/PCA/pca_of_parameters_fan_biplot.", fig_type, sep = ""))
autoplot(fan_pca, loadings = TRUE, loadings.label = TRUE,
         loadings.label.size = 5, loadings.colour = 'blue', loadings.label.colour = 'blue', main = "Fan") 
dev.off()


compact_pca <- my_preds %>%
    filter(class == 'compact') %>% 
    mutate_at(.vars = vars(fa:jumpD), as.numeric) %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp(scale. = T)

save_fig(paste("Analysis/Plots/PCA/pca_of_parameters_compact_biplot.", fig_type, sep = ""))
autoplot(compact_pca, loadings = TRUE, loadings.label = TRUE,
         loadings.label.size = 5, loadings.colour = 'blue', loadings.label.colour = 'blue', main = "Compact")
dev.off()


column_pca <- my_preds %>%
    filter(class == 'column') %>% 
    mutate_at(.vars = vars(fa:jumpD), as.numeric) %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp(scale. = T)

save_fig(paste("Analysis/Plots/PCA/pca_of_parameters_column_biplot.", fig_type, sep = ""))
autoplot(column_pca, loadings = TRUE, loadings.label = TRUE,
         loadings.label.size = 5, loadings.colour = 'blue', loadings.label.colour = 'blue', main = "Column")
dev.off()


stream_pca <- my_preds %>%
    filter(class == 'stream') %>% 
    mutate_at(.vars = vars(fa:jumpD), as.numeric) %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp(scale. = T)

save_fig(paste("Analysis/Plots/PCA/pca_of_parameters_stream_biplot.", fig_type, sep = ""))
autoplot(stream_pca, loadings = TRUE, loadings.label = TRUE,
         loadings.label.size = 5, loadings.colour = 'blue', loadings.label.colour = 'blue', main = "Stream")
dev.off()


other_pca <- my_preds %>%
    filter(class == 'other') %>% 
    mutate_at(.vars = vars(fa:jumpD), as.numeric) %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp(scale. = T)

save_fig(paste("Analysis/Plots/PCA/pca_of_parameters_other_biplot.", fig_type, sep = ""))
autoplot(other_pca, loadings = TRUE, loadings.label = TRUE,
         loadings.label.size = 5, loadings.colour = 'blue', loadings.label.colour = 'blue', main = "Other")
dev.off()


