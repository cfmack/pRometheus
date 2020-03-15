######################################################################
#' Prometheus Raw Sample Object
#'
#' @importFrom R6 R6Class
#' @export
PrometheusSample <- R6Class(
  "PrometheusSample",
  public = list(
    initialize = function(name,
                          value,
                          label_names = list(),
                          label_values = list()) {
      private$name <- name
      private$label_names <- label_names
      private$label_values <- label_values
      private$sample_value <- value
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
    getLabelValues = function() {
      return(private$label_values)
    },
    setLabelValues = function(val) {
      private$label_values = val
      invisible(self)
    },
    getValue = function() {
      return(private$sample_value)
    },
    setValue = function(val) {
      private$sample_value = val
      invisible(self)
    },
    hasLabelNames = function() {
      if (is.null(private$label_names)) {
        return (FALSE)
      } else if (length(private$label_names) == 0) {
        return (FALSE)
      }

      return (TRUE)
    }
  ),
  private = list(
    name = NULL,
    label_names = NULL,
    label_values = NULL,
    sample_value = NULL
  )
)
