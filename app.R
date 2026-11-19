library(shiny)

ui <- fluidPage(
  titlePanel("Meu Projeto Shiny"),
  h2("Olá, mundo!")
)

server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)