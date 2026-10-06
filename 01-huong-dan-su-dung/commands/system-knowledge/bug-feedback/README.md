# /feedback + /bug — Gửi feedback/bug cho GitHub

> Nôm na: bỏ phiếu góp ý + báo hỏng hóc cho ban quản lý.

## Lệnh làm gì (1 câu nôm na)

Nôm na: bỏ phiếu góp ý + báo hỏng hóc cho ban quản lý. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Câu trả lời hay/dở muốn vote.
- Gặp bug lặp lại được.
- Muốn GitHub cải thiện tính năng.

## Cách gọi (copy-paste)

```bash
/feedback tốt/xấu + lý do
/bug “mô tả + bước lặp + version”
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/feedback + /bug`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/bug “/tests sinh sai import. Lặp: bôi đen hàm X → /tests. Version: ext 1.2.3, VS Code 1.8x”
```

**Kết quả mong đợi:** Feedback/bug có đủ context (prompt + version + bước lặp); GitHub nhận được.

**Cách verify:** Nhận được confirm/tham chiếu issue là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Báo “nó dở” chung chung | Thiếu bước lặp | Kèm prompt + file + version + ảnh/log |
| Báo nhầm do scope mình sai | Chưa check scope | Gọn scope + thử lại trước khi báo |
| Gửi feedback có secrets | Paste log chứa token | Soát secrets trước khi gửi |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
