
# Trims a NLP data.frame (columns: count, ngram) based on cumulative percentage
# of a corpus represented by the ngram data.
trimFeatureDF <- function(df, pct, kind='top') {
  # If searching for bottom percentage of features, need to invert the sort
  # order of the data.frame
  if (kind == "bot") {
    df <- df[order(df$count), ]
  }

  total <- sum(df$count)
  df$freq <- df$count/total
  counts.cumulative.norm <- cumsum(df$freq)
  result <- df[counts.cumulative.norm <= pct, ]

  # If the sort order was inverted for bottom percentage, need to flip again.
  if (kind == "bot") {
    result <- result[order(-result$count), ]
  }

  return(result)
}
