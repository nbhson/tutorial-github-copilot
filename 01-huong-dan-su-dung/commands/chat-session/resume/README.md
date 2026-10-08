# /resume — Tiếp tục phiên chat đã lưu

> **Dành cho:** dev quay lại việc dở từ hôm qua hoặc sau khi IDE tắt/crash · **Vấn đề:** mất bối cảnh, phải giải thích lại từ đầu · **Đọc xong:** mở lại đúng phiên và hỏi tiếp không mất công (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: mở lại vở cũ và viết tiếp, khỏi chép lại từ đầu. Lệnh mở lại phiên chat đã lưu (hoặc đi qua `/history` khi không nhớ tên phiên). Lưu ý: history giữ text, không giữ nguyên tool state.

## Khi nào dùng

Section này trả lời: lúc nào nên mở lại phiên cũ thay vì `/new`, và cách tránh nhầm phiên.

- **Cho ai:** người làm việc theo ngày, hoặc người bị tắt IDE/crash giữa chừng.
- Việc dở hôm qua, nay làm tiếp.
- Chat bị đóng nhầm (tắt IDE, crash).
- Muốn rẽ nhánh từ 1 chat cũ thành 2 hướng.

## Cách gọi (copy-paste)

Cách gọi `/resume` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/resume
# hoặc /history → chọn phiên → tiếp tục
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/resume`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/resume` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/resume phiên “thêm rate-limit cho /api/login” hôm qua
```

**Kết quả mong đợi:** Phiên cũ mở lại đúng chỗ dừng; hỏi tiếp không cần giải thích lại từ đầu.

**Cách verify:** Nhắn “tiếp tục bước 3 hôm qua” — model làm đúng bước 3 là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Resume nhưng model quên tool state | History chỉ lưu text | Nhắc lại 3 dòng bối cảnh + file liên quan |
| Nhầm phiên cũ khác | Tên chat giống nhau | Đặt tên chat rõ + /export bản quan trọng |
| Phiên quá cũ, code đã đổi | Code trên đĩa khác lúc chat | Chạy git diff + test lại trước khi tin |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
