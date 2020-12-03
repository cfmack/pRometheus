#' Prometheus with Shiny
#' 
#' Render the metrics and serve the `/metrics` 
#' endpoint in shiny.semantic
#' 
#' @param app A shiny application as returned by [shiny::shinyApp()].
#' @param registry A registry as returned by [CollectorRegistry].
#' 
#' @examples 
#' library(shiny)
#' 
#' registry <<- CollectorRegistry$new()
#' registry$registerGauge(
#'  name = 'test',
#'  help = 'some_gauge',
#'  namespace = "my_space"
#' )
#' 
#' ui <- fluidPage(
#'  actionButton("click", "Click")
#' )
#' 
#' server <- function(input, output){
#'  gauge <- registry$getGauge(name = 'test', namespace = "my_space")
#' 
#'  observeEvent(input$click, {
#'    gauge$inc()
#'  })
#' }
#' 
#' 
#' app <- shinyApp(ui, server)
#' 
#' if(interactive())
#'  prometheusRenderShiny(app, registry)
#' 
#' @name prometheusRenderShiny
#' @export
prometheusRenderShiny <- function(app, registry){
  renderer <- PrometheusRenderMetrics$new()

  original_handler <- app$httpHandler

  app$httpHandler <- function(req){
    metrics <- renderer$render(registry$getMetricFamilySamples())

    if(req$PATH_INFO == "/metrics"){
      return(
        http_response(metrics)
      )
    }

    original_handler(req)
  }

  return(app)
}

# get unexported function from shiny
httpResponse <- getFromNamespace("httpResponse", "shiny")

#' HTTP Response
#' 
#' Serves the metrics as HTTP response for shiny.
#' 
#' @param content Output of renderer.
#' 
#' @noRd 
#' @keywords internal
http_response <- function(content){
  httpResponse(200, "text/plain", content)
}