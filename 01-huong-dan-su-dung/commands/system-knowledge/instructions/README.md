# /instructions — Xem/sửa instructions của repo

> Nôm na: xem nội quy lớp đang dán trên tường — sai thì sửa ngay tại chỗ.

## Lệnh làm gì (1 câu nôm na)

Nôm na: xem nội quy lớp đang dán trên tường — sai thì sửa ngay tại chỗ. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Nghi instructions không load.
- Muốn sửa rule team ngay.
- Onboard: xem repo có quy tắc gì.

## Cách gọi (copy-paste)

```bash
/instructions
# liệt kê rules đang áp cho repo/file hiện tại
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/instructions`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/instructions “liệt kê quy tắc đang áp cho file apps/api/login.ts”
```

**Kết quả mong đợi:** Thấy đúng rules (repo-wide + applyTo khớp file); sửa sai được ngay.

**Cách verify:** Sửa 1 rule → hỏi lại → model làm theo rule mới là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Rule không ăn | applyTo sai / file quá dài | Check glob + giữ file <200 dòng |
| Nhiều rules mâu thuẫn | Ưu tiên không rõ | Gom rule chung lên repo-wide, chi tiết xuống applyTo |
| Sửa mà model vẫn làm cũ | Chat cũ còn context | /new chat mới rồi test lại |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
