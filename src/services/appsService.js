import { supabase } from '../lib/supabase'

export async function listApps() {
  const { data, error } = await supabase
    .from('apps')
    .select('*')
    .order('sort_order', { ascending: true })
    .order('name', { ascending: true })
  if (error) throw error
  return data
}

export async function listFavorites() {
  const { data, error } = await supabase.from('app_favorites').select('app_id')
  if (error) throw error
  return data.map((row) => row.app_id)
}

export async function addFavorite(appId) {
  const { error } = await supabase.from('app_favorites').insert({ app_id: appId })
  if (error) throw error
}

export async function removeFavorite(appId) {
  const { error } = await supabase.from('app_favorites').delete().eq('app_id', appId)
  if (error) throw error
}

export async function recordLaunch(appId) {
  const { error } = await supabase.from('app_launches').insert({ app_id: appId })
  if (error) throw error
}

export async function listRecentAppIds(limit = 4) {
  const { data, error } = await supabase
    .from('app_launches')
    .select('app_id, launched_at')
    .order('launched_at', { ascending: false })
    .limit(50)
  if (error) throw error

  const seen = []
  for (const row of data) {
    if (!seen.includes(row.app_id)) seen.push(row.app_id)
    if (seen.length === limit) break
  }
  return seen
}
