# Análisis de Datos Espaciales

Actividad del **Taller de Ciencia de Datos — Datos Espaciales** del Seminario de Métodos Analíticos de la Empresa de la Maestría en Ciencia de Datos del Instituto Tecnológico Autónomo de México (ITAM).

## Objetivo

Analizar la distribución espacial de los centros de acondicionamiento físico (gimnasios) en la Ciudad de México utilizando información del Directorio Estadístico Nacional de Unidades Económicas (DENUE) del INEGI.

El análisis considera tanto el número absoluto de establecimientos como su distribución relativa respecto a la población de cada alcaldía.

## Datos

Se utilizaron las siguientes fuentes:

- Directorio Estadístico Nacional de Unidades Económicas (DENUE), INEGI, mayo de 2026.
- Marco Geoestadístico 2025, INEGI.
- Censo de Población y Vivienda 2020, INEGI.

A partir del DENUE se identificaron **2,275 centros de acondicionamiento físico** en la Ciudad de México correspondientes a los siguientes códigos SCIAN:

- `713943`: Centros de acondicionamiento físico del sector privado.
- `713944`: Centros de acondicionamiento físico del sector público.

Del total de establecimientos identificados, **2,008 corresponden al sector privado** y **267 al sector público**.

## Análisis

El proyecto se desarrolló en dos partes.

### Parte 1 — Réplica

Se realizó la exploración del DENUE de la Ciudad de México y se filtraron los centros de acondicionamiento físico. El análisis incluyó:

1. Lectura y exploración del DENUE y su diccionario de datos.
2. Identificación de las variables relevantes para el análisis.
3. Revisión de coordenadas faltantes y nombres repetidos.
4. Conteo de establecimientos por alcaldía.
5. Construcción de un mapa interactivo de puntos con `leaflet`.

No se encontraron establecimientos con coordenadas faltantes. Se identificaron **69 nombres de establecimientos que aparecen más de una vez**; estos registros se conservaron debido a que compartir un nombre no implica necesariamente que se trate de observaciones duplicadas.

### Parte 2 — Mapa coroplético municipal normalizado

Para analizar las diferencias entre alcaldías se realizó una unión espacial entre los puntos del DENUE y las Áreas Geoestadísticas Municipales (AGEM) del Marco Geoestadístico 2025 del INEGI.

Los 2,275 establecimientos fueron convertidos a objetos espaciales y se realizó un cruce espacial con los polígonos de las 16 alcaldías de la Ciudad de México. La totalidad de los establecimientos pudo ser asignada a una alcaldía.

Posteriormente se construyeron dos mapas:

1. Número absoluto de gimnasios por alcaldía.
2. Número de gimnasios por cada 10,000 habitantes.

Para la normalización se utilizó la población total de cada alcaldía reportada en el Censo de Población y Vivienda 2020.

La tasa se calculó mediante:

**Gimnasios por cada 10,000 habitantes = (Número de gimnasios / Población total) × 10,000**

## Resultados principales

En términos absolutos, **Iztapalapa** presenta el mayor número de centros de acondicionamiento físico, con **422 establecimientos**, seguida por **Gustavo A. Madero**, con **303**.

Sin embargo, el ranking cambia de manera importante al considerar la población de cada alcaldía. Iztapalapa pasa del primer lugar en número absoluto al lugar 12, con aproximadamente **2.30 gimnasios por cada 10,000 habitantes**.

**Benito Juárez** pasa del sexto lugar en términos absolutos al primer lugar después de normalizar, con **3.11 gimnasios por cada 10,000 habitantes**. **Cuauhtémoc** ocupa el segundo lugar con **2.99** y **Tláhuac** el tercero con **2.83**.

También destaca **Milpa Alta**, que presenta únicamente 43 establecimientos y ocupa el último lugar en términos absolutos, pero asciende al cuarto lugar después de normalizar por población, con **2.82 gimnasios por cada 10,000 habitantes**.

Estos resultados muestran que el conteo absoluto y la tasa normalizada proporcionan perspectivas diferentes sobre la distribución espacial de los establecimientos. El conteo permite identificar dónde existe un mayor número de gimnasios, mientras que la normalización permite comparar su oferta relativa respecto al tamaño de la población.

Desde una perspectiva de toma de decisiones, los resultados pueden utilizarse como un primer diagnóstico para identificar alcaldías con una oferta relativa alta o baja de centros de acondicionamiento físico. Sin embargo, la tasa por población no es suficiente por sí sola para determinar una ubicación óptima, ya que también sería necesario considerar factores como ingreso, edad de la población, accesibilidad, precios, competencia cercana y distribución de los establecimientos dentro de cada alcaldía.

## Mapas interactivos

### Mapa de gimnasios en la Ciudad de México

[Ver mapa interactivo de puntos](https://andres-padronqu.github.io/An-lisis-Datos-Espaciales/outputs/mapas/mapa_gimnasios_cdmx.html)

### Número de gimnasios por alcaldía

[Ver mapa interactivo del conteo absoluto](https://andres-padronqu.github.io/An-lisis-Datos-Espaciales/outputs/mapas/mapa_conteo_gimnasios.html)

### Gimnasios por cada 10,000 habitantes

[Ver mapa interactivo normalizado por población](https://andres-padronqu.github.io/An-lisis-Datos-Espaciales/outputs/mapas/mapa_gimnasios_10000.html)

## Estructura del repositorio

```text
.
├── data/
│   ├── raw/
│   └── processed/
├── outputs/
│   ├── mapas/
│   └── tablas/
├── reporte/
│   ├── img/
│   └── interpretacion.md
└── scripts/
    ├── 01_leer_denue.R
    ├── 02_mapa_puntos.R
    └── 03_choropleth_municipio.R
```

## Requisitos e instalación

### Requisitos

Para reproducir el análisis es necesario contar con:

- **R** instalado.
- **RStudio** o **Visual Studio Code** con soporte para R.
- **Git**, en caso de clonar el repositorio.
- Conexión a internet para visualizar los mapas base utilizados por `leaflet`.

### Paquetes de R

El análisis utiliza principalmente los siguientes paquetes:

- `tidyverse`
- `sf`
- `leaflet`
- `htmlwidgets`

Si alguno de estos paquetes no se encuentra instalado, puede instalarse desde R mediante:

```r
install.packages(c(
  "tidyverse",
  "sf",
  "leaflet",
  "htmlwidgets"
))
```

### Clonar el repositorio

El proyecto puede descargarse mediante Git ejecutando:

```bash
git clone https://github.com/andres-padronqu/An-lisis-Datos-Espaciales.git
cd An-lisis-Datos-Espaciales
```

### Datos de entrada

Los datos utilizados en el análisis se encuentran organizados dentro de:

```text
data/
├── raw/
└── processed/
```

Los archivos originales provienen del **INEGI** e incluyen:

- DENUE de la Ciudad de México, mayo de 2026.
- Áreas Geoestadísticas Municipales (AGEM) del Marco Geoestadístico 2025.
- Censo de Población y Vivienda 2020, principales resultados por localidad (ITER).

Los archivos procesados generados durante el análisis se almacenan en `data/processed/`.

Las tablas y los mapas resultantes se almacenan en:

```text
outputs/
├── mapas/
└── tablas/
```

## Ejecución

Los scripts deben ejecutarse **desde la carpeta raíz del proyecto** y en el siguiente orden:

```text
scripts/01_leer_denue.R
scripts/02_mapa_puntos.R
scripts/03_choropleth_municipio.R
```

### 1. Lectura y preparación del DENUE

```text
scripts/01_leer_denue.R
```

Este script realiza:

- Lectura del DENUE.
- Exploración inicial de los datos.
- Filtrado de los códigos SCIAN `713943` y `713944`.
- Revisión de coordenadas faltantes.
- Identificación de nombres repetidos.
- Conteo de establecimientos por alcaldía.
- Lectura del diccionario de datos.
- Generación del archivo procesado utilizado en las siguientes etapas.

### 2. Mapa de puntos

```text
scripts/02_mapa_puntos.R
```

Este script utiliza los establecimientos previamente filtrados para construir un mapa interactivo con `leaflet`.

Cada punto representa un centro de acondicionamiento físico e incluye información sobre el nombre del establecimiento, actividad económica y alcaldía.

### 3. Mapas coropléticos

```text
scripts/03_choropleth_municipio.R
```

Este script realiza:

- Conversión de los establecimientos a objetos espaciales.
- Homologación de sistemas de referencia de coordenadas.
- Unión espacial con las alcaldías.
- Conteo espacial de establecimientos.
- Incorporación de la población del Censo 2020.
- Cálculo de gimnasios por cada 10,000 habitantes.
- Generación del mapa de conteos absolutos.
- Generación del mapa normalizado por población.

Los scripts utilizan **rutas relativas a la raíz del repositorio**, por lo que se recomienda mantener la estructura original de carpetas.

## Reporte

La interpretación completa de los resultados se encuentra en:

[`reporte/interpretacion.md`](reporte/interpretacion.md)

El reporte incluye:

- Descripción y exploración de los datos.
- Variables utilizadas.
- Revisión de calidad.
- Tabla de establecimientos por alcaldía.
- Mapa de puntos.
- Metodología del cruce espacial.
- Mapa coroplético de conteos absolutos.
- Normalización por población.
- Mapa de gimnasios por cada 10,000 habitantes.
- Comparación e interpretación de los rankings.

## Herramientas

El análisis fue desarrollado en **R**, utilizando principalmente:

- `tidyverse` para manipulación y transformación de datos.
- `sf` para operaciones y uniones espaciales.
- `leaflet` para visualización cartográfica interactiva.
- `htmlwidgets` para exportación de mapas interactivos.

Se utilizó **Git y GitHub** para el control de versiones y **GitHub Pages** para publicar los mapas interactivos.

## Referencias

Castro, C. (2026a). *Datos espaciales* [Material de clase]. Seminario de Métodos Analíticos de la Empresa, Maestría en Ciencia de Datos, Instituto Tecnológico Autónomo de México (ITAM).

Castro, C. (2026b). *Scripts y ejemplos de análisis de datos espaciales en R* [Material de clase]. Seminario de Métodos Analíticos de la Empresa, Maestría en Ciencia de Datos, Instituto Tecnológico Autónomo de México (ITAM).

Instituto Nacional de Estadística y Geografía (INEGI). (2026). *Directorio Estadístico Nacional de Unidades Económicas (DENUE), mayo de 2026*. INEGI.

Instituto Nacional de Estadística y Geografía (INEGI). (2025). *Marco Geoestadístico 2025. Áreas Geoestadísticas Municipales (AGEM), Ciudad de México*. INEGI.

Instituto Nacional de Estadística y Geografía (INEGI). (2020). *Censo de Población y Vivienda 2020. Principales resultados por localidad (ITER), Ciudad de México*. INEGI.

**Lic. Andrés Padrón Quintana**  
Maestría en Ciencia de Datos  
Instituto Tecnológico Autónomo de México (ITAM)