
# pRometheus
Prometheus Client Library for R and Plumber

Port of [prometheus_client_php](https://github.com/endclothing/prometheus_client_php) 

## Background

This library currently only uses a in memory adapter with counters or gauges.  If you would like to contribute and create a redis or other backend, please do.   


## How to install

Currently, you can run the following to pull from Github

```
if (!requireNamespace("remotes"))
  install.packages("remotes")

remotes::install_github("cfmack/pRomtheus")
```

Once a CRAN package is available, you can pull it with `install.packages`

## How does it work?

Usually R worker processes don't share any state.   In Plumber, you can leverage a global registry.   You can find the below in the `examples` folder.  At the top of your plumber.R, create a global instance and register your metrics:

```R
registry <<- CollectorRegistry$new()
registry$registerGauge(
  name = 'test',
  help = 'some_gauge',
  namespace = "my_space"
)

# label names are optional on both counters and gauges

registry$registerGauge(
  name = 'plot_gauge',
  help = 'some gauge with label',
  namespace = "my_space",
  labels = 'color'
)

registry$registerCounter(
  name = 'test counter',
  help = 'some counter',
  namespace = "my_space"
)

```

After that, depending on your functionality, you can adjust of your metric whereever is appropriate in your API.   This is common to be within each end point

```R
  gauge <- registry$getGauge(name = 'test', namespace = "my_space")
  gauge$inc()

  gauge <- registry$getGauge(name = 'plot_gauge', namespace = "my_space")
  gauge$decBy(2, list('red'))
  
  counter <- registry$getCounter(name = 'test counter', namespace = "my_space")
  counter$inc()
  
```

## How to publish to Promtheus
As push notification have not been added yet, you will want to expose a metrics end point

```R
#* Render Prometheus metrics
#*
#* @serializer contentType list(type="text/plain")
#* @get /metrics
function() {
  renderer <- PrometheusRenderMetrics$new()
  out <- renderer$render(registry$getMetricFamilySamples())
  return(out)
}

``` 
