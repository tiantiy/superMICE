% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mice_impute_h2o_norm.R
\name{mice.impute.h2o.norm}
\alias{mice.impute.h2o.norm}
\title{Method for \code{mice} using the normal SuperLearner model fit
using \code{h2o}.}
\usage{
mice.impute.h2o.norm(y, ry, x, wy = NULL, h2o.models)
}
\arguments{
\item{y}{Vector to be imputed}

\item{ry}{Logical vector of length length(y) indicating the the subset y[ry]
of elements in y to which the imputation model is fitted. The ry generally
distinguishes the observed (TRUE) and missing values (FALSE) in y.}

\item{x}{Numeric design matrix with length(y) rows with predictors for y.
Matrix x may have no missing values.}

\item{wy}{Logical vector of length length(y). A TRUE value indicates
locations in y for which imputations are created.}

\item{SL.library}{For SuperLearner: Either a character vector of prediction
algorithms or list containing character vectors as specified by the
SuperLearner package.  For h2o, a named list of character vectors specifying
prediction algorithms and arguments to be passed to h2o.  See details below
for examples on the structure.}

\item{SL.CV}{Logical.  If true cv.SuperLearner is used to estimate the risk.}

\item{SL.backend}{Backend to fit the SuperLearner models.  Must be
one of "SuperLearner" or "h2o".}

\item{imputation.method}{Method used to randomly generate imputed values.
Must be one of "Regression" or "PMM".}

\item{donors}{If PMM imputation method is being used, this is the number
of donors from which to draw an imputed value.}

\item{...}{Further arguments passed to \code{SuperLearner} or \code{h2o}.}
}
\value{
Vector with imputed data, same type as y, and of length sum(wy)
}
\description{
Calculates imputations for univariate missing data by the normal model.
Parameters for the normal distribution generating the data are determined
using a SuperLearner model fit in H2O.
}