######################################################################
# Prometheus collector registry
#
#' @export
CollectorRegistry <- R6Class(
  "CollectorRegistry",
  public = list(
    initialize = function(storageAdapter = NULL) {
      if (is.null(storageAdapter)) {
        storageAdapter = PrometheusMemoryAdapter$new()
      }

      private$storageAdapter = storageAdapter
    },
    getMetricFamilySamples = function() {
      return (private$storageAdapter$collect())
    },
    registerGauge = function(namespace, name, help, type, labels = list()) {
      id = private$generateMetricIdentifier(namespace, name)
      if (isset(private$gauges[[id]])) {
        stop(paste("Metric already defined:" , id))

      }

      # new_gauge =
      #   $this->gauges[$metricIdentifier] = new Gauge(
      #     $this->storageAdapter,
      #     $namespace,
      #     $name,
      #     $help,
      #     $labels
      #   );
      #   return $this->gauges[$metricIdentifier];

    },
    getGauge = function(namespace, name) {
      id = private$generateMetricIdentifier(namespace, name)
      if (!isset(private$gauges[[id]])) {
        stop(paste("Metric not found:" , id))

      }
      return (private$gauges[[id]])

    }
  ),
  private = list(
    storageAdapter = NULL,
    gauges = list(),
    generateMetricIdentifier = function(namespace, name) {
      return (paste(namespace, name, sep = ":"))
    }
  )
)
