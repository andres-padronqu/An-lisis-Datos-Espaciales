# Taller de Datos Espaciales
# Parte 1 - Lectura y exploración del DENUE
# Entidad: Ciudad de México
# Actividad: Centros de acondicionamiento físico/Gimnasios

# Librerías
library(readr)
library(dplyr)

# Ruta al archivo ZIP del DENUE
ruta_zip <- "data/raw/denue_09_csv.zip"

# Carpeta donde se descomprimirán los datos
ruta_extraida <- "data/raw/denue_09_csv"

# Descomprimir el archivo solo si aún no se ha hecho
if (!dir.exists(ruta_extraida)) {
  unzip(ruta_zip, exdir = ruta_extraida)
}

# Ruta al CSV principal del DENUE
archivo_denue <- file.path(
  ruta_extraida,
  "conjunto_de_datos",
  "denue_inegi_09_.csv"
)

# Leer la base
denue <- read_csv(
  archivo_denue,
  locale = locale(encoding = "Latin1"),
  show_col_types = FALSE
)

# Revisar dimensiones
dim(denue)

# Revisar nombres de las variables
names(denue)

# Visualizar las primeras observaciones
head(denue)

# Revisar actividades relacionadas con gimnasios
denue %>%
  filter(grepl("acondicionamiento físico|gimnas", nombre_act, ignore.case = TRUE)) %>%
  count(codigo_act, nombre_act, sort = TRUE)

# Filtrar centros de acondicionamiento físico
gimnasios <- denue %>%
  filter(codigo_act %in% c(713943, 713944))

# Revisar dimensiones
dim(gimnasios)

# Revisión de calidad de los datos

# Registros con coordenadas faltantes
coord_faltantes <- gimnasios %>%
  filter(is.na(latitud) | is.na(longitud))

nrow(coord_faltantes)

# Revisar nombres de establecimientos duplicados
nombres_duplicados <- gimnasios %>%
  count(nom_estab, sort = TRUE) %>%
  filter(n > 1)

# Número de nombres que aparecen más de una vez
nrow(nombres_duplicados)

# Ver los nombres más repetidos
head(nombres_duplicados, 20)

# Número de establecimientos por alcaldía
gimnasios_alcaldia <- gimnasios %>%
  count(cve_mun, municipio, name = "num_gimnasios") %>%
  arrange(desc(num_gimnasios))

# Mostrar tabla
gimnasios_alcaldia

# Guardar tabla de establecimientos por alcaldía
write_csv(
  gimnasios_alcaldia,
  "outputs/tablas/gimnasios_por_alcaldia.csv"
)

# Guardar base filtrada para utilizarla en los siguientes scripts
write_csv(
  gimnasios,
  "data/processed/gimnasios_cdmx.csv"
)

# Diccionario de datos

# Ruta al diccionario incluido en la descarga del DENUE
archivo_diccionario <- file.path(
  ruta_extraida,
  "diccionario_de_datos",
  "denue_diccionario_de_datos.csv"
)

# Leer diccionario
diccionario <- read_csv(
  archivo_diccionario,
  skip = 1,
  locale = locale(encoding = "Latin1"),
  show_col_types = FALSE
)

# Revisar estructura
names(diccionario)
head(diccionario)

# Seleccionar variables relevantes para el análisis
variables_relevantes <- diccionario %>%
  filter(`Nombre del Atributo en csv` %in% c(
    "nom_estab",
    "codigo_act",
    "nombre_act",
    "municipio",
    "latitud",
    "longitud"
  )) %>%
  select(
    `Nombre del Atributo en csv`,
    `Tipo de dato`,
    Descripción
  )

variables_relevantes

print(variables_relevantes, width = Inf)

# Guardar variables relevantes del diccionario
write_csv(
  variables_relevantes,
  "outputs/tablas/variables_relevantes_denue.csv"
)
