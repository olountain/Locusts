## In this script we check whether any two simulation runs with the same parameters resulted in receiving different
# labels (using the first model which assigns labels based on summary statistics)

# run the script to label all data first (either manually or with the following line of code) 
source("Analysis/R/04_label_all_data.R")

# get all parameter combinations
param_combos <- labeled_data %>%
    select(fa, fr, fal, rproba, pause, jumpD) %>%
    unique()

# logical vector indicating whether all reps of the same param combo result in one classification
one_class <- !logical(nrow(param_combos))

# character vector to store the modal label for each parameter combination
modal_classes <- character(nrow(param_combos))

# integer vector to store the frequency of the modal label
# if one_class[i] is TRUE, then modal_frequency[i] should be 20
modal_frequency <- integer(nrow(param_combos))


for (i in 1:nrow(param_combos)) {
    
    fa_ <- param_combos$fa[i]
    fr_ <- param_combos$fr[i]
    fal_ <- param_combos$fal[i]
    rproba_ <- param_combos$rproba[i]
    pause_ <- param_combos$pause[i]
    jumpD_ <- param_combos$jumpD[i]
    
    cur_classes <- labeled_data %>%
        filter(fa == fa_) %>%
        filter(fr == fr_) %>%
        filter(fal == fal_) %>%
        filter(rproba == rproba_) %>%
        filter(pause == pause_) %>% 
        filter(jumpD == jumpD_) %>%
        pull(class)
    
    modal_classes[i] <- cur_classes %>%
        as_tibble() %>%
        count(value) %>%
        arrange(-n) %>%
        slice(1) %>%
        pull(value) %>% 
        as.character()
    
    modal_frequency[i] <- cur_classes %>%
        as_tibble() %>%
        count(value) %>%
        arrange(-n) %>%
        slice(1) %>%
        pull(n)
    
    cur_length <- cur_classes %>% unique() %>% length()
    
    if (cur_length > 1) {one_class[i] <- FALSE}
}

# proportion of param combos for which every rep receives the same label
mean(one_class) # 0.769

# example of param combo receiving different labels
labeled_data %>%
    filter(fa == param_combos$fa[which(!one_class)[1]]) %>%
    filter(fr == param_combos$fr[which(!one_class)[1]]) %>%
    filter(fal == param_combos$fal[which(!one_class)[1]]) %>%
    filter(rproba == param_combos$rproba[which(!one_class)[1]]) %>%
    filter(pause == param_combos$pause[which(!one_class)[1]]) %>% 
    filter(jumpD == param_combos$jumpD[which(!one_class)[1]])

