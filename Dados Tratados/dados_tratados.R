library(readr)
library(dplyr)
library(stringr)
library(janitor)

tratar_dados_csv <- function(caminho_arquivo) {
  dados_brutos <- readr::read_csv2(
    file = caminho_arquivo,
    skip = 1,
    locale = readr::locale(encoding = "UTF-8"),
    show_col_types = FALSE
  )
  
  dados_tratados <- dados_brutos |>
    janitor::clean_names() |>
    dplyr::select(1:11) |>
    dplyr::mutate(
      dplyr::across(
        dplyr::everything(),
        ~ {
          val <- stringr::str_squish(as.character(.x))
          dplyr::if_else(stringr::str_to_upper(val) %in% c("ND", ""), NA_character_, val)
        }
      )
    ) |>
    dplyr::filter(
      stringr::str_detect(ano_de_exibicao, "^\\d{4}$"),
      !is.na(titulo_da_obra)
    )
    
  
  return(dados_tratados)
}

dados_prontos <- tratar_dados_csv("Dados Base/listagem-de-filmes-brasileiros-e-estrangeiros-exibidos-2009-a-2025.csv")
saveRDS(dados_prontos, "Dados Tratados/dados_prontos.rds")
