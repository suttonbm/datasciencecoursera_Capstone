source('script/getFeatureStatsForSample.R')

TokensVsSizeData <- function(probs = c()) {
  data <- readLines("data/en_US.blogs.txt")
  stats <- getFeatureStatsForSample(data, 0.0001)

  for (p in probs) {
    stats <- rbind(stats, getFeatureStatsForSample(data, p))
  }

  remove("data")

  TokensVsSize.df <- stats
  save("TokensVsSize.df",
       file="data/TokensVsSize.RData")
}

TokensVsSizeData.noStops <- function(probs = c()) {
  data <- readLines("data/en_US.blogs.txt")
  stats <- getFeatureStatsForSample(data, 0.0001, T)

  for (p in probs) {
    stats <- rbind(stats, getFeatureStatsForSample(data, p, T))
  }

  remove("data")

  TokensVsSize.noStop.df <- stats
  save("TokensVsSize.noStop.df",
       file="data/TokensVsSize.noStop.RData")
}
