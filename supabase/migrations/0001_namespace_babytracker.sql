-- Beresin dulu tabrakan nama sebelum tabel hub dibikin.
--
-- Kondisi awal project ini (djeomfyh...): selain `todos` & `categories` punya
-- todolist, ternyata schema babytracker (`profiles` dengan kolom hpht/baby_name,
-- dan `measurements`) juga udah pernah dijalanin di sini.
--
-- Masalahnya: hub butuh nama `profiles` buat identitas bersama. Jadi tabel
-- babytracker dikasih prefix dulu.
--
-- AMAN dijalanin sekarang: app babytracker yang live masih nunjuk ke project
-- lain (bznjrtpo...), jadi rename di sini nggak bikin dia error.
-- TAPI pas nanti babytracker dipindah ke project ini (Fase 2), `js/db.js`-nya
-- harus diganti ke nama tabel yang baru.
--
-- `todos` & `categories` sengaja TIDAK di-rename -- todolist lagi live pakai
-- nama itu. Konvensi prefix berlaku buat app baru.

-- profiles (punya babytracker) -> baby_profiles
do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'profiles' and column_name = 'hpht'
  ) and not exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'baby_profiles'
  ) then
    alter table public.profiles rename to baby_profiles;
    raise notice 'profiles -> baby_profiles';
  end if;
end $$;

-- measurements -> baby_measurements
do $$
begin
  if exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'measurements'
  ) and not exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'baby_measurements'
  ) then
    alter table public.measurements rename to baby_measurements;
    raise notice 'measurements -> baby_measurements';
  end if;
end $$;
