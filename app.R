library(shiny)

ui <- fluidPage(
  titlePanel("tarot é coisa de idiota"),
  h1("TRABAI DE MCCD"),
  h2("Skibidi toilet")
)

server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)