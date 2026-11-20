library(shiny)

ui <- fluidPage(
  titlePanel("TASM 1 MELHOR FILME"),
  h2("Olá, mundo!")
)

server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)