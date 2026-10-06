# gh copilot explain — Giải thích lệnh CLI vừa gặp

> Nôm na: phiên dịch biển báo — thấy lệnh lạ thì hỏi “biển này nghĩa gì?”.

## Lệnh làm gì (1 câu nôm na)

Nôm na: phiên dịch biển báo — thấy lệnh lạ thì hỏi “biển này nghĩa gì?”. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Gặp lệnh lạ trong docs/script của người khác.
- Trước khi chạy lệnh nguy hiểm copy trên mạng.
- Học flag mới.

## Cách gọi (copy-paste)

```bash
gh copilot explain "docker run -p 5432:5432 postgres"
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `gh copilot explain`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
gh copilot explain “find . -type f -name \"*.log\" -delete” (hỏi trước khi chạy!)
```

**Kết quả mong đợi:** Hiểu từng flag + rủi ro (lệnh này xóa file!); quyết chạy/không có cơ sở.

**Cách verify:** Nói lại được “lệnh này làm gì + rủi ro gì” là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Hỏi sau khi chạy | Sai thứ tự | explain TRƯỚC, chạy SAU |
| Lệnh quá dài vẫn chạy mù | Lười đọc | Bắt giải thích từng flag + thử trên copy/thư mục test |
| Copy lệnh mạng về chạy | Không verify | explain + search docs chính thức trước |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
