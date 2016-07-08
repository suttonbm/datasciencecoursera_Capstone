data.paths <- c("data/en_US.blogs.txt", "data/en_US.twitter.txt", "data/en_US.news.txt")
probs <- c(0.001, 0.005, 0.01, 0.05, 0.1)

for (path in data.paths) {
  data <- readLines(path)
  nLines <- length(data)
  for (p in probs) {
    set.seed(12345)
    sampleLines <- rbinom(nLines, 1, p)
    writeLines(data[sampleLines == 1], sprintf("%s.%s", path, p))
  }
}