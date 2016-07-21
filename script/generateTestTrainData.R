###############################################################################
#
#   Coursera - Data Science Capstone
#
#   Test/Train Datasets
#   Author: Ben Sutton
#   Date: 2016/07/16
#
#   DESCRIPTION:
#   ------------
#   This script will generate test and train datasets with target sizes as
#   specified at the function call.  The datasets are generated with the
#   following sequence:
#     - Read in the raw data from disk (see: HC Corpora)
#     - Apply batch preprocessing/data cleaning to the sampled corpora
#     - Generate n-gram features as specified
#     - Create document-frequency matrix and collapse to data.frame
#     - Generate outcome data from n-grams
#
#   TO USE:
#   -------
#   
#
###############################################################################

source('script/generateSampleData.R')
source('script/loadCorpusFromFile.R')
source('script/generateNGrams.R')
source('script/generateFeaturesDF.R')
source('script/genOutcomeFromNGram.R')

generateTestTrainData <- function(train.p = 0.01, test.p = 0.001, ngram = 1) {
  data.paths <- c("data/en_US.blogs.txt",
                  "data/en_US.twitter.txt",
                  "data/en_US.news.txt")
  
  test <- c()
  train <- c()
  # Generate data subsample
  for (file in data.paths) {
    print(paste("Sampling from", file))
    data <- readLines(file)
    test.sample <- generateSampleData(data, test.p)
    train.sample <- generateSampleData(data, train.p)
    test <- c(test, test.sample)
    train <- c(train, train.sample)
  }
  # Memory management
  rm(list=c('data', 'test.sample', 'train.sample'))
  
  # Apply preprocessing of data
  print("Preprocessing test data...")
  test <- loadCorpusFromVector(test)
  print("Preprocessing train data...")
  train <- loadCorpusFromVector(train)
  
  # Generate n-grams.
  # n+1 is used so we can generate features of size n and also keep the
  # following word as the outcome to predict (n+1)
  print("Generating NGrams from test data...")
  test <- generateNGrams(test, n=ngram+1)
  print("Generating NGrams from train data...")
  train <- generateNGrams(train, n=ngram+1)
  
  # Collapse to frequency-rank data frame
  print("Collapsing test data...")
  test <- generateFeaturesDF(test, rm.stop=T, trim.df=F)
  print("Collapsing train data...")
  train <- generateFeaturesDF(train, rm.stop=T, trim.df=F)
  
  # Generate predictor and outcome variables from ngram data.
  print("Postprocessing test data...")
  test <- genOutcomeFromNGram(test)
  ("Postprocessing train data...")
  train <- genOutcomeFromNGram(train)
  
  return(list('test'=test, 'train'=train))
}