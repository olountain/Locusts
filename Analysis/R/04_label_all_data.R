## labelling all the data


# ---- Prelim ----

pacman::p_load(tidyverse, tidymodels, themis, rpart, ranger, caret, vip, rpart.plot)

# old data set without column class
# my_summaries_new <- readRDS(file = 'Analysis/R/data/my_summaries_new.rds')
# new data set with column class
my_summaries_with_col <- readRDS(file = 'Analysis/R/data/my_summaries_with_col.rds') %>% mutate(class = as.factor(class))
# data verified in app
new_summaries <- readRDS(file = 'Analysis/R/data/verified_data_summary.rds')
my_summaries_with_col <- bind_rows(my_summaries_with_col, new_summaries)


use_saved_data <- TRUE

if (use_saved_data) {
    labeled_data <- readRDS(file = 'Analysis/R/data/labeled_data.rds')
    rf_param_res <- readRDS(file = 'Analysis/R/data/rf_param_res.rds')
    my_preds <- readRDS(file = 'Analysis/R/data/my_preds.rds')
} else {
    



# ---- Model to label the data set based on summary statistics ----
set.seed(123)
my_split <- initial_split(my_summaries_with_col, strata = class)
my_train <- training(my_split)
my_test <- testing(my_split)

my_recipe <- recipe(class ~ x_to_y + num_sqrs + fractal_dim + z_skew, data = my_train) %>% 
    step_smote(class)

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

all_data <- readRDS(file = 'Analysis/R/data/all_data.rds')

labeled_data <- 
    bind_cols(params,
          predict(rf_res, new_data = all_data),
          predict(rf_res, new_data = all_data, type = 'prob')) %>% 
    mutate(file = all_data$class) %>% 
    rename(class = .pred_class) %>% 
    rename_with(stringr::str_replace, pattern = ".pred",
                replacement = "prop", matches(".pred"))

# saveRDS(labeled_data, file = 'Analysis/R/data/labeled_data.rds')




# ---- Model to predict labels from parameters ----

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

rf_param_res <- workflow() %>% 
    add_recipe(my_recipe) %>% 
    add_model(rf_param_spec) %>% 
    fit(my_train)

# saveRDS(rf_param_res, file = 'Analysis/R/data/rf_param_res.rds')

my_preds <- predict(rf_param_res, new_data = my_test) %>% bind_cols(my_test)
# saveRDS(my_preds, file = 'Analysis/R/data/my_preds.rds')

}

make_plots <- FALSE
if (make_plots) {
    # confusion matrix
    my_preds %>% pull(.pred_class) %>% confusionMatrix(reference = my_test$class)
    
    # vip plot
    vip_plot <- rf_param_res %>% extract_fit_parsnip() %>% vip()    


# ---- plot of a single decision tree ----
    dt_param_spec <- decision_tree() %>% 
        set_mode("classification") %>% 
        set_engine("rpart")
    
    dt_param_res <- workflow() %>% 
        add_recipe(my_recipe) %>% 
        add_model(dt_param_spec) %>% 
        fit(my_split)
    
    dt_param_res$.workflow[[1]]$fit$fit$fit %>% rpart.plot()

}