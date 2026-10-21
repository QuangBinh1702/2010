# Gửi Em iu

Thiệp hỏi "Em yêu anh không :3", gồm một file `index.html` duy nhất. Không cần build, mở trực tiếp bằng trình duyệt là chạy.

## Chạy thử
- Mở `index.html` bằng Chrome, Edge, Safari hoặc Firefox.
- Hoặc chạy server tĩnh: `npx serve .` rồi mở http://localhost:3000

## Lưu trữ
Trang tự chọn chế độ lưu trữ:
- **Trên claude.ai:** dùng `window.claude.use("db")` / `use("assets")` có sẵn.
- **Tự host + đã cấu hình Supabase:** lưu thật vào Supabase (xem bên dưới).
- **Chưa cấu hình gì:** chế độ xem thử — mọi thứ vẫn chạy nhưng ảnh/câu trả lời chỉ nằm trong tab, mất khi tải lại.

## Deploy lên Vercel + Supabase

### A. Tạo backend Supabase (~5 phút)
1. Tạo project miễn phí tại [supabase.com](https://supabase.com).
2. Vào **Storage → New bucket**, đặt tên `cards`, bật **Public bucket**.
3. Vào **SQL Editor**, dán toàn bộ nội dung file [`supabase-setup.sql`](./supabase-setup.sql) rồi **Run**.
4. Vào **Project Settings → API**, copy **Project URL** và **anon public key**.

### B. Điền cấu hình vào `index.html`
Mở `index.html`, tìm block `const SUPABASE = {` (gần đầu `<script>`) và điền:
```js
const SUPABASE = {
  url:     'https://xxxx.supabase.co', // Project URL
  anonKey: 'eyJ...',                   // anon public key
  editKey: 'mat-khau-bi-mat-cua-ban',  // tự đặt, dùng để mở chế độ sửa
};
```

### C. Deploy lên Vercel
- Kéo-thả thư mục này vào [vercel.com](https://vercel.com), hoặc `npx vercel`. Không cần build.
- Trong **Supabase → Authentication → URL Configuration** (hoặc API settings), không cần thêm gì cho chế độ đơn giản; nếu gặp lỗi CORS, thêm domain Vercel vào danh sách cho phép.

### D. Cách dùng 2 loại link
- **Link gửi cho pé (chỉ xem + trả lời):** `https://ten-cua-ban.vercel.app/`
- **Link của bạn (sửa ảnh/lời nhắn + xem câu trả lời):** `https://ten-cua-ban.vercel.app/?edit=mat-khau-bi-mat-cua-ban`

> ⚠️ Chế độ đơn giản này tiện nhưng **không bảo mật thật**: anon key lộ trong trang, nên người rành kỹ thuật vẫn có thể đọc/sửa dữ liệu. Đủ ổn cho một tấm thiệp cá nhân; nếu cần riêng tư/chống phá thật thì nên chuyển sang phương án có đăng nhập.

### Muốn đổi sang backend khác (Firebase…)?
Adapter Supabase nằm ở hàm `makeSupabase()` — nó chỉ giả lập đúng interface mà app dùng. Viết một hàm tương tự trả về `{ db, assets }` là thay được, không cần sửa logic app.

## Tuỳ chỉnh nhanh
Trong `<script>`, sửa các hằng sau:
- `DEFAULTS`: tên người nhận, câu hỏi, lời nhắn, danh sách chỗ đi chơi.
- `NO_TEXTS`: các câu nút "Không" đổi qua.
- `TIMES`: các khung giờ hẹn.
- `THEMES`: các theme màu. Bảng màu của từng theme nằm trong CSS, ở `:root[data-theme-name="..."]`.
