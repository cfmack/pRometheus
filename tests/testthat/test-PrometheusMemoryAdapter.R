test_that("PrometheusMemoryAdapter", {
  adapter <- PrometheusMemoryAdapter$new()

  input_list = list(
    'name' = "space:name",
    'help' = "Unit tests help",
    'type' = "unit test",
    'labelNames' = list(),
    'labelValues' = list(),
    'value' = 5
  )

  adapter$updateGauge(input_list)

  collect <- adapter$collect()
  samples <- collect[[1]]$getSamples()

  expect_equal(samples[[1]]$getValue(), input_list[['value']])
})
