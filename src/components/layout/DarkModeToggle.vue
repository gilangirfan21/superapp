<script setup>
import { Moon, Sun } from '@lucide/vue'
import { useDarkMode } from '../../composables/useDarkMode'

const { isDark, toggle } = useDarkMode()
</script>

<template>
  <button
    type="button"
    class="rounded-lg p-2 text-zinc-500 transition-colors hover:bg-zinc-100 hover:text-zinc-900 dark:text-zinc-400 dark:hover:bg-zinc-800 dark:hover:text-zinc-100"
    :aria-label="isDark ? 'Ganti ke mode terang' : 'Ganti ke mode gelap'"
    @click="toggle"
  >
    <Sun v-if="isDark" :size="18" />
    <Moon v-else :size="18" />
  </button>
</template>
