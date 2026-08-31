<script setup>
import { onMounted, ref, watch } from 'vue'
import AppHeader from '../components/layout/AppHeader.vue'
import BaseButton from '../components/ui/BaseButton.vue'
import BaseInput from '../components/ui/BaseInput.vue'
import { useAuthStore } from '../stores/auth'
import { useProfileStore } from '../stores/profile'

const auth = useAuthStore()
const profile = useProfileStore()

const displayName = ref('')
const avatarUrl = ref('')
const bio = ref('')
const busy = ref(false)
const saved = ref(false)

onMounted(() => profile.load())

watch(
  () => profile.profile,
  (p) => {
    displayName.value = p?.display_name ?? ''
    avatarUrl.value = p?.avatar_url ?? ''
    bio.value = p?.bio ?? ''
  },
  { immediate: true },
)

async function submit() {
  busy.value = true
  saved.value = false
  try {
    await profile.save({
      display_name: displayName.value || null,
      avatar_url: avatarUrl.value || null,
      bio: bio.value || null,
    })
    saved.value = true
  } catch {
    // pesan error udah ada di profile.error
  } finally {
    busy.value = false
  }
}
</script>

<template>
  <div class="min-h-full">
    <AppHeader />

    <main class="mx-auto max-w-lg px-4 py-8">
      <h1 class="text-2xl font-semibold tracking-tight">Profil</h1>
      <p class="mt-1 text-sm text-zinc-500 dark:text-zinc-400">
        Dipakai bareng semua app. Ganti di sini, kebawa ke mana-mana.
      </p>

      <form class="mt-6 flex flex-col gap-4" @submit.prevent="submit">
        <BaseInput :model-value="auth.user?.email ?? ''" label="Email" disabled />
        <BaseInput v-model="displayName" label="Nama tampilan" placeholder="Gilang" />
        <BaseInput v-model="avatarUrl" label="URL avatar" placeholder="https://..." />

        <label class="block">
          <span class="mb-1.5 block text-sm font-medium text-zinc-700 dark:text-zinc-300">Bio</span>
          <textarea
            v-model="bio"
            rows="3"
            class="w-full rounded-lg border border-zinc-300 bg-white px-3 py-2 text-sm dark:border-zinc-700 dark:bg-zinc-900"
          ></textarea>
        </label>

        <p v-if="profile.error" class="text-sm text-red-600 dark:text-red-400">
          {{ profile.error }}
        </p>
        <p v-else-if="saved" class="text-sm text-emerald-600 dark:text-emerald-400">Tersimpan.</p>

        <div class="flex gap-2">
          <BaseButton type="submit" :disabled="busy">
            {{ busy ? 'Nyimpen...' : 'Simpan' }}
          </BaseButton>
          <RouterLink :to="{ name: 'home' }">
            <BaseButton variant="secondary">Batal</BaseButton>
          </RouterLink>
        </div>
      </form>
    </main>
  </div>
</template>
