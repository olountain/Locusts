# analysis of parameters using the DALEX package for explainable AI

# load package
pacman::p_load(DALEX)

# ensure that label_all_data script has been run
source("Analysis/R/04_label_all_data.R")


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

# create explainer variable
explainer <- explain(rf_param_res$fit$fit$fit, data = my_train[,c(1,2,3,5,6,8)], y = my_train$class, label = "")
explainer

## Global methods

# Variable importance
m_parts <- model_parts(explainer)
m_parts
save_fig(paste("Analysis/Plots/DALEX/dalex_analysis_vip.", fig_type, sep = ""))
plot(m_parts) + labs(subtitle = NULL) 
dev.off()

# Partial dependence profile comparing fa and jumpD
m_profile <- model_profile(explainer = explainer, variables = c("fa", "jumpD"), variable_type = "categorical")
m_profile
save_fig(paste("Analysis/Plots/DALEX/dalex_analysis_partial_dependence.", fig_type, sep = ""))
plot(m_profile) + labs(subtitle = NULL) 
dev.off()


## Local methods

# Break down method
m_breakdown <- predict_parts(explainer = explainer, new_observation = my_test[1,], type = "break_down")
m_breakdown
save_fig(paste("Analysis/Plots/DALEX/dalex_analysis_breakdown.", fig_type, sep = ""))
plot(m_breakdown)
dev.off()

# Shapley values
m_shapley <- predict_parts(explainer = explainer, new_observation = my_test[1,], type = "shap")
m_shapley
save_fig(paste("Analysis/Plots/DALEX/dalex_analysis_shapley.", fig_type, sep = ""))
plot(m_shapley)
dev.off()


# struggling to get the plots for the next methods working. I think it's to do with us having categorical variables
# LIME method
pacman::p_load(lime)
explain_lime <- lime(my_train[,c(1,2,3,5,6,8,9)], rf_param_res$fit$fit$fit)
mod_lime <- explain(my_test[1,c(1,2,3,5,8,9)], explain_lime, n_features = 5)

# Ceteris Paribus profile
m_cpprofile <- predict_profile(explainer = explainer, new_observation = my_test[1,])
m_cpprofile
plot(m_cpprofile)
