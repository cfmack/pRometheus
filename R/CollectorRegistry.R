######################################################################
#' Prometheus collector registry
#'
#' Allows an object for collecting and registering gauges, counters, etc
#'
#' @importFrom R6 R6Class
#' @export
CollectorRegistry <- R6Class(
  "CollectorRegistry",
  public = list(
    #' Initializing CollectorRegistry
    #'
    #' @param storage_adapter instance of the storage adapter to how you want to persist metrics
    #' @return instance of CollectorRegistry
    #' @examples
    #' registry <- CollectorRegistry$new() # default to a new PrometheusMemoryAdapter
    initialize = function(storage_adapter = NULL) {

      if (is.null(storage_adapter)) {
        private$storage_adapter = PrometheusMemoryAdapter$new()
      } else {
        private$storage_adapter = storage_adapter
      }
    },

    #' Return the list of samples CollectorRegistry, typically to render after
    #'
    #' @return list of MetricFamilySamples
    #' @examples
    #' registry <- CollectorRegistry$new() # default to a new PrometheusMemoryAdapter
    #' renderer <- PrometheusRenderMetrics$new()
    #' out <- renderer$render(registry$getMetricFamilySamples())
    getMetricFamilySamples = function() {
      return (private$storage_adapter$collect())
    },

    #' Registers a gauge to be leveraged later
    #'
    #' @param name name of the gauge
    #' @param help help text of the gauge
    #' @param namespace optional namespace that will be help keep the name unique
    #' @param labels list of label names to be used in the gauge
    #' @examples
    #' registry <- CollectorRegistry$new() # default to a new PrometheusMemoryAdapter
    #' registry$registerGauge( name = 'test', help = 'some_gauge', namespace = "my_space" )
    registerGauge = function(name,
                             help,
                             namespace = NULL,
                             labels = list()) {

      id <- private$generateMetricIdentifier(namespace, name)
      if (id %in% names(private$gauges)) {
        stop(paste("Metric already defined:" , id))
      }

      new_gauge = PrometheusGauge$new(
        storage_adapter = private$storage_adapter,
        namespace = namespace,
        name = name,
        help = help,
        label_names = labels
      )

      private$gauges[[id]] <- new_gauge
    },

    #' Retrieves the gauge to be leveraged
    #'
    #' @param name name of the gauge
    #' @param namespace optional namespace that will be help keep the name unique
    #' @examples
    #' registry <- CollectorRegistry$new() # default to a new PrometheusMemoryAdapter
    #' registry$registerGauge( name = 'test', help = 'my_gauge', namespace = "my_space" )
    #' count <- registry$getGauge(name = 'my_gauge', namespace = "my_space")
    #' count$incBy(5)
    getGauge = function(name, namespace = NULL) {
      id <- private$generateMetricIdentifier(namespace, name)
      if (!(id %in% names(private$gauges))) {
        stop(paste("Metric not found:" , id))

      }

      return (private$gauges[[id]])
    },

    #' Registers a counter to be leveraged later
    #'
    #' @param name name of the counter
    #' @param help help text of the counter
    #' @param namespace optional namespace that will be help keep the name unique
    #' @param labels list of label names to be used in the counter
    #' @examples
    #' registry <- CollectorRegistry$new() # default to a new PrometheusMemoryAdapter
    #' registry$registerCounter( name = 'test', help = 'some_counter', namespace = "my_space" )
    registerCounter = function(name,
                             help,
                             namespace = NULL,
                             labels = list()) {

      id <- private$generateMetricIdentifier(namespace, name)
      if (id %in% names(private$counters)) {
        stop(paste("Metric already defined:" , id))
      }

      new_counter = PrometheusCounter$new(
        storage_adapter = private$storage_adapter,
        namespace = namespace,
        name = name,
        help = help,
        label_names = labels
      )

      private$counters[[id]] <- new_counter
    },

    #' Retrieves the counter to be leveraged
    #'
    #' @param name name of the counter
    #' @param namespace optional namespace that will be help keep the name unique
    #' @examples
    #' registry <- CollectorRegistry$new() # default to a new PrometheusMemoryAdapter
    #' registry$registerCounter( name = 'test', help = 'my_counter', namespace = "my_space" )
    #' count <- registry$getCounter(name = 'my_counter', namespace = "my_space")
    #' count$inc()
    getCounter = function(name, namespace = NULL) {
      id <- private$generateMetricIdentifier(namespace, name)
      if (!(id %in% names(private$counters))) {
        stop(paste("Metric not found:" , id))

      }

      return (private$counters[[id]])
    }
  ),
  private = list(
    storage_adapter = NULL,
    gauges = list(),
    counters = list(),
    generateMetricIdentifier = function(namespace, name) {
      if (is.null(namespace)) {
        return(name)
      }

      return (paste(namespace, name, sep = ":"))
    }
  )
)
