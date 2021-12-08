## imports
pacman::p_load(tidymodels, tidyverse, themis, ranger, rpart, tictoc)

## visualising predictors
my_summaries_new %>% 
    ggplot(aes(sup_norm_0, sup_norm_1, color = class)) +
    geom_point()

my_summaries_new %>% 
    ggplot(aes(`2_norm_0`, `2_norm_1`, color = class)) +
    geom_point()

my_summaries_new %>% 
    ggplot(aes(x_to_y, z_skew, color = class)) +
    geom_point()

my_summaries_new %>% 
    ggplot(aes(fractal_dim, stdev_1, color = class)) +
    geom_point()

my_summaries_new %>% 
    ggplot(aes(num_sqrs, prop_above_thresh, color = class)) +
    geom_point()

my_summaries_new %>% 
    ggplot(aes(x_spread, y_spread, color = class)) +
    geom_point()


## EDA
my_summaries_new %>% select(-class) %>% cor() %>% corrplot::corrplot()

my_summaries_trim <- my_summaries_new %>% 
    select(-x_spread, -y_spread, -prop_above_thresh, -stdev_1, -stdev_2, -rot_y, -`2_norm_0`, -`2_norm_1`) %>% 
    mutate(class = as_factor(class))

my_summaries_trim %>% select(-class) %>% cor() %>% corrplot::corrplot()

## random forest
set.seed(123)
my_split <- initial_split(my_summaries_trim %>% select(-pred_classes) %>% rbind(my_summaries_new), strata = class)
my_split <- initial_split(my_summaries_trim, strata = class)
my_split <- initial_split(my_summaries_new, strata = class)
my_train <- training(my_split)
my_test <- testing(my_split)

my_recipe <- recipe(class ~ ., data = my_train) %>% 
    # step_downsample(class)
    step_smote(class)

rf_spec <- rand_forest() %>% 
    set_mode("classification") %>% 
    set_engine("ranger")

rf_wf <- workflow() %>% 
    add_recipe(my_recipe) %>% 
    add_model(rf_spec)

rf_res <- rf_wf %>% 
    last_fit(my_split)

rf_res %>% 
    collect_metrics()

rf_res %>% 
    collect_predictions() %>%
    select(-id) %>% 
    filter(class == "other")

confusionMatrix(rf_res$.predictions[[1]]$.pred_class, reference = rf_res$.predictions[[1]]$class)


## iterate over parameter combinations


RF_compare_features <- function(summaries_data, n = 7, p = 4, resample = 'none', RF = TRUE) {
    
    
    combins <- vector(mode = 'list', length = choose(7,4) + choose(7,5) + choose(7,6) + choose(7,7))
    cur_ind <- 1
    for (i in p:n) {
        
        cur_combn <- combn(n,i)
        
        for (j in 1:ncol(cur_combn)) {
            combins[[cur_ind]] <- cur_combn[,j] + 1
            cur_ind <- cur_ind + 1
        }
    }
    
    set.seed(123)
    my_split <- initial_split(summaries_data, strata = class)
    my_train <- training(my_split)
    my_test <- testing(my_split)
    out <- tibble()
    
    
    for (i in 1:length(combins)) {
        
        feats <- names(summaries_data[,combins[[i]]])
        form <- formula(paste("class ~", paste(feats, collapse = " + ")))
        
        
        if (resample == 'none') {
            my_recipe <- recipe(form, data = my_train) %>% 
                step_downsample(class)
        } else if (resample == 'smote') {
            my_recipe <- recipe(form, data = my_train) %>% 
                step_smote(class)
        } else if (resample == 'down') {
            my_recipe <- recipe(form, data = my_train)
        } else {
            stop("Enter a valid resampling method")
        }
        
        
        
        if (RF) {
            rf_spec <- rand_forest() %>% 
                set_mode("classification") %>% 
                set_engine("ranger")    
        } else {
            rf_spec <- decision_tree() %>% 
                set_mode("classification") %>% 
                set_engine("rpart")
        }
        
        
        
        rf_wf <- workflow() %>% 
            add_recipe(my_recipe) %>% 
            add_model(rf_spec)
        
        rf_res <- rf_wf %>% 
            last_fit(my_split)
        
        out <- rf_res %>% 
            collect_predictions() %>% 
            mn_log_loss(class, .pred_comet:.pred_stream) %>% 
            bind_rows(rf_res %>% collect_metrics() %>% 
                          select(-.config)) %>% 
            select(-.estimator) %>% 
            pivot_wider(names_from = .metric, values_from = .estimate) %>% 
            rename(loss = mn_log_loss) %>% 
            bind_cols(tibble(n_vars = length(feats),
                             vars = paste(feats, collapse = ', '))) %>% 
            bind_rows(out)
        
    }
    
    return(out)
    
}

tic()
out <- RF_compare_features(my_summaries_trim, resample = 'smote')
toc()
# 57 seconds


out %>% ggplot(aes(y = loss, x = as.factor(n_vars))) +
    geom_boxplot()

out %>% ggplot(aes(y = accuracy, x = as.factor(n_vars))) +
    geom_boxplot()

out %>% ggplot(aes(y = accuracy, x = loss, color = as.factor(n_vars))) +
    geom_point(size = 1.5) +
    labs(color = "Number of Features")

out %>% filter(loss < 1) %>% 
    ggplot(aes(y = accuracy, x = loss, color = as.factor(n_vars))) +
    geom_point(size = 1.5) +
    labs(color = "Number of Features")

out %>% filter(accuracy == 1) %>% 
    ggplot(aes(y = accuracy, x = loss, color = as.factor(n_vars))) +
    geom_point(size = 1.5) +
    labs(color = "Number of Features")

best_models
out %>% filter(accuracy > 0.97)



## basic decision tree version
tic()
out_tree <- RF_compare_features(my_summaries_trim, resample = 'smote', RF = FALSE)
toc()

out_tree %>% ggplot(aes(y = loss, x = as.factor(n_vars))) +
    geom_boxplot()

out_tree %>% ggplot(aes(y = accuracy, x = loss, color = as.factor(n_vars))) +
    geom_point(size = 1.5) +
    labs(color = "Number of Features")

out_tree %>% filter(accuracy == 1)



## feature selection using package from github

devtools::install_github("stevenpawley/recipeselectors")




