library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(readr)

dados_prontos <- readRDS("Dados Tratados/dados_prontos.rds")

# Identidade visual
tema <- bs_theme(
  version = 5,
  bootswatch = "darkly",
  bg = "#151923",
  fg = "#F5F5F5",
  primary = "#D9A85F"
)

ui <- page_navbar(
  title = "CINE.DADOS",
  id = "pagina",
  theme = tema,
  
  header = tags$head(
    tags$style(HTML("
      .hero {
        background: linear-gradient(135deg, #252C38, #151923);
        padding: 55px 45px;
        border-radius: 18px;
        margin-top: 20px;
        margin-bottom: 25px;
        border: 1px solid #323B4B;
      }
      .hero span {
        color: #D9A85F;
        font-weight: 700;
        letter-spacing: 2px;
        font-size: 13px;
      }
      .hero h1 {
        font-size: 44px;
        font-weight: 800;
        color: #FFFFFF;
        margin-top: 10px;
      }
      .hero p {
        font-size: 17px;
        color: #D0D3DA;
        max-width: 700px;
      }
      .info-card {
        background: #252C38;
        padding: 22px;
        border-radius: 12px;
        height: 100%;
        border: 1px solid #323B4B;
      }
      .info-card h3 {
        color: #D9A85F;
        margin-bottom: 5px;
      }
      .card {
        background-color: #1E2430 !important;
        border: 1px solid #323B4B !important;
      }
    "))
  ),
  
  # ==========================================
  # ABA 1: APRESENTAÇÃO, OBJETIVOS E VARIÁVEIS
  # ==========================================
  nav_panel(
    "Início e Base de Dados",
    
    div(
      class = "hero",
      span("CINEMA • DADOS • BRASIL"),
      h1("O cinema brasileiro em números."),
      p(
        "Explore a evolução do mercado cinematográfico brasileiro e estrangeiro 
        exibido no Brasil entre 2009 e 2025 a partir dos microdados públicos da ANCINE."
      ),
      actionButton(
        "explorar",
        "Explorar os dados →",
        class = "btn btn-warning btn-lg"
      )
    ),
    
    layout_columns(
      div(class = "info-card", h3("2009–2025"), p("Período histórico analisado")),
      div(class = "info-card", h3("Brasil"), p("Salas de exibição em território nacional")),
      div(class = "info-card", h3("ANCINE"), p("Agência Nacional do Cinema (Fonte oficial)")),
      col_widths = c(4, 4, 4)
    ),
    
    br(),
    
    layout_columns(
      card(
        card_header(strong("Objetivos do Aplicativo")),
        p("Investigar o comportamento do mercado exibidor no Brasil ao longo de 17 anos, comparando:"),
        tags$ul(
          tags$li("A evolução temporal de público e arrecadação (R$) por gênero cinematográfico;"),
          tags$li("A participação de mercado entre obras brasileiras e estrangeiras;"),
          tags$li("O impacto de períodos específicos (como a retração de 2020–2021 e a retomada posterior).")
        )
      ),
      card(
        card_header(strong("Variáveis Consideradas na Base")),
        p("O conjunto de dados tratado reúne mais de 6 variáveis da ANCINE, destacando-se:"),
        tags$ul(
          tags$li(strong("ano_de_exibicao:"), " Ano em que a obra foi exibida nas salas (2009 a 2025)."),
          tags$li(strong("genero:"), " Classificação do gênero da obra (ex: Animação, Comédia, Drama)."),
          tags$li(strong("nacionalidade_da_obra:"), " Origem da produção (Brasileira ou Estrangeira)."),
          tags$li(strong("publico_no_ano_de_exibicao:"), " Total de espectadores pagantes/registrados no ano."),
          tags$li(strong("renda_r_no_ano_de_exibicao:"), " Bilheteria bruta arrecadada em reais (R$)."),
          tags$li(strong("titulo_da_obra / distribuidora:"), " Identificação dos filmes e empresas distribuidoras.")
        )
      ),
      col_widths = c(6, 6)
    )
  ),
  
  # ==========================================
  # ABA 2: ANÁLISE TEMPORAL (3 TIPOS DE INPUT + 2 OUTPUTS + DOWNLOAD)
  # ==========================================
  nav_panel(
    "Evolução ao Longo dos Anos",
    
    layout_sidebar(
      sidebar = sidebar(
        bg = "#1E2430",
        title = "Filtros da Análise",
        
        # Tipo de Input 1: selectInput
        selectInput(
          inputId = "genero",
          label = "1. Selecione o gênero:",
          choices = sort(unique(dados_prontos$genero)),
          selected = "Animação",
          multiple = FALSE
        ),
        
        # Tipo de Input 2: radioButtons (diferente de selectInput!)
        radioButtons(
          inputId = "indicador",
          label = "2. O que você quer avaliar?",
          choices = c("Público", "Dinheiro Arrecadado"),
          selected = "Público"
        ),
        
        # Tipo de Input 3: checkboxGroupInput (diferente dos anteriores!)
        checkboxGroupInput(
          inputId = "nacionalidade",
          label = "3. Nacionalidade da obra:",
          choices = c("Brasileira", "Estrangeira"),
          selected = c("Brasileira", "Estrangeira")
        ),
        
        hr(),
        
        # Requisito obrigatório: Botão de Download
        downloadButton(
          outputId = "baixar_tabela",
          label = "Baixar dados filtrados (.csv)",
          class = "btn-warning w-100"
        )
      ),
      
      # Área Principal (2 tipos de outputs: plotOutput e tableOutput)
      card(
        card_header(strong("Evolução Temporal por Nacionalidade")),
        plotOutput("grafico_evolucao", height = "460px")
      ),
      
      card(
        card_header(strong("Resultados Consolidados por Ano e Nacionalidade")),
        tableOutput("tabela_evolucao")
      )
    )
  ),
  
  # ==========================================
  # ABA 3: SEGUNDA ANÁLISE (ESTRUTURA PRONTA PARA PREENCHER)
  # ==========================================
  nav_panel(
    "Ranking e Comparativo",
    layout_sidebar(
      sidebar = sidebar(
        bg = "#1E2430",
        title = "Parâmetros do Ranking",
        sliderInput(
          inputId = "periodo_aba3",
          label = "Intervalo de anos:",
          min = 2009,
          max = 2025,
          value = c(2015, 2025),
          sep = ""
        ),
        numericInput(
          inputId = "top_n",
          label = "Quantidade de itens no ranking:",
          value = 10,
          min = 3,
          max = 25
        )
      ),
      card(
        card_header(strong("Espaço para o 2º Gráfico (plotOutput) e Tabela/Texto")),
        p("Aqui podemos colocar o ranking de gêneros ou maiores bilheterias usando os filtros ao lado.")
      )
    )
  )
)

server <- function(input, output, session) {
  
  # Navegação pelo botão da tela inicial
  observeEvent(input$explorar, {
    nav_select("pagina", "Evolução ao Longo dos Anos")
  })
  
  # Dados reativos da Aba 2
  dados_grafico <- reactive({
    req(input$genero, input$indicador, input$nacionalidade)
    
    dados_filtrados <- dados_prontos %>%
      filter(
        genero == input$genero,
        nacionalidade_da_obra %in% input$nacionalidade
      )
    
    valores <- if (input$indicador == "Público") {
      dados_filtrados$publico_no_ano_de_exibicao
    } else {
      dados_filtrados$renda_r_no_ano_de_exibicao
    }
    
    dados_filtrados$valor <- parse_number(
      as.character(valores),
      locale = locale(decimal_mark = ",", grouping_mark = ".")
    )
    
    dados_filtrados %>%
      group_by(ano_de_exibicao, nacionalidade_da_obra) %>%
      summarise(
        valor = sum(valor, na.rm = TRUE),
        .groups = "drop"
      )
  })
  
  # Output 1: Gráfico estilizado para o tema escuro
  output$grafico_evolucao <- renderPlot({
    ggplot(dados_grafico(),
           aes(x = ano_de_exibicao,
               y = valor,
               color = nacionalidade_da_obra,
               group = nacionalidade_da_obra)) +
      geom_line(linewidth = 1.4) +
      geom_point(size = 3) +
      scale_color_manual(
        values = c("Brasileira" = "#D9A85F",
                   "Estrangeira" = "#4EA8DE")
      ) +
      scale_x_discrete(
        breaks = as.character(seq(2009, 2025, by = 2))
      ) +
      scale_y_continuous(
        labels = function(x) format(x, big.mark = ".", scientific = FALSE, trim = TRUE)
      ) +
      labs(
        x = "Ano de Exibição",
        y = if (input$indicador == "Público") "Quantidade de Espectadores" else "Dinheiro Arrecadado (R$)",
        color = "Nacionalidade"
      ) +
      theme_minimal() +
      theme(
        plot.background = element_rect(fill = "#1E2430", color = NA),
        panel.background = element_rect(fill = "#1E2430", color = NA),
        panel.grid.major = element_line(color = "#323B4B", linewidth = 0.4),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(size = 12, color = "#D0D3DA"),
        axis.text.y = element_text(size = 11, color = "#D0D3DA"),
        axis.title.x = element_text(size = 13, color = "#FFFFFF", margin = margin(t = 10)),
        axis.title.y = element_text(size = 13, color = "#FFFFFF", margin = margin(r = 10)),
        legend.position = "bottom",
        legend.text = element_text(size = 12, color = "#F5F5F5"),
        legend.title = element_text(size = 12, color = "#D9A85F", face = "bold")
      )
  })
  
  # Output 2: Tabela formatada
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
  }, striped = TRUE, hover = TRUE, bordered = TRUE, rownames = FALSE, width = "100%")
  
  # Download dos dados filtrados
  output$baixar_tabela <- downloadHandler(
    filename = function() {
      paste0("cinema_brasil_", tolower(input$genero), ".csv")
    },
    content = function(file) {
      write.csv2(dados_grafico(), file, row.names = FALSE)
    }
  )
}

shinyApp(ui = ui, server = server)