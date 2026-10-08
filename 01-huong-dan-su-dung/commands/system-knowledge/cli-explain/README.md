# gh copilot explain — Giải thích lệnh CLI vừa gặp

> **Dành cho:** người gặp lệnh lạ trong docs/script của người khác · **Vấn đề:** copy lệnh mạng về chạy mù, rủi ro xóa/force · **Đọc xong:** hiểu từng flag + rủi ro trước khi bấm Enter (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: phiên dịch biển báo — thấy lệnh lạ thì hỏi “biển này nghĩa gì?”. `gh copilot explain “...”` — explain TRƯỚC, chạy SAU; lệnh dài thì đòi giải thích từng flag.

## Khi nào dùng

Section này trả lời: lúc nào phải dịch biển báo, và vì sao thứ tự explain/run không được đảo.

- **Cho ai:** mọi người copy lệnh từ mạng/docs, đặc biệt lệnh destructive.
- Gặp lệnh lạ trong docs/script của người khác.
- Trước khi chạy lệnh nguy hiểm copy trên mạng.
- Học flag mới.

## Cách gọi (copy-paste)

Cách gọi `gh copilot explain` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
gh copilot explain "docker run -p 5432:5432 postgres"
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `gh copilot explain`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `gh copilot explain` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
gh copilot explain “find . -type f -name \"*.log\" -delete” (hỏi trước khi chạy!)
```

**Kết quả mong đợi:** Hiểu từng flag + rủi ro (lệnh này xóa file!); quyết chạy/không có cơ sở.

**Cách verify:** Nói lại được “lệnh này làm gì + rủi ro gì” là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Hỏi sau khi chạy | Sai thứ tự | explain TRƯỚC, chạy SAU |
| Lệnh quá dài vẫn chạy mù | Lười đọc | Bắt giải thích từng flag + thử trên copy/thư mục test |
| Copy lệnh mạng về chạy | Không verify | explain + search docs chính thức trước |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
