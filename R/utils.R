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

rd_get_text <- function(x) {
  if (is.character(x)) {
    return(c(x))
  }
  rval <- NULL
  file <- textConnection("rval", "w", local = TRUE)
  save <- options(useFancyQuotes = FALSE)
  Rdsave <- tools::Rd2txt_options(underline_titles = FALSE)
  sink(file)
  tryCatch(
    tools::Rd2txt(x, fragment = TRUE),
    finally = {
      sink()
      options(save)
      tools::Rd2txt_options(Rdsave)
      close(file)
    }
  )
  if (is.null(rval)) {
    rval <- character()
  } else {
    enc2utf8(rval)
  }
}

fetchRdDB <- function(filebase, key = NULL) {
  fun <- function(db) {
    vals <- db$vals
    vars <- db$vars
    datafile <- db$datafile
    compressed <- db$compressed
    envhook <- db$envhook
    fetch <- function(key) {
      lazyLoadDBfetch(vals[key][[1L]], datafile, compressed, envhook)
    }
    `%notin%` <- Negate(`%in%`)
    if (length(key)) {
      if (key %notin% vars)
        stop(gettextf(
          "No help on %s found in RdDB %s",
          sQuote(key),
          sQuote(filebase)
        ),
        domain = NA)
      fetch(key)
    } else {
      res <- lapply(vars, fetch)
      names(res) <- vars
      res
    }
  }
  res <- lazyLoadDBexec(filebase, fun)
  if (length(key)) {
    res
  } else {
    invisible(res)
  }
}


get_help_file <- function(file) {
  path <- dirname(file)
  dirpath <- dirname(path)
  if (!file.exists(dirpath)) {
    stop(gettextf("invalid %s argument", sQuote("file")),
         domain = NA)
  }
  pkgname <- basename(dirpath)
  RdDB <- file.path(path, pkgname)
  if (!file.exists(paste0(RdDB, ".rdx"))) {
    stop(
      gettextf(
        "package %s exists but was not installed under R >= 2.10.0
                    so help cannot be accessed",
        sQuote(pkgname)
      ),
      domain = NA
    )
  }
  fetchRdDB(RdDB, basename(file))
}

get_function_doc <- function(function_name, package_name) {
  helptext <- utils::help(
    topic = (function_name),
    package = (package_name)
    )
  help_documentation <- rd_get_text(get_help_file(as.character(helptext)))
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
