#' @title Launch the targetsketch app
#' @description Launch an interactive web application for
#'   creating and visualizing `targets` pipelines.
#' @param script Character of length 1, path to an existing targets script.
#' When `script` is `NULL` (default) then the function uses the default
#' starting script. If `script` file does not exist then function will stop
#' and user will get an error message.
#' @export
#' @examples
#' \dontrun{
#' targetsketch()
#' }
targetsketch <- function(script = NULL) {
  if (is.null(script) || file.exists(script)) {
    shiny::shinyApp(ui = ui(script = script), server = server)
  } else {
    stop(
      paste(
        "Targets script does not exist at specified path.",
        "Please specify a file path that exists."
      )
    )
  }
}
