
# Tokenize a corpus using N-Grams
generateNGrams <- function(corpus, n=1) {
  require(doParallel)
  ncores <- detectCores() - 1
  options(mc.cores = ncores)
  cl <- makeCluster(ncores)
  registerDoParallel(cl)

  result <- quanteda::tokenize(corpus,
                               what="word",
                               ngrams=n,
                               concatenator="_",
                               removePunct=FALSE,
                               verbose=FALSE,
                               simplify=FALSE)

  stopCluster(cl)
  return(result)
}
