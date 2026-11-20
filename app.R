library(shiny)

ui <- fluidPage(
  titlePanel("tarot é coisa de idiota"),
  h1("TRABAI DE MCCD")
)

server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)