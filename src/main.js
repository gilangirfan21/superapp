import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import { useAuthStore } from './stores/auth'
import './style.css'

const app = createApp(App)
app.use(createPinia())
app.use(router)

// auth.init() harus selesai sebelum mount: router guard baca auth.user secara
// sinkron, jadi kalau belum ke-restore semua route protected bakal nolak.
const auth = useAuthStore()
auth.init().then(() => {
  app.mount('#app')
})
