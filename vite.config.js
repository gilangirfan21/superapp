import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'
import { defineConfig } from 'vite'

// base harus sama dengan nama repo di GitHub Pages: gilangirfan21.github.io/superapp/
export default defineConfig({
  base: '/superapp/',
  plugins: [vue(), tailwindcss()],
})
