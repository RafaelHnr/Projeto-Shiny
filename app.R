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

      /* Destaques numéricos leves (sem caixa pesada) */
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
      /* Desloca o 9º item (início da 3ª fileira) para centralizar os 3 últimos */
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

      /* Adaptação responsiva para telas menores */
      @media (max-width: 992px) {
        .grade-variaveis {
          grid-template-columns: repeat(2, 1fr);
        }
        .var-pill, .var-pill:nth-child(9) {
          grid-column: span 1;
        }
      }

      /* Mantém estilo das abas 2 e 3 */
      .card {
        background-color: #1E2430 !important;
        border: 1px solid #323B4B !important;
      }
    "))
  ),
  
  # ==========================================
  # ABA 1: APRESENTAÇÃO ESTILO SITE (SCROLL)
  # ==========================================
  nav_panel(
    "Início",
    
    # 1. BANNER PRINCIPAL
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
    
    # 2. FAIXA DE DESTAQUES (SEM CAIXAS DE DASHBOARD)
    div(
      class = "secao-editorial",
      div(
        class = "faixa-numeros",
        div(class = "numero-item", h2("2009–2025"), p("17 anos de histórico comercial")),
        div(class = "numero-item", h2("11 Variáveis"), p("Dados oficiais tratados")),
        div(class = "numero-item", h2("ANCINE / OCA"), p("Fonte pública nacional"))
      )
    ),
    
    # 3. INTRODUÇÃO E METODOLOGIA EM TEXTO FLUIDO
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
    
    # 4. VARIÁVEIS EM GRADE 4 + 4 + 3 CENTRALIZADA
    div(
      class = "secao-editorial",
      div(class = "subtitulo-dourado", "DICIONÁRIO DE DADOS"),
      h2(class = "titulo-editorial", "O que está mapeado na base?"),
      p(class = "texto-editorial", "Confira as 11 variáveis consideradas na análise:"),
      
      div(
        class = "grade-variaveis",
        # Fileira 1 (4 itens)
        div(class = "var-pill", strong("Ano de Exibição"), "Ano em que o filme esteve em cartaz (2009 a 2025)"),
        div(class = "var-pill", strong("Data de Lançamento"), "Data oficial de estreia comercial no país"),
        div(class = "var-pill", strong("Título da Obra"), "Nome comercial registrado do longa-metragem"),
        div(class = "var-pill", strong("Registro (CPB / ROE)"), "Certificado de Produto Brasileiro ou Obra Estrangeira"),
        
        # Fileira 2 (4 itens)
        div(class = "var-pill", strong("Gênero"), "Ficção, Documentário, Animação ou Religiosa"),
        div(class = "var-pill", strong("País Produtor"), "País ou países responsáveis pela produção"),
        div(class = "var-pill", strong("Nacionalidade da Obra"), "Classificação entre obra Brasileira ou Estrangeira"),
        div(class = "var-pill", strong("Empresa Distribuidora"), "Distribuidora responsável pelo lançamento"),
        
        # Fileira 3 (3 itens centralizados)
        div(class = "var-pill", strong("Origem da Distribuidora"), "Capital Nacional, Estrangeiro ou Codistribuição"),
        div(class = "var-pill", strong("Público Anual"), "Total de espectadores registrados no ano"),
        div(class = "var-pill", strong("Renda Anual (R$)"), "Bilheteria bruta arrecadada em reais")
      )
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
  
  observeEvent(input$explorar, {
    nav_select("pagina", "Evolução ao Longo dos Anos")
  })
  
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