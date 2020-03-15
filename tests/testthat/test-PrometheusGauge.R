test_that("PrometheusGauge", {
  adapter <- PrometheusMemoryAdapter$new()

  gauge <- PrometheusGauge$new(
    storage_adapter = adapter,
    name = "myname",
    namespace = "myspace",
    help = "Unit tests help",
    label_names = list('color')
  )

  label_values = list('blue')
  gauge$incBy(6, label_values)
  gauge$inc(label_values)

  gauge$decBy(2, label_values)
  gauge$dec(label_values)

  collect <- adapter$collect()
  samples <- collect[[1]]$getSamples()

  expect_equal(samples[[1]]$getValue(), 4)
})
