# plumber.R
library("pRometheus")

registry <<- CollectorRegistry$new()
registry$registerGauge('test', 'some_gauge', 'it sets', namespace="my_space")

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg=""){
  gauge <- registry$getGauge(name='test', namespace="my_space")
  gauge$inc()

  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @png
#* @get /plot
function(){
  rand <- rnorm(100)
  hist(rand)
}

#* Render Prometheus metrics
#* @html
#* @get /metrics
function() {
  renderer <- PrometheusRenderMetrics$new()
  renderer$render(registry$getMetricFamilySamples())
}

