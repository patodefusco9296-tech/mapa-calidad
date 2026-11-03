import { createClient } from '@supabase/supabase-js'

const url = import.meta.env.VITE_SUPABASE_URL
const key = import.meta.env.VITE_SUPABASE_ANON_KEY

// Si faltan las variables, la app muestra datos de ejemplo con un aviso.
export const supabase = url && key ? createClient(url, key) : null
