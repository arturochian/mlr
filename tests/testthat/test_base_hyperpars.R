context("hyperpars")

test_that("hyperpars", {
  lrn = makeLearner("classif.rpart", minsplit = 10)
  expect_equal(getHyperPars(lrn), list(xval = 0, minsplit = 10))

  m = train(lrn, task = multiclass.task)
  expect_true(!inherits(m, "FailureModel"))
  expect_equal(getHyperPars(m$learner), list(xval = 0, minsplit = 10))

  # test a more complex param object
  lrn = makeLearner("classif.ksvm", class.weights = c(setosa = 1, versicolor = 2, virginica = 3))
  m = train(lrn, task = multiclass.task)

  # # check warnings
  mlr.opts = getMlrOptions()
  configureMlr(on.par.without.desc = "warn", show.learner.output = FALSE)
  expect_warning(makeLearner("classif.rpart", foo = 1), "Setting parameter foo without")
  configureMlr(on.par.without.desc = "quiet")
  expect_that(makeLearner("classif.rpart", foo = 1), not(gives_warning()))
  configureMlr(show.learner.output = FALSE)
  do.call(configureMlr, mlr.opts)
})


test_that("removing par settings works", {
  lrn = makeLearner("classif.qda")
  expect_error(removeHyperPars(lrn, "minsplit"), "Trying to remove")
  expect_error(removeHyperPars(lrn, "xxx"), "Trying to remove")
  lrn2 = setHyperPars(lrn, method = "mve", nu = 7)
  lrn3 = removeHyperPars(lrn2, "method")
  expect_equal(getHyperPars(lrn3), list(nu = 7))

  # now with wrapper
  lrn = makeBaggingWrapper(makeLearner("classif.qda"))
  lrn2 = setHyperPars(lrn, method = "mve", bw.iters = 9)
  lrn3 = removeHyperPars(lrn2, "method")
  expect_equal(getHyperPars(lrn3), list(bw.iters = 9))
  lrn3 = removeHyperPars(lrn2, "bw.iters")
  expect_equal(getHyperPars(lrn3), list(method = "mve"))

})

test_that("setting 'when' works for hyperpars", {
  lrn = makeLearner("regr.mock4", p1 = 1, p2 = 2, p3 = 3)
  hps = getHyperPars(lrn)
  expect_equal(hps, list(p1 = 1, p2 = 2, p3 = 3))
  # model stores p1 + p3 in fit, adds p2,p3 in predict to this (so it predicts constant val)
  m = train(lrn, regr.task)
  expect_equal(m$learner.model, list(foo = 1 + 3))
  p = predict(m, regr.task)
  expect_equal(p$data$response, rep(1+2+2*3, regr.task$task.desc$size))
})



test_that("options are respected", {
  mlr.opts = getMlrOptions()
  configureMlr()
  lrn = makeLearner("classif.mock2")
  expect_error(setHyperPars(lrn, beta = 1), "available description object")
  expect_warning(setHyperPars(lrn, beta = 1, on.par.without.desc = "warn"), , "available description object")
  expect_is(setHyperPars(lrn, beta = 1, on.par.without.desc = "quiet"), "Learner")

  expect_error(setHyperPars(lrn, alpha = 2), "feasible")
  expect_warning(setHyperPars(lrn, alpha = 2, on.par.out.of.bounds = "warn"), , "feasible")
  expect_is(setHyperPars(lrn, alpha = 2, on.par.out.of.bounds = "quiet"), "Learner")
  do.call(configureMlr, mlr.opts)
})
