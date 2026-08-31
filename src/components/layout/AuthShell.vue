<script setup>
import AppLogo from '../AppLogo.vue'
import DarkModeToggle from './DarkModeToggle.vue'

defineProps({
  title: { type: String, required: true },
  subtitle: { type: String, default: '' },
})
</script>

<template>
  <div class="flex min-h-full flex-col">
    <div class="flex justify-end p-4">
      <DarkModeToggle />
    </div>

    <div class="flex flex-1 items-start justify-center px-4 pb-16 pt-6 sm:items-center sm:pt-0">
      <div class="w-full max-w-sm">
        <div class="mb-8 flex flex-col items-center text-center">
          <AppLogo :size="48" />
          <h1 class="mt-4 text-xl font-semibold tracking-tight">{{ title }}</h1>
          <p v-if="subtitle" class="mt-1.5 text-sm text-zinc-500 dark:text-zinc-400">
            {{ subtitle }}
          </p>
        </div>

        <slot />
      </div>
    </div>
  </div>
</template>
