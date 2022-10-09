#' @title Launch the targetsketch app
#' @description Launch an interactive web application for
#'   creating and visualizing `targets` pipelines.
#' @param script path of reference _targets.R script
#' @export
#' @examples
#' \dontrun{
#' targetsketch()
#' }
targetsketch <- function(script = NULL) {
  shiny::shinyApp(ui = ui(path = script), server = server)
}
