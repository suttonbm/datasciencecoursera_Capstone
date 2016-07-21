# Generate RData files with tokenized data for analysis

source('script/loadCorpusFromFile.R')
source('script/generateNGrams.R')
source('script/generateFeaturesDF.R')

doData <- function(data, out.file, rm.stopwords=T) {

  corpus <- loadCorpusFromVector(data, rm.stopwords)

  for (n in seq(1,3)) {
    tokens <- generateNGrams(corpus, n)
    df <- generateFeaturesDF(tokens)
    remove("tokens")
    save("df", file=paste0("data/",out.file,".",n,"-gram.RData"))
    remove("df")
  }
  remove("corpus")
}

doBlog <- function(probs = c(0.001)) {
  data <- readLines("data/en_US.blogs.txt")
  nLines <- length(data)
  set.seed(12345)

  for (p in probs) {
    sampleLines <- rbinom(nLines, 1, p)
    sample.data <- data[sampleLines == 1]
    doData(sample.data, paste0("blogs/blogs.",p))
  }
  remove("data")
}

doNews <- function(probs = c(0.001)) {
  data <- readLines("data/en_US.news.txt")
  nLines <- length(data)
  set.seed(12345)

  for (p in probs) {
    sampleLines <- rbinom(nLines, 1, p)
    sample.data <- data[sampleLines == 1]
    doData(sample.data, paste0("news/news.",p))
  }
  remove("data")
}

doTwitter <- function(probs = c(0.001)) {
  data <- readLines("data/en_US.twitter.txt")
  nLines <- length(data)
  set.seed(12345)

  for (p in probs) {
    sampleLines <- rbinom(nLines, 1, p)
    sample.data <- data[sampleLines == 1]
    doData(sample.data, paste0("twitter/twitter.",p))
  }
  remove("data")
}

doAll <- function() {
  probs = c(0.2, 0.4)
  doBlog(probs)
}
