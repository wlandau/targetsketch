server <- function(input, output, session) {
  values <- shiny::reactiveValues()
  shiny::observeEvent(
    input$update,
    update_values(values, input),
    ignoreNULL = FALSE
  )
  shiny::observeEvent(
    input$reset,{
      visNetworkProxy("graph") |> 
        visFit() |>
        visUnselectAll()
    }
  )
  shiny::observeEvent(
    input$manifest_rows_selected, {
      print( values$manifest[input$manifest_rows_selected, ] )
      selectedIDs <- values$manifest[input$manifest_rows_selected, ]$name
      print(selectedIDs)
      visNetworkProxy("graph") |>
        visUpdateNodes(nodes= data.frame(id = selectedIDs, color = "green")) 
    }
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
  values$graph <- targets::tar_glimpse(targets_only = FALSE) |>
    visNetwork::visInteraction(navigationButtons = TRUE)
    # visNetwork::visLegend(useGroups = FALSE, addNodes = values, ncol = 1L, position = "right")
  values$manifest <- targets::tar_manifest()
}
