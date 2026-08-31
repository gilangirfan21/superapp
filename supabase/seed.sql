-- Isi katalog awal. Jalanin SETELAH 0001_hub_init.sql, dan setelah lo
-- sign up sekali -- owner_id ngambil auth.uid(), jadi harus dijalanin
-- sambil login (SQL Editor: pakai "Run as" akun lo), atau ganti
-- auth.uid() di bawah dengan UUID user lo.

insert into public.apps
  (slug, name, description, icon, color, url, repo_url, tags, status, is_public, sort_order, owner_id)
values
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
    auth.uid()
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
    auth.uid()
  ),
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
    auth.uid()
  )
on conflict (slug) do nothing;
