<script setup>
import { Search } from '@lucide/vue'

defineProps({
  tags: { type: Array, default: () => [] },
})

const search = defineModel('search', { type: String, default: '' })
const tag = defineModel('tag', { type: String, default: '' })
const status = defineModel('status', { type: String, default: '' })

const statuses = [
  { value: '', label: 'Semua' },
  { value: 'live', label: 'Live' },
  { value: 'wip', label: 'Dikerjain' },
  { value: 'archived', label: 'Arsip' },
]
</script>

<template>
  <div class="flex flex-col gap-3 sm:flex-row sm:items-center">
    <div class="relative flex-1">
      <Search :size="16" class="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400" />
      <input
        v-model="search"
        type="search"
        placeholder="Cari app..."
        class="w-full rounded-lg border border-zinc-300 bg-white py-2 pl-9 pr-3 text-sm dark:border-zinc-700 dark:bg-zinc-900"
      />
    </div>

    <div class="flex gap-2">
      <select
        v-model="tag"
        class="rounded-lg border border-zinc-300 bg-white px-3 py-2 text-sm dark:border-zinc-700 dark:bg-zinc-900"
        aria-label="Filter tag"
      >
        <option value="">Semua tag</option>
        <option v-for="t in tags" :key="t" :value="t">{{ t }}</option>
      </select>

      <select
        v-model="status"
        class="rounded-lg border border-zinc-300 bg-white px-3 py-2 text-sm dark:border-zinc-700 dark:bg-zinc-900"
        aria-label="Filter status"
      >
        <option v-for="s in statuses" :key="s.value" :value="s.value">{{ s.label }}</option>
      </select>
    </div>
  </div>
</template>
