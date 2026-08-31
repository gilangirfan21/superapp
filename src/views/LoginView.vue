<script setup>
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import AuthShell from '../components/layout/AuthShell.vue'
import BaseButton from '../components/ui/BaseButton.vue'
import BaseInput from '../components/ui/BaseInput.vue'
import { useAuthStore } from '../stores/auth'

const auth = useAuthStore()
const router = useRouter()
const route = useRoute()

const email = ref('')
const password = ref('')
const busy = ref(false)

async function submit() {
  busy.value = true
  try {
    await auth.signIn(email.value, password.value)
    router.push(route.query.next ?? { name: 'home' })
  } catch {
    // pesan error udah ada di auth.error
  } finally {
    busy.value = false
  }
}
</script>

<template>
  <AuthShell title="Masuk ke Superapp" subtitle="Satu akun buat semua app lo.">
    <form class="flex flex-col gap-4" @submit.prevent="submit">
      <BaseInput v-model="email" label="Email" type="email" autocomplete="email" required />
      <BaseInput
        v-model="password"
        label="Password"
        type="password"
        autocomplete="current-password"
        required
      />

      <p v-if="auth.error" class="text-sm text-red-600 dark:text-red-400">{{ auth.error }}</p>

      <BaseButton type="submit" block :disabled="busy">
        {{ busy ? 'Sebentar...' : 'Masuk' }}
      </BaseButton>
    </form>

    <div class="mt-6 flex flex-col items-center gap-2 text-sm">
      <RouterLink :to="{ name: 'forgot-password' }" class="text-zinc-500 hover:text-brand-500">
        Lupa password?
      </RouterLink>
      <p class="text-zinc-500">
        Belum punya akun?
        <RouterLink :to="{ name: 'register' }" class="font-medium text-brand-500 hover:underline">
          Daftar
        </RouterLink>
      </p>
    </div>
  </AuthShell>
</template>
