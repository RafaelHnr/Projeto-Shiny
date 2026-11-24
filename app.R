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

      /* Caixa fixa de texto genérico acima do gráfico */
      .aviso-fixo-grafico {
        background: rgba(30, 36, 48, 0.85);
        border-left: 4px solid #D9A85F;
        border-top: 1px solid #323B4B;
        border-right: 1px solid #323B4B;
        border-bottom: 1px solid #323B4B;
        padding: 14px 20px;
        border-radius: 10px;
        color: #D0D3DA;
        font-size: 14.5px;
        line-height: 1.5;
        margin-bottom: 15px;
      }

      /* Cartões de resumo que substituem a tabela */
      .kpi-box {
        background: #1E2430;
        border: 1px solid #323B4B;
        border-radius: 12px;
        padding: 18px 20px;
        height: 100%;
      }
      .kpi-label {
        font-size: 12px;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: #9CA3AF;
        margin-bottom: 6px;
        font-weight: 700;
      }
      .kpi-valor {
        font-size: 24px;
        font-weight: 800;
        color: #D9A85F;
        margin-bottom: 4px;
      }
      .kpi-sub {
        font-size: 13px;
        color: #D0D3DA;
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
  # ABA 2: TEXTO FIXO + GRÁFICO + RESUMO KPI
  # ==========================================
  nav_panel(
    "Evolução do Cinema ao Longo dos Anos",
    
    layout_sidebar(
      fillable = FALSE,
      sidebar = sidebar(
        width = 280,
        bg = "#1E2430",
        title = "Filtros da Análise",
        
        selectInput(
          inputId = "genero",
          label = "1. Selecione o gênero:",
          choices = c("Todos", sort(unique(dados_prontos$genero))),
          selected = "Todos",
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
      
      # 1. CAIXINHA FIXA GENÉRICA ACIMA DO GRÁFICO
      div(
        class = "aviso-fixo-grafico",
        strong("Como explorar este painel: "),
        "Utilize os filtros à esquerda para alternar o gênero cinematográfico (ou visualizar todos juntos), a métrica de desempenho e a origem das obras. Passe o cursor sobre qualquer ponto do gráfico para visualizar os valores exatos de cada ano e observe o impacto da retração de 2020–2021."
      ),
      
      # 2. GRÁFICO INTERATIVO (OUTPUT 1)
      card(
        card_header(
          style = "font-size: 17px; font-weight: 700; color: #D9A85F;",
          textOutput("titulo_grafico_aba2", inline = TRUE)
        ),
        plotlyOutput("grafico_evolucao", height = "460px", width = "100%")
      ),
      
      # 3. CARTÕES DE INDICADORES-CHAVE (OUTPUT 2)
      uiOutput("resumo_kpis_aba2")
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
  
  # Base filtrada (suporta tanto "Todos" quanto um gênero específico)
  dados_filtrados_base <- reactive({
    req(input$genero, input$nacionalidade)
    
    dados_temp <- dados_prontos %>%
      filter(nacionalidade_da_obra %in% input$nacionalidade)
    
    if (input$genero != "Todos") {
      dados_temp <- dados_temp %>% filter(genero == input$genero)
    }
    
    dados_temp %>%
      mutate(
        ano_de_exibicao = as.character(ano_de_exibicao),
        pub_num = parse_number(as.character(publico_no_ano_de_exibicao),
                               locale = locale(decimal_mark = ",", grouping_mark = ".")),
        renda_num = parse_number(as.character(renda_r_no_ano_de_exibicao),
                                 locale = locale(decimal_mark = ",", grouping_mark = "."))
      )
  })
  
  dados_grafico <- reactive({
    req(input$indicador)
    
    df <- dados_filtrados_base() %>%
      mutate(valor_escolhido = if (input$indicador == "Público") pub_num else renda_num) %>%
      group_by(ano_de_exibicao, nacionalidade_da_obra) %>%
      summarise(valor = sum(valor_escolhido, na.rm = TRUE), .groups = "drop")
    
    expand.grid(
      ano_de_exibicao = as.character(2009:2025),
      nacionalidade_da_obra = input$nacionalidade,
      stringsAsFactors = FALSE
    ) %>%
      left_join(df, by = c("ano_de_exibicao", "nacionalidade_da_obra")) %>%
      mutate(valor = ifelse(is.na(valor), 0, valor))
  })
  
  output$titulo_grafico_aba2 <- renderText({
    nome_gen <- if (input$genero == "Todos") "Todos os Gêneros" else paste0("Gênero: ", input$genero)
    paste0(input$indicador, " — ", nome_gen, " (2009–2025)")
  })
  
  # Output 1: Gráfico Interativo
  output$grafico_evolucao <- renderPlotly({
    df <- dados_grafico()
    eh_dinheiro <- input$indicador == "Dinheiro Arrecadado"
    
    cores <- c("Brasileira" = "#D9A85F", "Estrangeira" = "#4EA8DE")
    preenchimentos <- c("Brasileira" = "rgba(217, 168, 95, 0.16)", "Estrangeira" = "rgba(78, 168, 222, 0.16)")
    
    p <- plot_ly(height = 460)
    
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
      config(displayModeBar = FALSE, responsive = TRUE)
  })
  
  # Output 2: 3 Cartões de Indicadores Estratégicos
  output$resumo_kpis_aba2 <- renderUI({
    df_graf <- dados_grafico()
    df_base <- dados_filtrados_base()
    eh_dinheiro <- input$indicador == "Dinheiro Arrecadado"
    
    # 1. Ano de Pico
    linha_pico <- df_graf %>% arrange(desc(valor)) %>% slice(1)
    valor_pico_fmt <- format(round(linha_pico$valor, 0), big.mark = ".", decimal.mark = ",", scientific = FALSE, trim = TRUE)
    texto_pico <- if (eh_dinheiro) paste0("R$ ", valor_pico_fmt) else paste0(valor_pico_fmt, " espectadores")
    
    # 2. Participação do Cinema Nacional no recorte
    total_geral <- sum(df_graf$valor, na.rm = TRUE)
    total_br <- sum(df_graf$valor[df_graf$nacionalidade_da_obra == "Brasileira"], na.rm = TRUE)
    share_br <- if (total_geral > 0) round((total_br / total_geral) * 100, 1) else 0
    
    # 3. Ticket Médio (Renda Total / Público Total no filtro atual)
    pub_tot <- sum(df_base$pub_num, na.rm = TRUE)
    renda_tot <- sum(df_base$renda_num, na.rm = TRUE)
    ticket <- if (pub_tot > 0) renda_tot / pub_tot else 0
    ticket_fmt <- format(round(ticket, 2), big.mark = ".", decimal.mark = ",", nsmall = 2, trim = TRUE)
    
    layout_columns(
      col_widths = c(4, 4, 4),
      div(
        class = "kpi-box",
        div(class = "kpi-label", "Recorde Histórico no Período"),
        div(class = "kpi-valor", paste0(linha_pico$ano_de_exibicao, " (", linha_pico$nacionalidade_da_obra, ")")),
        div(class = "kpi-sub", texto_pico)
      ),
      div(
        class = "kpi-box",
        div(class = "kpi-label", "Fatia das Obras Brasileiras"),
        div(class = "kpi-valor", paste0(format(share_br, decimal.mark = ","), "%")),
        div(class = "kpi-sub", paste0("Do total acumulado de ", tolower(input$indicador), " no recorte"))
      ),
      div(
        class = "kpi-box",
        div(class = "kpi-label", "Ticket Médio Estimado"),
        div(class = "kpi-valor", paste0("R$ ", ticket_fmt)),
        div(class = "kpi-sub", "Razão entre renda total e público no recorte")
      )
    )
  })
  
  output$baixar_tabela <- downloadHandler(
    filename = function() {
      nome_arquivo <- if (input$genero == "Todos") "todos_generos" else tolower(input$genero)
      paste0("cinema_brasil_", nome_arquivo, ".csv")
    },
    content = function(file) {
      write.csv2(dados_grafico(), file, row.names = FALSE)
    }
  )
}

shinyApp(ui = ui, server = server)