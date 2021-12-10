# plot of a single decision tree 

source("Analysis/R/04_label_all_data.R")

set.seed(123)
my_split <- initial_split(labeled_data %>% mutate_at(vars(fa:jumpD), as.factor), strata = class)
my_split <- initial_split(labeled_data, strata = class)
my_train <- training(my_split)
my_test <- testing(my_split)

my_recipe <- recipe(class ~ fa + fr + fal + pause + rproba + jumpD, data = my_train) %>% 
    step_downsample(class)

dt_param_spec <- decision_tree() %>% 
    set_mode("classification") %>% 
    set_engine("rpart")
    
dt_param_res <- workflow() %>% 
    add_recipe(my_recipe) %>% 
    add_model(dt_param_spec) %>% 
    last_fit(my_split)

    
pdf("Analysis/Plots/Parameter_combinations/classifier/single_decision_tree_plot.pdf")
dt_param_res$.workflow[[1]]$fit$fit$fit %>% rpart.plot()
dev.off()
