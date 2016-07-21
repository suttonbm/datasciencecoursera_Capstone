source("script/getFeatureStats.R")

# Given a text corpus, calculate feature statistics for a random subset of the
# corpus, selected via a binomial RV with p specified as below
getFeatureStatsForSample <- function(data, p, rm.stopwords=F) {
  nLines <- length(data)

  result <- list()

  require(doParallel)
  ncores <- detectCores() - 1
  options(mc.cores = ncores)
  cl <- makeCluster(ncores)
  registerDoParallel(cl)

  print(paste0("Generating data for p = ", p))
  set.seed(p*1000)
  sampleLines <- rbinom(nLines, 1, p)
  sample.data <- data[sampleLines == 1]

  stats <- getFeatureStats(sample.data, rm.stopwords)
  stats$size <- object.size(sample.data)[1]
  stats$p <- paste0("p = ", p)

  remove("data")
  remove("sample.data")

  stopCluster(cl)

  return(stats)
}
