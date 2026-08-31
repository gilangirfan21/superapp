-- Superapp hub -- tabel inti. Jalanin SETELAH 0001.
--
-- Semua tabel wajib RLS: nggak ada server di antara browser dan Postgres,
-- jadi policy di sini satu-satunya batas otorisasi yang ada.

-- ---------------------------------------------------------------- profiles
-- Identitas bersama. Dibaca hub, dan nanti app lain juga.
create table if not exists public.profiles (
  user_id      uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  avatar_url   text,
  bio          text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

alter table public.profiles enable row level security;

drop policy if exists profiles_select_own on public.profiles;
drop policy if exists profiles_insert_own on public.profiles;
drop policy if exists profiles_update_own on public.profiles;

create policy profiles_select_own on public.profiles
  for select using (auth.uid() = user_id);
create policy profiles_insert_own on public.profiles
  for insert with check (auth.uid() = user_id);
create policy profiles_update_own on public.profiles
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ------------------------------------------------------------------- apps
create table if not exists public.apps (
  id          uuid primary key default gen_random_uuid(),
  slug        text unique not null,
  name        text not null,
  description text,
  icon        text,                       -- key di src/lib/icons.js
  color       text,                       -- warna aksen kartu
  url         text not null,
  repo_url    text,
  tags        text[] not null default '{}',
  status      text not null default 'live'
              check (status in ('live', 'wip', 'archived')),
  is_public   boolean not null default false,
  sort_order  int not null default 0,
  owner_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  created_at  timestamptz not null default now()
);

alter table public.apps enable row level security;

drop policy if exists apps_select on public.apps;
drop policy if exists apps_insert_own on public.apps;
drop policy if exists apps_update_own on public.apps;
drop policy if exists apps_delete_own on public.apps;

-- App publik kebaca siapa saja (buat mode portofolio nanti);
-- sisanya cuma buat yang udah login.
create policy apps_select on public.apps
  for select using (is_public or auth.role() = 'authenticated');

-- Nulis cuma owner. Admin panel nanti bersandar ke policy ini, bukan v-if.
create policy apps_insert_own on public.apps
  for insert with check (auth.uid() = owner_id);
create policy apps_update_own on public.apps
  for update using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy apps_delete_own on public.apps
  for delete using (auth.uid() = owner_id);

-- --------------------------------------------------------- app_favorites
create table if not exists public.app_favorites (
  user_id   uuid not null default auth.uid() references auth.users(id) on delete cascade,
  app_id    uuid not null references public.apps(id) on delete cascade,
  pinned_at timestamptz not null default now(),
  primary key (user_id, app_id)
);

alter table public.app_favorites enable row level security;

drop policy if exists app_favorites_select_own on public.app_favorites;
drop policy if exists app_favorites_insert_own on public.app_favorites;
drop policy if exists app_favorites_delete_own on public.app_favorites;

create policy app_favorites_select_own on public.app_favorites
  for select using (auth.uid() = user_id);
create policy app_favorites_insert_own on public.app_favorites
  for insert with check (auth.uid() = user_id);
create policy app_favorites_delete_own on public.app_favorites
  for delete using (auth.uid() = user_id);

-- ---------------------------------------------------------- app_launches
create table if not exists public.app_launches (
  id          bigint generated always as identity primary key,
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  app_id      uuid not null references public.apps(id) on delete cascade,
  launched_at timestamptz not null default now()
);

create index if not exists app_launches_user_recent_idx
  on public.app_launches (user_id, launched_at desc);

alter table public.app_launches enable row level security;

drop policy if exists app_launches_select_own on public.app_launches;
drop policy if exists app_launches_insert_own on public.app_launches;

create policy app_launches_select_own on public.app_launches
  for select using (auth.uid() = user_id);
create policy app_launches_insert_own on public.app_launches
  for insert with check (auth.uid() = user_id);
