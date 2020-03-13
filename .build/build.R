install.packages("devtools")
install.packages("roxygen2")
install.packages("renv")

library("devtools")
library("roxygen2")
library("renv")

renv::restore()

devtools::document(roclets=c('rd', 'collate', 'namespace'))
devtools::build(".")


