install.packages("devtools")
install.packages("roxygen2")
install.packages("renv")

library("renv")

renv::restore()

library("devtools")
library("desc")
library("roxygen2")

update_version = function() {
  desc <- description$new()

  version <- desc$get("Version")

  # keep major and minor
  version <- Sys.getenv(x="TRAVIS_TAG")
  if (version == "") {
  	version <- "0.0.1"
  }


  # signal an unrelease branch in CRAN by using 9000
  if (Sys.getenv(x="TRAVIS_BRANCH") != "master" 
	&& Sys.getenv(x="TRAVIS_TAG") == "") {
    version <- paste(version, "9000", sep=".")
  }
  else {
    version <- paste(version, "0", sep=".")
  }

  desc$set("Version", version)
  desc$write()
}

update_version()

devtools::document(roclets=c('rd', 'collate', 'namespace'))
devtools::build(".")
devtools::test()


