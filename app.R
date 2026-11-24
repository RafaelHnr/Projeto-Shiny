library(shiny)
library(dplyr)
library(ggplot2)
library(readr)

dados_prontos <- readRDS("Dados Tratados/dados_prontos.rds")

ui <- fluidPage(
  titlePanel("Filmes no Brasil"),
  
  tabsetPanel(
    
    tabPanel("Introdução a base de dados",
             h3("teste")
    ),
    
    tabPanel("Evolução do Cinema ao Longo dos Anos",
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
                   label = "Qual a Nacionalidade? (Você também pode escolher as duas)",
                   choices = c("Brasileira", "Estrangeira"),
                   selected = c("Brasileira", "Estrangeira"),
                   multiple = TRUE
                 )
               ),
               
               mainPanel(
                 h3("Evolução do Cinema ao Longo dos Anos"),
                 plotOutput("grafico_evolucao", height = "500px"),
                 h4("Resultados por Ano e Nacionalidade"),
                 tableOutput(outputId = "tabela_evolucao")
               )
             )
    )
    
  )
)

server <- function(input, output, session) {
  
  dados_grafico <- reactive({
    
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
    
    dados_filtrados %>%
      group_by(ano_de_exibicao, nacionalidade_da_obra) %>%
      summarise(
        valor = sum(valor, na.rm = TRUE),
        .groups = "drop"
      )
    
  })
  
  output$tabela_evolucao <- renderTable({
    
    tabela <- dados_grafico()
    
    names(tabela) <- c("Ano", "Nacionalidade", "Total")
    
    tabela$Total <- format(
      tabela$Total,
      big.mark = ".",
      decimal.mark = ",",
      scientific = FALSE,
      trim = TRUE
    )
    
    tabela
    
  }, striped = TRUE, hover = TRUE, bordered = TRUE, rownames = FALSE)
  
  output$grafico_evolucao <- renderPlot({
    
    ggplot(dados_grafico(),
           aes(x = ano_de_exibicao,
               y = valor,
               color = nacionalidade_da_obra,
               group = nacionalidade_da_obra)) +
      geom_line(linewidth = 1.4) +
      geom_point(size = 2.9) +
      scale_color_manual(
        values = c("Brasileira" = "mediumseagreen",
                   "Estrangeira" = "firebrick2")
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