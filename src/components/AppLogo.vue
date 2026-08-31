<script setup>
defineProps({
  size: { type: Number, default: 32 },
})
</script>

<template>
  <!-- Stroke pakai currentColor biar mark-nya kebaca di terang maupun gelap;
       titik oranye tetap warna brand. -->
  <svg
    :width="size"
    :height="size"
    viewBox="0 0 100 100"
    class="text-zinc-900 dark:text-white"
    role="img"
    aria-label="Gia"
  >
    <g transform="translate(50, 50)">
      <path
        d="M 0 -28 A 28 28 0 0 0 0 28"
        fill="none"
        stroke="currentColor"
        stroke-width="4"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
      <line x1="0" y1="0" x2="22" y2="0" stroke="currentColor" stroke-width="4" stroke-linecap="round" />
      <line x1="22" y1="0" x2="22" y2="18" stroke="currentColor" stroke-width="4" stroke-linecap="round" />
      <circle cx="0" cy="0" r="4.5" fill="#ff6b35" />
    </g>
  </svg>
</template>
