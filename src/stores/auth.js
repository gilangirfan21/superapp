import { defineStore } from 'pinia'
import { ref } from 'vue'
import * as authService from '../services/authService'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const session = ref(null)
  const loading = ref(true)
  const error = ref(null)

  async function init() {
    const { data } = await authService.getSession()
    session.value = data.session
    user.value = data.session?.user ?? null
    loading.value = false

    authService.onAuthStateChange((_event, newSession) => {
      session.value = newSession
      user.value = newSession?.user ?? null
    })
  }

  async function run(fn) {
    error.value = null
    const { data, error: err } = await fn()
    if (err) {
      error.value = err.message
      throw err
    }
    return data
  }

  async function signUp(email, password) {
    const data = await run(() => authService.signUp(email, password))
    session.value = data.session
    user.value = data.user
    return data
  }

  async function signIn(email, password) {
    const data = await run(() => authService.signIn(email, password))
    session.value = data.session
    user.value = data.user
    return data
  }


  function sendPasswordReset(email) {
    return run(() => authService.sendPasswordReset(email))
  }

  function updatePassword(password) {
    return run(() => authService.updatePassword(password))
  }

  async function signOut() {
    await authService.signOut()
    session.value = null
    user.value = null
  }

  return {
    user,
    session,
    loading,
    error,
    init,
    signUp,
    signIn,
    sendPasswordReset,
    updatePassword,
    signOut,
  }
})
