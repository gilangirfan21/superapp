import { supabase } from '../lib/supabase'

// `profile_admin`, bukan `profiles` -- tabel `profiles` di project ini punya
// babytracker (profil ibu: hpht, baby_name). Beda urusan, jangan dicampur.
const TABLE = 'profile_admin'

export async function getProfile(userId) {
  const { data, error } = await supabase
    .from(TABLE)
    .select('*')
    .eq('user_id', userId)
    .maybeSingle()
  if (error) throw error
  return data
}

export async function upsertProfile(userId, fields) {
  const { data, error } = await supabase
    .from(TABLE)
    .upsert({ user_id: userId, ...fields }, { onConflict: 'user_id' })
    .select()
    .single()
  if (error) throw error
  return data
}
