# Datos para la entrega

**URL pública:** (pegar la de Vercel)
**Repositorio:** (pegar el de GitHub)
**Dataset:** datos/sensores.csv
**Captura:** sacarla de la URL publicada, con el mapa en "Puntos" y un tooltip abierto

## Descripción (5 líneas)

Analizamos la calidad del aire en CABA a partir de la concentración de material particulado fino (PM2.5) en 60 sensores.
Usamos un dataset simulado con ubicaciones reales por barrio, tomando como referencia el formato de la Red de Monitoreo de Buenos Aires Data.
El mapa representa cada sensor coloreado según su nivel (Buena hasta 15 µg/m³, Moderada hasta 35, Mala más de 35), con vistas de calor y hexágonos.
Permite ver que los valores más altos se concentran en el centro, las grandes avenidas y la zona sur cercana al Riachuelo, y los más bajos en parques y costanera.
En una segunda versión agregaríamos datos reales en el tiempo, un filtro por fecha y hora, y alertas cuando un sensor supere los 35 µg/m³.
