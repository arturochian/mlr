% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/setHyperPars.R
\name{setHyperPars2}
\alias{setHyperPars2}
\title{Only exported for internal use.}
\usage{
setHyperPars2(learner, par.vals,
  on.par.without.desc = getMlrOption("on.par.without.desc"),
  on.par.out.of.bounds = getMlrOption("on.par.out.of.bounds"))
}
\arguments{
\item{learner}{[\code{\link{Learner}}]\cr
The learner.}

\item{par.vals}{[\code{list}]\cr
List of named (hyper)parameter settings.}

\item{on.par.without.desc}{[\code{character(1)}]\cr
Locally overrule this option. See \code{\link{configureMlr}} for details.}

\item{on.par.out.of.bounds}{[\code{character(1)}]\cr
Locally overrule this option. See \code{\link{configureMlr}} for details.}
}
\description{
Only exported for internal use.
}

