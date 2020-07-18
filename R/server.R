server <- function(input, output, session) {
  values <- shiny::reactiveValues()
  shiny::observeEvent(
    input$update,
    update_values(values, input),
    ignoreNULL = FALSE
  )
  output$manifest <- DT::renderDataTable(values$manifest, rownames = FALSE)
  output$graph <- visNetwork::renderVisNetwork(values$graph)
  output$download <- shiny::downloadHandler(
    filename = function() "_targets.R",
    content = function(con) writeLines(input$script, con)
  )
}

update_values <- function(values, input) {
  shinybusy::show_modal_spinner(
    spin = "self-building-square",
    text = "Analyzing the pipeline..."
  )
  withr::local_dir(tempdir())
  writeLines(input$script, "_targets.R")
  with_handling(update_values_impl(values))
  shinybusy::remove_modal_spinner()
}

update_values_impl <- function(values) {
  values$graph <- targets::tar_glimpse(targets_only = FALSE)
  values$manifest <- targets::tar_manifest()
}
