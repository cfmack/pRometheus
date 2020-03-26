######################################################################
#' Prometheus Sample R6 Object
#'
#' Classic data object to encapsulate a sampling of a metric.   You likely will not interact witht this object
#'
#' @importFrom R6 R6Class
#' @export
PrometheusSample <- R6Class(
  "PrometheusSample",
  public = list(
    #' Initializing PrometheusSample
    #'
    #' @param name name of the sample, combined in other functions or R6 objects with namespace
    #' @param value the actual value of the sample
    #' @param label_names the name of the labels being passed in
    #' @param label_values the actual values of the labels.  This must be UTF-8 encoded and the same number of labels
    #' @return instance of PrometheusSample
    #' @examples
    #' sample <- PrometheusSample$new("sample name", 10)
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

    #' Getter for the sample name
    #'
    #' @return fully qualified name of the sample
    #' @examples
    #' sample <- PrometheusSample$new("sample name", 10)
    #' print(sample$getName()) # 'sample name'
    getName = function() {
      return(private$name)
    },

    #' Getter for the label names
    #'
    #' @return list of label names in the sample
    getLabelNames = function() {
      return(private$label_names)
    },

    #' Getter for the label values
    #'
    #' @return list of label values in the sample
    getLabelValues = function() {
      return(private$label_values)
    },

    #' Getter for the sample value
    #'
    #' @return list of sample values in the sample
    getValue = function() {
      return(private$sample_value)
    },

    #' Setter for the sample value
    #'
    #' @param val value to actually set
    #' @return self
    setValue = function(val) {
      private$sample_value = val
      invisible(self)
    },

    #' Helper function to check if this sample has labels by checking label names
    #'
    #' @return bool if sample has label_names
    #' @examples
    #' sample <- PrometheusSample$new("sample name", 10, list("colors"), list("red"))
    #' sample$hasLabelNames() # TRUE
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

