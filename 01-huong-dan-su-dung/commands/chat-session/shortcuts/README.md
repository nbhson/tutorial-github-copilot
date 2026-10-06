# Shortcuts — Phím tắt Chat trong IDE này

> Nôm na: tờ giấy dán phím tắt trên bàn — thuộc 5 phím là nhanh gấp đôi.

## Lệnh làm gì (1 câu nôm na)

Nôm na: tờ giấy dán phím tắt trên bàn — thuộc 5 phím là nhanh gấp đôi. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Muốn code không rời bàn phím.
- Phím tắt mặc định xung đột với layout máy.
- Onboard: phát cho member mới 1 tờ shortcuts.

## Cách gọi (copy-paste)

```bash
VS Code → Ctrl+K Ctrl+S → search “copilot chat”
Ctrl+I inline · Ctrl+Shift+I quick · Ctrl+Alt+I chat view · Tab nhận · Esc từ chối
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Shortcuts`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Mở Keyboard Shortcuts, search “copilot”, ghi lại 5 phím mình dùng nhất
```

**Kết quả mong đợi:** Thuộc 5 phím core; thao tác chat/inline/receive/dismiss không cần chuột.

**Cách verify:** Làm 1 task chỉ dùng phím tắt, không chạm chuột là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Phím tắt không ăn | Xung đột extension khác | Search keybinding, gán lại phím trống |
| Nhớ nhầm Ctrl+I vs Ctrl+Shift+I | Chưa phân biệt inline vs quick | Inline = sửa tại chỗ; Quick = hỏi nhanh popup |
| Máy Mac/Win khác phím | Quen 1 layout | Ghi 2 cột Mac/Win dán lên bàn |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
