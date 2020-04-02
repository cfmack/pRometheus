###############################################################
#' Prometheus Counter implementation
#'
#' These objects only increase in value
#'
#' @importFrom R6 R6Class
#' @export
PrometheusCounter <- R6Class(
  "PrometheusCounter",
  public = list(
    #' Initializing PrometheusCounter
    #'
    #' @param storage_adapter instance of the storage adapter to how you want to persist metrics
    #' @param name name of the counter metric you are collecting
    #' @param help helper text to display to Prometheus
    #' @param namespace mechanism to scope counter name
    #' @param label_names the names of the labels.
    #' @return instance of PrometheusCounter
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

    #' Getter for the type, which will always be 'counter'
    #'
    #' @return string of 'counter'
    getType = function() {
      return (private$type)
    },

    #' Getter for the scoped name of the counter
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
    #' @return list of label names in the counter
    getLabelNames = function() {
      return (private$label_names)
    },

    #' Getter for an adapter usaged key to include name, namespace, and label_names
    #'
    #' @return string to uniquely identify the counter
    getKey = function() {
      return(digest::sha1(paste0(
        private$name, serialized(private$label_names)
      )))
    },

    #' Setter for the value of counter
    #'
    #' @param value value to set the counter to
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
      private$storate_adapter$updateCounter(input_list)
    },

    #' increment the counter by a discrete value
    #'
    #' @param value value to implement the counter by
    #' @param labels list of label values, which must match to the same number of label names
    #' @examples
    #' my_counter$incBy(3)
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

      private$storage_adapter$updateCounter(input_list)
    },

    #' increment the counter by a 1
    #'
    #' @param labels list of label values, which must match to the same number of label names
    #' @examples
    #' my_counter$inc()
    #' my_colors$inc(list('red'))
    inc = function(labels = list()) {
      self$incBy(1, labels)
      invisible(self)
    }
  ),
  private = list(
    storage_adapter = NULL,
    name = NULL,
    help = NULL,
    type = 'counter',
    label_names = list()
  )
)
