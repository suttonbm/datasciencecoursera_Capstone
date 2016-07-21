###############################################################################
#
#   Coursera - Data Science Capstone
#
#   Corpora Preparation
#   Author: Ben Sutton
#   Date: 2016/07/16
#
#   DESCRIPTION:
#   ------------
#   This script carries out the following tasks to prepare the corpus for
#   building and testing a predictive text model of the english language:
#     - Read in the raw data from disk (see: HC Corpora)
#     - Apply batch preprocessing to the sampled corpora:
#         o Remove non-latin characters
#         o Convert to lowercase
#         o Remove expletive words
#         o Remove words not included in an english dictionary
#         o Create and store a list of words not included in the corpus
#         o Apply sentence recognition
#
#   TO USE:
#   -------
#   To load a corpus from a text file, use `loadCorpusFromFile`
#   To load from a character vector, use `loadCorpusFromVector`
#
###############################################################################


# Regex function to remove most special characters
removeSpecialCharacters <- function(x) {
  validchars <- "[^a-zA-Z[:space:]\\.']"
  decnum <- "[[:digit:]]*\\.[[:digit:]]+"
  apost1 <- "[\U0027\U0060\U00B4\U2018\U2019]"
  apost2 <- "\U00E2\U20AC\U2122"
  apost3 <- "\U00E2\U20AC\U02DC"
  # Replace alternative sentence markers with periods
  x <- gsub("[?!]", ".", x)
  # Replace unicode apostrophe variants
  x <- gsub(apost1, "'", x)
  # Replace unicode errors for apostrophes
  x <- gsub(apost2, "'", x)
  x <- gsub(apost3, "'", x)
  # Remove decimal numbers with the period to avoid sentence detection errors
  x <- gsub(decnum, " ", x)
  # Remove everything else that's not a "valid" latin character
  x <- gsub(validchars, " ", x)
  x <- tolower(x)
  x
}

# Regex function to remove leading space from periods
# and add a leading space to apostrophes
fixApostAndPeriods <- function(x) {
  # Remove space around periods
  x <- gsub("\\s+\\.\\s+", ".", x)
  # Remove repeated periods
  x <- gsub("\\.+", ".", x)
  # Add trailing space to periods
  x <- gsub("\\.", ". ", x)
  # Add leading space to apostrophes to create features (`he's` -> `he`,`'s`)
  #x <- gsub("'", " '", x)
  x
}

# Function to replace words in the corpus
# If invert is FALSE, any terms in `data` that ARE in `dict` will be replaced
# with `repl`.  If invert is TRUE, any terms NOT in `dict` will be replaced.
replaceTerms <- function(data, dict, repl = ' ', invert=F) {
  data[(data %in% dict) == !invert] <- repl
  data
}

loadCorpusFromFile <- function(in.file, incl.missing=F) {
  data <- readLines(in.file, encoding="UTF-8")
  return(loadCorpusFromVector(data, incl.missing))
}

# Load a corpus and apply preprocessing tasks:
loadCorpusFromVector <- function(data, incl.missing=F) {
  # Set up parallel processing for use where possible
  require(doParallel)
  ncores <- detectCores() - 1
  options(mc.cores = ncores)
  cl <- makeCluster(ncores)
  registerDoParallel(cl)

  # Clean the text file to remove special (non-latin) characters
  data <- unlist(mclapply(data, removeSpecialCharacters))

  # Create corpus and clean up data
  # `data` chr vector not needed after corpus is created, cleans up memory.
  data <- quanteda::tokenize(data,
                             what="word",
                             verbose=FALSE,
                             simplify=TRUE)

  # Remove expletives from the corpus
  expletives <- readLines("data/expletives-coursera-swiftkey-nlp")
  data <- replaceTerms(data, expletives, "")
  rm(expletives)

  # Flag and remove words not included in the dictionary
  dict <- readLines("hunspell/dictionary.txt", encoding="UTF-8")
  dict <- unlist(mclapply(dict, tolower))
  dict <- c(dict, ".")
  data <- replaceTerms(data, dict, repl="<UNK>", invert=T)

  # Identify words missing from the corpus
  missingWords <- dict[!(dict %in% data)]
  missingWords <- unique(quanteda::wordstem(missingWords, language="english"))
  rm(dict)

  # Combine words into single string before sentence recognition
  data <- paste(data, collapse=' ', sep = ' ')

  # Split apostrophe suffixes from words
  # Remove leading whitespace before periods
  data <- unlist(mclapply(data, fixApostAndPeriods))

  # Apply sentence recognition to the created corpus
  data <- qdap::sent_detect(data)

  # Remove periods
  data <- unlist(mclapply(data, function(x) {
    gsub("\\.", "", x)
  }))

  # Create a corpus from the data
  corpus <- quanteda::corpus(tm::VCorpus(tm::VectorSource(data)))

  # Return a simplified corpus
  stopCluster(cl)

  if (incl.missing) {
    return(list('corpus'=corpus, 'missingwords'=missingWords))
  } else {
    return(corpus)
  }
}
