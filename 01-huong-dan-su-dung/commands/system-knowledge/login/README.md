# /login — Đăng nhập GitHub cho Copilot

> **Dành cho:** người mới cài, đổi máy hoặc đổi account · **Vấn đề:** token hết hạn làm Copilot im lặng, không gợi ý gì · **Đọc xong:** login đúng account và tự verify bằng `/status` (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: xuất trình thẻ nhân viên để vào tòa nhà. `/login` → làm theo popup GitHub → verify bằng `/status`; có 2 account thì logout trước rồi login lại đúng account cần dùng.

## Khi nào dùng

Section này trả lời: khi nào cần login lại, và vì sao login xong vẫn chưa có gợi ý.

- **Cho ai:** người mới cài, người đổi máy/account, người debug “Copilot không chạy”.
- Mới cài / đổi máy.
- Token hết hạn, Copilot silent fail.
- Đổi account cá nhân ↔ công ty.

## Cách gọi (copy-paste)

Cách gọi `/login` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/login
# làm theo popup GitHub → verify bằng /status
# Kỳ vọng: /status hiện đúng login + plan, gợi ý chạy lại
# Verify: gõ thử 1 hàm thấy gợi ý
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/login`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/login` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/login → sign-in GitHub → /status thấy account đúng → gõ thử 1 hàm thấy gợi ý
```

**Kết quả mong đợi:** Login đúng account; /status hiện đúng login + plan; gợi ý chạy.

**Cách verify:** Gợi ý + chat đều chạy sau login là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Login nhầm account | 2 GitHub accounts | /logout rồi /login lại đúng account |
| Popup bị chặn | Browser/proxy chặn | Mở browser mặc định, tắt chặn popup tạm |
| Login xong vẫn không gợi ý | Chưa có seat / exclusion | Check seat + exclusion + /status |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
