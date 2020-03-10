######################################################################
# Output for Prometheus to parse
#
#' @export
PrometheusRenderMetrics <- R6Class(
  "PrometheusRenderMetrics",
  public = list(
    initialize = function() {
    },
    render = function(metrics) {
      output <- ""

      for (metric in metrics) {
        help <- paste("# HELP", metric$getName(), metric$getHelp(), sep = " ")
        help <-
          paste("# TYPE", metric$getName(), metric$getType(), sep = " ")

        output <- paste(output, help, type, sep = "\n")

        for (sample in metric$getSamples()) {
          sampleOutput <- private$renderSample(sample)
          output <- paste(output, sampleOutput, sep = "\n")
        }

        output <- paste0(output, "\n")
      }

      return(paste0(output, "\n"))
    }
  ),
  private = list(
    renderSample = function(sample) {
      label_output <- ""
      if (sample$hasLabelNames()) {
        count <- length(sample$getLabelNames())
        if (count == 1) {
          label_output <-
            paste0(sample$getLabelNames()[1],
                   '="',
                   sample$getLabelValues()[1],
                   '"')
        }
        else {
          for (i in 1:count) {
            single_label_output <-
              paste0(sample$getLabelNames()[i],
                     '="',
                     sample$getLabelValues()[i],
                     '"')
            label_output <-
              paste0(label_output, single_label_output)
            if (i < count) {
              label_output <- paste0(label_output, ",")
            }
          }
        }

        label_output <- paste0("{", label_output, "}")
      }

      return(paste0(sample$getName(), label_output, " ", sample$getValue()))
    }
  )
)
