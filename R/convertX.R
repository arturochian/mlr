# start is a named list, flatten it to an unnamed num vec, of correct order as in par.set
convertStartToNumeric = function(start, par.set) {
  ids = getParamIds(par.set, repeated = FALSE)
  start = start[ids]
  as.numeric(unlist(start))
}

convertXNumeric = function(x, par.set) {
  ids = getParamIds(par.set, repeated = TRUE, with.nr = FALSE)
  # factor usually does sort(unique(...)) for levels which changes order!
  x = split(x, factor(ids, levels = unique(ids)))
  names(x) = getParamIds(par.set, repeated = FALSE)
  roundIntegers(x, par.set = par.set)
}


convertXMatrixCols = function(xs, par.set) {
  rownames(xs) = colnames(xs) = NULL
  xs = lapply(seq_col(xs), function(i) {
    convertXNumeric(xs[, i], par.set)
  })
}

# convert logical param values from chars to true logicals, eg irace produces strings in tuning
convertXLogicalsNotAsStrings = function(x, par.set) {
  types = getParamTypes(par.set, use.names = TRUE)
  j = types %in% c("logical", "logicalvector")
  if (any(j))
    x[j] = lapply(x[j], as.logical)
  return(x)
}

roundIntegers = function(x, par.set) {
  Map(function(par, v) {
    if (par$type %in% c("integer", "integervector"))
      as.integer(round(v))
    else
      v
  }, par.set$pars, x)
}
