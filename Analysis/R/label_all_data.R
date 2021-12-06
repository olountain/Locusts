## labelling all the data

pacman::p_load(tidyverse, tidymodels, themis, rpart, ranger, caret, vip, rpart.plot)

# old data set without column class
# my_summaries_new <- readRDS(file = 'Analysis/R/data/my_summaries_new.rds')
# new data set with column class
my_summaries_with_col <- readRDS(file = 'Analysis/R/data/my_summaries_with_col.rds') %>% mutate(class = as.factor(class))
# data verified in app
new_summaries <- readRDS(file = 'Analysis/R/data/verified_data_summary.rds')
my_summaries_with_col <- bind_rows(my_summaries_with_col, new_summaries)

set.seed(123)
my_split <- initial_split(my_summaries_with_col, strata = class)
my_train <- training(my_split)
my_test <- testing(my_split)

dt_model <- decision_tree() %>% 
    set_mode("classification") %>% 
    set_engine("rpart") %>%
    fit(class ~ x_to_y + num_sqrs + fractal_dim + z_skew, data = my_train)

dt_preds <- predict(dt_model, new_data = my_test, type = 'prob') %>%
    bind_cols(predict(dt_model, new_data = my_test)) %>% 
    bind_cols(my_test %>% select(class))


my_recipe <- recipe(class ~ x_to_y + num_sqrs + fractal_dim + z_skew, data = my_train) %>% 
    step_smote(class)

dt_spec <- decision_tree() %>% 
    set_mode("classification") %>% 
    set_engine("rpart")

dt_res <- workflow() %>% 
    add_recipe(my_recipe) %>% 
    add_model(dt_spec) %>% 
    last_fit(my_split)

dt_res %>% collect_metrics()

rf_spec <- rand_forest() %>% 
    set_mode("classification") %>% 
    set_engine("ranger")

rf_res <- workflow() %>% 
    add_recipe(my_recipe) %>% 
    add_model(rf_spec) %>% 
    fit(my_train)

workflow() %>% 
    add_recipe(my_recipe) %>% 
    add_model(rf_spec) %>% 
    last_fit(my_split) %>% 
    collect_metrics()

    


predict(dt_res, new_data = my_test, type = 'prob')
predict(rf_res, new_data = my_test, type = 'prob')


all_data <- readRDS(file = 'Analysis/R/data/all_data.rds')

labeled_data <- 
    bind_cols(params,
          predict(rf_res, new_data = all_data),
          predict(rf_res, new_data = all_data, type = 'prob')) %>% 
    mutate(file = all_data$class) %>% 
    rename(class = .pred_class) %>% 
    rename_with(stringr::str_replace, pattern = ".pred",
                replacement = "prop", matches(".pred"))

saveRDS(labeled_data, file = 'Analysis/R/data/labeled_data.rds')
labeled_data <- readRDS(file = 'Analysis/R/data/labeled_data.rds')


## EDA

labeled_data %>%
    pivot_longer(starts_with("prop"), names_to = "feature", values_to = "prop")
    
labeled_data %>% 
    ggplot(aes(fa, fill = class)) +
    geom_bar()

labeled_data %>% 
    ggplot(aes(fr, fill = class)) +
    geom_bar(width = 0.35) +
    facet_wrap(~fal)

labeled_data %>% 
    ggplot(aes(fal, fill = class)) +
    geom_bar()

labeled_data %>% 
    ggplot(aes(pause, fill = class)) +
    geom_bar()

labeled_data %>% 
    ggplot(aes(rproba, fill = class)) +
    geom_bar(width = 0.1)

labeled_data %>% 
    mutate(jumpD = as.factor(jumpD)) %>% 
    ggplot(aes(jumpD, fill = class)) +
    geom_bar() +
    facet_wrap(~fa) +
    ggtitle('Facet by fa')



labeled_data %>%
    pivot_longer(c(fa,fr,fal,pause,rproba,jumpD), names_to = "param", values_to = "value") %>% 
    ggplot(aes(value, param, color = class)) +
    geom_point()


#### pairwise plots ----

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(fa, fr, color = class)) +
    geom_jitter() 

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(fa, fal, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(fa, pause, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(fa, rproba, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(fa, jumpD, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(fr, fal, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(fr, pause, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(fr, rproba, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(fr, jumpD, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(fal, pause, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(fal, rproba, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(fal, jumpD, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(pause, pause, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(pause, rproba, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(pause, jumpD, color = class)) +
    geom_jitter()

labeled_data %>% 
    filter(class != "other") %>% 
    ggplot(aes(rproba, jumpD, color = class)) +
    geom_jitter()

#### ----

## predicting label from params

set.seed(123)
my_split <- initial_split(labeled_data %>% mutate_at(vars(fa:jumpD), as.factor), strata = class)
my_split <- initial_split(labeled_data, strata = class)
my_train <- training(my_split)
my_test <- testing(my_split)

my_recipe <- recipe(class ~ fa + fr + fal + pause + rproba + jumpD, data = my_train) %>% 
    step_downsample(class)



rf_param_spec <- rand_forest() %>% 
    set_mode("classification") %>% 
    set_engine("ranger", importance = "impurity")

rf_param_res <- workflow() %>% 
    add_recipe(my_recipe) %>% 
    add_model(rf_param_spec) %>% 
    last_fit(my_split)

rf_param_res %>% collect_metrics()


# before adding verified classes
# .metric  .estimator .estimate .config             
# accuracy multiclass     0.897 Preprocessor1_Model1
# roc_auc  hand_till      0.991 Preprocessor1_Model1

# after adding verified classes
# .metric  .estimator .estimate .config             
# accuracy multiclass     0.904 Preprocessor1_Model1
# roc_auc  hand_till      0.993 Preprocessor1_Model1

# # numeric params
# .metric    .estimator .estimate .config             
# <chr>      <chr>          <dbl> <chr>               
# 1 accuracy multiclass     0.932 Preprocessor1_Model1
# 2 roc_auc  hand_till      0.996 Preprocessor1_Model1
# 
# # factor params
# .metric    .estimator .estimate .config             
# <chr>      <chr>          <dbl> <chr>               
# 1 accuracy multiclass     0.945 Preprocessor1_Model1
# 2 roc_auc  hand_till      0.997 Preprocessor1_Model1


rf_param_res <- workflow() %>% 
    add_recipe(my_recipe) %>% 
    add_model(rf_param_spec) %>% 
    fit(my_train)


my_preds <- predict(rf_param_res, new_data = my_test) %>% bind_cols(my_test)

comet_rproba1 <- my_preds %>% filter(.pred_class == 'comet') %>% filter(rproba == 1)


my_preds %>% pull(.pred_class) %>% confusionMatrix(reference = my_test$class)

vip_plot <- rf_param_res %>% extract_fit_parsnip() %>% vip()

all_files <- list.files('processed_data/Desktop/simout_files', ".csv", full.names = T, recursive = T)
sample_indices <- sample(1:length(all_files), size = 50, replace = F)
sample_files <- all_files[sample_indices]
labeled_data$class[sample_indices]

dt_param_spec <- decision_tree() %>% 
    set_mode("classification") %>% 
    set_engine("rpart")

dt_param_res <- workflow() %>% 
    add_recipe(my_recipe) %>% 
    add_model(dt_param_spec) %>% 
    fit(my_split)

dt_param_res$.workflow[[1]]$fit$fit$fit %>% rpart.plot()



## find weird comets


i <- 64
list.files(path = "processed_data/Desktop/simout_files", recursive = T, pattern = comet_rproba1$file[i], full.names = T)[1] %>% 
    read_csv() %>% 
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
          legend.position = "none",
          plot.title = element_text(hjust = 0.5)) +
    ggtitle(str_remove(str_remove(comet_rproba1$file[i], '-active2700'), 'occlu25-'))





# groups
# 1-3
# 4-6
# 7-13
# 14-19
# 20-25
# 26-33
# 34-40
# 41
# 42-46
# 47-50
# 51-54
# 55-57
# 58-61
# 62-63
# 64-69

