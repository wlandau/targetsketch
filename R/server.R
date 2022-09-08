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

  output$clip <- renderUI({
    output$clip <- renderUI({
      rclipboard::rclipButton(
        inputId = "clipbtn",
        label = "Copy",
        clipText = input$script,
        icon = icon("clipboard")
      )
    })
  })

  observeEvent(input$clipbtn, {
    shinyalert::shinyalert(title = "_targets.R copied to clipboard",
                           type = "success")
  })
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
