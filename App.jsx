import { useEffect, useMemo, useState } from 'react'
import DeckGL from '@deck.gl/react'
import { ScatterplotLayer } from '@deck.gl/layers'
import { HeatmapLayer, HexagonLayer } from '@deck.gl/aggregation-layers'
import Map from 'react-map-gl/maplibre'
import { supabase } from './supabase'
import datosEjemplo from './datosEjemplo.json'

// Umbrales de PM2.5 (µg/m³)
const GUIA_OMS = 15   // guía OMS 2021, promedio 24 h
const LIMITE_MALO = 35 // por encima de este valor el sensor se considera crítico
const ESCALA_MAX = 50

const COLORES = {
  Buena: [62, 156, 140],
  Moderada: [224, 164, 58],
  Mala: [184, 50, 79],
}

const VISTA_INICIAL = {
  longitude: -58.443,
  latitude: -34.612,
  // En pantallas angostas arranca más alejado para que entre toda la Ciudad
  zoom: typeof window !== 'undefined' && window.innerWidth < 600 ? 10.3 : 10.9,
  pitch: 0,
  bearing: 0,
}

const CAPAS = [
  { id: 'puntos', nombre: 'Puntos' },
  { id: 'calor', nombre: 'Mapa de calor' },
  { id: 'hexagonos', nombre: 'Hexágonos' },
]

const MAPA_CLARO = 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json'
const MAPA_OSCURO = 'https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json'

function useModoOscuro() {
  const consulta = '(prefers-color-scheme: dark)'
  const [oscuro, setOscuro] = useState(() => window.matchMedia(consulta).matches)
  useEffect(() => {
    const mq = window.matchMedia(consulta)
    const cambio = (e) => setOscuro(e.matches)
    mq.addEventListener('change', cambio)
    return () => mq.removeEventListener('change', cambio)
  }, [])
  return oscuro
}

const formato = (n, dec = 1) =>
  n.toLocaleString('es-AR', { minimumFractionDigits: dec, maximumFractionDigits: dec })

export default function App() {
  const [sensores, setSensores] = useState([])
  const [estado, setEstado] = useState('cargando') // cargando | ok | ejemplo | error
  const [mensajeError, setMensajeError] = useState('')
  const [capa, setCapa] = useState('puntos')
  const oscuro = useModoOscuro()

  // Etapa 4: consulta a Supabase
  useEffect(() => {
    async function cargar() {
      if (!supabase) {
        setSensores(datosEjemplo)
        setEstado('ejemplo')
        return
      }
      const { data, error } = await supabase
        .from('puntos')
        .select('id, nombre, categoria, latitud, longitud, valor, temperatura, humedad, fecha, descripcion')
        .order('id')
      if (error) {
        console.error('Error al consultar Supabase:', error)
        setMensajeError(error.message)
        setEstado('error')
        return
      }
      console.log('Registros recibidos desde Supabase:', data)
      setSensores(data.map((d) => ({ ...d, valor: Number(d.valor) })))
      setEstado('ok')
    }
    cargar()
  }, [])

  // Etapa 7: indicadores calculados con los datos cargados
  const indicadores = useMemo(() => {
    const total = sensores.length
    const promedio = total ? sensores.reduce((s, d) => s + d.valor, 0) / total : 0
    const criticos = sensores.filter((d) => d.valor > LIMITE_MALO).length
    const sobreOms = sensores.filter((d) => d.valor > GUIA_OMS).length
    return { total, promedio, criticos, sobreOms }
  }, [sensores])

  // Etapa 5 y desafío adicional: capas de deck.gl
  const layers = useMemo(() => {
    if (capa === 'calor') {
      return [
        new HeatmapLayer({
          id: 'calor',
          data: sensores,
          getPosition: (d) => [d.longitud, d.latitud], // deck.gl usa [LONGITUD, LATITUD]
          getWeight: (d) => d.valor,
          radiusPixels: 85,
          intensity: 1.5,
          threshold: 0.05,
          colorRange: [
            [62, 156, 140, 40],
            [120, 180, 130, 120],
            [224, 164, 58, 170],
            [214, 110, 60, 200],
            [184, 50, 79, 230],
            [130, 20, 60, 255],
          ],
        }),
      ]
    }
    if (capa === 'hexagonos') {
      return [
        new HexagonLayer({
          id: 'hexagonos',
          data: sensores,
          getPosition: (d) => [d.longitud, d.latitud],
          getColorWeight: (d) => d.valor,
          colorAggregation: 'MEAN',
          getElevationWeight: (d) => d.valor,
          elevationAggregation: 'MEAN',
          radius: 900,
          coverage: 0.9,
          extruded: false,
          opacity: 0.75,
          pickable: true,
          colorDomain: [8, 42],
          colorRange: [
            [62, 156, 140],
            [140, 180, 110],
            [224, 164, 58],
            [214, 110, 60],
            [184, 50, 79],
            [130, 20, 60],
          ],
        }),
      ]
    }
    return [
      new ScatterplotLayer({
        id: 'puntos',
        data: sensores,
        getPosition: (d) => [d.longitud, d.latitud],
        getFillColor: (d) => [...(COLORES[d.categoria] || [120, 120, 120]), 220],
        getLineColor: oscuro ? [20, 30, 34] : [255, 255, 255],
        getRadius: (d) => 90 + d.valor * 9,
        radiusMinPixels: 5,
        radiusMaxPixels: 22,
        stroked: true,
        lineWidthMinPixels: 1.5,
        pickable: true,
        autoHighlight: true,
        highlightColor: oscuro ? [255, 255, 255, 90] : [20, 48, 58, 80],
        updateTriggers: { getLineColor: oscuro },
      }),
    ]
  }, [sensores, capa, oscuro])

  // Etapa 6: información al pasar el mouse
  const getTooltip = ({ object, layer }) => {
    if (!object) return null
    const estilo = {
      background: oscuro ? '#E6EEEF' : '#14303A',
      color: oscuro ? '#14303A' : '#F2F6F6',
      fontFamily: 'Archivo, system-ui, sans-serif',
      fontSize: '13px',
      lineHeight: '1.45',
      padding: '10px 12px',
      borderRadius: '6px',
      maxWidth: '260px',
    }
    if (layer?.id === 'hexagonos') {
      const n = object.count ?? object.points?.length ?? 0
      return {
        html: `<strong>Zona agregada</strong><br/>Sensores: ${n}<br/>PM2.5 promedio: ${formato(object.colorValue ?? 0)} µg/m³`,
        style: estilo,
      }
    }
    return {
      html: `<strong>${object.nombre}</strong><br/>
        Categoría: ${object.categoria}<br/>
        Valor (PM2.5): ${formato(object.valor)} µg/m³<br/>
        Barrio: ${object.descripcion}<br/>
        Temperatura: ${formato(object.temperatura)} °C · Humedad: ${object.humedad}%`,
      style: estilo,
    }
  }

  const posPromedio = Math.min(indicadores.promedio / ESCALA_MAX, 1) * 100
  const posOms = (GUIA_OMS / ESCALA_MAX) * 100
  const posMalo = (LIMITE_MALO / ESCALA_MAX) * 100

  return (
    <div className="app">
      <header className="cabecera">
        <div className="titulo">
          <h1>Calidad del aire en CABA</h1>
          <p>
            Material particulado fino (PM2.5) medido por 60 sensores distribuidos en los barrios de la Ciudad.
            Pasá el mouse sobre un punto para ver su medición.
          </p>
        </div>

        <dl className="indicadores" aria-live="polite">
          <div className="indicador">
            <dt>Sensores registrados</dt>
            <dd>{estado === 'cargando' ? '—' : indicadores.total}</dd>
          </div>
          <div className="indicador indicador-escala">
            <dt>PM2.5 promedio</dt>
            <dd>
              {estado === 'cargando' ? '—' : formato(indicadores.promedio)}
              <span className="unidad"> µg/m³</span>
            </dd>
            <div className="escala" aria-hidden="true">
              <div className="escala-barra">
                <span className="escala-tramo buena" style={{ width: `${posOms}%` }} />
                <span className="escala-tramo moderada" style={{ width: `${posMalo - posOms}%` }} />
                <span className="escala-tramo mala" style={{ width: `${100 - posMalo}%` }} />
                {estado !== 'cargando' && (
                  <span className="escala-marca" style={{ left: `${posPromedio}%` }} />
                )}
              </div>
              <div className="escala-rotulos">
                <span style={{ left: `${posOms}%` }}>OMS {GUIA_OMS}</span>
                <span style={{ left: `${posMalo}%` }}>{LIMITE_MALO}</span>
              </div>
            </div>
          </div>
          <div className="indicador">
            <dt>Sensores críticos</dt>
            <dd className="critico">{estado === 'cargando' ? '—' : indicadores.criticos}</dd>
            <p className="nota">más de {LIMITE_MALO} µg/m³</p>
          </div>
        </dl>
      </header>

      {estado === 'ejemplo' && (
        <p className="aviso">
          Mostrando datos de ejemplo: falta conectar Supabase. Cargá <code>VITE_SUPABASE_URL</code> y{' '}
          <code>VITE_SUPABASE_ANON_KEY</code> en el archivo .env (o en Vercel) y volvé a abrir la página.
        </p>
      )}
      {estado === 'error' && (
        <p className="aviso aviso-error">
          No se pudieron leer los datos de Supabase: {mensajeError}. Revisá que exista la tabla <code>puntos</code>{' '}
          y la política de lectura pública.
        </p>
      )}

      <main className="mapa">
        <DeckGL initialViewState={VISTA_INICIAL} controller layers={layers} getTooltip={getTooltip}>
          <Map mapStyle={oscuro ? MAPA_OSCURO : MAPA_CLARO} reuseMaps attributionControl={false} />
        </DeckGL>

        <div className="selector" role="radiogroup" aria-label="Tipo de visualización">
          {CAPAS.map((c) => (
            <button
              key={c.id}
              role="radio"
              aria-checked={capa === c.id}
              className={capa === c.id ? 'activo' : ''}
              onClick={() => setCapa(c.id)}
            >
              {c.nombre}
            </button>
          ))}
        </div>

        <div className="leyenda">
          {capa === 'puntos' ? (
            <ul>
              <li><span className="punto buena" />Buena (hasta {GUIA_OMS})</li>
              <li><span className="punto moderada" />Moderada ({GUIA_OMS}–{LIMITE_MALO})</li>
              <li><span className="punto mala" />Mala (más de {LIMITE_MALO})</li>
            </ul>
          ) : (
            <div className="leyenda-gradiente">
              <span>Menor concentración</span>
              <span className="gradiente" />
              <span>Mayor</span>
            </div>
          )}
        </div>

        <p className="atribucion">© OpenStreetMap · © CARTO</p>
      </main>
    </div>
  )
}
