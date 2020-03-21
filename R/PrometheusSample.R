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
      if (length(label_names) != length(label_values)) {
        stop(paste(
            name,
            "had differing label names (",
            length(label_names),
            ") than label values (",
            length(label_values),
            ")"
          )
        )
      }

      if (length(label_values) > 0) {
        vector_check <- validUTF8(as.vector(unlist(label_values)))
        valid <- all(vector_check)
        if (valid == FALSE) {
          stop(paste(
              name,
              "has non-UTF8 encode label values"
            )
          )
        }
      }

      private$name <- name
      private$label_names <- label_names
      private$label_values <- label_values
      private$sample_value <- value
    },
    getName = function() {
      return(private$name)
    },
    getLabelNames = function() {
      return(private$label_names)
    },
    getLabelValues = function() {
      return(private$label_values)
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
