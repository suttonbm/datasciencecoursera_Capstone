# Split last token from ngram data as a predicted outcome for test/train
genOutcomeFromNGram <- function(feature.df) {
  feature.df$outcome <- unlist(mclapply(feature.df$ngram, function(x) {
    result <- unlist(strsplit(x, split="_", fixed=T))
    result[length(result)]
  }))
  feature.df$feature <- unlist(mclapply(feature.df$ngram, function(x) {
    gsub("_[[:alpha:]]+$", "", x)
  }))
  feature.df
}