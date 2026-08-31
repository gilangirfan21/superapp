import { defineStore } from 'pinia'
import { ref } from 'vue'
import * as profileService from '../services/profileService'
import { useAuthStore } from './auth'

export const useProfileStore = defineStore('profile', () => {
  const profile = ref(null)
  const loading = ref(false)
  const error = ref(null)

  async function load() {
    const auth = useAuthStore()
    if (!auth.user) return
    loading.value = true
    error.value = null
    try {
      profile.value = await profileService.getProfile(auth.user.id)
    } catch (err) {
      error.value = err.message
    } finally {
      loading.value = false
    }
  }

  async function save(fields) {
    const auth = useAuthStore()
    error.value = null
    try {
      profile.value = await profileService.upsertProfile(auth.user.id, fields)
    } catch (err) {
      error.value = err.message
      throw err
    }
  }

  return { profile, loading, error, load, save }
})
