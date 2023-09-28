#' List of railway lines
#'
#' A list of railway lines from 'extra/data.json' in \href{https://github.com/Seo-4d696b75/station_database}{Seo-4d696b75/station_database}.
#' The original data is \href{https://github.com/Seo-4d696b75/station_database/blob/main/out/extra/data.json}{here}.
#'
#' @format A tibble with 13 variables:
#' \describe{
#' \item{code}{A value that uniquely distinguishes lines in the dataset. Unlike line IDs, it does not guarantee consistency between different versions of the dataset.}
#' \item{id}{A string that uniquely distinguishes lines in the dataset. Unlike line codes, it ensures consistency between different versions of datasets (the IDs of the same lines be always the same IDs even if in different datasets).}
#' \item{name}{Name of lines. A suffix may be added to prevent duplications.}
#' \item{name_kana}{Hiragana representation of line names.}
#' \item{name_formal}{The original names of lines.}
#' \item{station_size}{How many stations does the line have?}
#' \item{station_list}{A list of tibbles with 2 variables; `code` (station codes that the line is passing through) and `name` (their names).}
#' \item{company_code}{Company (company codes) that ownes the line.}
#' \item{color}{Image color of the line.}
#' \item{symbol}{The symbol string of the line.}
#' \item{closed}{Whether the line was closed or not?}
#' \item{closed_date}{Date when the line was closed.}
#' \item{impl}{Whether or not the line is implemented in the 'Ekimemo!' game app?}
#' }
"lines"
