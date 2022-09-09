server <- function(input, output, session) {
  values <- shiny::reactiveValues()
  shiny::observeEvent(
    input$update,
    update_values(values, input),
    ignoreNULL = FALSE
  )
  shiny::observeEvent(
    input$reset, {
      visNetwork::visNetworkProxy("graph") |>
        visNetwork::visFit() |>
        visNetwork::visUnselectAll()
      req(input$manifest_rows_selected)
      prevSelectedIDs <- values$manifest[input$manifest_rows_selected, ]$name
      DTproxy <- DT::dataTableProxy("manifest")
      DT::selectRows(DTproxy, list())
      visNetwork::visNetworkProxy("graph") |>
        visNetwork::visUpdateNodes(nodes = data.frame(id = prevSelectedIDs,
                                                      color = "#899DA4"))
    }
  )
  shiny::observeEvent(
    input$manifest_rows_selected, {
      print(values$manifest[input$manifest_rows_selected, ])
      allIDs <- values$manifest$name
      selectedIDs <- values$manifest[input$manifest_rows_selected, ]$name
      visNetwork::visNetworkProxy("graph") |>
        visNetwork::visUpdateNodes(nodes = data.frame(id = allIDs,
                                                      color = "#899DA4"))
      if (length(selectedIDs) > 0) {
        visNetwork::visNetworkProxy("graph") |>
          visNetwork::visUpdateNodes(nodes = data.frame(id = selectedIDs,
                                                       color = "green"))
        }
      }, ignoreNULL = FALSE)
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

  shiny::observeEvent(input$clipbtn, {
    shinyalert::shinyalert(title = "_targets.R copied to clipboard",
                           type = "success")
  })

  shiny::observeEvent(input$add_target, {
    original_text <- input$script
    new_target_text <- "#new target placeholder"
    shinyAce::updateAceEditor(
      session,
      "script",
      paste0(c(original_text, new_target_text),
              collapse = "\n")
    )
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
  values$graph <- targets::tar_glimpse(targets_only = FALSE) |>
    visNetwork::visInteraction(navigationButtons = TRUE)
  values$manifest <- targets::tar_manifest()
}
