loadDataFromFile <- function(filename) {
  data <- readLines(filename)
  
  require(tm)
  require(quanteda)
  
  corpus <- VCorpus(VectorSource(data))
  
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, content_transformer(tolower))
  
  expletives <- VectorSource(readLines("data/expletives-coursera-swiftkey-nlp"))
  corpus <- tm_map(corpus, removeWords, expletives$content)
  corpus <- tm_map(corpus, stripWhitespace)
  return(corpus)
}