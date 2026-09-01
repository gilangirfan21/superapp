-- Catatan kenalan -- orang yang pernah ditemui, biar nggak lupa namanya.
-- Jalanin di Supabase SQL Editor (project yang sama dengan hub & todolist),
-- atau lewat CLI: supabase db push
--
-- App-nya ada di repo terpisah, tapi migration-nya ditaro di sini karena satu
-- database dipakai bareng-bareng -- sama kayak 0002 yang ngurus tabel punya
-- babytracker. Satu tempat buat semua perubahan skema.
--
-- Ini data ORANG LAIN, bukan data sendiri. RLS-nya owner-only buat semua
-- operasi -- nggak ada `is_public` kayak `apps`, nggak ada mode publik.

create table if not exists public.people (
  id         uuid primary key default gen_random_uuid(),
  owner_id   uuid not null default auth.uid() references auth.users(id) on delete cascade,

  name       text not null,                -- nama/panggilan: "Pak Andi"
  gender     text check (gender in ('L', 'P')),
  relation   text,                         -- hubungan: tetangga, teman kerja, ...
  context    text,                         -- kenal di mana: "warung kopi deket kantor"
  note       text,                         -- catatan bebas: ciri, obrolan, apa aja
  tags       text[] not null default '{}',
  met_at     date,                         -- kapan kenal, kalau inget

  created_at timestamptz not null default now(),
  -- Di-set dari app pas update. Sengaja nggak pakai trigger, ngikutin 0001.
  updated_at timestamptz not null default now(),

  -- Satu kolom buat dicari, biar query-nya cukup satu ilike -- bukan OR
  -- panjang ke tiap kolom. Yang dicari justru konteksnya ("warung kopi",
  -- "kacamata"), soalnya namanya yang lupa.
  --
  -- `tags` sengaja nggak ikut: array_to_string itu STABLE, bukan IMMUTABLE,
  -- jadi nggak boleh dipakai di generated column. Filter tag pakai operator
  -- array di query (`tags @> '{kerja}'`).
  search_text text generated always as (
    coalesce(name, '')     || ' ' ||
    coalesce(relation, '') || ' ' ||
    coalesce(context, '')  || ' ' ||
    coalesce(note, '')
  ) stored
);

create index if not exists people_owner_name_idx
  on public.people (owner_id, name);

-- Kalau nanti datanya udah ribuan dan search mulai berat, tambahin:
--   create extension if not exists pg_trgm;
--   create index people_search_trgm_idx on public.people
--     using gin (search_text gin_trgm_ops);
-- Buat ratusan baris, seq scan masih lebih cepat -- nggak usah buru-buru.

alter table public.people enable row level security;

drop policy if exists people_select_own on public.people;
drop policy if exists people_insert_own on public.people;
drop policy if exists people_update_own on public.people;
drop policy if exists people_delete_own on public.people;

create policy people_select_own on public.people
  for select using (auth.uid() = owner_id);
create policy people_insert_own on public.people
  for insert with check (auth.uid() = owner_id);
create policy people_update_own on public.people
  for update using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy people_delete_own on public.people
  for delete using (auth.uid() = owner_id);
