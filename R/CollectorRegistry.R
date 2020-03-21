######################################################################
#' Prometheus collector registry
#'
#' @importFrom R6 R6Class
#' @export
CollectorRegistry <- R6Class(
  "CollectorRegistry",
  public = list(
    initialize = function(storage_adapter = NULL) {
      if (is.null(storage_adapter)) {
        private$storage_adapter = PrometheusMemoryAdapter$new()
      } else {
        private$storage_adapter = storage_adapter
      }
    },
    getMetricFamilySamples = function() {
      return (private$storage_adapter$collect())
    },
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
    getGauge = function(name, namespace = NULL) {
      id <- private$generateMetricIdentifier(namespace, name)
      if (!(id %in% names(private$gauges))) {
        stop(paste("Metric not found:" , id))

      }

      return (private$gauges[[id]])
    },
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
