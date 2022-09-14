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

tar_name_desc <- function() {
  "name: Symbol, name of the target. A target name must be a valid
  name for a symbol in R, and it must not start with a dot.
  Subsequent targets can refer to this name symbolically to
  induce a dependency relationship: e.g.
  'tar_target(downstream_target, f(upstream_target))' is a
  target named 'downstream_target' which depends on a target
  'upstream_target' and a function 'f()'. In addition, a
  target's name determines its random number generator seed. In 
  this way, each target runs with a reproducible seed so
  someone else running the same pipeline should get the same
  results, and no two targets in the same pipeline share the
  same seed. (Even dynamic branches have different names and
  thus different seeds.) You can recover the seed of a
  completed target with 'tar_meta(your_target, seed)' and run
  'set.seed()' on the result to locally recreate the target's
  initial RNG state."
}

tar_command_desc <- function() {
  "command: R code to run the target."
}
