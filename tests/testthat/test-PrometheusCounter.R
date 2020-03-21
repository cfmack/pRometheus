test_that("PrometheusCounter", {
  adapter <- PrometheusMemoryAdapter$new()

  counter <- PrometheusCounter$new(
    storage_adapter = adapter,
    name = "myname",
    namespace = "myspace",
    help = "Unit tests help",
    label_names = list('color')
  )

  label_values = list('blue')
  counter$incBy(6, label_values)
  counter$inc(label_values)

  collect <- adapter$collect()
  samples <- collect[[1]]$getSamples()

  expect_equal(samples[[1]]$getValue(), 7)
})
