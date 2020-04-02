######################################################################
#' Object to retain sample of the same time together (i.e. all gauges, counters, etc)
#'
#' @importFrom R6 R6Class
#' @export
MetricFamilySample <- R6Class(
  "MetricFamilySample",
  public = list(
    #' Initializing MetricFamilySample
    #'
    #' @param name name of the gauge metric you are collecting
    #' @param help helper text to display to Prometheus
    #' @param type type of metric in this family
    #' @param label_names the names of the labels.
    #' @return instance of MetricFamilySample
    initialize = function(name, type, help, label_names = list()) {
      private$name = name
      private$metric_type = type
      private$metric_help = help
      private$label_names = label_names
    },

    #' Getter for the family name
    #'
    #' @return fully qualified name of the family
    getName = function() {
      return(private$name)
    },

    #' Setter for the family name
    #'
    #' @param val string to set the name
    setName = function(val) {
      private$name = val
    },

    #' Getter for the label names
    #'
    #' @return list of label names
    getLabelNames = function() {
      return(private$label_names)
    },

    #' Setter for the label names
    #'
    #' @param val list to set the list of label names
    setLabelNames = function(val) {
      private$label_names = val
      invisible(self)
    },

    #' Getter for the family type
    #'
    #' @return type of the family
    getType = function() {
      return(private$metric_type)
    },

    #' Setter for the family type
    #'
    #' @param val string to set the family type
    setType = function(val) {
      private$metric_type = val
      invisible(self)
    },

    #' Getter for the family help
    #'
    #' @return fully qualif of the family
    getHelp = function() {
      return(private$metric_help)
    },

    #' Setter for the family help text
    #'
    #' @param val string to set the help
    setHelp = function(val) {
      private$metric_help = val
      invisible(self)
    },

    #' Getter for list of PrometheusSample objects
    #'
    #' @return returns list of PrometheusSample objects
    getSamples = function() {
      return(private$samples)
    },

    #' Setter for the family samples
    #'
    #' @param val list of PrometheusSample objects
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
