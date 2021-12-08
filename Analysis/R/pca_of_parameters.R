## in this file we compute PCA on the unique parameter combinations which were classified into each shape of swarm
# this is calculated separately for each class

comet_pca <- my_preds %>%
    filter(class == 'comet') %>% 
    mutate_at(.vars = vars(fa:jumpD), as.numeric) %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp(scale. = T)

png("Analysis/Plots/PCA/comet_biplot.png", width = 512, height = 512)
biplot(comet_pca)
dev.off()


fan_pca <- my_preds %>%
    filter(class == 'fan') %>% 
    mutate_at(.vars = vars(fa:jumpD), as.numeric) %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp()

png("Analysis/Plots/PCA/fan_biplot.png", width = 512, height = 512)
biplot(fan_pca)
dev.off()


compact_pca <- my_preds %>%
    filter(class == 'compact') %>% 
    mutate_at(.vars = vars(fa:jumpD), as.numeric) %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp(scale. = T)

png("Analysis/Plots/PCA/compact_biplot.png", width = 512, height = 512)
biplot(compact_pca)
dev.off()


column_pca <- my_preds %>%
    filter(class == 'column') %>% 
    mutate_at(.vars = vars(fa:jumpD), as.numeric) %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp(scale. = T)

png("Analysis/Plots/PCA/column_biplot.png", width = 512, height = 512)
biplot(column_pca)
dev.off()


stream_pca <- my_preds %>%
    filter(class == 'stream') %>% 
    mutate_at(.vars = vars(fa:jumpD), as.numeric) %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp(scale. = T)

png("Analysis/Plots/PCA/stream_biplot.png", width = 512, height = 512)
biplot(stream_pca)
dev.off()


other_pca <- my_preds %>%
    filter(class == 'other') %>% 
    mutate_at(.vars = vars(fa:jumpD), as.numeric) %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp(scale. = T)

png("Analysis/Plots/PCA/other_biplot.png", width = 512, height = 512)
biplot(other_pca)
dev.off()


