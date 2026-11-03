# Calidad del aire en CABA — PoC de datos georreferenciados

Recorrido del TP: **Dataset → Supabase → React/Vite → deck.gl → Vercel**

```
datos/sensores.csv    → dataset (60 registros) para entregar
datos/supabase.sql    → crea la tabla "puntos", la política de lectura y carga los 60 registros
src/App.jsx           → consulta, 3 indicadores, mapa, tooltip y selector de capas
src/supabase.js       → conexión a Supabase
.env.example          → modelo de las variables de conexión
```

## Paso a paso

### 1. Supabase (≈10 min)
1. Entrá a https://supabase.com, creá una cuenta y un proyecto nuevo (región: São Paulo).
2. Menú **SQL Editor** → **New query** → pegá todo el contenido de `datos/supabase.sql` → **Run**.
3. Al final tiene que aparecer la tabla de verificación: **Buena 17 · Moderada 31 · Mala 12** (total **60**).
4. Andá a **Project Settings → API** (o **Data API / API Keys**) y copiá:
   - la **Project URL** (`https://xxxx.supabase.co`)
   - la clave **anon public** (o la **publishable**). ⚠️ Nunca uses la `service_role` / `secret`.

> Si prefieren cargar el CSV a mano: **Table Editor → puntos → Insert → Import data from CSV** con `datos/sensores.csv`. En ese caso corran del SQL solo las partes 1 y 2.

### 2. Probar en tu compu (opcional, ≈5 min)
Necesitás Node.js 18 o superior.
```bash
npm install
cp .env.example .env      # en Windows: copy .env.example .env
# editá .env con la URL y la clave
npm run dev
```
Abrí http://localhost:5173. En la consola del navegador (F12) aparece `Registros recibidos desde Supabase:` con los 60 registros (Etapa 4).

Si la app muestra el aviso amarillo **"Mostrando datos de ejemplo"**, todavía no está leyendo Supabase: revisá el `.env`.

### 3. GitHub (≈5 min)
Subí la carpeta a un repositorio nuevo (sin el `.env`; el `.gitignore` ya lo excluye).
```bash
git init && git add . && git commit -m "PoC calidad del aire"
git branch -M main
git remote add origin https://github.com/USUARIO/mapa-calidad-aire.git
git push -u origin main
```
También se puede arrastrar los archivos desde la web de GitHub (sin `node_modules` ni `dist`).

### 4. Vercel (≈5 min)
1. https://vercel.com → **Add New → Project** → importá el repositorio.
2. Vercel detecta **Vite** solo (Build: `npm run build`, Output: `dist`).
3. En **Environment Variables** cargá las dos:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
4. **Deploy**. Te da la URL pública (ej. `https://mapa-calidad-aire.vercel.app`). Abrila desde el celular para comprobarla.

> Si agregaste las variables después del primer deploy: **Deployments → ⋯ → Redeploy**.

## Qué cumple de la consigna

| Requisito | Dónde |
|---|---|
| Título del proyecto | Cabecera |
| 3 indicadores calculados con datos de Supabase | Sensores registrados, PM2.5 promedio, sensores críticos (> 35 µg/m³) |
| Mapa interactivo deck.gl (zoom y desplazamiento) | `ScatterplotLayer`, posición `[longitud, latitud]` |
| Info al pasar el mouse | Nombre, categoría, valor, barrio, temperatura y humedad |
| Desafío adicional | Nivel 2 `HeatmapLayer` y Nivel 3 `HexagonLayer` (botones arriba a la izquierda) |
| Publicación | Vercel |

## Criterio de categorías (PM2.5 en µg/m³)
- **Buena:** hasta **15** (guía OMS 2021, promedio 24 h)
- **Moderada:** más de **15** y hasta **35**
- **Mala (crítico):** más de **35**

## Sobre los datos
Dataset **simulado** con fines didácticos: 60 sensores ubicados en puntos reales de los barrios de CABA, con valores de PM2.5 coherentes con cada entorno (avenidas y zona sur más altos, parques y costanera más bajos). Medición del 20/10/2026. La Red de Monitoreo de la Ciudad publica datos reales en https://data.buenosaires.gob.ar, pero con solo unas pocas estaciones, insuficientes para el mapa.
