library(myutils)

publishFiles = c(
  '2016-06-17-nlp_intro.rmd',
  '2016-06-29-sampling_data.rmd',
  '2016-06-30-tokenize_clean_data.rmd',
  '2016-07-05-tokenizing_aside.rmd'
)

for(filename in publishFiles) {
  print(paste("Publishing", filename))
  PublishPost(filename, out.path="../suttonbm.github.io/_posts/projects/datasciencecoursera/")
}