# Ctrl+I (inline chat) — Hỏi/sửa ngay tại dòng code

> Nôm na: thì thầm hỏi ngay bên cạnh dòng code, khỏi mở cửa sổ chat riêng.

## Lệnh làm gì (1 câu nôm na)

Nôm na: thì thầm hỏi ngay bên cạnh dòng code, khỏi mở cửa sổ chat riêng. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Sửa 1 đoạn nhỏ 5–20 dòng ngay tại chỗ.
- Đang đọc code, muốn hỏi nhanh về đoạn đó.
- Muốn giữ dòng suy nghĩ, không muốn chuyển tab.

## Cách gọi (copy-paste)

```bash
Bôi đen code → Ctrl+I (Win/Linux) / Cmd+I (Mac)
Nhập: thêm null check, giữ nguyên API
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Ctrl+I (inline chat)`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen hàm login) Ctrl+I → “thêm null check cho params, giữ nguyên API shape”
```

**Kết quả mong đợi:** Diff hiện ngay tại chỗ; Accept từng hunk hoặc Discard; code chạy tiếp không gián đoạn.

**Cách verify:** Chạy test focused cho hàm vừa sửa — xanh là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Bấm Ctrl+I không hiện gì | Chưa bôi đen / extension chưa active | Bôi đen code trước; check Copilot status bar |
| Sửa lan sang chỗ khác | Scope inline vẫn ăn cả file | Bôi hẹp lại + ghi rõ “chỉ sửa đoạn đã chọn” |
| Diff khó đọc | Change quá to 1 lần | Chia nhỏ: mỗi Ctrl+I 1 việc |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
