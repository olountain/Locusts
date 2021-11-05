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

mean(pred_classes == my_summaries$data)
