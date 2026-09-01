// Map eksplisit, bukan `import * as icons` -- biar yang ke-bundle cuma yang dipakai.
// Nambah app baru dengan ikon lain? Tambahin satu baris di sini.
import {
  Baby,
  Calendar,
  Camera,
  Gamepad2,
  Heart,
  LayoutGrid,
  ListTodo,
  Music,
  Notebook,
  Package,
  Rocket,
  Users,
  Wallet,
  Zap,
} from '@lucide/vue'

const map = {
  baby: Baby,
  calendar: Calendar,
  camera: Camera,
  gamepad: Gamepad2,
  heart: Heart,
  'layout-grid': LayoutGrid,
  'list-todo': ListTodo,
  music: Music,
  notebook: Notebook,
  package: Package,
  rocket: Rocket,
  users: Users,
  wallet: Wallet,
  zap: Zap,
}

export function iconFor(name) {
  return map[name] ?? LayoutGrid
}
