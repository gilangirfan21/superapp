<script setup>
import { onMounted } from 'vue'
import { AlertTriangle, Clock } from '@lucide/vue'
import AppHeader from '../components/layout/AppHeader.vue'
import AppCard from '../components/app/AppCard.vue'
import AppCardSkeleton from '../components/app/AppCardSkeleton.vue'
import AppFilterBar from '../components/app/AppFilterBar.vue'
import { useAppsStore } from '../stores/apps'

const apps = useAppsStore()

onMounted(() => apps.load())
</script>

<template>
  <div class="min-h-full">
    <AppHeader />

    <main class="mx-auto max-w-5xl px-4 py-8">
      <div class="mb-6">
        <h1 class="text-2xl font-semibold tracking-tight">App lo</h1>
        <p class="mt-1 text-sm text-zinc-500 dark:text-zinc-400">
          Semua app dipakai bareng satu akun. Nggak perlu login lagi di dalamnya.
        </p>
      </div>

      <div
        v-if="apps.usingFallback"
        class="mb-6 flex items-start gap-2.5 rounded-lg border border-amber-300 bg-amber-50 px-4 py-3 text-sm text-amber-800 dark:border-amber-800 dark:bg-amber-950 dark:text-amber-300"
      >
        <AlertTriangle :size="16" class="mt-0.5 shrink-0" />
        <span>Katalog lagi dibaca dari daftar cadangan di repo &mdash; pin dan riwayat sementara nggak aktif.</span>
      </div>

      <AppFilterBar
        v-model:search="apps.search"
        v-model:tag="apps.activeTag"
        v-model:status="apps.activeStatus"
        :tags="apps.allTags"
      />

      <div v-if="apps.loading" class="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <AppCardSkeleton v-for="n in 3" :key="n" />
      </div>

      <template v-else>
        <section v-if="apps.recent.length && !apps.search" class="mt-8">
          <h2 class="mb-3 flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-zinc-500">
            <Clock :size="13" /> Terakhir dibuka
          </h2>
          <div class="flex flex-wrap gap-2">
            <button
              v-for="app in apps.recent"
              :key="app.id"
              type="button"
              class="rounded-lg border border-zinc-200 bg-white px-3 py-1.5 text-sm transition-colors hover:border-brand-400 dark:border-zinc-800 dark:bg-zinc-900"
              @click="apps.launch(app)"
            >
              {{ app.name }}
            </button>
          </div>
        </section>

        <section v-if="apps.pinned.length" class="mt-8">
          <h2 class="mb-3 text-xs font-semibold uppercase tracking-wider text-zinc-500">Di-pin</h2>
          <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            <AppCard
              v-for="app in apps.pinned"
              :key="app.id"
              :app="app"
              favorite
              :favoritable="!apps.usingFallback"
              @launch="apps.launch"
              @toggle-favorite="apps.toggleFavorite(app.id)"
            />
          </div>
        </section>

        <section class="mt-8">
          <h2 v-if="apps.pinned.length" class="mb-3 text-xs font-semibold uppercase tracking-wider text-zinc-500">
            Lainnya
          </h2>
          <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            <AppCard
              v-for="app in apps.rest"
              :key="app.id"
              :app="app"
              :favorite="false"
              :favoritable="!apps.usingFallback"
              @launch="apps.launch"
              @toggle-favorite="apps.toggleFavorite(app.id)"
            />
          </div>
        </section>

        <p
          v-if="!apps.filtered.length"
          class="mt-12 text-center text-sm text-zinc-500 dark:text-zinc-400"
        >
          Nggak ada app yang cocok sama filter itu.
        </p>
      </template>
    </main>
  </div>
</template>
