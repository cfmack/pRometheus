install.packages("devtools")
install.packages("roxygen2")
install.packages("renv")

library("devtools")
library("roxygen2")
library("renv")

build_info <- function() {
  print("***** Build Info *****")
  print(paste("TRAVIS_BRANCH:", Sys.getenv(x="TRAVIS_BRANCH")))
  print(paste("TRAVIS_BUILD_NUMBER:", Sys.getenv(x="TRAVIS_BUILD_NUMBER")))
  print(paste("TRAVIS_JOB_NUMBER:", Sys.getenv(x="TRAVIS_JOB_NUMBER")))
}
build_info()

renv::restore()

devtools::document(roclets=c('rd', 'collate', 'namespace'))
devtools::build(".")
devtools::test()


