context("regr_IBk")

test_that("regr_IBk", {
  library(RWeka)
  parset.list = list(
    list(),
    list(K = 2)
  )

  old.predicts.list = list()

  for (i in 1:length(parset.list)) {
    parset = parset.list[[i]]
    ctrl = do.call(Weka_control, parset)
    pars = list(regr.formula, data = regr.train)
    pars = c(pars, parset)
    set.seed(getOption("mlr.debug.seed"))
    m =  IBk(regr.formula, regr.train, control = ctrl)
    set.seed(getOption("mlr.debug.seed"))
    p = predict(m, newdata = regr.test)
    old.predicts.list[[i]] = p
  }

  testSimpleParsets("regr.IBk", regr.df, regr.target, regr.train.inds, old.predicts.list, parset.list)
})
