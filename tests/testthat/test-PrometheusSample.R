test_that("PrometheusSample", {
  sample <- pRometheus::PrometheusSample$new(
    name = "overwrite",
    value = 5,
    label_names = list(),
    label_values = list()
  )

  name <- "overwrite"
  expect_equal(sample$getName(), name)

  sample <- pRometheus::PrometheusSample$new(
    name = "list size",
    value = 5,
    label_names = list("color"),
    label_values = list("red")
  )

  expect_equal(length(sample$getLabelNames()), length(sample$getLabelValues()))

  # expect an error when the names and values are not the same size
  create_error <- function() {
    pRometheus::PrometheusSample$new(
      name = "list size",
      value = 5,
      label_names = list("color"),
      label_values = list()
    )
  }

  expect_error(create_error())

  # expect an error when values contain invalid characters
  create_error <- function() {
    values <- c("fa\xE7ile")
    Encoding(values) <- c("latin1")

    pRometheus::PrometheusSample$new(
      name = "non-utf8 list",
      value = 5,
      label_names = list("color"),
      label_values = as.list(values)
    )
  }

  expect_error(create_error())

})
