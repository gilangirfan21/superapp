import { createRouter, createWebHashHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

// Hash history disengaja: GitHub Pages nggak punya rewrite, history mode
// bakal 404 pas halaman di-refresh atau dibuka lewat deep link.
const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('../views/HomeView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/profile',
    name: 'profile',
    component: () => import('../views/ProfileView.vue'),
    meta: { requiresAuth: true },
  },
  { path: '/login', name: 'login', component: () => import('../views/LoginView.vue') },
  { path: '/register', name: 'register', component: () => import('../views/RegisterView.vue') },
  {
    path: '/forgot-password',
    name: 'forgot-password',
    component: () => import('../views/ForgotPasswordView.vue'),
  },
  {
    path: '/reset-password',
    name: 'reset-password',
    component: () => import('../views/ResetPasswordView.vue'),
  },
  { path: '/:pathMatch(.*)*', redirect: { name: 'home' } },
]

const router = createRouter({
  history: createWebHashHistory(),
  routes,
})

const guestOnly = ['login', 'register', 'forgot-password']

router.beforeEach((to) => {
  const auth = useAuthStore()
  const isAuthed = !!auth.user

  if (to.meta.requiresAuth && !isAuthed) {
    return { name: 'login', query: { next: to.fullPath } }
  }
  if (guestOnly.includes(to.name) && isAuthed) {
    return { name: 'home' }
  }
})

export default router
