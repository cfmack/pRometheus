# plumber.R
library("pRometheus")

registry <<- CollectorRegistry$new()
registry$registerGauge(
  name = 'test',
  help = 'some_gauge',
  type = 'it sets',
  namespace = "my_space"
)

registry$registerGauge(
  name = 'plot_gauge',
  help = 'some_gauge',
  type = 'it sets',
  namespace = "my_space",
  labels = 'color'
)


#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg = "") {
  gauge <- registry$getGauge(name = 'test', namespace = "my_space")
  gauge$inc()

  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @png
#* @get /plot
function() {
  gauge <- registry$getGauge(name = 'plot_gauge', namespace = "my_space")
  gauge$incBy(2, list('red'))

  rand <- rnorm(100)
  hist(rand)
}

#* Render Prometheus metrics
#*
#* @serializer contentType list(type="text/plain")
#* @get /metrics
function() {
  renderer <- PrometheusRenderMetrics$new()
  out <- renderer$render(registry$getMetricFamilySamples())
  return(out)
}
