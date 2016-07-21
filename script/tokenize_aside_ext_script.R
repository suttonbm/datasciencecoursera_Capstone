ids <- c(1,2,3,4,5,6,7,8,9,10,11,12,13)
files <- c("data/en_US.blogs.txt.0.001",
           "data/en_US.news.txt.0.001",
           "data/en_US.twitter.txt.0.001",
           "data/en_US.blogs.txt.0.005",
           "data/en_US.news.txt.0.005",
           "data/en_US.twitter.txt.0.005",
           "data/en_US.blogs.txt.0.01",
           "data/en_US.news.txt.0.01",
           "data/en_US.twitter.txt.0.01",
           "data/en_US.blogs.txt.0.05",
           "data/en_US.news.txt.0.05",
           "data/en_US.twitter.txt.0.05",
           "data/en_US.news.txt.0.1")

data <- list()
file.sizes <- list()
nLines <- list()
for (id in ids) {
  file.sizes[[id]] <- file.size(files[id])
  
  data[[id]] <- readLines(files[id])
  nLines[[id]] <- length(data[[id]])
}

corpora <- list()
for (id in ids) {
  corpora[[id]] <- tm::VCorpus(tm::VectorSource(data[[id]]))
  corpora[[id]] <- tm::tm_map(corpora[[id]], tm::removePunctuation)
  corpora[[id]] <- tm::tm_map(corpora[[id]], tm::removeNumbers)
  corpora[[id]] <- tm::tm_map(corpora[[id]], tm::content_transformer(tolower))
  corpora[[id]] <- tm::tm_map(corpora[[id]], tm::stripWhitespace)
}

library(doParallel)

options(mc.cores=3)

parallelTask <- function(task, ...) {
  ncores <- detectCores() - 1
  cl <- makeCluster(ncores)
  registerDoParallel(cl)
  r <- task(...)
  stopCluster(cl)
  r
}

doEvaluate <- function(method.name, tokenFn, ...) {
  times <- list()
  for (id in ids) {
    t <- system.time({
      parallelTask(tokenFn, corpora[[id]], ...)
    })[['elapsed']]
    times[[id]] <- t
  }
  
  results <- data.frame(method = method.name,
                        file.size = unlist(file.sizes, use.names=F),
                        file.lines = unlist(nLines, use.names=F),
                        perf = unlist(times, use.names=F))
  return(results)
}

# Test the `words` tokenizer
words.df <- doEvaluate('tm.words', tm::TermDocumentMatrix)

# Test the `MC_tokenizer`
mc.df <- doEvaluate('tm.mc', tm::TermDocumentMatrix, control=list(tokenize=tm::MC_tokenizer))

ngram.nlp <- function(x, n=1) {
  unlist(lapply(NLP::ngrams(NLP::words(x), n), paste, collapse = " "), use.names = FALSE)
}

bigram.nlp <- function(x) {
  ngram.nlp(x, n=2)
}

trigram.nlp <- function(x) {
  ngram.nlp(x, n=3)
}

# Evaluate bigram matrix generation
nlp.2.df <- doEvaluate('nlp.2-gram', tm::TermDocumentMatrix, control=list(tokenize=bigram.nlp))

# Evaluate trigram matrix generation
nlp.3.df <- doEvaluate('nlp.3-gram', tm::TermDocumentMatrix, control=list(tokenize=bigram.nlp))

library(rJava)
.jinit(parameters="-Xmx1g")

ngram.rweka <- function(x, n=1) {
  RWeka::NGramTokenizer(x, RWeka::Weka_control(min = n, max = n))
}

unigram.rweka <- function(x) {
  ngram.rweka(x, n=1)
}

bigram.rweka <- function(x) {
  ngram.rweka(x, n=2)
}

trigram.rweka <- function(x) {
  ngram.rweka(x, n=3)
}

# Evaluate 1-grams
rweka.1.df <- doEvaluate('RWeka.1-gram', tm::TermDocumentMatrix, control=list(tokenize=unigram.rweka))

# Evaluate 2-grams
rweka.2.df <- doEvaluate('RWeka.2-gram', tm::TermDocumentMatrix, control=list(tokenize=bigram.rweka))

# Evaluate 3-grams
rweka.3.df <- doEvaluate('RWeka.23gram', tm::TermDocumentMatrix, control=list(tokenize=trigram.rweka))

doEvaluate.qeda <- function(method.name, tokenFn, ...) {
  times <- list()
  for (id in ids) {
    c <- quanteda::corpus(corpora[[id]])
    t <- system.time({
      parallelTask(tokenFn, c, ...)
    })[['elapsed']]
    times[[id]] <- t
  }
  
  results <- data.frame(method = method.name,
                        file.size = unlist(file.sizes, use.names=F),
                        file.lines = unlist(nLines, use.names=F),
                        perf = unlist(times, use.names=F))
  return(results)
}

# Evaluate 1-grams
qeda.1.df <- doEvaluate.qeda('qeda.1-gram', quanteda::tokenize, what='word', ngrams=1, simplify=TRUE)

# Evaluate 2-grams
qeda.2.df <- doEvaluate.qeda('qeda.2-gram', quanteda::tokenize, what='word', ngrams=2, simplify=TRUE)

# Evaluate 3-grams
qeda.3.df <- doEvaluate.qeda('qeda.3-gram', quanteda::tokenize, what='word', ngrams=3, simplify=TRUE)