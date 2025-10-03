###############################################################
#' Prometheus Gauge object
#'
#' Gauges differ from Counters as they can decrease in value
#'
#' @importFrom R6 R6Class
#' @export
PrometheusGauge <- R6Class(
  "PrometheusGauge",
  public = list(
    #' Initializing PrometheusGauge
    #'
    #' @param storage_adapter instance of the storage adapter to how you want to persist metrics
    #' @param name name of the gauge metric you are collecting
    #' @param help helper text to display to Prometheus
    #' @param namespace mechanism to scope gauge name
    #' @param label_names the names of the labels.
    #' @return instance of PrometheusGauge
    initialize = function(storage_adapter,
                          name,
                          help,
                          namespace = NULL,
                          label_names = list()) {
      private$storage_adapter <- storage_adapter
      private$help <- help
      private$label_names <- label_names

      if (!is.null(namespace)) {
        private$name <- paste(namespace, name, sep = '_')
      }
      else {
        private$name <- name
      }
    },

    #' Getter for the type, which will always be 'gauge'
    #'
    #' @return string of 'gauge'
    getType = function() {
      return (private$type)
    },

    #' Getter for the scoped name of the gauge
    #'
    #' This could include a concatenated namespace
    #'
    #' @return string of name text
    getName = function() {
      return (private$name)
    },

    #' Getter for the helper text
    #'
    #' @return string of helper text
    getHelp = function() {
      return (private$help)
    },

    #' Getter for the label names
    #'
    #' @return list of label names in the gauge
    getLabelNames = function() {
      return (private$label_names)
    },

    #' Getter for an adapter usaged key to include name, namespace, and label_names
    #'
    #' @return string to uniquely identify the gauge
    getKey = function() {
      return(digest::sha1(paste0(
        private$name, serialized(private$label_names)
      )))
    },

    #' Setter for the value of gauge
    #'
    #' @param value value to set the gauge to
    #' @param labels list of label values, which must match to the same number of label names
    set = function(value, labels = list()) {
      input_list = list(
        'name' = private$getName(),
        'help' = private$getHelp(),
        'type' = private$getType(),
        'labelNames' = private$getLabelNames(),
        'labelValues' = labels,
        'value' = value
      )
      private$storage_adapter$updateGauge(input_list)
    },

    #' increment the gauge by a discrete value
    #'
    #' @param value value to implement the gauge by
    #' @param labels list of label values, which must match to the same number of label names
    #' @examples
    #' my_gauge$incBy(3)
    #' my_colors$incBy(3, list('red'))
    incBy = function(value, labels = list()) {
      input_list = list(
        name = self$getName(),
        help = self$getHelp(),
        type = self$getType(),
        label_names = self$getLabelNames(),
        label_values = labels,
        value = value
      )

      private$storage_adapter$updateGauge(input_list)
    },

    #' increment the gauge by a 1
    #'
    #' @param labels list of label values, which must match to the same number of label names
    #' @examples
    #' my_gauge$inc()
    #' my_colors$inc(list('red'))
    inc = function(labels = list()) {
      self$incBy(1, labels)
      invisible(self)
    },

    #' decrement the gauge by a discrete value
    #'
    #' @param value value to decrement the gauge by.  Should be a positive number
    #' @param labels list of label values, which must match to the same number of label names
    #' @examples
    #' my_gauge$decBy(3)
    #' my_colors$decBy(3, list('red'))
    decBy = function(value, labels = list()) {
      value <- value * -1
      self$incBy(value, labels)
    },

    #' decrement the gauge by a 1
    #'
    #' @param labels list of label values, which must match to the same number of label names
    #' @examples
    #' my_gauge$dec()
    #' my_colors$dec(list('red'))
    dec = function(labels = list()) {
      self$decBy(1, labels)
    }
  ),
  private = list(
    storage_adapter = NULL,
    name = NULL,
    help = NULL,
    type = 'gauge',
    label_names = list()
  )
)
