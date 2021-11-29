## labelling all the data

pacman::p_load(tidyverse, tidymodels, themis, rpart, ranger, caret)

my_summaries_new <- readRDS(file = 'Analysis/R/data/my_summaries_new.rds')
my_summaries_with_col <- readRDS(file = 'Analysis/R/data/my_summaries_with_col.rds') %>% mutate(class = as.factor(class))

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
    


predict(dt_res, new_data = my_test, type = 'prob')
predict(rf_res, new_data = my_test, type = 'prob')


all_data <- readRDS(file = 'Analysis/R/data/all_data.rds')

labeled_data <- 
    bind_cols(params,
          predict(rf_res, new_data = all_data),
          predict(rf_res, new_data = all_data, type = 'prob')) %>% 
    rename(class = .pred_class) %>% 
    rename_with(stringr::str_replace, pattern = ".pred",
                replacement = "prop", matches(".pred"))

saveRDS(labeled_data, file = 'Analysis/R/data/labeled_data.rds')
labeled_data <- readRDS(file = 'Analysis/R/data/labeled_data.rds')
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
    set_engine("ranger")

rf_param_res <- workflow() %>% 
    add_recipe(my_recipe) %>% 
    add_model(rf_param_spec) %>% 
    fit(my_train)

predict(rf_param_res, new_data = my_test) %>% pull(.pred_class) %>% confusionMatrix(reference = my_test$class)


rf_param_res %>% collect_metrics()

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

all_files <- list.files('processed_data/Desktop/simout_files', ".csv", full.names = T, recursive = T)
sample_indices <- sample(1:length(all_files), size = 50, replace = F)
sample_files <- all_files[sample_indices]
labeled_data$class[sample_indices]




