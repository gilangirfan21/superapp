<script setup>
import { ref } from 'vue'
import AuthShell from '../components/layout/AuthShell.vue'
import BaseButton from '../components/ui/BaseButton.vue'
import BaseInput from '../components/ui/BaseInput.vue'
import { useAuthStore } from '../stores/auth'

const auth = useAuthStore()
const email = ref('')
const busy = ref(false)
const sent = ref(false)

async function submit() {
  busy.value = true
  try {
    await auth.sendPasswordReset(email.value)
    sent.value = true
  } catch {
    // pesan error udah ada di auth.error
  } finally {
    busy.value = false
  }
}
</script>

<template>
  <AuthShell title="Reset password" subtitle="Kirim link reset ke email lo.">
    <div
      v-if="sent"
      class="rounded-lg border border-emerald-300 bg-emerald-50 px-4 py-3 text-sm text-emerald-800 dark:border-emerald-800 dark:bg-emerald-950 dark:text-emerald-300"
    >
      Link-nya udah dikirim ke {{ email }}. Buka dari perangkat yang sama biar sesinya kebaca.
    </div>

    <form v-else class="flex flex-col gap-4" @submit.prevent="submit">
      <BaseInput v-model="email" label="Email" type="email" autocomplete="email" required />
      <p v-if="auth.error" class="text-sm text-red-600 dark:text-red-400">{{ auth.error }}</p>
      <BaseButton type="submit" block :disabled="busy">
        {{ busy ? 'Ngirim...' : 'Kirim link reset' }}
      </BaseButton>
    </form>

    <p class="mt-6 text-center text-sm">
      <RouterLink :to="{ name: 'login' }" class="text-zinc-500 hover:text-brand-500">
        Balik ke halaman masuk
      </RouterLink>
    </p>
  </AuthShell>
</template>
