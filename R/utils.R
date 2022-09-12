with_handling <- function(code) {
  tryCatch(
    withCallingHandlers(code, warning = handle_warning),
    error = handle_error
  )
}

handle_warning <- function(w) {
  shinyalert::shinyalert("warning", w$message, type = "warning")
  "warning"
}

handle_error <- function(e) {
  shinyalert::shinyalert("error", e$message, type = "error")
  "error"
}

default_target_text <- function() {
  path <- system.file("_targets.R", package = "targetsketch", mustWork = TRUE)
  lines <- readLines(path)
  paste(lines, collapse = "\n")
}

label_with_tooltip <- function(label, ...) {
  shiny::tagList(
    label,
    shiny::a(
      class = "help-icon",
      href = "#",
      "data-toggle" = "tooltip",
      "data-html" = "true",
      shiny::icon("circle-info"),
      title = paste(...)
    )
  )
}

get_function_doc <- function(function_name, package_name) {
  helptext <- utils::help(topic = (function_name),
                   package = (package_name))
  rd_get_text <- utils::getFromNamespace(".Rd_get_text", "tools")
  getHelpFile <- utils::getFromNamespace(".getHelpFile", "utils")
  help_documentation <- rd_get_text(
    getHelpFile(
      as.character(helptext))
  )
  return(help_documentation)
}
