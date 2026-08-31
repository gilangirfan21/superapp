<script setup>
defineProps({
  variant: { type: String, default: 'primary' }, // primary | secondary | ghost
  type: { type: String, default: 'button' },
  disabled: { type: Boolean, default: false },
  block: { type: Boolean, default: false },
})

const styles = {
  primary: 'bg-brand-500 text-white hover:bg-brand-600 disabled:hover:bg-brand-500',
  secondary:
    'border border-zinc-300 text-zinc-800 hover:bg-zinc-100 dark:border-zinc-700 dark:text-zinc-100 dark:hover:bg-zinc-800',
  ghost: 'text-zinc-600 hover:bg-zinc-100 dark:text-zinc-400 dark:hover:bg-zinc-800',
}
</script>

<template>
  <button
    :type="type"
    :disabled="disabled"
    :class="[
      'inline-flex items-center justify-center gap-2 rounded-lg px-4 py-2 text-sm font-medium transition-colors disabled:cursor-not-allowed disabled:opacity-50',
      styles[variant],
      block && 'w-full',
    ]"
  >
    <slot />
  </button>
</template>
