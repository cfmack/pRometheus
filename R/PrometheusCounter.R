###############################################################
#' Prometheus Counter implementation
#'
#' @importFrom R6 R6Class
#' @export
PrometheusCounter <- R6Class(
  "PrometheusCounter",
  public = list(
    initialize = function(storage_adapter,
                          name,
                          help,
                          namespace = NULL,
                          label_names = list()) {
      private$storage_adapter <- storage_adapter

      if (!is.null(namespace)) {
        private$name <- paste(namespace, name, sep = '_')
      }
      else {
        private$name <- name
      }

      private$help <- help

      # to do: validate input
      private$label_names <- label_names
    },
    getType = function() {
      return (private$type)
    },
    getName = function() {
      return (private$name)
    },
    getHelp = function() {
      return (private$help)
    },
    getLabelNames = function() {
      return (private$label_names)
    },
    getKey = function() {
      return(digest::sha1(paste0(
        private$name, serialized(private$label_names)
      )))
    },
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
