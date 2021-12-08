# analysis of parameters using the DALEX package for explainable AI

# load package
pacman::p_load(DALEX)

# create explainer variable
explainer <- explain(rf_param_res$fit$fit$fit, data = my_train[,c(1,2,3,5,6,8)], y = my_train$class)
explainer

## Global methods

# Variable importance
m_parts <- model_parts(explainer)
m_parts
png("Analysis/Plots/DALEX/vip.png", width = 512, height = 512)
plot(m_parts)
dev.off()

# Partial dependence profile comparing fa and jumpD
m_profile <- model_profile(explainer = explainer, variables = c("fa"), variable_type = "categorical")
m_profile
png("Analysis/Plots/DALEX/partial_dependence.png", width = 512, height = 512)
plot(m_profile)
dev.off()


## Local methods

# Break down method
m_breakdown <- predict_parts(explainer = explainer, new_observation = my_test[1,], type = "break_down")
m_breakdown
png("Analysis/Plots/DALEX/breakdown.png", width = 512, height = 512)
plot(m_breakdown)
dev.off()

# Shapley values
m_shapley <- predict_parts(explainer = explainer, new_observation = my_test[1,], type = "shap")
m_shapley
png("Analysis/Plots/DALEX/shapley.png", width = 512, height = 512)
plot(m_shapley)
dev.off()


# struggling to get the plots for the next methods working. I think it's to do with us having categorical variables
# LIME method
pacman::p_load(lime)
explain_lime <- lime(my_train[,c(1,2,3,5,6,8,9)], rf_param_res$fit$fit$fit)
mod_lime <- explain(my_test[1,c(1,2,3,5,8,9)], explain_lime, n_features = 5)

# Ceteris Paribus profile
m_cpprofile <- predict_profile(explainer = explainer, new_observation = my_test[1,])
x
plot(m_cpprofile)
