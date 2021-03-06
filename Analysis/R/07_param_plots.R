## In this file we produce plots of some parameter combinations to investigate how different parameters affect shape
# run the label all data script first to obtain the rf_param_res and labeled_data variables

# ensure that label_all_data script has been run
source("Analysis/R/04_label_all_data.R")

# vip plot
vip_plot <- rf_param_res %>% extract_fit_parsnip() %>% vip()
vip_plot


## set file type for plots
fig_type <- "pdf"
if (fig_type == "pdf") {
    save_fig <- pdf
} else if (fig_type == "png") {
    save_fig <- png
} else if (fig_type == "eps") {
    save_fig <- postscript
    setEPS()
}

# since fa and jumpD are the most important predictors, we plot the fa against jumpD with fixed values of the other
# parameters, and colour by class
# the "other" input argument is set to true by default, and determines whether the other class is included in the plots
# plots can be saved by setting the "save_plot" input argument to TRUE

param_plot <- function(other = TRUE, save_plot = FALSE) {
    
    if(!exists("i")){ # initialise integer global i
        i <<- 1
    } else if (!is.numeric(i)){
        i <<- 1
    } else if (round(i != i)) {
        i <<- 1
    } else if (i < 1) {
        i <<- 1
    }
    
    param_combos <- labeled_data %>%
        select(fr, fal, rproba, pause) %>%
        unique()
    
    fr_ <- param_combos$fr[i]
    fal_ <- param_combos$fal[i]
    rproba_ <- param_combos$rproba[i]
    pause_ <- param_combos$pause[i]
    
    i <<- i + 1
    
    
    if (save_plot) {
        save_fig(paste("Analysis/Plots/Parameter_combinations/" ,"param_plots_fr=", fr_, "_fal=",
                       fal_, "_rproba=", rproba_, "_pause=", pause_, "/comet_biplot.png", sep = ""))
    }
    
    if(other) {
        labeled_data %>%
            filter(fr == fr_) %>%
            filter(fal == fal_) %>%
            filter(rproba == rproba_) %>%
            filter(pause == pause_) %>% 
            ggplot(aes(fa, jumpD, color = class)) +
            geom_jitter(height = 0.02) +
            ggtitle(paste("fr =", fr_, ", fal =", fal_, ", rproba =", rproba_, ", pause =", pause_))    
    } else {
        labeled_data %>%
            filter(class != "other") %>% 
            filter(fr == fr_) %>%
            filter(fal == fal_) %>%
            filter(rproba == rproba_) %>%
            filter(pause == pause_) %>% 
            ggplot(aes(fa, jumpD, color = class)) +
            geom_jitter(height = 0.02) +
            ggtitle(paste("fr =", fr_, ", fal =", fal_, ", rproba =", rproba_, ", pause =", pause_))
    }
    
    if (save_plot) { dev.off() }
    
}


param_plot(other = T, save_plot = F)






