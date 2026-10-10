# /feedback + /bug — Gửi feedback/bug cho GitHub

> **Dành cho:** người gặp bug lặp lại được hoặc có góp ý cho GitHub · **Vấn đề:** báo “nó dở” chung chung thì GitHub không xử lý được · **Đọc xong:** gửi bug/feedback đủ context: prompt + version + bước lặp (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: bỏ phiếu góp ý + báo hỏng hóc cho ban quản lý. `/feedback` vote tốt/xấu kèm lý do; `/bug` gửi mô tả + bước lặp + version. Soát secrets trước khi gửi.

## Khi nào dùng

Section này trả lời: khi nào nên báo, và context nào khiến bug được xử lý nhanh.

- **Cho ai:** mọi người dùng Copilot, nhất là người test tính năng mới.
- Câu trả lời hay/dở muốn vote.
- Gặp bug lặp lại được.
- Muốn GitHub cải thiện tính năng.

## Cách gọi (copy-paste)

Cách gọi `/feedback + /bug` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/feedback tốt/xấu + lý do
/bug “mô tả + bước lặp + version”
# Kỳ vọng: GitHub nhận đủ context để tái hiện bug
# Verify: nhận được confirm/tham chiếu issue
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/feedback + /bug`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/feedback + /bug` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/bug “/tests sinh sai import. Lặp: bôi đen hàm X → /tests. Version: ext 1.2.3, VS Code 1.8x”
```

**Kết quả mong đợi:** Feedback/bug có đủ context (prompt + version + bước lặp); GitHub nhận được.

**Cách verify:** Nhận được confirm/tham chiếu issue là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Báo “nó dở” chung chung | Thiếu bước lặp | Kèm prompt + file + version + ảnh/log |
| Báo nhầm do scope mình sai | Chưa check scope | Gọn scope + thử lại trước khi báo |
| Gửi feedback có secrets | Paste log chứa token | Soát secrets trước khi gửi |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
