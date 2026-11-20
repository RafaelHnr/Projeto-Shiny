library(shiny)

ui <- fluidPage(
  titlePanel("arthur goat"),
  h2("Olá, mundo!")
)

server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)