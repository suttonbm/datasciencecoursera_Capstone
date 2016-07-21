
# Use a tokenized corpus and generate a data.frame object with ngrams sorted
# in descending order
generateFeaturesDF <- function(corpus, rm.stop=F, trim.df=F) {
  require(doParallel)
  ncores <- detectCores() - 1
  options(mc.cores = ncores)
  cl <- makeCluster(ncores)
  registerDoParallel(cl)
  
  if (rm.stop) {
    result <- quanteda::dfm(corpus, ignoredFeatures=quanteda::stopwords('english'))
  } else {
    result <- quanteda::dfm(corpus)
  }
  
  if (trim.df) {
    result <- quanteda::trim(result, minCount=2)
  }
  
  result <- data.frame(ngram = quanteda::features(result),
                       count = quanteda::colSums(result),
                       stringsAsFactors = F)
  result <- result[order(-result$count), ]
  row.names(result) <- NULL

  stopCluster(cl)
  return(result)
}
