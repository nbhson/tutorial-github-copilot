# Shortcuts — Phím tắt Chat trong IDE này

> **Dành cho:** dev muốn code không rời bàn phím · **Vấn đề:** phím mặc định xung đột, hoặc nhớ nhầm Ctrl+I với Ctrl+Shift+I · **Đọc xong:** thuộc 5 phím cốt lõi của Chat và gỡ được xung đột (~2 phút)

## 1 câu nôm na

Tờ giấy dán phím tắt trên bàn — thuộc 5 phím là nhanh gấp đôi. Mở Keyboard Shortcuts (`Ctrl+K Ctrl+S`), search "copilot chat", rồi ghi lại 5 phím bạn dùng nhiều nhất.

Đây không phải một lệnh đơn lẻ mà là "bản đồ phím" của cả nhóm Chat — bỏ chuột ra là mạch làm việc không bị ngắt.

## Vì sao nắm Shortcuts?

Chuyển tay từ bàn phím sang chuột rồi về bàn phím tốn thời gian và phá mạch. Nắm phím của Chat giúp:

- **Nhanh hơn** — mở đúng chế độ chat bằng một tổ hợp phím.
- **Không nhớ nhầm** — phân biệt rõ inline / quick / chat view.
- **Tự gỡ xung đột** — biết chỗ sửa khi phím không ăn.

**Nếu làm sai thì sao?** Hai nhầm lẫn phổ biến: (1) đổi lẫn `Ctrl+I` (inline) với `Ctrl+Shift+I` (quick) — sai chế độ; (2) gặp xung đột phím lại tưởng extension lỗi. Xem ❌/✅ và bảng phím.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** muốn code không rời bàn phím; phím mặc định xung đột với layout máy; onboard và phát cho thành viên mới một tờ shortcuts.
- **ĐỪNG dùng khi:** bạn đang cần gỡ lỗi *nội dung* câu trả lời — vấn đề phím chỉ là chuyện gán tổ hợp.
- **Cho ai:** mọi người dùng Chat hằng ngày; tech lead phát cho member mới một tờ khi onboard.

> Chọn nhanh cách gọi Chat bằng phím:

| Phím | Mở ra | Khi nào dùng |
|---|---|---|
| `Ctrl+I` | Inline chat tại dòng code | Sửa 5–20 dòng ngay chỗ đang đọc |
| `Ctrl+Shift+I` | Quick chat (popup) | Hỏi nhanh 30 giây, không cần lưu lịch sử |
| `Ctrl+Alt+I` | Chat view đầy đủ | Việc dài, cần context + tool ngoài |

## Cách gọi (copy-paste)

```bash
VS Code → Ctrl+K Ctrl+S → search "copilot chat"
Ctrl+I inline · Ctrl+Shift+I quick · Ctrl+Alt+I chat view · Tab nhận · Esc từ chối
# Kỳ vọng: đủ danh sách phím, chỉ gán lại cái xung đột
```

> Phím không ăn? Trong Keyboard Shortcuts, gõ tên lệnh (ví dụ "inline chat") để xem tổ hợp hiện tại và gán lại phím trống.

## Ví dụ thật

Nghiệp vụ: máy bạn dùng layout có sẵn phím tắt của extension khác chiếm `Ctrl+Shift+I`, nên quick chat không mở. Bạn cần gỡ xung đột và in ra 5 phím core.

```bash
# Ctrl+K Ctrl+S -> search "quick chat"
# Thay Ctrl+Shift+I bang to hop khac (vd Ctrl+Shift+Q)
# Verify: lam 1 task chi dung phim, khong cham chuot
```

**Kết quả mong đợi:** Thuộc 5 phím core; thao tác chat/inline/receive/dismiss không cần chuột.

**✅ Verify:** Làm 1 task chỉ dùng phím tắt, không chạm chuột là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — nhớ nhầm `Ctrl+I` và `Ctrl+Shift+I`, hoặc thấy xung đột là bỏ cuộc:**

```bash
Ctrl+I   # dinh mo quick chat nhung lai ra inline -> sai che do
# hoac: thay phim khong an roi ket luan "extension loi"
```

**✅ ĐÚNG — phân biệt rõ ba phím, và xử lý xung đột ngay trong Keyboard Shortcuts:**

```bash
# Inline = sua tai cho (Ctrl+I)
# Quick  = hoi nhanh popup (Ctrl+Shift+I)
# View   = chat day du (Ctrl+Alt+I)
# Xung dot -> Ctrl+K Ctrl+S -> gan lai phim trong
```

**Bài học:** Ba phím na ná nhau nhưng ba chế độ khác hẳn. Gán rõ ràng và dán lên bàn để không nhầm.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Phím tắt không ăn | Xung đột extension khác | Search keybinding, gán lại phím trống |
| Nhớ nhầm `Ctrl+I` vs `Ctrl+Shift+I` | Chưa phân biệt inline vs quick | Inline = sửa tại chỗ; Quick = hỏi nhanh popup |
| Máy Mac/Win khác phím | Quen 1 layout | Ghi 2 cột Mac/Win dán lên bàn |

## So sánh với Claude Code

| Việc | Copilot (`Shortcuts`) | Claude Code | Ghi chú |
|---|---|---|---|
| Phím mở chat trong editor | `Ctrl+I` / `Ctrl+Shift+I` / `Ctrl+Alt+I` | Không áp dụng — terminal-first | Copilot có lớp phím tắt trong IDE |
| Gỡ xung đột phím | `Ctrl+K Ctrl+S` gán lại | Cấu hình keybind của terminal/shell | Cơ chế khác nhau do nền tảng khác |
| Nhận / từ chối gợi ý | `Tab` nhận, `Esc` từ chối | Duyệt diff trong terminal/IDE | Cùng tinh thần: duyệt trước khi nhận |

## Best practices (kèm "vì sao")

- **Ghi ra 5 phím bạn dùng nhiều nhất rồi dán gần màn hình.** *Vì sao?* Phím chỉ nhanh khi thành phản xạ, không phải khi bạn còn phải nhớ.
- **Phân biệt rõ ba chế độ trước khi học thêm phím.** *Vì sao?* Nhầm inline với quick dẫn tới sai chế độ, mất thời gian hơn là tiết kiệm.
- **Gỡ xung đột ngay, đừng chịu đựng.** *Vì sao?* Một phím bị chiếm sẽ âm thầm làm bạn bỏ thói quen dùng phím.
- **Ghi hai cột Mac/Win khi làm việc đa máy.** *Vì sao?* Tổ hợp khác nhau (Ctrl vs Cmd); dán hai cột tránh nhớ lẫn.

## Bài tập nhỏ

1. **(3 phút)** Mở Keyboard Shortcuts search "copilot chat", ghi ra 5 phím bạn sẽ dùng.
2. **(5 phút)** Làm một task nhỏ chỉ bằng phím (mở inline, sửa, Accept, đóng) — không chạm chuột.
3. **(5 phút)** Tìm một phím đang bị xung đột trên máy bạn và gán lại thành tổ hợp không đụng ai.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Inline chat: [../inline-chat/README.md](../inline-chat/README.md). Quick chat: [../quick-chat/README.md](../quick-chat/README.md).

> Phím tắt là khoản đầu tư nhỏ lãi dài: học một lần, tiết kiệm vài giây mỗi lần — nhân lên cả ngày làm việc.
