# Taller de Ciencia de Datos — Datos Espaciales

## DENUE y análisis espacial

**Entidad:** Ciudad de México  
**Giro económico:** Centros de acondicionamiento físico (gimnasios)  
**Fuente:** Directorio Estadístico Nacional de Unidades Económicas (DENUE), INEGI, mayo de 2026.

## Parte 1 — Réplica

### 1. Descarga y exploración de los datos

Para realizar el análisis se utilizó el DENUE correspondiente a la Ciudad de México, publicado por el INEGI en mayo de 2026. La base contiene 462,732 unidades económicas y 42 variables.

Para identificar los gimnasios se revisó la variable `nombre_act` y se identificaron dos códigos de actividad económica:

- `713943`: Centros de acondicionamiento físico del sector privado.
- `713944`: Centros de acondicionamiento físico del sector público.

En total se identificaron 2,275 establecimientos: 2,008 pertenecientes al sector privado y 267 al sector público.

### 2. Variables utilizadas

A partir del diccionario de datos del DENUE se seleccionaron las siguientes variables relevantes para el análisis:

- **`nom_estab`**: nombre comercial con el que se identifica o anuncia la unidad económica. En este análisis permite identificar cada gimnasio o centro de acondicionamiento físico.
- **`codigo_act`**: código que clasifica la actividad económica desarrollada por el establecimiento de acuerdo con el SCIAN. Se utilizó para seleccionar los centros de acondicionamiento físico.
- **`nombre_act`**: descripción de la actividad económica asociada al código SCIAN. Permite interpretar el giro al que pertenece cada establecimiento.
- **`municipio`**: nombre del municipio o demarcación territorial donde se encuentra la unidad económica. En la Ciudad de México permite agrupar los establecimientos por alcaldía.
- **`latitud`**: coordenada geográfica que indica la posición norte-sur del establecimiento y permite ubicarlo espacialmente.
- **`longitud`**: coordenada geográfica que indica la posición este-oeste del establecimiento y, junto con la latitud, permite representarlo en un mapa.

### 3. Revisión de calidad de los datos

Después de filtrar los códigos de actividad `713943` y `713944`, se obtuvieron 2,275 centros de acondicionamiento físico.

No se encontraron registros con latitud o longitud faltantes, por lo que los 2,275 establecimientos pueden utilizarse para el análisis espacial.

Respecto a los nombres de los establecimientos, se encontraron 69 nombres que aparecen más de una vez. Por ejemplo, "CLASES DE ZUMBA" aparece 12 veces, "GIMNASIO SIN NOMBRE" 10 veces y "ZUMBA" 9 veces. Estos registros no fueron eliminados, ya que compartir un nombre comercial no implica necesariamente que se trate de una observación duplicada; pueden corresponder a establecimientos distintos o a diferentes sucursales.

### 4. Unidades de negocio por alcaldía

La distribución de centros de acondicionamiento físico no es homogénea entre las alcaldías de la Ciudad de México. El mayor número de establecimientos se concentra en Iztapalapa y Gustavo A. Madero, mientras que Milpa Alta presenta el menor número.

| Alcaldía | Número de gimnasios |
|---|---:|
| Iztapalapa | 422 |
| Gustavo A. Madero | 303 |
| Álvaro Obregón | 170 |
| Tlalpan | 167 |
| Cuauhtémoc | 163 |
| Benito Juárez | 135 |
| Coyoacán | 134 |
| Xochimilco | 116 |
| Tláhuac | 111 |
| Miguel Hidalgo | 110 |
| Iztacalco | 94 |
| Venustiano Carranza | 93 |
| Azcapotzalco | 84 |
| La Magdalena Contreras | 69 |
| Cuajimalpa de Morelos | 61 |
| Milpa Alta | 43 |

En términos absolutos, Iztapalapa concentra el mayor número de centros de acondicionamiento físico, con 422 establecimientos, seguida por Gustavo A. Madero, con 303. En contraste, Milpa Alta registra únicamente 43 establecimientos.

Sin embargo, estos conteos no deben interpretarse todavía como una medida directa de disponibilidad o concentración de gimnasios, ya que las alcaldías tienen tamaños de población muy distintos. Por esta razón, en la segunda parte del análisis se comparará el número bruto de establecimientos con una medida normalizada por población.

### 5. Mapa de puntos

Para visualizar la distribución espacial de los centros de acondicionamiento físico en la Ciudad de México, se construyó un mapa interactivo de puntos utilizando `leaflet` en R. Cada punto representa uno de los 2,275 establecimientos identificados en el DENUE y se ubicó a partir de sus coordenadas de latitud y longitud.

El mapa permite consultar de manera interactiva el nombre del establecimiento, la actividad económica registrada y la alcaldía en la que se encuentra. Debido a que no se identificaron registros con coordenadas faltantes, fue posible representar la totalidad de los establecimientos seleccionados.

A partir de la distribución de los puntos se observa que los centros de acondicionamiento físico se encuentran distribuidos a lo largo de las 16 alcaldías, aunque visualmente existe una mayor concentración en las zonas con mayor densidad urbana. También se observan áreas con una presencia considerablemente menor de establecimientos, particularmente hacia algunas zonas periféricas de la ciudad.

Este primer mapa permite identificar patrones generales de localización, pero no es suficiente para determinar qué alcaldías cuentan con una mayor oferta relativa de gimnasios. Una mayor cantidad de puntos puede estar relacionada simplemente con una mayor población. Por ello, en la segunda parte del análisis se incorporará la población de cada alcaldía para comparar el número absoluto de establecimientos con una medida normalizada.


![Mapa de gimnasios en la Ciudad de México](img/mapa_gimnasios_cdmx.png)

[Ver mapa interactivo](https://andres-padronqu.github.io/An-lisis-Datos-Espaciales/outputs/mapas/mapa_gimnasios_cdmx.html)

## Parte 2 — Mapa corópletico municipal normalizado

### 6. Cruce espacial por alcaldía

Para analizar la distribución de los centros de acondicionamiento físico a nivel de alcaldía, se utilizó la capa de Áreas Geoestadísticas Municipales (AGEM) del Marco Geoestadístico 2025 del INEGI para la Ciudad de México.

Los 2,275 establecimientos identificados en el DENUE fueron convertidos a objetos espaciales de tipo punto a partir de sus coordenadas de longitud y latitud. Posteriormente, se transformaron al mismo sistema de referencia de coordenadas utilizado por los polígonos del Marco Geoestadístico y se realizó un cruce espacial para identificar la alcaldía en la que se localiza cada establecimiento.

El cruce espacial permitió asignar una alcaldía a la totalidad de los 2,275 establecimientos, sin registros fuera de los polígonos de la Ciudad de México. Además, los conteos obtenidos mediante este procedimiento coincidieron con los obtenidos previamente utilizando la variable `municipio` del DENUE.

### 7. Distribución absoluta de gimnasios por alcaldía

A partir del cruce espacial se calculó el número de centros de acondicionamiento físico localizado dentro de cada una de las 16 alcaldías y se construyó un mapa coroplético utilizando el conteo absoluto de establecimientos.

El mapa muestra diferencias importantes en el número de establecimientos entre alcaldías. Iztapalapa presenta el mayor conteo, con 422 gimnasios, seguida por Gustavo A. Madero con 303. En contraste, Milpa Alta registra 43 establecimientos, el menor número entre las alcaldías de la Ciudad de México.

Sin embargo, el conteo absoluto está influido por el tamaño de la población de cada alcaldía. Por esta razón, una alcaldía con un número elevado de gimnasios no necesariamente presenta una mayor oferta relativa para sus habitantes. Para considerar estas diferencias, posteriormente se normalizará el número de establecimientos utilizando la población de cada alcaldía.

![Número de gimnasios por alcaldía](img/mapa_conteo_gimnasios.png)

[Ver mapa interactivo](https://andres-padronqu.github.io/An-lisis-Datos-Espaciales/outputs/mapas/mapa_conteo_gimnasios.html)

### 8. Normalización por población

Para comparar la disponibilidad relativa de centros de acondicionamiento físico entre alcaldías, se incorporó información de población del Censo de Población y Vivienda 2020 del INEGI. Se utilizó la población total de cada alcaldía y se calculó el número de gimnasios por cada 10,000 habitantes mediante la siguiente expresión:

**Gimnasios por cada 10,000 habitantes = (Número de gimnasios / Población total) × 10,000**

La normalización modifica de manera importante el orden observado a partir de los conteos absolutos. Benito Juárez presenta la mayor tasa, con 3.11 gimnasios por cada 10,000 habitantes, seguida por Cuauhtémoc con 2.99, Tláhuac con 2.83, Milpa Alta con 2.82 y Cuajimalpa de Morelos con 2.80.

En contraste, algunas alcaldías que presentan un número elevado de establecimientos en términos absolutos descienden al considerar el tamaño de su población. Iztapalapa, por ejemplo, ocupa el primer lugar en número absoluto con 422 gimnasios, pero registra aproximadamente 2.30 gimnasios por cada 10,000 habitantes.

![Gimnasios por cada 10,000 habitantes](img/mapa_gimnasios_10000.png)

[Ver mapa interactivo](https://andres-padronqu.github.io/An-lisis-Datos-Espaciales/outputs/mapas/mapa_gimnasios_10000.html)