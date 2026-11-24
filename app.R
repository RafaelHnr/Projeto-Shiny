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

      /* Cartões de resumo */
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
        font-size: 22px;
        font-weight: 800;
        color: #D9A85F;
        margin-bottom: 4px;
        word-break: break-word;
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
          choices = c("Todos", sort(unique(as.character(dados_prontos$genero)))),
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
      
      div(
        class = "aviso-fixo-grafico",
        strong("Como explorar este painel: "),
        "Utilize os filtros à esquerda para alternar o gênero cinematográfico (ou visualizar todos juntos), a métrica de desempenho e a origem das obras. Passe o cursor sobre qualquer ponto do gráfico para visualizar os valores exatos de cada ano e observe o impacto da retração de 2020–2021."
      ),
      
      card(
        card_header(
          style = "font-size: 17px; font-weight: 700; color: #D9A85F;",
          textOutput("titulo_grafico_aba2", inline = TRUE)
        ),
        plotlyOutput("grafico_evolucao", height = "460px", width = "100%")
      ),
      
      uiOutput("resumo_kpis_aba2")
    )
  ),
  
  # ==========================================
  # ABA 3: DISTRIBUIDORAS E CONCENTRAÇÃO
  # ==========================================
  nav_panel(
    "Distribuidoras",
    layout_sidebar(
      fillable = FALSE, # Impede o gráfico de esticar/encolher conforme o tamanho da tabela
      sidebar = sidebar(
        width = 280,
        bg = "#1E2430",
        title = "Filtros da análise",
        sliderInput(
          inputId = "periodo_aba3",
          label = "1. Intervalo de anos:",
          min = 2009,
          max = 2025,
          value = c(2015, 2025),
          sep = ""
        ),
        selectInput(
          inputId = "nacionalidade_aba3",
          label = "2. Nacionalidade da obra:",
          choices = c("Todas", sort(unique(na.omit(as.character(dados_prontos$nacionalidade_da_obra))))),
          selected = "Todas"
        ),
        selectInput(
          inputId = "genero_aba3",
          label = "3. Gênero:",
          choices = c("Todos", sort(unique(na.omit(as.character(dados_prontos$genero))))),
          selected = "Todos"
        ),
        radioButtons(
          inputId = "metrica_aba3",
          label = "4. Classificar distribuidoras por:",
          choices = c("Público", "Renda"),
          selected = "Renda"
        ),
        numericInput(
          inputId = "top_n",
          label = "5. Distribuidoras no ranking:",
          value = 10,
          min = 5,
          max = 25,
          step = 1
        )
      ),
      
      div(
        class = "aviso-fixo-grafico",
        strong("Como explorar este painel: "),
        "Escolha o período, o perfil dos filmes e se quer comparar as distribuidoras por público ou renda. O ranking mostra as maiores no recorte; os indicadores resumem a concentração dos resultados."
      ),
      
      uiOutput("resumo_kpis_aba3"),
      
      card(
        card_header(
          style = "font-size: 17px; font-weight: 700; color: #D9A85F;",
          textOutput("titulo_grafico_aba3", inline = TRUE)
        ),
        plotlyOutput("grafico_distribuidoras", height = "460px", width = "100%")
      ),
      
      card(
        card_header(strong("Detalhamento das distribuidoras no ranking")),
        tableOutput("tabela_distribuidoras")
      )
    )
  )
)

server <- function(input, output, session) {
  
  observeEvent(input$explorar, {
    nav_select("pagina", "Evolução do Cinema ao Longo dos Anos")
  })
  
  # ==========================================
  # LÓGICA DA ABA 2
  # ==========================================
  dados_filtrados_base <- reactive({
    req(input$genero, input$nacionalidade)
    
    dados_temp <- dados_prontos %>%
      filter(as.character(nacionalidade_da_obra) %in% input$nacionalidade)
    
    if (input$genero != "Todos") {
      dados_temp <- dados_temp %>% filter(as.character(genero) == input$genero)
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
  
  output$resumo_kpis_aba2 <- renderUI({
    df_graf <- dados_grafico()
    df_base <- dados_filtrados_base()
    eh_dinheiro <- input$indicador == "Dinheiro Arrecadado"
    
    linha_pico <- df_graf %>% arrange(desc(valor)) %>% slice(1)
    valor_pico_fmt <- format(round(linha_pico$valor, 0), big.mark = ".", decimal.mark = ",", scientific = FALSE, trim = TRUE)
    texto_pico <- if (eh_dinheiro) paste0("R$ ", valor_pico_fmt) else paste0(valor_pico_fmt, " espectadores")
    
    total_geral <- sum(df_graf$valor, na.rm = TRUE)
    total_br <- sum(df_graf$valor[df_graf$nacionalidade_da_obra == "Brasileira"], na.rm = TRUE)
    share_br <- if (total_geral > 0) round((total_br / total_geral) * 100, 1) else 0
    
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
  
  # ==========================================
  # LÓGICA DA ABA 3 (CORRIGIDA)
  # ==========================================
  dados_aba3 <- reactive({
    req(input$periodo_aba3, input$nacionalidade_aba3, input$genero_aba3)
    
    df <- dados_prontos %>%
      mutate(
        # as.character() antes de as.integer() evita o bug de fator!
        ano_num = suppressWarnings(as.integer(as.character(ano_de_exibicao))),
        dist_clean = trimws(as.character(empresa_distribuidora)),
        origem_clean = trimws(as.character(origem_da_empresa_distribuidora)),
        publico_num = parse_number(
          as.character(publico_no_ano_de_exibicao),
          locale = locale(decimal_mark = ",", grouping_mark = ".")
        ),
        renda_num = parse_number(
          as.character(renda_r_no_ano_de_exibicao),
          locale = locale(decimal_mark = ",", grouping_mark = ".")
        )
      ) %>%
      filter(
        !is.na(ano_num),
        ano_num >= input$periodo_aba3[1],
        ano_num <= input$periodo_aba3[2],
        !is.na(dist_clean),
        dist_clean != "",
        dist_clean != "ND"
      )
    
    if (input$nacionalidade_aba3 != "Todas") {
      df <- df %>% filter(as.character(nacionalidade_da_obra) == input$nacionalidade_aba3)
    }
    if (input$genero_aba3 != "Todos") {
      df <- df %>% filter(as.character(genero) == input$genero_aba3)
    }
    
    df
  })
  
  distribuidores_aba3 <- reactive({
    req(input$metrica_aba3)
    df_base <- dados_aba3()
    if (nrow(df_base) == 0) return(tibble())
    
    # Agrupa APENAS pela distribuidora para evitar nomes duplicados no eixo Y
    df <- df_base %>%
      group_by(dist_clean) %>%
      summarise(
        origem = paste(unique(na.omit(origem_clean[origem_clean != ""])), collapse = " / "),
        filmes = n_distinct(titulo_da_obra, na.rm = TRUE),
        publico = sum(publico_num, na.rm = TRUE),
        renda = sum(renda_num, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      mutate(
        origem = ifelse(origem == "", "Não informada", origem),
        valor = if (input$metrica_aba3 == "Público") publico else renda
      ) %>%
      arrange(desc(valor), dist_clean)
    
    n_informado <- if (is.null(input$top_n) || is.na(input$top_n)) 10L else as.integer(input$top_n)
    n <- max(1L, min(25L, n_informado))
    df %>% slice_head(n = n)
  })
  
  output$titulo_grafico_aba3 <- renderText({
    paste0(
      "Top Distribuidoras por ", tolower(input$metrica_aba3),
      " (", input$periodo_aba3[1], "–", input$periodo_aba3[2], ")"
    )
  })
  
  output$grafico_distribuidoras <- renderPlotly({
    df <- distribuidores_aba3()
    
    # Se o filtro não retornar nenhuma linha, exibe aviso limpo no próprio gráfico
    if (nrow(df) == 0) {
      return(
        plot_ly(height = 460) %>%
          layout(
            paper_bgcolor = "#1E2430",
            plot_bgcolor = "#1E2430",
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            annotations = list(
              text = "Nenhum registro encontrado para essa combinação de filtros.",
              xref = "paper", yref = "paper", x = 0.5, y = 0.5,
              showarrow = FALSE,
              font = list(color = "#D9A85F", size = 16)
            )
          ) %>%
          config(displayModeBar = FALSE)
      )
    }
    
    eh_renda <- input$metrica_aba3 == "Renda"
    
    df <- df %>%
      mutate(
        # Abrevia nomes gigantes no eixo Y para o gráfico nunca encolher lateralmente
        nome_curto = ifelse(nchar(dist_clean) > 26, paste0(substr(dist_clean, 1, 24), "..."), dist_clean),
        rotulo = if (eh_renda) {
          paste0("R$ ", format(round(valor, 2), big.mark = ".", decimal.mark = ",", nsmall = 2, trim = TRUE))
        } else {
          paste0(format(round(valor, 0), big.mark = ".", decimal.mark = ",", scientific = FALSE, trim = TRUE), " espectadores")
        },
        dica = paste0(
          "<b>", dist_clean, "</b><br>",
          "Origem: ", origem, "<br>",
          "Filmes no período: ", filmes, "<br>",
          if (eh_renda) "Renda: " else "Público: ", rotulo
        )
      ) %>%
      arrange(valor)
    
    # Garante níveis únicos no eixo Y mesmo se dois nomes curtos coincidirem
    df$nome_curto <- make.unique(df$nome_curto)
    df$nome_curto <- factor(df$nome_curto, levels = df$nome_curto)
    
    plot_ly(
      data = df,
      x = ~valor,
      y = ~nome_curto,
      type = "bar",
      orientation = "h",
      height = 460,
      marker = list(color = "#D9A85F"),
      text = ~dica,
      textposition = "none", # Evita que o texto HTML apareça escrito dentro das barras!
      hoverinfo = "text"
    ) %>%
      layout(
        paper_bgcolor = "#1E2430",
        plot_bgcolor = "#1E2430",
        margin = list(l = 185, r = 30, t = 15, b = 65),
        xaxis = list(
          title = list(
            text = if (eh_renda) "Renda acumulada (R$)" else "Público acumulado (espectadores)",
            font = list(color = "#FFFFFF", size = 14)
          ),
          tickfont = list(color = "#D0D3DA", size = 12),
          gridcolor = "#323B4B",
          zeroline = FALSE,
          separatethousands = TRUE,
          tickprefix = if (eh_renda) "R$ " else "",
          fixedrange = TRUE
        ),
        yaxis = list(
          title = "",
          tickfont = list(color = "#D0D3DA", size = 12),
          fixedrange = TRUE
        ),
        hoverlabel = list(
          bgcolor = "#151923",
          bordercolor = "#D9A85F",
          font = list(color = "#F5F5F5", size = 13)
        )
      ) %>%
      config(displayModeBar = FALSE, responsive = TRUE)
  })
  
  output$resumo_kpis_aba3 <- renderUI({
    df_filtro <- dados_aba3()
    df_top <- distribuidores_aba3()
    eh_renda <- input$metrica_aba3 == "Renda"
    
    valor_total <- if (eh_renda) sum(df_filtro$renda_num, na.rm = TRUE) else sum(df_filtro$publico_num, na.rm = TRUE)
    valor_top5 <- if (nrow(df_top) > 0) sum(head(df_top$valor, 5), na.rm = TRUE) else 0
    participacao_top5 <- if (valor_total > 0) 100 * valor_top5 / valor_total else 0
    
    lider <- if (nrow(df_top) > 0) df_top$dist_clean[1] else "Sem dados"
    valor_lider <- if (nrow(df_top) > 0) df_top$valor[1] else 0
    
    formatado <- function(x) {
      format(round(x, if (eh_renda) 2 else 0), big.mark = ".", decimal.mark = ",", nsmall = if (eh_renda) 2 else 0, scientific = FALSE, trim = TRUE)
    }
    
    layout_columns(
      col_widths = c(4, 4, 4),
      div(
        class = "kpi-box",
        div(class = "kpi-label", "Líder no recorte"),
        div(class = "kpi-valor", lider),
        div(class = "kpi-sub", if (eh_renda) paste0("R$ ", formatado(valor_lider)) else paste0(formatado(valor_lider), " espectadores"))
      ),
      div(
        class = "kpi-box",
        div(class = "kpi-label", "Concentração das 5 maiores"),
        div(class = "kpi-valor", paste0(format(round(participacao_top5, 1), decimal.mark = ","), "%")),
        div(class = "kpi-sub", paste0("Do total de ", tolower(input$metrica_aba3), " no período"))
      ),
      div(
        class = "kpi-box",
        div(class = "kpi-label", "Distribuidoras ativas"),
        div(class = "kpi-valor", n_distinct(df_filtro$dist_clean)),
        div(class = "kpi-sub", "Com registros válidos no recorte")
      )
    )
  })
  
  output$tabela_distribuidoras <- renderTable({
    df <- distribuidores_aba3()
    if (nrow(df) == 0) return(data.frame(Aviso = "Nenhum registro encontrado para os filtros selecionados."))
    
    df %>%
      transmute(
        `#` = row_number(),
        Distribuidora = dist_clean,
        Origem = origem,
        Filmes = filmes,
        Público = format(round(publico, 0), big.mark = ".", decimal.mark = ",", scientific = FALSE, trim = TRUE),
        `Renda (R$)` = format(round(renda, 2), big.mark = ".", decimal.mark = ",", nsmall = 2, scientific = FALSE, trim = TRUE)
      )
  }, striped = TRUE, bordered = FALSE, hover = TRUE, spacing = "s", rownames = FALSE, width = "100%")
  
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