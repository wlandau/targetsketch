library(rsconnect)
setAccountInfo(
  name = Sys.getenv("SHINYAPPS_NAME"),
  token = Sys.getenv("SHINYAPPS_TOKEN"),
  secret = Sys.getenv("SHINYAPPS_SECRET")
)
deployApp(
  appDir = ".",
  appName = "targetsketch",
  account = Sys.getenv("SHINYAPPS_NAME"),
  server = "shinyapps.io",
  forceUpdate = TRUE
)
