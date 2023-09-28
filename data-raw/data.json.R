# v20230731 ----
download.file(
  "https://github.com/Seo-4d696b75/station_database/raw/v20230731/out/extra/data.json",
  (data_json <- tempfile(fileext = ".json"))
)
dt <- jsonlite::read_json(data_json, simplifyVector = TRUE)

## stations ----
stations <- dplyr::as_tibble(dt$stations) |>
  dplyr::rename(delaunay = "next")

voronoi <- stations |>
  dplyr::pull(voronoi) |>
  dplyr::as_tibble()
props <- stations |>
  dplyr::select(!"voronoi")

list(
  type = "FeatureCollection",
  features = dplyr::mutate(voronoi, properties = props)
) |>
  jsonlite::write_json(
    path = (tmp <- tempfile(fileext = ".json")),
    auto_unbox = TRUE,
    digits = NA
  )

stations <- sf::read_sf(tmp) |>
  dplyr::mutate(
    prefecture = stringi::stri_pad_left(prefecture, width = 2, pad = "0"),
    attr = as.factor(attr)
  ) |>
  dplyr::relocate(
    "code", "id", "name", "original_name", "name_kana", "closed",
    "lat", "lng",
    "prefecture", "postal_code", "address",
    "open_date", "closed_date", "impl", "attr"
  )

usethis::use_data(stations, overwrite = TRUE)


## lines ----
lines <- dt$lines |>
  dplyr::as_tibble() |>
  dplyr::select(!"polyline_list") |>
  dplyr::mutate(station_list = purrr::map(station_list, ~ dplyr::as_tibble(.))) |>
  dplyr::relocate(
    "code", "id", "name", "name_kana", "name_formal",
    "station_size", "station_list",
    "company_code", "color", "symbol", "closed", "closed_date", "impl"
  )

usethis::use_data(lines, overwrite = TRUE)


## polylines ----
polylines <- dt$lines |>
  dplyr::select(code, id, polyline_list) |>
  tidyr::unnest(polyline_list) |>
  dplyr::as_tibble() |>
  tidyr::unnest(properties) |>
  dplyr::select(!"type") |>
  tidyr::unnest(features) |>
  tidyr::unnest(properties) |>
  dplyr::select(!"closed")

list(
  type = "FeatureCollection",
  features = dplyr::select(polylines, type, geometry) |>
    dplyr::mutate(properties = dplyr::select(polylines, !c("type", "geometry")))
) |>
  jsonlite::write_json(
    path = (tmp <- tempfile(fileext = ".json")),
    auto_unbox = TRUE,
    digits = NA
  )

polylines <- sf::read_sf(tmp)

usethis::use_data(polylines, overwrite = TRUE)
