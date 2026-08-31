import { createClient } from '@supabase/supabase-js'

// Satu client, satu project. Karena semua app duduk di origin yang sama
// (gilangirfan21.github.io), sesi di localStorage ini kepakai bareng-bareng
// sama todolist & babytracker -- itu yang bikin login-nya cuma sekali.
export const supabase = createClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY,
)
