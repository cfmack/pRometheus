######################################################################
#' Prometheus Raw Sample Object
#'
#' @importFrom R6 R6Class 
#' @export
MetricFamilySample <- R6Class(
  "MetricFamilySample",
  public = list(
    initialize = function() {
    },
    getName = function() {
      return(private$name)
    },
    setName = function(val) {
      private$name = val
      invisible(self)
    },
    getLabelNames = function() {
      return(private$label_names)
    },
    setLabelNames = function(val) {
      private$label_names = val
      invisible(self)
    },
    getType = function() {
      return(private$metric_type)
    },
    setType = function(val) {
      private$metric_type = val
      invisible(self)
    },
    getHelp = function() {
      return(private$metric_help)
    },
    setHelp = function(val) {
      private$metric_help = val
      invisible(self)
    },
    getSamples = function() {
      return(private$samples)
    },
    setSamples = function(val) {
      private$samples = val
      invisible(self)
    }
  ),
  private = list(
    name = NULL,
    label_names = NULL,
    metric_type = NULL,
    metric_help = NULL,
    samples = list()
  )
)
