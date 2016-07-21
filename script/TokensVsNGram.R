source("script/loadCorpusFromFile.R")
source("script/generateNGrams.R")
source("script/generateFeaturesDF.R")

TokensVsNGram <- function(data, ns = c(1)) {
  features <- c()
  result <- list()

  require(doParallel)
  ncores <- detectCores() - 1
  options(mc.cores = ncores)
  cl <- makeCluster(ncores)
  registerDoParallel(cl)

  for (n in ns) {
    print(paste("Generating data for n =", n))

    qcorpus <- loadCorpusFromVector(data)

    tokens <- generateNGrams(qcorpus, n)
    remove("qcorpus")

    tokens <- generateFeaturesDF(tokens)
    result[[paste0(n,".df")]] <- tokens
    features <- c(features, length(tokens$ngram))
  }

  stopCluster(cl)

  result[["counts.df"]] <- data.frame(n = ns,
                                      feats = features)

  TokensVsNGram.lst <- result
  save("TokensVsNGram.lst", file="data/TokensVsNGram.RData")
}
