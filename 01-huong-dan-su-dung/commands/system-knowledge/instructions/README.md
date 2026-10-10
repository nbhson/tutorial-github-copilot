# /instructions — Xem/sửa instructions của repo

> **Dành cho:** người mới onboard repo và tech lead giữ rules team · **Vấn đề:** nghi instructions không load, hoặc rule ghi sai mà model vẫn làm theo · **Đọc xong:** xem đúng rules đang áp và sửa ngay tại chỗ (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: xem nội quy lớp đang dán trên tường — sai thì sửa ngay tại chỗ. `/instructions` liệt kê rules đang áp cho repo/file hiện tại; rule không ăn thì check glob applyTo và giữ file dưới 200 dòng.

## Khi nào dùng

Section này trả lời: khi nào tra instructions, và vì sao sửa rule xong model vẫn làm theo cách cũ.

- **Cho ai:** người mới onboard (muốn biết repo có quy tắc gì) và tech lead sửa rule team.
- Nghi instructions không load.
- Muốn sửa rule team ngay.
- Onboard: xem repo có quy tắc gì.

## Cách gọi (copy-paste)

Cách gọi `/instructions` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/instructions
# liệt kê rules đang áp cho repo/file hiện tại
# Kỳ vọng: thấy đúng rules (repo-wide + applyTo khớp file)
# Verify: sửa 1 rule → /new → hỏi lại → model làm theo rule mới
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/instructions`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/instructions` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/instructions “liệt kê quy tắc đang áp cho file apps/api/login.ts”
```

**Kết quả mong đợi:** Thấy đúng rules (repo-wide + applyTo khớp file); sửa sai được ngay.

**Cách verify:** Sửa 1 rule → hỏi lại → model làm theo rule mới là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Rule không ăn | applyTo sai / file quá dài | Check glob + giữ file <200 dòng |
| Nhiều rules mâu thuẫn | Ưu tiên không rõ | Gom rule chung lên repo-wide, chi tiết xuống applyTo |
| Sửa mà model vẫn làm cũ | Chat cũ còn context | /new chat mới rồi test lại |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
