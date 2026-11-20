library(shiny)

ui <- fluidPage(
  titlePanel("corinthians maior do Brasil"),
  h1("TRABAI DE MCCD")
)

server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)