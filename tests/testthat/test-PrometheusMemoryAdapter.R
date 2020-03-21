test_that("PrometheusMemoryAdapter", {
  adapter <- PrometheusMemoryAdapter$new()

  gauge_input_list <- list(
    'name' = "space_gauge",
    'help' = "Unit tests help",
    'type' = "gauge",
    'labelNames' = list(),
    'labelValues' = list(),
    'value' = 5
  )

  adapter$updateGauge(gauge_input_list)

  counter_input_list <- list(
    'name' = "space_counter",
    'help' = "Unit tests help",
    'type' = "counter",
    'labelNames' = list(),
    'labelValues' = list(),
    'value' = 7
  )

  adapter$updateCounter(counter_input_list)

  collect <- adapter$collect()

  gauge_samples <- collect[[1]]$getSamples()
  expect_equal(gauge_samples[[1]]$getValue(), gauge_input_list[['value']])

  counter_samples <- collect[[2]]$getSamples()
  expect_equal(counter_samples[[1]]$getValue(), counter_input_list[['value']])
})
