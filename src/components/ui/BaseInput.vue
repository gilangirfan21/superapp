<script setup>
defineProps({
  label: { type: String, default: '' },
  type: { type: String, default: 'text' },
  placeholder: { type: String, default: '' },
  autocomplete: { type: String, default: 'off' },
  required: { type: Boolean, default: false },
  disabled: { type: Boolean, default: false },
})
const model = defineModel({ type: String, default: '' })
</script>

<template>
  <label class="block">
    <span v-if="label" class="mb-1.5 block text-sm font-medium text-zinc-700 dark:text-zinc-300">
      {{ label }}
    </span>
    <input
      v-model="model"
      :type="type"
      :placeholder="placeholder"
      :autocomplete="autocomplete"
      :required="required"
      :disabled="disabled"
      class="w-full rounded-lg border border-zinc-300 bg-white px-3 py-2 text-sm text-zinc-900 placeholder:text-zinc-400 disabled:cursor-not-allowed disabled:bg-zinc-100 disabled:text-zinc-500 dark:border-zinc-700 dark:bg-zinc-900 dark:text-zinc-100 dark:placeholder:text-zinc-500 dark:disabled:bg-zinc-800"
    />
  </label>
</template>
