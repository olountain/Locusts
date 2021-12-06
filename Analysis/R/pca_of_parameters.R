## in this file we compute PCA on the unique parameter combinations which were classified into each shape of swarm

comet_pca <- my_preds %>%
    filter(class == 'comet') %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp()
comet_pca$rotation


fan_pca <- my_preds %>%
    filter(class == 'fan') %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp()
fan_pca


compact_pca <- my_preds %>%
    filter(class == 'compact') %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp()
compact_pca


column_pca <- my_preds %>%
    filter(class == 'column') %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp()
column_pca


stream_pca <- my_preds %>%
    filter(class == 'stream') %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp()
stream_pca


other_pca <- my_preds %>%
    filter(class == 'other') %>% 
    select(c(fa:jumpD), -active, -occlu) %>% 
    unique() %>% 
    as.matrix() %>% 
    prcomp()
other_pca


