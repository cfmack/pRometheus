######################################################################
# Prometheus Raw Sample Object
#
#' @export
PrometheusSample <- R6Class(
  "PrometheusSample",
  public = list(
    initialize = function() {},
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
    }
    getValue = function() {
      return(private$sample_value)
    },
    setValue = function(val) {
      private$sample_value = val
      invisible(self)
    }
  ),
  private = list(
    name = NULL,
    label_names = NULL,
    label_values = NULL,
    sample_value = NULL
  )
)
