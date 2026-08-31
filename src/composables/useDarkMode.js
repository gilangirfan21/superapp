import { ref, watchEffect } from 'vue'

// Key 'theme' sengaja sama dengan todolist. Satu origin = satu localStorage,
// jadi ganti tema di sini kebawa ke app lain juga.
const isDark = ref(localStorage.getItem('theme') !== 'light')

watchEffect(() => {
  document.documentElement.classList.toggle('dark', isDark.value)
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
})

export function useDarkMode() {
  function toggle() {
    isDark.value = !isDark.value
  }
  return { isDark, toggle }
}
