ui <- function() {
  ui_pipeline <- bs4Dash::bs4TabItem(
    tabName = "pipeline",
    rclipboard::rclipboardSetup(),
    htmltools::tags$head(
      htmltools::tags$style("#source{overflow-y:scroll; max-height: 400px;}")
    ),
    shiny::fluidRow(
      shiny::column(
        6,
        bs4Dash::bs4Sortable(
          width = 12,
          bs4Dash::bs4Card(
            title = "Control",
            width = 12,
            status = "primary",
            closable = FALSE,
            solidHeader = TRUE,
            shiny::div(
              style = "display:inline-block",
              shiny::actionButton(
                "update",
                "Update",
                icon = shiny::icon("redo-alt")
              )
            ),
            shiny::div(
              style = "display:inline-block",
              shiny::downloadButton("download", "Download")
            ),
            shiny::div(style = "display:inline-block", shiny::uiOutput("clip")),
            shiny::div(style = "display:inline-block", shiny::actionButton(
              "reset",
              "Reset selection",
              icon = shiny::icon("undo-alt"))),
            shiny::div(
              style = "display:inline-block",
              bs4Dash::tooltip(
                shiny::actionButton(
                  "add_target",
                  "Add target",
                  icon = shiny::icon("plus")),
                title = "Add new target to your list",
                placement = "bottom"
              )
            ),
            shiny::div(
              style = "display:inline-block",
              shinyFiles::shinyFilesButton(
                "loadFile",
                "Load _targets.R",
                title = "Please select a file",
                multiple = FALSE,
                icon = shiny::icon("upload")
              )
            ),
            shiny::div(
              style = "display:inline-block",
              shinyFiles::shinySaveButton(
                "saveFile",
                "Save _targets.R",
                filename = "_targets.R",
                title = "Please select a folder",
                icon = shiny::icon("save")
              )
            )
          ),
          bs4Dash::bs4Card(
            title = "_targets.R",
            width = 12,
            status = "primary",
            closable = FALSE,
            solidHeader = TRUE,
            shinyAce::aceEditor(
              "script",
              default_target_text(),
              fontSize = 14,
              tabSize = 2,
              height = "600px"
            ),
            shiny::textOutput("pipeline_warnings")
          )
        )
      ),
      shiny::column(
        6,
        bs4Dash::bs4Sortable(
          width = 12,
          bs4Dash::bs4Card(
            title = "Graph",
            width = 12,
            status = "success",
            closable = FALSE,
            solidHeader = TRUE,
            shinycssloaders::withSpinner(
              visNetwork::visNetworkOutput("graph")
            )
          ),
          bs4Dash::bs4Card(
            title = "Manifest",
            width = 12,
            status = "success",
            closable = FALSE,
            solidHeader = TRUE,
            shinycssloaders::withSpinner(DT::dataTableOutput("manifest"))
          )
        )
      )
    )
  )
  ui_usage <- bs4Dash::bs4TabItem(
    tabName = "usage",
    bs4Dash::bs4Card(
      title = "Usage",
      width = 12,
      status = "success",
      closable = FALSE,
      solidHeader = TRUE,
      shiny::includeMarkdown(
        system.file("README.md", package = "targetsketch", mustWork = TRUE)
      )
    )
  )
  ui_body <- bs4Dash::bs4DashBody(
    bs4Dash::bs4TabItems(
      ui_pipeline,
      ui_usage
    )
  )
  ui_sidebar <- bs4Dash::bs4DashSidebar(
    skin = "light",
    status = "primary",
    brandColor = "primary",
    title = "targetsketch",
    bs4Dash::bs4SidebarMenu(
      bs4Dash::bs4SidebarMenuItem(
        text = "Pipeline",
        tabName = "pipeline",
        icon = shiny::icon("project-diagram")
      ),
      bs4Dash::bs4SidebarMenuItem(
        text = "Usage",
        tabName = "usage",
        icon = shiny::icon("book-reader")
      )
    )
  )
  bs4Dash::bs4DashPage(
    title = " targetsketch",
    body = ui_body,
    header = bs4Dash::bs4DashNavbar(controlbarIcon = NULL),
    sidebar = ui_sidebar,
    dark = NULL
  )
}
