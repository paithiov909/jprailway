#' List of railway stations
#'
#' A list of railway stations from 'extra/json.zip' in \href{https://github.com/Seo-4d696b75/station_database}{Seo-4d696b75/station_database}.
#' The original data is \href{https://github.com/Seo-4d696b75/station_database/blob/main/out/extra/json.zip}{here}.
#'
#' @format A simple feature collection with 17 fields:
#' \describe{
#' \item{code}{A value that uniquely distinguishes stations in the dataset. Unlike station IDs, it does not guarantee consistency between different versions of the dataset.}
#' \item{id}{A string that uniquely distinguishes stations in the dataset. Unlike station codes, it ensures consistency between different versions of datasets (the IDs of the same stations be always the same IDs even if in different datasets).}
#' \item{name}{Name of stations. A suffix may be added to prevent duplications.}
#' \item{original_name}{Station name as indicated by each company.}
#' \item{name_kana}{Hiragana representation of station names.}
#' \item{closed}{Whether the station was closed or not?}
#' \item{lat}{Station coordinates (latitude).}
#' \item{lng}{Station coordinates (longitude).}
#' \item{prefecture}{JIS code of the prefecture where the station is located.}
#' \item{postal_code}{Zip code of the station's location.}
#' \item{address}{Address of the station's location.}
#' \item{open_date}{Date when the station was opened.}
#' \item{closed_date}{Date when the station was closed.}
#' \item{extra}{Whether or not the station is implemented in the 'Ekimemo!' game app?}
#' \item{attr}{Station attribute in the 'Ekimemo!' game app.}
#' \item{lines}{List of line codes passing through the station.}
#' \item{delaunay}{List of the neighboring points (station codes) obtained by Delaunay partitioning.}
#' }
"stations"
