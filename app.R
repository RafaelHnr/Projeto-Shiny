library(shiny)

ui <- fluidPage(
  titlePanel("tarot é coisa de idiota"),
  h1("TRABAI DE MCCD"),
  h2("tung tung tung tung tung tung tung")
)

server <- function(input, output, session) {
  dados_prontos <- readRDS("Dados Tratados/dados_prontos.rds") 
}

shinyApp(ui = ui, server = server)