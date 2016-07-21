source("script/getDeltaFeatures.R")

GenerateDeltaFeatureData <- function() {
  ngrams <- c(1, 2, 3)

  for (n in ngrams) {
    ref <- new.env()
    load(paste0("data/blogs/blogs.0.01.",n,"-gram.RData"), envir=ref)
    source <- new.env()
    load(paste0("data/blogs/blogs.0.1.",n,"-gram.RData"), envir=source)

    delta.df <- getDeltaFeatures(source$df, ref$df)
    save("delta.df", file=paste0("data/DeltaFeatures.",n,"-gram.RData"))

    remove(list=c('ref', 'source', 'delta.df'))
  }
}
