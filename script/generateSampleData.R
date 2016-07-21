# Create sample data based on specified sampling probability
# and optionally save to file.
generateSampleData <- function(data, prob = 0.001) {
  nLines <- length(data)
  set.seed(prob*nLines)
  sampleLines <- rbinom(nLines, 1, prob)
  result <- data[sampleLines == 1]

  return(result)
}

batchRun <- function() {
  data.paths <- c("data/en_US.blogs.txt",
                  "data/en_US.twitter.txt",
                  "data/en_US.news.txt")
  probs <- c(.001, 0.005, 0.01, 0.05, 0.1)
  for (file in data.paths) {
    data <- readLines(file)
    for (p in probs) {
      sample <- generateSampleData(data, p)
      writeLines(sample, paste0(file, ".", p))
    }
  }
  rm(data)
}
