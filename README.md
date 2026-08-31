# Superapp

Satu pintu masuk buat semua app yang gua bikin. Login sekali, semua app kebuka.

Vue 3 + Vite + Pinia + Tailwind v4 + Supabase, di-deploy static ke GitHub Pages.

## Jalanin lokal

```bash
npm install
cp .env.example .env   # isi dengan URL + anon key project Supabase
npm run dev
```

## Setup pertama kali

1. **Migration** — buka Supabase SQL Editor, jalanin berurutan:
   - `supabase/migrations/0001_namespace_babytracker.sql`
   - `supabase/migrations/0002_hub_init.sql`
2. **Daftar akun** lewat halaman `/#/register`.
3. **Seed katalog** — jalanin `supabase/seed.sql` sambil login (kolom `owner_id` ngambil `auth.uid()`).

## Deploy

Push ke `main` bakal jalanin `.github/workflows/deploy.yml`. Sebelum push pertama, satu kali di GitHub:

- Settings → Pages → Source: **GitHub Actions**
- Settings → Secrets and variables → Actions, tambahin:
  - `VITE_SUPABASE_URL`
  - `VITE_SUPABASE_ANON_KEY`

Nama repo harus `superapp` supaya cocok dengan `base: '/superapp/'` di `vite.config.js`.

## Nambah app ke katalog

```sql
insert into public.apps (slug, name, description, icon, color, url, repo_url, tags, status, is_public, sort_order)
values ('nama-app', 'Nama App', 'Deskripsi singkat.', 'rocket', '#ff6b35',
        'https://gilangirfan21.github.io/nama-app/',
        'https://github.com/gilangirfan21/nama-app',
        array['vue', 'supabase'], 'live', true, 3);
```

Ikon diambil dari map di `src/lib/icons.js`. Kalau mau ikon baru, tambahin satu baris di situ.

## Kenapa login-nya cuma sekali

Semua app duduk di origin yang sama (`gilangirfan21.github.io`) dan nunjuk ke satu project Supabase, jadi sesi di `localStorage` kepakai bareng. Konsekuensinya: jangan pindahin salah satu app ke domain lain tanpa nyiapin ganti mekanisme auth-nya.

## Struktur

```
src/
  components/   app/ (kartu katalog) · layout/ (header, shell auth) · ui/ · icons/
  composables/  useDarkMode
  data/         apps.json — katalog cadangan kalau DB nggak kebaca
  lib/          supabase client, map ikon
  router/       hash history + guard auth
  services/     satu-satunya lapisan yang nyentuh Supabase
  stores/       Pinia — auth, apps, profile
  views/        Home, Login, Register, ForgotPassword, ResetPassword, Profile
supabase/
  migrations/   dijalanin manual, berurutan
  seed.sql
```
