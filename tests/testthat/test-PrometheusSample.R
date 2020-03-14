test_that("PrometheusSample", {
  sample <- pRometheus::PrometheusSample$new(
    name = "overwrite",
    value = 5,
    label_names = list(),
    label_values = list()
  )

  name <- "test_metric"
  sample$setName(name)
  expect_equal(sample$getName(), name)
})
