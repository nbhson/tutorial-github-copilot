# Shortcuts — Phím tắt Chat trong VS Code

> **Dành cho:** người muốn rời chuột khi làm việc với Copilot · **Vấn đề:** các phím ❌ `Shift+Alt+I`, `Ctrl+Shift+I` "truyền miệng" không còn trong docs — bấm thấy Copilot "liệt" · **Đọc xong:** thuộc 6 tổ hợp phím docs ghi nhận và xử lý được xung đột phím (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code keybinding (lệnh chat / inline / quickchat)

## 1 câu nôm na

Phím tắt chat là **6 dòng trong bảng docs**, không phải bí kíp lan truyền. Ba ô bị nhầm nhiều nhất: `Ctrl+I` = inline chat (không phải "quick chat"), `Ctrl+Shift+Alt+L` = Quick Chat, `Ctrl+Alt+I` = mở Chat view.

## Vì sao dùng phím tắt?

Hỏi Copilot là thao tác lặp hàng chục lần mỗi ngày: mở chat, hỏi nhanh, nhận/bỏ gợi ý. Mỗi lần rời bàn phím để tìm chuột là một lần gãy dòng suy nghĩ. Bảng 6 phím dưới phủ đúng các hành động lặp lại đó; việc lác đác thì Command Palette (`Ctrl+Shift+P`, macOS `⇧⌘P`) lo, không cần học thêm phím.

**Nếu làm sai thì sao?** Tin phím sai rồi kết luận "Copilot không phản hồi": ví dụ bấm `Ctrl+I` mong hộp hỏi nhanh nhưng lại nhảy vào inline chat ngay giữa đoạn code đang tô đậm. Cách soi: Command Palette gõ tên lệnh — lệnh có tồn tại thì phím chỉ là vấn đề keybinding.

> **Tóm gọn 1 câu:** Thứ bạn cần thuộc đúng bằng kích thước bảng docs — mọi "phím tắt Copilot" nằm ngoài bảng đó đều là đồ cũ hoặc bịa.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** hỏi nhanh không đổi layout (`Ctrl+Shift+Alt+L`), sửa tại chỗ một đoạn code (`Ctrl+I`), bắt đầu task mới (`Ctrl+N`).
- **ĐỪNG dùng khi:** hành động chưa có phím trong docs — gọi Command Palette theo tên lệnh, đừng tự chế rồi đi dạy lại người khác.
- **Cho ai:** người dùng Chat view/inline chat hằng ngày; bài chi tiết hơn cho từng phím: [Quick Chat](../quick-chat/README.md) · [Inline chat](../inline-chat/README.md).

## Bảng phím (docs cheat-sheet)

| Hành động | Windows/Linux | macOS | Lệnh |
|---|---|---|---|
| Mở Chat view | `Ctrl+Alt+I` | `⌃⌘I` | `workbench.action.chat.open` |
| Chat mới | `Ctrl+N` | `⌘N` | `workbench.action.chat.newChat` |
| Inline chat trong editor | `Ctrl+I` | `⌘I` | `inlineChat.start` |
| Inline chat trong terminal | `Ctrl+I` | `⌘I` | `workbench.action.terminal.chat.start` |
| Quick Chat | `Ctrl+Shift+Alt+L` | `⇧⌥⌘L` | `workbench.action.quickchat.toggle` |
| Nhận / bỏ gợi ý code | `Tab` / `Esc` | `Tab` / `Esc` | — |

## Cách đổi phím (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> `Ctrl+K Ctrl+S` mở Keyboard Shortcuts → tìm "chat" → đổi tổ hợp bị chiếm. Docs không "cấm" đổi phím — nhưng đổi xong hãy ghi chú lại, đừng dạy người khác phím của bạn.

## Ví dụ thật (lấy đúng nghiệp vụ của lệnh này)

Extension khác chiếm mất `Ctrl+Shift+Alt+L`: Quick Chat không mở, bạn đang phải mò chuột mỗi lần hỏi.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** một tổ hợp phím của riêng bạn cho Quick Chat, các lệnh chat khác giữ nguyên.
**✅ Verify:** chạy một đoạn việc nhỏ chỉ bằng phím, không chạm chuột từ mở Quick Chat đến `Esc`.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — dùng phím theo "truyền miệng", đụng đâu bấm đó:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — mỗi phím gắn đúng một hành động trong bảng docs:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** phím sai lệnh còn tai hại hơn không phím — bạn mất 10 phút debug một tính năng vốn hoạt động bình thường.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Bấm ❌ `Shift+Alt+I` / `Ctrl+Shift+I` không ra gì | Hai tổ hợp này không còn được docs ghi nhận cho chat | Dùng đúng 6 phím ở bảng trên |
| `Ctrl+Alt+I` mở ra thứ khác | Phím bị extension khác chiếm (keybinding when clause) | `Ctrl+K Ctrl+S` → tìm "chat" → gán lại (macOS đối chiếu cột ⇧⌥⌘L của bảng docs) |

## So sánh với Claude Code

| Việc | Copilot in VS Code (phím) | Claude Code (CLI) | Ghi chú |
|---|---|---|---|
| Bỏ qua/đóng | `Esc` | `Esc` ngắt lượt đang chạy | Cùng tinh thần "đỡ tay khỏi Enter" |
| Đổi lượt/phiên mới | `Ctrl+N` | `/clear` (xóa context) | Copilot: phím; Claude: slash |
| Switch mode | Không có phím docs ghi nhận | `Shift+Tab` | Đừng lẫn CLI key vào VS Code |

## Best practices (kèm "vì sao")

- **Học 6 phím trước, mọi thứ sau.** *Vì sao?* Đó là các hành động bạn lặp mỗi ngày; ngoài nó, Command Palette đã nhanh đủ.
- **Đổi phím thì ghi chú vào README cá nhân.** *Vì sao?* Keybinding là việc local — screenshot/README của bạn nói phím chuẩn docs, người khác áp theo phím bạn chế sẽ loạn.

## Bài tập nhỏ

1. **(3 phút)** Mở Keyboard Shortcuts (`Ctrl+K Ctrl+S`), tìm "chat": đếm số lệnh docs liệt kê và xác nhận `workbench.action.quickchat.toggle` có mặt.
2. **(2 phút)** Thực hiện 1 vòng đầy đủ không chuột: `Ctrl+Alt+I` → `Ctrl+N` → `Ctrl+Shift+Alt+L` → hỏi → `Esc`.
3. **(3 phút)** Test lại "mẹo phím" bạn học ở ngoài: Palette gõ tên lệnh tương ứng; không có → cắt khỏi sổ tay.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Docs: [AI features cheat sheet (keybindings)](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [Keybindings](https://code.visualstudio.com/docs/editing/codebasics#_keybindings)
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md). Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Phím nào làm gì chi tiết: [../quick-chat/README.md](../quick-chat/README.md) · [../inline-chat/README.md](../inline-chat/README.md).

> Phím tắt là hợp đồng giữa bạn và editor — chỉ có hiệu lực khi cả hai đọc cùng một bảng.
