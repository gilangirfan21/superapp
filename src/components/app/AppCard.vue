<script setup>
import { computed } from 'vue'
import { Code, ExternalLink, Star } from '@lucide/vue'
import { iconFor } from '../../lib/icons'

const props = defineProps({
  app: { type: Object, required: true },
  favorite: { type: Boolean, default: false },
  favoritable: { type: Boolean, default: true },
})

defineEmits(['launch', 'toggle-favorite'])

const Icon = computed(() => iconFor(props.app.icon))

const statusLabel = { live: 'Live', wip: 'Dikerjain', archived: 'Arsip' }
const statusClass = {
  live: 'bg-emerald-50 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-400',
  wip: 'bg-amber-50 text-amber-700 dark:bg-amber-950 dark:text-amber-400',
  archived: 'bg-zinc-100 text-zinc-500 dark:bg-zinc-800 dark:text-zinc-400',
}
</script>

<template>
  <div
    class="group relative flex flex-col rounded-xl border border-zinc-200 bg-white p-5 transition-colors hover:border-brand-400 dark:border-zinc-800 dark:bg-zinc-900 dark:hover:border-brand-500"
  >
    <div class="flex items-start gap-3">
      <span
        class="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg text-white"
        :style="{ backgroundColor: app.color || '#ff6b35' }"
      >
        <component :is="Icon" :size="20" />
      </span>

      <div class="min-w-0 flex-1">
        <div class="flex items-center gap-2">
          <h3 class="truncate font-semibold">{{ app.name }}</h3>
          <span
            class="shrink-0 rounded px-1.5 py-0.5 text-[10px] font-medium uppercase tracking-wide"
            :class="statusClass[app.status]"
          >
            {{ statusLabel[app.status] }}
          </span>
        </div>
        <p class="mt-1 line-clamp-2 text-sm text-zinc-500 dark:text-zinc-400">
          {{ app.description }}
        </p>
      </div>

      <button
        v-if="favoritable"
        type="button"
        class="shrink-0 rounded-lg p-1.5 transition-colors"
        :class="
          favorite
            ? 'text-brand-500'
            : 'text-zinc-300 hover:text-zinc-500 dark:text-zinc-600 dark:hover:text-zinc-400'
        "
        :aria-label="favorite ? 'Lepas dari pin' : 'Pin app ini'"
        @click="$emit('toggle-favorite', app)"
      >
        <Star :size="17" :fill="favorite ? 'currentColor' : 'none'" />
      </button>
    </div>

    <div v-if="app.tags?.length" class="mt-4 flex flex-wrap gap-1.5">
      <span
        v-for="tag in app.tags"
        :key="tag"
        class="rounded-md bg-zinc-100 px-2 py-0.5 text-[11px] text-zinc-600 dark:bg-zinc-800 dark:text-zinc-400"
      >
        {{ tag }}
      </span>
    </div>

    <div class="mt-5 flex items-center gap-2 pt-0.5">
      <button
        type="button"
        class="inline-flex flex-1 items-center justify-center gap-1.5 rounded-lg bg-zinc-900 px-3 py-2 text-sm font-medium text-white transition-colors hover:bg-brand-500 dark:bg-zinc-100 dark:text-zinc-900 dark:hover:bg-brand-500 dark:hover:text-white"
        @click="$emit('launch', app)"
      >
        Buka <ExternalLink :size="14" />
      </button>
      <a
        v-if="app.repo_url"
        :href="app.repo_url"
        target="_blank"
        rel="noopener"
        class="rounded-lg border border-zinc-300 p-2 text-zinc-500 transition-colors hover:text-zinc-900 dark:border-zinc-700 dark:hover:text-zinc-100"
        :aria-label="'Repo ' + app.name"
      >
        <Code :size="16" />
      </a>
    </div>
  </div>
</template>
