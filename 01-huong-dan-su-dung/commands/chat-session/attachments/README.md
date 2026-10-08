# Attach / #file — Gắn đúng scope vào prompt

> **Dành cho:** mọi người prompt về code, nhất là người mới · **Vấn đề:** không gắn scope thì model đoán mò, sửa sai file · **Đọc xong:** gắn đúng 1–3 file mỗi prompt, trả lời trúng hơn với ít token hơn (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: kẹp tài liệu vào câu hỏi — hỏi về file nào thì kẹp file đó vào. Dùng `#file` để chọn file, `@workspace` để hỏi cross-file, hoặc kéo-thả file/ảnh vào Chat input.

## Khi nào dùng

Section này trả lời: lúc nào bắt buộc phải đính kèm, và đính kèm bao nhiêu là đủ.

- **Cho ai:** mọi mức độ kinh nghiệm — đây là kỹ năng quan trọng nhất với người mới dùng Copilot.
- Mọi prompt về code (bắt buộc gắn scope).
- Muốn model đọc đúng file thay vì đoán.
- Đính kèm ảnh lỗi UI, log terminal.

## Cách gọi (copy-paste)

Cách gọi `Attach / #file` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
#file → chọn file
@workspace → hỏi cross-file
Kéo-thả file/ảnh vào Chat input
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Attach / #file`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `Attach / #file` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
@workspace “hàm login nằm ở file nào, ai gọi nó?” + attach #file src/auth/login.ts
```

**Kết quả mong đợi:** Model liệt kê đúng file đã đọc + trả lời trúng scope; không sửa sai file.

**Cách verify:** Bắt model “liệt kê file mày đã đọc” — khớp file bạn gắn là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Attach cả repo → chậm + tốn token | Scope quá rộng | Chỉ gắn 1–3 file liên quan nhất |
| Quên attach → model đoán mò | Tưởng model tự đọc cả repo | Luôn gắn #file hoặc @workspace |
| Attach file chứa secret | Soát không kỹ | Kiểm tra file trước khi attach/share/export |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
