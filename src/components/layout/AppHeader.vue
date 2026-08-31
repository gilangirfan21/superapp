<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { LogOut, User } from '@lucide/vue'
import AppLogo from '../AppLogo.vue'
import DarkModeToggle from './DarkModeToggle.vue'
import { useAuthStore } from '../../stores/auth'

const auth = useAuthStore()
const router = useRouter()
const menuOpen = ref(false)

async function handleSignOut() {
  menuOpen.value = false
  await auth.signOut()
  router.push({ name: 'login' })
}
</script>

<template>
  <header
    class="sticky top-0 z-20 border-b border-zinc-200 bg-zinc-50/85 backdrop-blur dark:border-zinc-800 dark:bg-zinc-950/85"
  >
    <div class="mx-auto flex max-w-5xl items-center gap-3 px-4 py-3">
      <RouterLink :to="{ name: 'home' }" class="flex items-center gap-2.5">
        <AppLogo :size="30" />
        <span class="text-base font-semibold tracking-tight">Superapp</span>
      </RouterLink>

      <div class="ml-auto flex items-center gap-1">
        <DarkModeToggle />

        <div class="relative">
          <button
            type="button"
            class="flex h-9 w-9 items-center justify-center rounded-full bg-brand-500 text-sm font-semibold text-white"
            aria-label="Menu akun"
            @click="menuOpen = !menuOpen"
          >
            {{ (auth.user?.email ?? '?').charAt(0).toUpperCase() }}
          </button>

          <div
            v-if="menuOpen"
            class="absolute right-0 mt-2 w-56 overflow-hidden rounded-xl border border-zinc-200 bg-white shadow-lg dark:border-zinc-800 dark:bg-zinc-900"
          >
            <p class="truncate border-b border-zinc-200 px-4 py-3 text-xs text-zinc-500 dark:border-zinc-800">
              {{ auth.user?.email }}
            </p>
            <RouterLink
              :to="{ name: 'profile' }"
              class="flex items-center gap-2 px-4 py-2.5 text-sm hover:bg-zinc-100 dark:hover:bg-zinc-800"
              @click="menuOpen = false"
            >
              <User :size="15" /> Profil
            </RouterLink>
            <button
              type="button"
              class="flex w-full items-center gap-2 px-4 py-2.5 text-left text-sm text-red-600 hover:bg-zinc-100 dark:text-red-400 dark:hover:bg-zinc-800"
              @click="handleSignOut"
            >
              <LogOut :size="15" /> Keluar
            </button>
          </div>
        </div>
      </div>
    </div>
  </header>

  <!-- klik di luar buat nutup menu -->
  <div v-if="menuOpen" class="fixed inset-0 z-10" @click="menuOpen = false"></div>
</template>
