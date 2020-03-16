install.packages("renv")

library("renv")

renv::restore()

library("devtools")
library("desc")
library("roxygen2")

update_version = function() {
  desc <- description$new()

  version <- desc$get("Version")
  version_parts <- strsplit(version, "[.]")

  # keep major and minor
  version <- paste(version_parts[[1]][1], version_parts[[1]][2], sep=".")


  # update patch version based on TRAVIS BUILD NUMBERS
  patch <- Sys.getenv(x="TRAVIS_BUILD_NUMBER")
  if (patch == "") {
    patch <- 0
  }

  version <- paste(version, patch, sep=".")

  # signal an unrelease branch in CRAN by using 9000
  if (Sys.getenv(x="TRAVIS_BRANCH") != "master") {
    version <- paste(version, "9000", sep=".")
  }

  desc$set("Version", version)
  desc$write()
}

update_version()

devtools::document(roclets=c('rd', 'collate', 'namespace'))
devtools::build(".")
devtools::test()


