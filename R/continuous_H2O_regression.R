#' Function to generate imputations using regression and H2O for data with a continuous outcome
#'
#' @param Y Vector of observed values of the variable to be imputed.
#' @param X Numeric matrix of variables to be used as predictors in H2O methods
#' with rows corresponding to observed values of the variable to be imputed.
#' @param newdata Numeric matrix of variables to as predictors in H2O methods
#' with rows corresponding to missing values of the variable to be imputed. The
#' H2O model makes predictions from this matrix to determine the
#' imputation-generating distribution.
#' @param SL.library List of functions and parameters to be passed on to the
#' H2O function
#' @return Numeric vector of randomly generated imputed values.
#'


#Continuous H2O regression
continuous.H2O = function(Y, X, newdata, SL.library){
  h2oModels = lapply(SL.library, function(h2oArgs, EX, Y){
    f.h2o = h2oArgs[[1]]
    if(is.null(h2oArgs$keep_cross_validation_predictions) ||
       !h2oArgs$keep_cross_validation_predictions){
      h2oArgs$keep_cross_validation_predictions = TRUE
    }
    if(is.null(h2oArgs$nfolds)){
      h2oArgs$nfolds = 5
    }
    if(!is.null(h2oArgs$interaction_pairs)){
      h2oArgs$interaction_pairs = lapply(h2oArgs$interaction_pairs,
                                         function(pair, varNames){
                                           c(varNames[pair[1]],
                                             varNames[pair[2]])
                                         }, varNames = colnames(EX))
    }
    f.args = c(list(x = 2:(ncol(EX) + 1), y = 1,
                    training_frame = as.h2o(data.frame(cbind(Y, EX)))),
               h2oArgs[-1])
    do.call(f.h2o, f.args)
  }, EX = X, Y = Y)

  namesArgs = names(args)
  namesSL = names(formals(h2o.stackedEnsemble))
  formals(h2o.stackedEnsemble)[intersect(namesArgs, namesSL)] <- args[
    intersect(namesArgs, namesSL)]
  sl <- h2o.stackedEnsemble(x = 2:(ncol(X) + 1), y = 1,
                            training_frame = as.h2o(data.frame(cbind(Y, X))),
                            base_models = h2oModels)
  # if(is.null(h2oArgs$interaction_pairs)){
  mu <- as.vector(h2o.predict(sl, newdata = as.h2o(newdata)))
  # }
  # else{
  #   newdata
  #   mu <- as.vector(h2o.predict(sl, newdata = as.h2o(newdata)))
  # }

  MSE <- sl@model$training_metrics@metrics$MSE
  sd <- sqrt(MSE * (1 + 1 / nrow(X)))

}
