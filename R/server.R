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
      shiny::req(input$manifest_rows_selected)
      prevSelectedIDs <- values$manifest[input$manifest_rows_selected, ]$name
      DTproxy <- DT::dataTableProxy("manifest")
      DT::selectRows(DTproxy, list())
      visNetwork::visNetworkProxy("graph") |>
        visNetwork::visUpdateNodes(
          nodes = data.frame(id = prevSelectedIDs, color = "#899DA4")
        )
    }
  )
  shiny::observeEvent(
    input$manifest_rows_selected, {
      print(values$manifest[input$manifest_rows_selected, ])
      allIDs <- values$manifest$name
      selectedIDs <- values$manifest[input$manifest_rows_selected, ]$name
      visNetwork::visNetworkProxy("graph") |>
        visNetwork::visUpdateNodes(
          nodes = data.frame(id = allIDs, color = "#899DA4")
        )
      if (length(selectedIDs) > 0) {
        visNetwork::visNetworkProxy("graph") |>
          visNetwork::visUpdateNodes(
            nodes = data.frame(id = selectedIDs, color = "green")
          )
      }
    },
    ignoreNULL = FALSE
  )
  output$manifest <- DT::renderDataTable(values$manifest, rownames = FALSE)
  output$graph <- visNetwork::renderVisNetwork(values$graph)
  output$download <- shiny::downloadHandler(
    filename = function() "_targets.R",
    content = function(con) writeLines(input$script, con)
  )
  output$clip <- shiny::renderUI({
    output$clip <- shiny::renderUI({
      rclipboard::rclipButton(
        inputId = "clipbtn",
        label = "Copy",
        clipText = input$script,
        icon = shiny::icon("clipboard")
      )
    })
  })
  shiny::observeEvent(input$clipbtn, {
    shinyalert::shinyalert(
      title = "_targets.R copied to clipboard",
      type = "success"
    )
  })
  shiny::observeEvent(input$add_target, {
    script_modal()
  })
  shiny::observeEvent(input$modal_ok, {
    print(input$modal_tar_name)
    print(input$modal_tar_command)
    if (
      nchar(input$modal_tar_name) > 0 & nchar(input$modal_tar_command) > 0
    ) {
      original_text <- input$script
      new_target_text <- paste0(
        " |>\n  append(tar_target(",
        input$modal_tar_name,
        ", ",
        input$modal_tar_command,
        "))",
        sep = ""
      )
      shiny::removeModal()
      shinyAce::updateAceEditor(
        session,
        "script",
        paste0(
          c(original_text, new_target_text),
          collapse = ""
        )
      )
      shinyalert::shinyalert(
        title = "Added new target to _targets.R",
        type = "success"
      )
    }
  })
  shiny::observeEvent(
    input$loadFile, {
      shinyFiles::shinyFileChoose(
        input,
        'loadFile',
        roots = c(root = '.'),
        filetypes = c('', 'R', 'md')
      )
      inFile <- shinyFiles::parseFilePaths(
        roots = c(root = "."),
        input$loadFile
      )
      if(length(inFile$datapath) > 0){
        lines <- readLines(inFile$datapath)
        shinyAce::updateAceEditor(
          session,
          "script",
          paste(
            lines,
            collapse = "\n"
          )
        )
      }
    }
  )
  observeEvent(
    input$saveFile,{
      shinyFiles::shinyFileSave(
        input,
        "saveFile",
        roots = c(root = ".")
      )
      if (length(input$saveFile) > 1) {
        fileinfo <- shinyFiles::parseSavePath(
          roots = c(root = "."),
          input$saveFile)
        writeLines(input$script, as.character(fileinfo$datapath))
      }
    }
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
  values$manifest <- targets::tar_manifest()
}

script_modal <- function() {
  shiny::showModal(
    shiny::modalDialog(
      shiny::textInput(
        "modal_tar_name",
        label = label_with_tooltip(
          "Enter target name",
          paste0(
            tar_name_desc(),
            collapse = "\n"
          )
        )
      ),
      shiny::textAreaInput(
        "modal_tar_command",
        label = label_with_tooltip(
          "Enter target command",
          paste0(
            tar_command_desc(),
            collapse = "\n")
        )
      ),
      title = "Declare the new target",
      footer = shiny::tagList(
        shiny::modalButton("Cancel"),
        shiny::actionButton("modal_ok", "OK")
      ),
      easyClose = TRUE
    )
  )
}
