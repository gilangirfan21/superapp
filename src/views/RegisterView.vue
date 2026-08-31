<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import AuthShell from '../components/layout/AuthShell.vue'
import BaseButton from '../components/ui/BaseButton.vue'
import BaseInput from '../components/ui/BaseInput.vue'
import { useAuthStore } from '../stores/auth'

const auth = useAuthStore()
const router = useRouter()

const email = ref('')
const password = ref('')
const busy = ref(false)
const needsConfirm = ref(false)

async function submit() {
  busy.value = true
  try {
    const data = await auth.signUp(email.value, password.value)
    // Kalau email confirmation nyala di Supabase, session-nya null dulu.
    if (data.session) router.push({ name: 'home' })
    else needsConfirm.value = true
  } catch {
    // pesan error udah ada di auth.error
  } finally {
    busy.value = false
  }
}
</script>

<template>
  <AuthShell title="Bikin akun" subtitle="Sekali daftar, kepakai di semua app.">
    <div
      v-if="needsConfirm"
      class="rounded-lg border border-emerald-300 bg-emerald-50 px-4 py-3 text-sm text-emerald-800 dark:border-emerald-800 dark:bg-emerald-950 dark:text-emerald-300"
    >
      Cek email lo buat konfirmasi, terus balik ke sini buat masuk.
    </div>

    <form v-else class="flex flex-col gap-4" @submit.prevent="submit">
      <BaseInput v-model="email" label="Email" type="email" autocomplete="email" required />
      <BaseInput
        v-model="password"
        label="Password"
        type="password"
        autocomplete="new-password"
        required
      />

      <p v-if="auth.error" class="text-sm text-red-600 dark:text-red-400">{{ auth.error }}</p>

      <BaseButton type="submit" block :disabled="busy">
        {{ busy ? 'Sebentar...' : 'Daftar' }}
      </BaseButton>
    </form>

    <p class="mt-6 text-center text-sm text-zinc-500">
      Udah punya akun?
      <RouterLink :to="{ name: 'login' }" class="font-medium text-brand-500 hover:underline">
        Masuk
      </RouterLink>
    </p>
  </AuthShell>
</template>
