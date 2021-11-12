# naive classifier

obs <- important_summs[7 ,]    


naive_classifier <- function(obs) {
    if (obs$x_to_y < 1){
        class <- "fan"
    } else {
        if (obs$x_to_y > 2.5){
            class <- "stream"
        } else {
            if (obs$sup_norm_1 > 3){
                class <- "comet"
            } else {
                if (obs$sup_norm_0 > 12){
                    class <- "dense_blob"
                } else {
                    class <- "compact"
                }
            }
        }
    }
    
    return(class)
}

my_summaries


pred_classes <- character(length = nrow(my_summaries))

for (i in 1:nrow(my_summaries)){
    pred_classes[i] <- naive_classifier(my_summaries[i,])
}

my_summaries$pred_classes <- pred_classes

mean(my_summaries$pred_classes == my_summaries$class)

my_summaries %>% filter(class == 'comet') %>% 
    mutate(eq = pred_classes == class) %>% 
    pull(eq) %>% mean

my_summaries %>% group_by(class) %>% 
    summarise(acc = mean(pred_classes == class))

my_summaries %>% group_by(pred_classes) %>% 
    summarise(acc = mean(pred_classes == class))

my_levels <- c(my_summaries$pred_classes, my_summaries$class) %>% unique()

confusionMatrix(factor(my_summaries$pred_classes, levels = my_levels), reference = factor(my_summaries$class, levels = my_levels))


## random forest

train_ind <- sample(1:nrow(my_summaries))
test_ind <- train_ind[1:20]
train_ind <- train_ind[-c(1:20)]

my_predictors <- my_summaries %>% select(-class, -pred_classes)
my_rf <- randomForest(x = my_predictors[train_ind,], y = my_summaries$class[train_ind,],
                      xtest = my_predictors[test_ind,])
my_rf$predicted
