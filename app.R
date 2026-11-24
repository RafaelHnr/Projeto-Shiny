library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(readr)
library(plotly)

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
      html { scroll-behavior: smooth; }

      /* Hero estilo tela de abertura de site */
      .hero {
        background: radial-gradient(circle at top right, #2A3344 0%, #151923 70%);
        padding: 85px 40px;
        border-radius: 24px;
        margin-top: 15px;
        margin-bottom: 60px;
        text-align: center;
        border: 1px solid rgba(217, 168, 95, 0.25);
        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
      }
      .hero .tag-topo {
        display: inline-block;
        background: rgba(217, 168, 95, 0.15);
        color: #D9A85F;
        padding: 6px 16px;
        border-radius: 30px;
        font-weight: 700;
        letter-spacing: 2px;
        font-size: 12px;
        margin-bottom: 18px;
      }
      .hero h1 {
        font-size: 52px;
        font-weight: 800;
        color: #FFFFFF;
        margin-bottom: 18px;
        letter-spacing: -1px;
      }
      .hero p {
        font-size: 18px;
        color: #C5C9D3;
        max-width: 720px;
        margin: 0 auto 35px auto;
        line-height: 1.7;
      }

      /* Container centralizado para leitura orgânica ao rolar */
      .secao-editorial {
        max-width: 1120px;
        margin: 0 auto 75px auto;
        padding: 0 15px;
      }
      .subtitulo-dourado {
        color: #D9A85F;
        font-size: 13px;
        font-weight: 700;
        letter-spacing: 2px;
        text-transform: uppercase;
        margin-bottom: 8px;
      }
      .titulo-editorial {
        font-size: 32px;
        font-weight: 700;
        color: #FFFFFF;
        margin-bottom: 20px;
      }
      .texto-editorial {
        font-size: 16px;
        color: #C5C9D3;
        line-height: 1.8;
      }

      /* Destaques numéricos leves */
      .faixa-numeros {
        display: flex;
        justify-content: space-around;
        flex-wrap: wrap;
        gap: 20px;
        padding: 35px 20px;
        border-top: 1px solid #283040;
        border-bottom: 1px solid #283040;
        margin-bottom: 75px;
        text-align: center;
      }
      .numero-item h2 {
        font-size: 38px;
        font-weight: 800;
        color: #D9A85F;
        margin: 0;
      }
      .numero-item p {
        color: #9CA3AF;
        margin: 5px 0 0 0;
        font-size: 14px;
      }

      /* Grade simétrica: 4 + 4 + 3 centralizados */
      .grade-variaveis {
        display: grid;
        grid-template-columns: repeat(8, 1fr);
        gap: 16px;
        margin-top: 25px;
      }
      .var-pill {
        grid-column: span 2;
        background: #1E2430;
        border: 1px solid #323B4B;
        padding: 18px 18px;
        border-radius: 14px;
        font-size: 13.5px;
        color: #D0D3DA;
        display: flex;
        flex-direction: column;
        justify-content: center;
        text-align: center;
        transition: all 0.2s ease;
      }
      .var-pill:nth-child(9) {
        grid-column: 2 / span 2;
      }
      .var-pill:hover {
        border-color: #D9A85F;
        transform: translateY(-3px);
      }
      .var-pill strong {
        color: #D9A85F;
        font-size: 14.5px;
        margin-bottom: 6px;
      }

      @media (max-width: 992px) {
        .grade-variaveis {
          grid-template-columns: repeat(2, 1fr);
        }
        .var-pill, .var-pill:nth-child(9) {
          grid-column: span 1;
        }
      }

      .card {
        background-color: #1E2430 !important;
        border: 1px solid #323B4B !important;
        overflow: visible !important;
      }
      .card-body {
        overflow: visible !important;
      }
    "))
  ),
  
  # ==========================================
  # ABA 1: APRESENTAÇÃO ESTILO SITE (SCROLL)
  # ==========================================
  nav_panel(
    "Início",
    
    div(
      class = "hero",
      div(class = "tag-topo", "CINEMA • DADOS • BRASIL"),
      h1("O cinema brasileiro em números."),
      p(
        "Uma plataforma interativa para explorar a trajetória das salas de cinema no Brasil entre 2009 e 2025 — cruzando público, arrecadação, gêneros e a disputa entre produções nacionais e estrangeiras."
      ),
      div(
        style = "display: flex; gap: 15px; justify-content: center; flex-wrap: wrap;",
        actionButton(
          "explorar",
          "Explorar os gráficos →",
          class = "btn btn-primary btn-lg",
          style = "color: #151923; font-weight: 800; border-radius: 30px; padding: 12px 30px;"
        ),
        tags$a(
          href = "#sobre-projeto",
          class = "btn btn-outline-light btn-lg",
          style = "border-radius: 30px; padding: 12px 28px;",
          "Ler sobre o projeto ↓"
        )
      )
    ),
    
    div(
      class = "secao-editorial",
      div(
        class = "faixa-numeros",
        div(class = "numero-item", h2("2009–2025"), p("17 anos de histórico comercial")),
        div(class = "numero-item", h2("11 Variáveis"), p("Dados oficiais tratados")),
        div(class = "numero-item", h2("ANCINE / OCA"), p("Fonte pública nacional"))
      )
    ),
    
    div(
      id = "sobre-projeto",
      class = "secao-editorial",
      layout_columns(
        col_widths = c(6, 6),
        div(
          style = "padding-right: 20px;",
          div(class = "subtitulo-dourado", "O PROJETO"),
          h2(class = "titulo-editorial", "Introdução e Objetivos"),
          p(class = "texto-editorial",
            "Este aplicativo analisa o banco de dados oficial disponibilizado pela Agência Nacional do Cinema (ANCINE) e pelo Observatório Brasileiro do Cinema e do Audiovisual (OCA), referente aos filmes brasileiros e estrangeiros exibidos comercialmente no Brasil."
          ),
          p(class = "texto-editorial",
            "Nosso objetivo é investigar a evolução do mercado exibidor nacional, comparando a performance de público e renda (R$) por gênero cinematográfico, a participação das obras nacionais frente às estrangeiras e os efeitos de choques no setor, como o período 2020–2021."
          )
        ),
        div(
          style = "padding-left: 20px; border-left: 1px solid #283040;",
          div(class = "subtitulo-dourado", "BASTIDORES"),
          h2(class = "titulo-editorial", "Metodologia"),
          p(class = "texto-editorial",
            "O trabalho seguiu as etapas da Análise Exploratória de Dados (AED) utilizando a linguagem R e o pacote Shiny para construção da interface reativa."
          ),
          p(class = "texto-editorial",
            "Os registros brutos da ANCINE passaram por limpeza, conversão de formatos numéricos e padronização de categorias ausentes ('ND'). O desenvolvimento em equipe foi versionado via GitHub, com apoio técnico do Gemini na estruturação do código e refino visual."
          )
        )
      )
    ),
    
    div(
      class = "secao-editorial",
      div(class = "subtitulo-dourado", "DICIONÁRIO DE DADOS"),
      h2(class = "titulo-editorial", "O que está mapeado na base?"),
      p(class = "texto-editorial", "Confira as 11 variáveis consideradas na análise:"),
      
      div(
        class = "grade-variaveis",
        div(class = "var-pill", strong("Ano de Exibição"), "Ano em que o filme esteve em cartaz (2009 a 2025)"),
        div(class = "var-pill", strong("Data de Lançamento"), "Data oficial de estreia comercial no país"),
        div(class = "var-pill", strong("Título da Obra"), "Nome comercial registrado do longa-metragem"),
        div(class = "var-pill", strong("Registro (CPB / ROE)"), "Certificado de Produto Brasileiro ou Obra Estrangeira"),
        div(class = "var-pill", strong("Gênero"), "Ficção, Documentário, Animação ou Religiosa"),
        div(class = "var-pill", strong("País Produtor"), "País ou países responsáveis pela produção"),
        div(class = "var-pill", strong("Nacionalidade da Obra"), "Classificação entre obra Brasileira ou Estrangeira"),
        div(class = "var-pill", strong("Empresa Distribuidora"), "Distribuidora responsável pelo lançamento"),
        div(class = "var-pill", strong("Origem da Distribuidora"), "Capital Nacional, Estrangeiro ou Codistribuição"),
        div(class = "var-pill", strong("Público Anual"), "Total de espectadores registrados no ano"),
        div(class = "var-pill", strong("Renda Anual (R$)"), "Bilheteria bruta arrecadada em reais")
      )
    )
  ),
  
  # ==========================================
  # ABA 2: GRÁFICO 100% VISÍVEL SEM BARRA INTERNA
  # ==========================================
  nav_panel(
    "Evolução do Cinema ao Longo dos Anos",
    
    layout_sidebar(
      fillable = FALSE, # Impede que o card esprema o gráfico e crie barra de rolagem interna!
      sidebar = sidebar(
        width = 280,
        bg = "#1E2430",
        title = "Filtros da Análise",
        
        selectInput(
          inputId = "genero",
          label = "1. Selecione o gênero:",
          choices = sort(unique(dados_prontos$genero)),
          selected = "Animação",
          multiple = FALSE
        ),
        
        radioButtons(
          inputId = "indicador",
          label = "2. O que você quer avaliar?",
          choices = c("Público", "Dinheiro Arrecadado"),
          selected = "Público"
        ),
        
        checkboxGroupInput(
          inputId = "nacionalidade",
          label = "3. Nacionalidade da obra:",
          choices = c("Brasileira", "Estrangeira"),
          selected = c("Brasileira", "Estrangeira")
        ),
        
        hr(),
        
        downloadButton(
          outputId = "baixar_tabela",
          label = "Baixar dados filtrados (.csv)",
          class = "btn-warning w-100"
        )
      ),
      
      # Gráfico inteiro visível de ponta a ponta sem barra de rolagem interna
      card(
        card_header(
          style = "font-size: 17px; font-weight: 700; color: #D9A85F;",
          textOutput("titulo_grafico_aba2", inline = TRUE)
        ),
        plotlyOutput("grafico_evolucao", height = "480px", width = "100%")
      ),
      
      card(
        card_header(strong("Resultados Consolidados por Ano e Nacionalidade")),
        tableOutput(outputId = "tabela_evolucao")
      )
    )
  ),
  
  # ==========================================
  # ABA 3: SEGUNDA ANÁLISE
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
  
  observeEvent(input$explorar, {
    nav_select("pagina", "Evolução do Cinema ao Longo dos Anos")
  })
  
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
      as.character(valores),
      locale = locale(decimal_mark = ",", grouping_mark = ".")
    )
    
    anos_completos <- as.character(2009:2025)
    
    resumo <- dados_filtrados %>%
      mutate(ano_de_exibicao = as.character(ano_de_exibicao)) %>%
      group_by(ano_de_exibicao, nacionalidade_da_obra) %>%
      summarise(
        valor = sum(valor, na.rm = TRUE),
        .groups = "drop"
      )
    
    expand.grid(
      ano_de_exibicao = anos_completos,
      nacionalidade_da_obra = input$nacionalidade,
      stringsAsFactors = FALSE
    ) %>%
      left_join(resumo, by = c("ano_de_exibicao", "nacionalidade_da_obra")) %>%
      mutate(valor = ifelse(is.na(valor), 0, valor))
  })
  
  output$titulo_grafico_aba2 <- renderText({
    paste0(input$indicador, " — Gênero: ", input$genero, " (2009–2025)")
  })
  
  output$grafico_evolucao <- renderPlotly({
    df <- dados_grafico()
    eh_dinheiro <- input$indicador == "Dinheiro Arrecadado"
    
    cores <- c(
      "Brasileira" = "#D9A85F",
      "Estrangeira" = "#4EA8DE"
    )
    
    preenchimentos <- c(
      "Brasileira" = "rgba(217, 168, 95, 0.16)",
      "Estrangeira" = "rgba(78, 168, 222, 0.16)"
    )
    
    p <- plot_ly(height = 480)
    
    for (nac in unique(df$nacionalidade_da_obra)) {
      sub_df <- df %>% filter(nacionalidade_da_obra == nac)
      
      valor_formatado <- format(
        round(sub_df$valor, 2),
        big.mark = ".",
        decimal.mark = ",",
        scientific = FALSE,
        trim = TRUE
      )
      
      texto_hover <- if (eh_dinheiro) {
        paste0("<b>", nac, " (", sub_df$ano_de_exibicao, ")</b><br>Renda: R$ ", valor_formatado)
      } else {
        paste0("<b>", nac, " (", sub_df$ano_de_exibicao, ")</b><br>Público: ", valor_formatado, " espectadores")
      }
      
      p <- p %>%
        add_trace(
          data = sub_df,
          x = ~ano_de_exibicao,
          y = ~valor,
          name = nac,
          type = "scatter",
          mode = "lines+markers",
          fill = "tozeroy",
          fillcolor = preenchimentos[[nac]],
          line = list(color = cores[[nac]], width = 3),
          marker = list(color = cores[[nac]], size = 7),
          text = texto_hover,
          hoverinfo = "text"
        )
    }
    
    p %>%
      layout(
        paper_bgcolor = "#1E2430",
        plot_bgcolor = "#1E2430",
        margin = list(l = 85, r = 25, t = 20, b = 70),
        hovermode = "x unified",
        hoverlabel = list(
          bgcolor = "#151923",
          bordercolor = "#D9A85F",
          font = list(color = "#F5F5F5", size = 13)
        ),
        xaxis = list(
          title = list(text = "Ano de Exibição", font = list(color = "#FFFFFF", size = 14)),
          tickfont = list(color = "#D0D3DA", size = 12),
          gridcolor = "#283040",
          zeroline = FALSE,
          fixedrange = TRUE
        ),
        yaxis = list(
          title = list(
            text = if (eh_dinheiro) "Dinheiro Arrecadado (R$)" else "Quantidade de Espectadores",
            font = list(color = "#FFFFFF", size = 14)
          ),
          tickfont = list(color = "#D0D3DA", size = 12),
          gridcolor = "#323B4B",
          zeroline = FALSE,
          separatethousands = TRUE,
          fixedrange = TRUE
        ),
        legend = list(
          orientation = "h",
          x = 0.5,
          xanchor = "center",
          y = -0.16,
          font = list(color = "#F5F5F5", size = 13)
        )
      ) %>%
      config(
        displayModeBar = FALSE,
        responsive = TRUE
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
  }, striped = TRUE, hover = TRUE, bordered = TRUE, rownames = FALSE, width = "100%")
  
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