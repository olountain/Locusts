## multivariate regression

param_tibble <- bind_cols(params, my_summaries_trim)

set.seed(123)
my_split <- initial_split(param_tibble, strata = class)
my_train <- training(my_split)
my_test <- testing(my_split)



m1 <- lm(cbind(x_to_y, num_sqrs, fractal_dim, z_skew) ~ fa + fr + fal + pause + rproba + jumpD, data = lm_train)
summary(m1)
plot(m1)

rf_test <- cbind(rf_test %>% select(class), predict(m1, newdata = lm_test)) %>% as_tibble()


## random forests all the way down

rf_reg <- rand_forest() %>% 
    set_mode("regression") %>% 
    set_engine("ranger")

rf_x_to_y <- rf_reg %>% fit(x_to_y ~ fa + fr + fal + pause + rproba + jumpD, data = lm_train)

metric_preds <- my_test %>% select(class) %>% bind_cols(predict(rf_x_to_y, new_data = my_test)) %>% rename(x_to_y = .pred)

rf_num_sqrs <- rf_reg %>% fit(num_sqrs ~ fa + fr + fal + pause + rproba + jumpD, data = lm_train)

metric_preds <- metric_preds %>%  bind_cols(predict(rf_num_sqrs, new_data = my_test)) %>% rename(num_sqrs = .pred)

rf_fractal_dim <- rf_reg %>% fit(fractal_dim ~ fa + fr + fal + pause + rproba + jumpD, data = lm_train)

metric_preds <- metric_preds %>%  bind_cols(predict(rf_fractal_dim, new_data = my_test)) %>% rename(fractal_dim = .pred)

rf_z_skew <- rf_reg %>% fit(z_skew ~ fa + fr + fal + pause + rproba + jumpD, data = lm_train)

metric_preds <- metric_preds %>%  bind_cols(predict(rf_z_skew, new_data = my_test)) %>% rename(z_skew = .pred)

rf_sup_norm_0 <- rf_reg %>% fit(sup_norm_0 ~ fa + fr + fal + pause + rproba + jumpD, data = lm_train)

metric_preds <- metric_preds %>%  bind_cols(predict(rf_sup_norm_0, new_data = my_test)) %>% rename(sup_norm_0 = .pred)

rf_sup_norm_1 <- rf_reg %>% fit(sup_norm_1 ~ fa + fr + fal + pause + rproba + jumpD, data = lm_train)

metric_preds <- metric_preds %>%  bind_cols(predict(rf_sup_norm_1, new_data = my_test)) %>% rename(sup_norm_1 = .pred)


metric_preds %>%
    select(-class) %>%
    gather(key = "metric", value = "truth") %>% 
    bind_cols(my_test %>%
                  select(x_to_y, num_sqrs, fractal_dim, z_skew, sup_norm_0, sup_norm_1) %>%
                  gather(key = "metric", value = "predicted") %>% 
                  select(-metric)) %>% 
    ggplot(aes(x = predicted, y= truth)) +
    geom_point() +
    geom_abline() +
    facet_wrap(facets = vars(metric), scales = 'free') +
    theme_bw() +
    theme(strip.text.x = element_text(size = 16),
          axis.title = element_text(size = 16))
    





rf_class <- rand_forest() %>% 
    set_mode("classification") %>% 
    set_engine("ranger")


rf_model <- rf_class %>% fit(class ~ x_to_y + num_sqrs + fractal_dim + z_skew, data = my_train)

rf_preds <- predict(rf_model, new_data = metric_preds, type = 'prob') %>% bind_cols(my_test %>% select(class))

bind_cols(metric_preds, predict(rf_model, new_data = metric_preds)) %>% 
    precision(class, .pred_class) %>% 
    bind_rows(
        bind_cols(metric_preds %>% select(class), predict(rf_model, new_data = metric_preds, type = 'prob')) %>% 
            roc_auc(truth = class, .pred_comet, .pred_compact, .pred_fan, .pred_other, .pred_stream)        
    )



rf_preds %>% mutate(a = .pred_class == class) %>% pull(a) %>% mean 
