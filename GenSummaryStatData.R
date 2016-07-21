source("script/TokensVsNGram.R")
data <- readLines("data/en_US.blogs.txt.0.01")
TokensVsNGram(data, seq(1,25))
remove("data")

source("script/TokensVsSizeData.R")
TokensVsSizeData(c(0.001, 0.005, 0.01, 0.05, 0.1, 0.2, 0.4, 0.8))
TokensVsSizeData.noStops(c(0.001, 0.005, 0.01, 0.05, 0.1, 0.2, 0.4, 0.8))

source("script/GenerateDeltaFeatureData.R")
GenerateDeltaFeatureData()
