# Ctrl+I (inline chat) — Hỏi/sửa ngay tại dòng code

> **Dành cho:** dev sửa đoạn nhỏ ngay tại dòng code · **Vấn đề:** mở Chat view riêng làm đứt mạch đọc code · **Đọc xong:** sửa 5–20 dòng tại chỗ, Accept từng hunk, không rời editor (~2 phút)
> **Harness:** Copilot · **Surface:** editor inline chat & terminal inline chat (phím `Ctrl+I` / macOS `⌘I`)

## 1 câu nôm na

Thì thầm hỏi ngay bên cạnh dòng code, khỏi mở cửa sổ chat riêng. Bạn bôi đen code → `Ctrl+I` (macOS `⌘I`) → nhập yêu cầu → diff hiện ngay tại chỗ để Keep/Undo. Cùng tổ hợp phím đó trong terminal mở **terminal inline chat** — hỏi về shell command, rồi Run (`Ctrl+Enter`) hoặc Insert (`Alt+Enter`).

Khác với mở Chat view: inline chat giữ bạn **trong editor**, không nhảy tab, nên mạch đọc code không bị cắt.

## Vì sao dùng Ctrl+I?

Phần lớn thao tác sửa code hằng ngày rất nhỏ: thêm một null check, đổi tên biến, bọc một `try/catch`. Mở hẳn Chat view cho những việc này là thừa. Inline chat gọn hơn vì:

- **Không rời editor** — diff ngay tại dòng đang đứng.
- **Scope tự nhiên là selection** — bạn bôi đen cái gì thì nó sửa cái đó.
- **Duyệt từng hunk** — Keep/Undo tại chỗ, kiểm soát chặt.

**Nếu làm sai thì sao?** Hai lỗi hay gặp: (1) chưa bôi đen đã bấm nên không thấy gì; (2) yêu cầu quá to trong một lần khiến diff khó đọc. Cũng có trường hợp scope inline vẫn "ăn" ra ngoài vùng chọn nếu bạn không nói rõ. Xem ❌/✅.

> **Tóm gọn 1 câu:** `Ctrl+I` là thì thầm ngay bên dòng code — bôi hẹp, một việc một lần, diff nhỏ thì review chắc tay.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** sửa một đoạn nhỏ 5–20 dòng ngay tại chỗ; đang đọc code và muốn hỏi nhanh về đoạn đó; muốn giữ dòng suy nghĩ, không chuyển tab.
- **ĐỪNG dùng khi:** việc cần context nhiều file hoặc tool ngoài — mở Chat view (Agent mode) sẽ phù hợp hơn.
- **Cho ai:** dev đang đọc/sửa code lẻ, muốn giữ mạch suy nghĩ không chuyển tab.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Hai cài đặt đáng biết (docs): `inlineChat.askInChat` — file thuộc phiên chat đang mở thì `Ctrl+I` sẽ dẫn vào "Ask in Chat" của Chat view thay vì inline thường; set `false` nếu muốn luôn inline. `inlineChat.defaultModel` — model mặc định cho editor inline chat.

## Ví dụ thật

Nghiệp vụ: trong `src/utils/parse.ts`, hàm `parseConfig()` đọc `process.env.CONFIG` có thể `undefined` và ném lỗi khó hiểu. Bạn muốn chặn sớm ngay tại chỗ.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** Diff hiện ngay tại chỗ; Keep/Undo từng hunk; code chạy tiếp không gián đoạn.

**✅ Verify:** Chạy test focused cho hàm vừa sửa — xanh là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — bấm Ctrl+I khi chưa bôi đen, hoặc gom quá nhiều việc vào một lần:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — bôi hẹp đúng đoạn, nói rõ "chỉ sửa đoạn đã chọn":**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** Mỗi lần `Ctrl+I` một việc, bôi hẹp. Diff nhỏ thì review dễ và chính xác.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Bấm `Ctrl+I` không hiện gì | Chưa bôi đen / extension chưa active | Bôi đen code trước; check Copilot status bar |
| Bấm `Ctrl+I` lại nhảy sang Chat view | File thuộc phiên chat đang mở (`inlineChat.askInChat=true`) | Gõ tiếp trong "Ask in Chat", hoặc set `false` để luôn inline |
| Diff khó đọc | Change quá to một lần | Chia nhỏ: mỗi `Ctrl+I` một việc |

## So sánh với Claude Code

| Việc | Copilot (`Ctrl+I`) | Claude Code | Ghi chú |
|---|---|---|---|
| Sửa tại chỗ trong editor | Inline chat ngay dòng code | Không có tương đương trực tiếp (terminal-first) | Copilot mạnh ở lớp editor |
| Hỏi trong terminal | Terminal inline chat, cùng `Ctrl+I` | Chính Claude Code sống trong terminal | Hai hướng ngược nhau của cùng một phím |
| Duyệt diff tại chỗ | Keep/Undo từng hunk | Duyệt diff trong terminal/IDE | Đều bắt bạn review trước khi nhận |

## Best practices (kèm "vì sao")

- **Bôi đen trước, luôn luôn.** *Vì sao?* Selection là scope — không bôi thì hoặc không có gì, hoặc model tự đoán rộng.
- **Một việc mỗi lần `Ctrl+I`.** *Vì sao?* Diff nhỏ dễ review; gom nhiều việc làm diff rối và dễ Keep nhầm.
- **Terminal: luôn đọc command trước khi bấm Run.** *Vì sao?* Run là thực thi thật; Alt+Enter chèn để sửa tay thì an toàn hơn.
- **Sửa xong chạy test focused.** *Vì sao?* Inline chỉ sinh diff; tính đúng do test quyết định.

## Bài tập nhỏ

1. **(3 phút)** Bôi đen một hàm nhỏ, `Ctrl+I` sửa một chỗ (ví dụ thêm guard), Keep và quan sát diff nhỏ cỡ nào.
2. **(5 phút)** Mở terminal inline chat bằng `Ctrl+I`, hỏi "lệnh nào liệt kê 5 file lớn nhất thư mục src" — so kết quả Run với Insert rồi sửa tay.
3. **(5 phút)** Gọi `Ctrl+I` mà không bôi đen, xem phản ứng; rút ra thói quen bôi trước.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Docs: [Inline chat and Quick Chat](https://code.visualstudio.com/docs/chat/inline-chat) · [AI settings reference](https://code.visualstudio.com/docs/agents/reference/ai-settings)
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md). Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Hỏi nhanh không cần sửa: [../quick-chat/README.md](../quick-chat/README.md). Liệt kê lệnh+agent trong Chat view: [help](../../../local/chat-session/help/README.md).

> Inline chat là công cụ của những thay đổi nhỏ: càng bôi hẹp và càng nói rõ "giữ nguyên", diff của bạn càng sạch.
