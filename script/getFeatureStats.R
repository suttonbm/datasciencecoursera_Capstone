source("script/loadCorpusFromFile.R")
source("script/generateNGrams.R")
source("script/generateFeaturesDF.R")
source("script/trimFeatureDF.R")


# Given a specified text corpus, generate summary statistics about included
# features. Will return total number of features, as well as the top and bottom
# 99, 90, and 50%, for words, bigrams, and trigrams.
getFeatureStats <- function(data, rm.stopwords=F) {
  result <- list()
  qcorpus <- loadCorpusFromVector(data, rm.stopwords)

  # Get statistics of word tokens
  words <- generateNGrams(qcorpus, 1)
  words <- generateFeaturesDF(words)
  result[['words.100']] <- length(words$ngram)
  result[['words.top.99']] <- length(trimFeatureDF(words, 0.99)$ngram)
  result[['words.top.90']] <- length(trimFeatureDF(words, 0.90)$ngram)
  result[['words.top.50']] <- length(trimFeatureDF(words, 0.50)$ngram)
  result[['words.bot.99']] <- length(trimFeatureDF(words, 0.99, 'bot')$ngram)
  result[['words.bot.90']] <- length(trimFeatureDF(words, 0.90, 'bot')$ngram)
  result[['words.bot.50']] <- length(trimFeatureDF(words, 0.50, 'bot')$ngram)
  result[['words.top.25.tok']] <- paste(head(words$ngram, 25), collapse="|")
  remove("words")

  # Generate tokens by bigrams
  bigrams <- generateNGrams(qcorpus, 2)
  bigrams <- generateFeaturesDF(bigrams)
  result[['bigrams.100']] <- length(bigrams$ngram)
  result[['bigrams.top.99']] <- length(trimFeatureDF(bigrams, 0.99)$ngram)
  result[['bigrams.top.90']] <- length(trimFeatureDF(bigrams, 0.90)$ngram)
  result[['bigrams.top.50']] <- length(trimFeatureDF(bigrams, 0.50)$ngram)
  result[['bigrams.bot.99']] <- length(trimFeatureDF(bigrams, 0.99, 'bot')$ngram)
  result[['bigrams.bot.90']] <- length(trimFeatureDF(bigrams, 0.90, 'bot')$ngram)
  result[['bigrams.bot.50']] <- length(trimFeatureDF(bigrams, 0.50, 'bot')$ngram)
  result[['bigrams.top.25.tok']] <- paste(head(bigrams$ngram, 25), collapse="|")
  remove("bigrams")

  # Generate tokens by trigrams
  trigrams <- generateNGrams(qcorpus, 3)
  trigrams <- generateFeaturesDF(trigrams)
  result[['trigrams.100']] <- length(trigrams$ngram)
  result[['trigrams.top.99']] <- length(trimFeatureDF(trigrams, 0.99)$ngram)
  result[['trigrams.top.90']] <- length(trimFeatureDF(trigrams, 0.90)$ngram)
  result[['trigrams.top.50']] <- length(trimFeatureDF(trigrams, 0.50)$ngram)
  result[['trigrams.bot.99']] <- length(trimFeatureDF(trigrams, 0.99, 'bot')$ngram)
  result[['trigrams.bot.90']] <- length(trimFeatureDF(trigrams, 0.90, 'bot')$ngram)
  result[['trigrams.bot.50']] <- length(trimFeatureDF(trigrams, 0.50, 'bot')$ngram)
  result[['trigrams.top.25.tok']] <- paste(head(trigrams$ngram, 25), collapse="|")
  remove("trigrams")
  remove("qcorpus")

  result <- as.data.frame(result)

  return(result)
}
