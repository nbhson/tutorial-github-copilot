# Shortcuts — Phím tắt Chat trong IDE này

> **Dành cho:** dev muốn code không rời bàn phím · **Vấn đề:** phím mặc định xung đột, hoặc nhớ nhầm Ctrl+I với Ctrl+Shift+I · **Đọc xong:** thuộc 5 phím cốt lõi của Chat và gỡ được xung đột (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: tờ giấy dán phím tắt trên bàn — thuộc 5 phím là nhanh gấp đôi. Mở Keyboard Shortcuts (Ctrl+K Ctrl+S) search “copilot chat” rồi ghi lại 5 phím bạn dùng nhất.

## Khi nào dùng

Section này trả lời: cần thuộc phím nào, và xử lý thế nào khi phím tắt không ăn.

- **Cho ai:** mọi người dùng Chat hằng ngày; tech lead phát cho member mới 1 tờ khi onboard.
- Muốn code không rời bàn phím.
- Phím tắt mặc định xung đột với layout máy.
- Onboard: phát cho member mới 1 tờ shortcuts.

## Cách gọi (copy-paste)

Cách gọi `Shortcuts` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
VS Code → Ctrl+K Ctrl+S → search “copilot chat”
Ctrl+I inline · Ctrl+Shift+I quick · Ctrl+Alt+I chat view · Tab nhận · Esc từ chối
# Kỳ vọng: đủ danh sách phím, chỉ gán lại cái xung đột
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Shortcuts`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `Shortcuts` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Mở Keyboard Shortcuts, search “copilot”, ghi lại 5 phím mình dùng nhất
# Verify: làm 1 task chỉ dùng phím, không chạm chuột
```

**Kết quả mong đợi:** Thuộc 5 phím core; thao tác chat/inline/receive/dismiss không cần chuột.

**Cách verify:** Làm 1 task chỉ dùng phím tắt, không chạm chuột là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Phím tắt không ăn | Xung đột extension khác | Search keybinding, gán lại phím trống |
| Nhớ nhầm Ctrl+I vs Ctrl+Shift+I | Chưa phân biệt inline vs quick | Inline = sửa tại chỗ; Quick = hỏi nhanh popup |
| Máy Mac/Win khác phím | Quen 1 layout | Ghi 2 cột Mac/Win dán lên bàn |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
