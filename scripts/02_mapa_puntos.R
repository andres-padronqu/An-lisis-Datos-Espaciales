# Mapa puntos

# Librerías
library(readr)
library(dplyr)
library(leaflet)
library(htmlwidgets)

# Leer la base filtrada generada en 01_leer_denue.R
gimnasios <- read_csv(
  "data/processed/gimnasios_cdmx.csv",
  show_col_types = FALSE
)

# Revisar la base
dim(gimnasios)

# Comprobar nuevamente que las coordenadas estén disponibles
sum(is.na(gimnasios$latitud))
sum(is.na(gimnasios$longitud))


# Construcción del mapa de puntos

mapa_gimnasios <- leaflet(gimnasios) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(
    lng = ~longitud,
    lat = ~latitud,
    radius = 4,
    stroke = FALSE,
    fillOpacity = 0.7,
    popup = ~paste0(
      "<b>", nom_estab, "</b><br>",
      "Actividad: ", nombre_act, "<br>",
      "Alcaldía: ", municipio
    )
  )

# Mostrar mapa
mapa_gimnasios

# Guardar mapa interactivo en formato HTML
saveWidget(
  mapa_gimnasios,
  file = "outputs/mapas/mapa_gimnasios_cdmx.html",
  selfcontained = TRUE
)
