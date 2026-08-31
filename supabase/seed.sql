-- Isi katalog awal. Jalanin SETELAH 0001_hub_init.sql DAN setelah lo
-- daftar akun lewat hub (butuh user buat dijadiin owner).
--
-- CATATAN: di SQL Editor, auth.uid() itu NULL -- editor jalan sebagai role
-- postgres, bukan sebagai user yang login. Makanya owner-nya dicari lewat
-- email di bawah ini, bukan ngandelin default auth.uid() di tabel.

do $$
declare
  owner uuid;
  -- GANTI dengan email akun yang lo pakai daftar di hub:
  owner_email text := 'gilangxirfan21@gmail.com';
begin
  select id into owner from auth.users where email = owner_email;

  if owner is null then
    raise exception 'Nggak nemu user dengan email %. Daftar dulu di hub (/#/register), atau betulin owner_email di atas.', owner_email;
  end if;

  insert into public.apps
    (slug, name, description, icon, color, url, repo_url, tags, status, is_public, sort_order, owner_id)
  values
    (
      'superapp',
      'Superapp',
      'Hub ini sendiri -- pintu masuk ke semua app.',
      'layout-grid',
      '#71717a',
      'https://gilangirfan21.github.io/superapp/',
      'https://github.com/gilangirfan21/superapp',
      array['vue', 'supabase', 'hub'],
      'live',
      true,
      0,
      owner
    ),
    (
      'todolist',
      'Todolist',
      'Todo harian dengan kategori, drag-reorder, dan export CSV.',
      'list-todo',
      '#ff6b35',
      'https://gilangirfan21.github.io/todolist/',
      'https://github.com/gilangirfan21/todolist',
      array['vue', 'supabase', 'produktivitas'],
      'live',
      true,
      1,
      owner
    ),
    (
      'babytracker',
      'Baby Tracker',
      'Catatan pertumbuhan bayi dengan kurva referensi WHO.',
      'baby',
      '#3b9c8f',
      'https://gilangirfan21.github.io/welcome-page/',
      'https://github.com/gilangirfan21/welcome-page',
      array['vanilla-js', 'supabase', 'keluarga'],
      'live',
      true,
      2,
      owner
    )
  on conflict (slug) do nothing;

  raise notice 'Katalog ke-seed buat user %', owner_email;
end $$;
