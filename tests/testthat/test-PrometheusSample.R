test_that("PrometheusSample", {
  sample <- pRometheus::PrometheusSample$new()
  name <- "test_metric"
  sample$setName(name)
  expect_equal(sample$getName(), name)
})
