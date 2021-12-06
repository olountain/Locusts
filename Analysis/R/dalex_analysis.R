pacman::p_load(DALEX)

explainer <- explain(rf_param_res$fit$fit$fit, data = my_train[,c(1,2,3,5,6,8)], y = my_train$class)
explainer

m_parts <- model_parts(explainer)
m_parts
plot(m_parts)

m_profile <- model_profile(explainer = explainer, variables = c("fa", "jumpD"), variable_type = "categorical")
m_profile
plot(m_profile)

m_pred_parts = predict_parts(explainer = explainer, new_observation = my_test[1,], type = "break_down")
m_pred_parts
plot(m_pred_parts)

