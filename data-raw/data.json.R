# v20240329 ----
download.file(
  "https://github.com/Seo-4d696b75/station_database/raw/v20240329/out/extra/json.zip",
  (data_zip <- tempfile(fileext = ".zip"))
)
unzip(data_zip, exdir = here::here("data-raw"))

## stations ----
stations <-
  jsonlite::read_json(
    "data-raw/json/station.json",
    simplifyVector = TRUE
  ) |>
  dplyr::as_tibble()

delaunay <-
  jsonlite::read_json(
    "data-raw/json/delaunay.json",
    simplifyVector = TRUE
  ) |>
  dplyr::as_tibble() |>
  dplyr::rename(delaunay = "next") |>
  dplyr::select(code, delaunay)

voronoi <- stations |>
  dplyr::pull(voronoi) |>
  dplyr::as_tibble()
props <- stations |>
  dplyr::select(!"voronoi") |>
  dplyr::left_join(delaunay, by = "code")

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
    "open_date", "closed_date", "extra", "attr"
  )

usethis::use_data(stations, overwrite = TRUE)


## lines ----
lines <-
  jsonlite::read_json(
    "data-raw/json/line.json",
    simplifyVector = TRUE
  ) |>
  dplyr::as_tibble() |>
  dplyr::mutate(station_list = purrr::map(code, ~ {
    lst <- jsonlite::read_json(
      file.path("data-raw/json/line", paste0(.x, ".json")),
      simplifyVector = TRUE
    )
    lst$station_list |>
      dplyr::as_tibble() |>
      dplyr::select(code, name)
  })) |>
  dplyr::relocate(
    "code", "id", "name", "name_kana", "name_formal",
    "station_size", "station_list",
    "company_code", "color", "symbol", "closed", "closed_date", "extra"
  )

usethis::use_data(lines, overwrite = TRUE)


## polylines ----
polylines <- lines |>
  ## https://github.com/Seo-4d696b75/station_database/issues/54
  dplyr::filter(!name %in% c("嘉手納線", "鉄道院中央本線")) |>
  dplyr::select(code, id, name) |>
  dplyr::mutate(polyline = purrr::map(code, ~ {
    json <-
      jsonlite::read_json(
        file.path("data-raw/json/polyline", paste0(.x, ".json")),
        simplifyVector = TRUE
      )
    as.data.frame(json$properties) |>
      dplyr::select(!"name")
  })) |>
  tidyr::unnest(polyline)

polylines <-
  dplyr::group_by(polylines, code) |>
  dplyr::group_map(~
    sf::read_sf(
      file.path("data-raw/json/polyline", paste0(.y$code, ".json"))
    ) |>
      dplyr::mutate(code = .y$code)
  ) |>
  purrr::list_rbind() |>
  dplyr::left_join(polylines, by = "code") |>
  dplyr::select(
    "code", "id",
    "start", "end",
    "name",
    "north", "south", "east", "west",
    "geometry"
  ) |>
  sf::st_sf()

usethis::use_data(polylines, overwrite = TRUE)
