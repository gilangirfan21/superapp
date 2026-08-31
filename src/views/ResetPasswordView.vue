<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import AuthShell from '../components/layout/AuthShell.vue'
import BaseButton from '../components/ui/BaseButton.vue'
import BaseInput from '../components/ui/BaseInput.vue'
import { useAuthStore } from '../stores/auth'

// Supabase nempelin sesi recovery-nya sendiri waktu link email dibuka,
// jadi halaman ini tinggal manggil updateUser.
const auth = useAuthStore()
const router = useRouter()

const password = ref('')
const busy = ref(false)

async function submit() {
  busy.value = true
  try {
    await auth.updatePassword(password.value)
    router.push({ name: 'home' })
  } catch {
    // pesan error udah ada di auth.error
  } finally {
    busy.value = false
  }
}
</script>

<template>
  <AuthShell title="Password baru">
    <form class="flex flex-col gap-4" @submit.prevent="submit">
      <BaseInput
        v-model="password"
        label="Password baru"
        type="password"
        autocomplete="new-password"
        required
      />
      <p v-if="auth.error" class="text-sm text-red-600 dark:text-red-400">{{ auth.error }}</p>
      <BaseButton type="submit" block :disabled="busy">
        {{ busy ? 'Nyimpen...' : 'Simpan password' }}
      </BaseButton>
    </form>
  </AuthShell>
</template>
