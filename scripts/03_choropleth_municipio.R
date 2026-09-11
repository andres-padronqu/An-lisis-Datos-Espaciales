# Taller de Datos Espaciales
# Parte 2 - Opción A: Coropleta municipal normalizada
# Entidad: Ciudad de México
# Actividad: Centros de acondicionamiento físico / Gimnasios

# Librerías
library(sf)
library(readr)
library(dplyr)
library(leaflet)
library(htmlwidgets)

# Leer polígonos de las alcaldías de la Ciudad de México

# Rutas del archivo comprimido y de la carpeta de extracción
archivo_mapa <- "data/raw/2025_1_09_MUN.zip"
carpeta_mapa <- "data/raw/2025_1_09_MUN"

# Descomprimir únicamente si la carpeta todavía no existe
if (!dir.exists(carpeta_mapa)) {
  unzip(archivo_mapa, exdir = carpeta_mapa)
}

# Leer el shapefile de las alcaldías
alcaldias <- st_read(
  "data/raw/2025_1_09_MUN/2025_1_09_MUN.shp"
)

# Revisar el objeto
alcaldias


# Verificar número de alcaldías
nrow(alcaldias)

# Revisar los nombres de las alcaldías
alcaldias %>%
  st_drop_geometry() %>%
  select(CVE_MUN, NOMGEO) %>%
  arrange(CVE_MUN)

# 2. Convertir los gimnasios a puntos espaciales

# Leer la base de gimnasios generada en la Parte 1
gimnasios <- read_csv(
  "data/processed/gimnasios_cdmx.csv",
  show_col_types = FALSE
)

# Convertir las coordenadas de los gimnasios a puntos espaciales
gimnasios_sf <- st_as_sf(
  gimnasios,
  coords = c("longitud", "latitud"),
  crs = 4326,
  remove = FALSE
)

gimnasios_sf

# Transformar los puntos al mismo sistema de coordenadas que utilizan los polígonos de las alcaldías

gimnasios_sf <- st_transform(
  gimnasios_sf,
  st_crs(alcaldias)
)

st_crs(gimnasios_sf)
st_crs(alcaldias)

# Cruce espacial: asignar alcaldía a cada gimnasio

gimnasios_join <- st_join(
  gimnasios_sf,
  alcaldias %>%
    select(CVE_MUN, NOMGEO),
  join = st_within
)

# Verificar cuántos gimnasios quedaron sin alcaldía
sum(is.na(gimnasios_join$NOMGEO))

gimnasios_por_alcaldia_espacial <- gimnasios_join %>%
  st_drop_geometry() %>%
  count(CVE_MUN, NOMGEO, name = "num_gimnasios") %>%
  arrange(desc(num_gimnasios))

gimnasios_por_alcaldia_espacial

# Incorporar el número de gimnasios a los polígonos

alcaldias_gimnasios <- alcaldias %>%
  left_join(
    gimnasios_por_alcaldia_espacial,
    by = c("CVE_MUN", "NOMGEO")
  )

alcaldias_gimnasios %>%
  st_drop_geometry() %>%
  select(CVE_MUN, NOMGEO, num_gimnasios) %>%
  arrange(desc(num_gimnasios))

# Mapa coroplético: número absoluto de gimnasios

# Transformar los polígonos a WGS 84 para visualizarlos en Leaflet
alcaldias_mapa <- st_transform(
  alcaldias_gimnasios,
  crs = 4326
)

pal_conteo <- colorNumeric(
  palette = "YlOrRd",
  domain = alcaldias_mapa$num_gimnasios
)

mapa_conteo <- leaflet(alcaldias_mapa) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(
    fillColor = ~pal_conteo(num_gimnasios),
    fillOpacity = 0.7,
    color = "white",
    weight = 1,
    popup = ~paste0(
      "<b>", NOMGEO, "</b><br>",
      "Gimnasios: ", num_gimnasios
    )
  ) %>%
  addLegend(
    pal = pal_conteo,
    values = ~num_gimnasios,
    title = "Número de gimnasios",
    opacity = 0.7
  )

mapa_conteo


# Incorporar población del Censo 2020

# Rutas del archivo del Censo 2020
archivo_censo <- "data/raw/iter_09_cpv2020_csv.zip"
carpeta_censo <- "data/raw/iter_09_cpv2020_csv"

# Descomprimir únicamente si la carpeta todavía no existe
if (!dir.exists(carpeta_censo)) {
  unzip(archivo_censo, exdir = carpeta_censo)
}

# Leer los datos del Censo 2020
censo <- read_csv(
  "data/raw/iter_09_cpv2020_csv/iter_09_cpv2020/conjunto_de_datos/conjunto_de_datos_iter_09CSV20.csv",
  show_col_types = FALSE
)

# Revisar dimensiones y variables
dim(censo)
names(censo)

censo %>%
  select(MUN, NOM_MUN, LOC, NOM_LOC, POBTOT) %>%
  filter(MUN == "002") %>%
  head(20)

# Obtener población total por alcaldía
poblacion_alcaldias <- censo %>%
  filter(
    LOC == "0000",
    MUN != "000"
  ) %>%
  select(
    CVE_MUN = MUN,
    NOM_MUN,
    poblacion = POBTOT
  ) %>%
  arrange(CVE_MUN)

poblacion_alcaldias

# Verificar número de alcaldías
nrow(poblacion_alcaldias)

# Calcular gimnasios por cada 10,000 habitantes

alcaldias_final <- alcaldias_gimnasios %>%
  left_join(
    poblacion_alcaldias,
    by = "CVE_MUN"
  ) %>%
  mutate(
    gimnasios_10000 = round(
      num_gimnasios / poblacion * 10000,
      2
    )
  )

alcaldias_final %>%
  st_drop_geometry() %>%
  select(
    CVE_MUN,
    NOMGEO,
    num_gimnasios,
    poblacion,
    gimnasios_10000
  ) %>%
  arrange(desc(gimnasios_10000))

# Transformar a WGS 84 para visualizar en Leaflet
alcaldias_final_mapa <- st_transform(
  alcaldias_final,
  crs = 4326
)

# Mapa coroplético: gimnasios por 10,000 habitantes

pal_tasa <- colorNumeric(
  palette = "YlGnBu",
  domain = alcaldias_final_mapa$gimnasios_10000
)

mapa_tasa <- leaflet(alcaldias_final_mapa) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(
    fillColor = ~pal_tasa(gimnasios_10000),
    fillOpacity = 0.7,
    color = "white",
    weight = 1,
    popup = ~paste0(
      "<b>", NOMGEO, "</b><br>",
      "Gimnasios: ", num_gimnasios, "<br>",
      "Población: ", format(poblacion, big.mark = ","), "<br>",
      "Gimnasios por 10,000 hab.: ", gimnasios_10000
    )
  ) %>%
  addLegend(
    pal = pal_tasa,
    values = ~gimnasios_10000,
    title = "Gimnasios por 10,000 hab.",
    opacity = 0.7
  )

mapa_tasa


# Guardar mapas

saveWidget(
  mapa_conteo,
  file = "outputs/mapas/mapa_conteo_gimnasios.html",
  selfcontained = FALSE
)

saveWidget(
  mapa_tasa,
  file = "outputs/mapas/mapa_gimnasios_10000.html",
  selfcontained = FALSE
)
