library(shiny)

ui <- fluidPage(
  titlePanel("TASM PIOR FILME DO HOMEM ARANHA"),
  h2("Olá, mundo!")
)

server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)