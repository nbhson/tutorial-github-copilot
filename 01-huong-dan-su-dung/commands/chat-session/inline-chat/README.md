# Ctrl+I (inline chat) — Hỏi/sửa ngay tại dòng code

> **Dành cho:** dev sửa đoạn nhỏ ngay tại dòng code · **Vấn đề:** mở Chat view riêng làm đứt mạch đọc code · **Đọc xong:** sửa 5–20 dòng tại chỗ, Accept từng hunk, không rời editor (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: thì thầm hỏi ngay bên cạnh dòng code, khỏi mở cửa sổ chat riêng. Bôi đen code → Ctrl+I (Win/Linux) / Cmd+I (Mac) → nhập yêu cầu, diff hiện ngay tại chỗ.

## Khi nào dùng

Section này trả lời: khi nào sửa tại chỗ là đủ, khi nào nên mở hẳn Chat view.

- **Cho ai:** dev đang đọc/sửa code lẻ, muốn giữ mạch suy nghĩ không chuyển tab.
- Sửa 1 đoạn nhỏ 5–20 dòng ngay tại chỗ.
- Đang đọc code, muốn hỏi nhanh về đoạn đó.
- Muốn giữ dòng suy nghĩ, không muốn chuyển tab.

## Cách gọi (copy-paste)

Cách gọi `Ctrl+I (inline chat)` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Bôi đen code → Ctrl+I (Win/Linux) / Cmd+I (Mac)
Nhập: thêm null check, giữ nguyên API
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Ctrl+I (inline chat)`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `Ctrl+I (inline chat)` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen hàm login) Ctrl+I → “thêm null check cho params, giữ nguyên API shape”
```

**Kết quả mong đợi:** Diff hiện ngay tại chỗ; Accept từng hunk hoặc Discard; code chạy tiếp không gián đoạn.

**Cách verify:** Chạy test focused cho hàm vừa sửa — xanh là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Bấm Ctrl+I không hiện gì | Chưa bôi đen / extension chưa active | Bôi đen code trước; check Copilot status bar |
| Sửa lan sang chỗ khác | Scope inline vẫn ăn cả file | Bôi hẹp lại + ghi rõ “chỉ sửa đoạn đã chọn” |
| Diff khó đọc | Change quá to 1 lần | Chia nhỏ: mỗi Ctrl+I 1 việc |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
