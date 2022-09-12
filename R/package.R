#' targetsketch: An R/Shiny app to visualize `targets` pipelines.
#' @docType package
#' @description `targetsketch` is an package and R/Shiny app
#'   for creating and visualizing `targets` pipelines.
#' @name targetsketch-package
#' @author William Michael Landau \email{will.landau@@gmail.com}
#' @examples
#' # targetsketch() # Launches the app.
#' @references <https://github.com/wlandau/targetsketch>
#' @import tidyverse
#' @importFrom bs4Dash bs4Card bs4DashBody bs4DashSidebar bs4SidebarMenu
#'   bs4DashNavbar bs4DashPage bs4SidebarMenu bs4SidebarMenuItem bs4Sortable
#'   bs4TabItem bs4TabItems
#' @importFrom DT dataTableOutput renderDataTable
#' @importFrom htmltools tags
#' @importFrom markdown markdownToHTML
#' @importFrom rclipboard rclipboardSetup rclipButton
#' @importFrom shiny actionButton column downloadHandler downloadButton fluidRow
#'   icon observeEvent reactiveValues renderText renderUI req shinyApp
#'   verbatimTextOutput
#' @importFrom shinyalert useShinyalert
#' @importFrom shinyAce aceEditor
#' @importFrom shinybusy remove_modal_spinner show_modal_spinner
#' @importFrom shinycssloaders withSpinner
#' @importFrom targets tar_glimpse tar_manifest
#' @importFrom tarchetypes tar_map
#' @importFrom visNetwork renderVisNetwork visNetworkOutput
#' @importFrom withr local_dir
NULL
