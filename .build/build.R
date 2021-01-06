library("devtools")
library("desc")
library("roxygen2")

update_version = function() {
  desc <- description$new()


  # keep major and minor
  desc_version <- desc$get("Version")

  version <- Sys.getenv(x="TRAVIS_TAG")
  if (version == "") {
    version <- desc_version
  } else if (version != desc_version) {
    stop(paste("Tag (", version , ") does not match DESCRIPTION (", desc_version, ")"))
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

#Comeback and update the version from the description
#update_version()

devtools::document(roclets=c('rd', 'collate', 'namespace'))
devtools::build(".")
devtools::test()


