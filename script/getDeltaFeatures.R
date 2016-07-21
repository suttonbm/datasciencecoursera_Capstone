# Return a data.frame object with the subset of features unique to a corpus.
#    - source.df: the list of features to filter
#    - ref.df: the list of features to compare against
#
# A subset of source.df is returned.
getDeltaFeatures <- function(source.df, ref.df) {
  return(source.df[!(source.df$ngram %in% ref.df$ngram), ])
}
