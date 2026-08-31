import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import * as appsService from '../services/appsService'
import fallbackApps from '../data/apps.json'

export const useAppsStore = defineStore('apps', () => {
  const apps = ref([])
  const favoriteIds = ref([])
  const recentIds = ref([])
  const loading = ref(true)
  const error = ref(null)
  const usingFallback = ref(false)

  const search = ref('')
  const activeTag = ref('')
  const activeStatus = ref('')

  const allTags = computed(() => {
    const set = new Set()
    apps.value.forEach((app) => (app.tags ?? []).forEach((tag) => set.add(tag)))
    return [...set].sort()
  })

  const filtered = computed(() => {
    const q = search.value.trim().toLowerCase()
    return apps.value.filter((app) => {
      if (activeStatus.value && app.status !== activeStatus.value) return false
      if (activeTag.value && !(app.tags ?? []).includes(activeTag.value)) return false
      if (!q) return true
      const haystack = [app.name, app.description, ...(app.tags ?? [])].join(' ').toLowerCase()
      return haystack.includes(q)
    })
  })

  const pinned = computed(() => filtered.value.filter((app) => favoriteIds.value.includes(app.id)))
  const rest = computed(() => filtered.value.filter((app) => !favoriteIds.value.includes(app.id)))

  const recent = computed(() =>
    recentIds.value.map((id) => apps.value.find((app) => app.id === id)).filter(Boolean),
  )

  async function load() {
    loading.value = true
    error.value = null
    try {
      apps.value = await appsService.listApps()
      usingFallback.value = false
      // Favorit & recent nggak boleh bikin katalog gagal render.
      const [favs, recents] = await Promise.allSettled([
        appsService.listFavorites(),
        appsService.listRecentAppIds(),
      ])
      favoriteIds.value = favs.status === 'fulfilled' ? favs.value : []
      recentIds.value = recents.status === 'fulfilled' ? recents.value : []
    } catch (err) {
      // Katalog tetap tampil walau DB lagi ngadat -- pakai apps.json di repo.
      error.value = err.message
      apps.value = fallbackApps
      usingFallback.value = true
    } finally {
      loading.value = false
    }
  }

  async function toggleFavorite(appId) {
    if (usingFallback.value) return
    const isFav = favoriteIds.value.includes(appId)
    favoriteIds.value = isFav
      ? favoriteIds.value.filter((id) => id !== appId)
      : [...favoriteIds.value, appId]
    try {
      if (isFav) await appsService.removeFavorite(appId)
      else await appsService.addFavorite(appId)
    } catch (err) {
      // gagal simpan -> balikin state biar UI nggak bohong
      favoriteIds.value = isFav
        ? [...favoriteIds.value, appId]
        : favoriteIds.value.filter((id) => id !== appId)
      error.value = err.message
    }
  }

  function launch(app) {
    recentIds.value = [app.id, ...recentIds.value.filter((id) => id !== app.id)].slice(0, 4)
    if (!usingFallback.value) {
      appsService.recordLaunch(app.id).catch(() => {})
    }
    window.open(app.url, '_blank', 'noopener')
  }

  return {
    apps,
    favoriteIds,
    loading,
    error,
    usingFallback,
    search,
    activeTag,
    activeStatus,
    allTags,
    filtered,
    pinned,
    rest,
    recent,
    load,
    toggleFavorite,
    launch,
  }
})
