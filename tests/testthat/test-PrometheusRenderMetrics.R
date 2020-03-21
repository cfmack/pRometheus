library("stringi")
test_that("PrometheusRenderMetrics", {
  registry <- CollectorRegistry$new()

  registry$registerGauge(
    name = 'test',
    help = 'some_gauge',
    namespace = "my_space"
  )

  registry$registerGauge(
    name = 'plot_gauge',
    help = 'some_gauge',
    namespace = "my_space",
    labels = 'color'
  )

  gauge <- registry$getGauge(name = 'test', namespace = "my_space")
  gauge$inc()

  gauge <-
    registry$getGauge(name = 'plot_gauge', namespace = "my_space")
  gauge$incBy(2, list('red'))
  gauge$incBy(3, list('red'))

  renderer <- PrometheusRenderMetrics$new()
  out <- renderer$render(registry$getMetricFamilySamples())

  # HELP my_space_test some_gauge
  # TYPE my_space_test gauge
  #my_space_test 1

  # HELP my_space_plot_gauge some_gauge
  # TYPE my_space_plot_gauge gauge
  #my_space_plot_gauge{color="red"} 5
  num_of_helps = 0
  num_of_types = 0
  seen_first_gauge = FALSE
  seen_second_gauge = FALSE

  lines <- strsplit(out, "\n")

  for (line in lines[[1]]) {
    if (stri_detect_fixed(line, "HELP")) {
      num_of_helps = num_of_helps + 1
    }
    else if (stri_detect_fixed(line, "TYPE")) {
      num_of_types = num_of_types + 1
    }
    else if (stri_detect_fixed(line, "my_space_test 1")) {
      seen_first_gauge = TRUE
    }
    else if (stri_detect_fixed(line, 'my_space_plot_gauge{color="red"} 5')) {
      seen_second_gauge = TRUE
    }
  }

  expect_equal(num_of_helps, 2)
  expect_equal(num_of_types, 2)
  expect_true(seen_first_gauge)
  expect_true(seen_second_gauge)

})
