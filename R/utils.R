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
