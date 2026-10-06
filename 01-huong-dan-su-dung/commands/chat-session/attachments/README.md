# Attach / #file — Gắn đúng scope vào prompt

> Nôm na: kẹp tài liệu vào câu hỏi — hỏi về file nào thì kẹp file đó vào.

## Lệnh làm gì (1 câu nôm na)

Nôm na: kẹp tài liệu vào câu hỏi — hỏi về file nào thì kẹp file đó vào. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Mọi prompt về code (bắt buộc gắn scope).
- Muốn model đọc đúng file thay vì đoán.
- Đính kèm ảnh lỗi UI, log terminal.

## Cách gọi (copy-paste)

```bash
#file → chọn file
@workspace → hỏi cross-file
Kéo-thả file/ảnh vào Chat input
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Attach / #file`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
@workspace “hàm login nằm ở file nào, ai gọi nó?” + attach #file src/auth/login.ts
```

**Kết quả mong đợi:** Model liệt kê đúng file đã đọc + trả lời trúng scope; không sửa sai file.

**Cách verify:** Bắt model “liệt kê file mày đã đọc” — khớp file bạn gắn là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Attach cả repo → chậm + tốn token | Scope quá rộng | Chỉ gắn 1–3 file liên quan nhất |
| Quên attach → model đoán mò | Tưởng model tự đọc cả repo | Luôn gắn #file hoặc @workspace |
| Attach file chứa secret | Soát không kỹ | Kiểm tra file trước khi attach/share/export |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
