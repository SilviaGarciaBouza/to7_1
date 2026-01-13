# Aplicación que utiliza la Api de BiciCoruña

Este proyecto es una aplicación móvil desarrollada en **Flutter** que ofrece una alternativa a la aplicación oficial de BiciCoruña.

## Requisitos del Proyecto

- **Selector de estaciones:**
  Listado con buscador por nombre.
- **Información detallada:**
  - Última actualización.
  - Capacidad total de la estación.
  - Desglose de bicicletas disponibles por tipo (Eléctricas vs Mecánicas).
  - Número de anclajes vacíos.
  - Cálculo de puestos rotos.
- **Gestión de estados:**
  Implementación de estados de Carga (Loading), Error (con mensaje y reintento) y Éxito.

## Arquitectura: MVVM

Se ha implementado el patrón de arquitectura **MVVM (Model-View-ViewModel)**:

- **Model:** Definición de las clases de datos (`Station`, `BikeType`) y lógica de parseo JSON mediante _factory constructors_.
- **View:** Interfaces de usuario (`StationListScreen`, `StationDetailScreen`) que reaccionan a los cambios de estado.
- **ViewModel:** Encargado de la lógica de negocio, manejo de estados de carga/error y comunicación con el repositorio.
- **Data Layer:**
  - `Api`: Cliente HTTP para peticiones JSON.
  - `Repository`: Lógica de cruce de datos entre `station_information` y `station_status` para consolidar la información en un único modelo.

## Fuente de Datos

- [Station Information](https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_information) (Datos estáticos: nombre, capacidad, ubicación).
- [Station Status](https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_status) (Datos dinámicos: bicis disponibles, anclajes libres).

## Características Técnicas

- **Combinación de datos:** Se utiliza un mapeo por `station_id` para unir la información de dos endpoints distintos en una sola entidad.
- **Buscador reactivo:** Filtrado dinámico de la lista mediante `TextField`.
- **UI Semántica:** Uso de colores condicionales (Verde/Naranja/Rojo) para indicar visualmente la disponibilidad de bicicletas.
- **Manejo de errores:** Manejo de excepciones y tiempos de espera (timeouts) en las peticiones de red.
