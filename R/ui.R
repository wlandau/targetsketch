ui <- function() {
  ui_pipeline <- bs4Dash::bs4TabItem(
    tabName = "pipeline",
    shinyalert::useShinyalert(),
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
            shiny::actionButton(
              "update",
              "Update",
              icon = shiny::icon("redo-alt")
            ),
            shiny::downloadButton("download", "Download")
          ),
          bs4Dash::bs4Card(
            title = "_targets.R",
            width = 12,
            status = "primary",
            closable = FALSE,
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
            shinycssloaders::withSpinner(visNetwork::visNetworkOutput("graph"))
          ),
          bs4Dash::bs4Card(
            title = "Manifest",
            width = 12,
            status = "success",
            closable = FALSE,
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
        "Pipeline",
        tabName = "pipeline",
        icon = "project-diagram"
      ),
      bs4Dash::bs4SidebarMenuItem(
        "Usage",
        tabName = "usage",
        icon = "book-reader"
      )
    )
  )

  bs4Dash::bs4DashPage(
    title = " targetsketch",
    body = ui_body,
    navbar = bs4Dash::bs4DashNavbar(controlbarIcon = NULL),
    sidebar = ui_sidebar
  )
}
