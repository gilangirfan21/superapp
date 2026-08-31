-- Kasih nama yang jelas ke tabel punya babytracker.
--
-- `profiles` itu profil ibu buat kehamilan (hpht, baby_name) -- bukan
-- identitas akun. Namanya terlalu umum buat satu database yang dipakai
-- banyak app, jadi dikasih akhiran biar kebaca punya siapa.
--
-- AMAN dijalanin sekarang: app babytracker yang live masih nunjuk project
-- lama (bznjrtpo...), jadi tabel di project ini lagi nggak dipakai siapa pun.
-- Rename nggak ngilangin data, cuma ganti nama.
--
-- NANTI di Fase 2, pas babytracker dipindah ke project ini, `js/db.js`-nya
-- harus ikut diganti: .from('profiles') -> .from('profiles_baby')
--
-- `todos` & `categories` sengaja dibiarin -- todolist lagi live pakai nama itu.

do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'profiles' and column_name = 'hpht'
  ) and not exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'profiles_baby'
  ) then
    alter table public.profiles rename to profiles_baby;
    raise notice 'profiles -> profiles_baby';
  else
    raise notice 'dilewati: profiles (versi babytracker) nggak ada, atau profiles_baby udah ada';
  end if;
end $$;
