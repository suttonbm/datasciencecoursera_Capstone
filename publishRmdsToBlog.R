library(myutils)

publishedFiles = c()

publishFiles = c(
  '2016-06-20-nlp_intro.rmd',
  '2016-06-29-sampling_data.rmd',
  '2016-06-30-tokenize_clean_data.rmd',
  '2016-07-08-tokenizing_aside.rmd',
  '2016-07-13-nlp_sampling_updated.rmd',
  '2016-07-16-nlp_data_exploration.rmd',
  '2016-07-20-data_cleaning.rmd'
)

for(filename in publishFiles) {
  print(paste("Publishing", filename))
  PublishPost(filename, out.path="../suttonbm.github.io/_posts/projects/datasciencecoursera/", base.url = "")
}
