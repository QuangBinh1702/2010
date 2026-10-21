-- ============================================================
--  Cài đặt Supabase cho thiệp "Gửi Pé Pookie"
--  Dán toàn bộ file này vào Supabase > SQL Editor > Run.
--  (Chế độ đơn giản, không cần đăng nhập.)
-- ============================================================

-- 1) Bảng dữ liệu --------------------------------------------
create table if not exists public.config (
  id   text primary key,
  data jsonb not null default '{}'::jsonb
);

create table if not exists public.memories (
  id         uuid primary key default gen_random_uuid(),
  ord        bigint not null default 0,
  data       jsonb  not null,
  created_at timestamptz not null default now()
);

create table if not exists public.responses (
  id         uuid primary key default gen_random_uuid(),
  ord        bigint not null default 0,
  data       jsonb  not null,
  created_at timestamptz not null default now()
);

-- 2) Bật Row Level Security ----------------------------------
alter table public.config    enable row level security;
alter table public.memories  enable row level security;
alter table public.responses enable row level security;

-- 3) Policy (chế độ đơn giản: anon làm được mọi thứ cần thiết)
--    Lưu ý: anon key lộ trong trang nên đây là "đủ dùng cho quà cá nhân",
--    không phải bảo mật thật sự. Muốn chặt hơn thì dùng phương án đăng nhập.
drop policy if exists "config read"      on public.config;
drop policy if exists "config write"     on public.config;
drop policy if exists "memories read"    on public.memories;
drop policy if exists "memories write"   on public.memories;
drop policy if exists "responses read"   on public.responses;
drop policy if exists "responses insert" on public.responses;

create policy "config read"      on public.config    for select using (true);
create policy "config write"     on public.config    for all    using (true) with check (true);
create policy "memories read"    on public.memories  for select using (true);
create policy "memories write"   on public.memories  for all    using (true) with check (true);
create policy "responses read"   on public.responses for select using (true);
create policy "responses insert" on public.responses for insert with check (true);

-- 4) Realtime (để câu trả lời / ảnh hiện ngay, không cần tải lại)
alter publication supabase_realtime add table public.config;
alter publication supabase_realtime add table public.memories;
alter publication supabase_realtime add table public.responses;

-- 5) Storage: policy cho bucket ảnh tên "cards"
--    TRƯỚC khi chạy phần này: vào Storage > New bucket, đặt tên "cards",
--    bật "Public bucket". Rồi chạy 3 policy dưới.
drop policy if exists "cards read"   on storage.objects;
drop policy if exists "cards upload" on storage.objects;
drop policy if exists "cards delete" on storage.objects;

create policy "cards read"   on storage.objects for select using (bucket_id = 'cards');
create policy "cards upload" on storage.objects for insert with check (bucket_id = 'cards');
create policy "cards delete" on storage.objects for delete using (bucket_id = 'cards');
