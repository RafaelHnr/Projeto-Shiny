library(shiny)
library(dplyr)
library(ggplot2)
library(readr)

dados_prontos <- readRDS("Dados Tratados/dados_prontos.rds")

ui <- fluidPage(
  titlePanel("tarot é coisa de idiota"),
  
  tabsetPanel(
    
    tabPanel("Apresentação dos Dados",
             h3("escolhemo pq sim carai")
    ),
    
    tabPanel("Evolução do cinema ao longo dos anos",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "genero",
                   label = "Selecione o gênero:",
                   choices = sort(unique(dados_prontos$genero)),
                   selected = "Animação",
                   multiple = FALSE
                 ),
                 
                 selectInput(
                   inputId = "indicador",
                   label = "O que você quer avaliar?",
                   choices = c("Público", "Dinheiro Arrecadado"),
                   multiple = FALSE
                 ),
                 
                 selectInput(
                   inputId = "nacionalidade",
                   label = "Qual a Nacionalidade? (Você também pode esolher as duas)",
                   choices = c("Brasileira", "Estrangeira"),
                   selected = c("Brasileira", "Estrangeira"),
                   multiple = TRUE
                 )
               ),
               
               mainPanel(
                 h3("Evolução do Cinema ao Longo dos Anos"),
                 plotOutput("grafico_evolucao", height = "500px")
               )
             )
    )
    
  )
)

server <- function(input, output, session) {
  
  output$grafico_evolucao <- renderPlot({
    
    req(input$genero, input$indicador, input$nacionalidade)
    
    dados_filtrados <- dados_prontos %>%
      filter(
        genero == input$genero,
        nacionalidade_da_obra %in% input$nacionalidade
      )
    
    if (input$indicador == "Público") {
      valores <- dados_filtrados$publico_no_ano_de_exibicao
    } else {
      valores <- dados_filtrados$renda_r_no_ano_de_exibicao
    }
    
    dados_filtrados$valor <- parse_number(
      valores,
      locale = locale(decimal_mark = ",", grouping_mark = ".")
    )
    
    dados_grafico <- dados_filtrados %>%
      group_by(ano_de_exibicao, nacionalidade_da_obra) %>%
      summarise(
        valor = sum(valor, na.rm = TRUE),
        .groups = "drop"
      )
    
    ggplot(dados_grafico,
           aes(x = ano_de_exibicao,
               y = valor,
               color = nacionalidade_da_obra,
               group = nacionalidade_da_obra)) +
      geom_line(linewidth = 1.2) +
      geom_point(size = 2.5) +
      scale_color_manual(
        values = c("Brasileira" = "blue",
                   "Estrangeira" = "red")
      ) +
      scale_x_discrete(
        breaks = as.character(seq(2009, 2025, by = 2))
      ) +
      scale_y_continuous(
        labels = function(x) format(
          x, big.mark = ".", scientific = FALSE, trim = TRUE
        )
      ) +
      labs(
        x = "Ano de Exibição",
        y = if (input$indicador == "Público") {
          "Quantidade de Espectadores"
        } else {
          "Dinheiro Arrecadado (R$)"
        },
        color = "Nacionalidade"
      ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(size = 13),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14),
        legend.position = "bottom",
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12)
      )
    
  })
  
}

shinyApp(ui = ui, server = server)