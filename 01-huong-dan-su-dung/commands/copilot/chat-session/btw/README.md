# /btw — Hỏi thêm một câu phụ mà không phá mạch task chính

> **Dành cho:** người đang giữa một task agent, chợt có câu hỏi bên lề không muốn đánh mất ngữ cảnh đang có · **Vấn đề:** hỏi thêm câu phụ làm loãng hội thoại, hoặc mở chat mới thì mất ngữ cảnh · **Đọc xong:** hỏi side question gọn, task chính vẫn nguyên vẹn (~2 phút)
> **Harness:** Copilot · **Surface:** side chat từ Chat view — `/btw <câu hỏi>` mở một cửa sổ chat phụ; docs ghi rõ **không có ở Local** và Codex-extension

## 1 câu nôm na

Có một góc bàn nhỏ để hỏi "mà này…" mà không lật tung giấy tờ đang làm dở: `/btw` tách câu hỏi phụ ra một **side chat** riêng, để hội thoại chính (đang giải một task) không bị nhiễu bởi chủ đề ngoài lề. Hỏi xong đóng side chat là xong — task chính vẫn nguyên ngữ cảnh. · 📄 [VS Code Docs: AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

## Vì sao dùng /btw?

Task agent dài ngày thường tụt đà vì những câu "à tiện thể hỏi luôn": syntax của lệnh kia, function này có deprecated không, thư viện nào nên dùng. Hỏi vào chat chính thì model phải trộn hai ngữ cảnh; mở chat mới thì phải gắn lại context. `/btw` cho bạn một **kênh phụ tách biệt** — đúng chỗ để hỏi câu 30 giây, không đụng vào mạch chính.

**Nếu làm sai thì sao?** Dùng `/btw` cho câu hỏi *liên quan trực tiếp* đến task đang làm thì ngược lại — nó làm mất ngữ cảnh chính. Đây là công cụ cho câu hỏi bên lề, không phải "chat chính thứ hai".

> **Tóm gọn 1 câu:** `/btw` là bàn phụ bên cạnh — hỏi câu ngoài lề ở đó, để task chính không bị loãng, context không bị phá.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** đang giữa task agent mà có câu hỏi cú pháp/thư viện/kinh nghiệm độc lập; không muốn để dành vì sợ quên.
- **ĐỪNG dùng khi:** câu hỏi là một phần của task hiện tại (hỏi ngay trong chat chính giúp model dùng đúng ngữ cảnh); bạn đang ở Local harness hoặc Codex-extension — docs không có `/btw` ở đó. · 📄 [VS Code Docs: Pick the right tool](https://code.visualstudio.com/docs/agents/best-practices#pick-the-right-tool-for-the-task)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> `/btw cách format date trong Python 3.12?` — gõ trong Chat view (Copilot harness); câu hỏi mở ở side chat, chat chính giữ nguyên. · 📄 [VS Code Docs: Cheat Sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

## Ví dụ thật

Đang nhờ agent refactor một service bằng TypeScript. Giữa chừng chợt nhớ: "mà `satisfies` với `as const` khác nhau sao ấy nhỉ?" — vài câu hỏi bên lề. Gõ `/btw ...` → side chat trả lời gọn, đóng lại; hội thoại refactor tiếp tục mà không bị chen ngang một chủ đề khác.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**✅ Verify:** chat chính sau khi gõ `/btw` vẫn còn nguyên câu/ngữ cảnh cũ, side chat đóng không để lại dấu vết trong hội thoại chính.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — gõ thẳng câu phụ vào chat chính đang giải task:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — tách câu phụ ra `/btw`:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** phân loại câu hỏi trước khi hỏi — câu nào của task thì hỏi chat chính, câu nào bên lề thì `/btw`.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy `/btw` khi gõ `/` | Đang ở Local harness / Codex-extension | Chuyển về Copilot harness (Session Target) |
| Câu hỏi bị trả lời thiếu ngữ cảnh | Hỏi câu cần biết code repo qua `/btw` | Câu cần ngữ cảnh thì hỏi chat chính + `#file` |
| Side chat đóng mất lịch sử | Side chat là phiên phụ | Copy kết quả quan trọng vào note trước khi đóng |

## So sánh với Claude Code

| Việc | Copilot (`/btw`) | Claude Code | Ghi chú |
|---|---|---|---|
| Hỏi câu bên lề không phá task | `/btw <câu hỏi>` (side chat) | Gõ thêm câu hỏi, có thể nhầm ngữ cảnh | Copilot tách hẳn kênh; không có tương đương trực tiếp |

## Best practices (kèm "vì sao")

- **Chỉ dùng cho câu hỏi độc lập với task.** *Vì sao?* Side chat không có ngữ cảnh chat chính — hỏi câu cần ngữ cảnh ở đó sẽ ra câu trả lời chung chung.
- **Đóng side chat sau khi xong.** *Vì sao?* Giữ mạch UI sạch, tránh nhầm "đây là chat chính" lúc quay lại.
- **Kết quả quan trọng thì chép ra file.** *Vì sao?* Side chat không nằm trong Session History của chat chính — coi nó là thứ dùng rồi bỏ. · 📄 [VS Code Docs: Crafting effective prompts](https://code.visualstudio.com/docs/agents/guides/prompt-examples#tips-for-crafting-effective-prompts)

## Bài tập nhỏ

1. **(2 phút)** Trong một phiên Copilot đang làm task, gõ `/btw` một câu hỏi cú pháp bất kỳ; xác nhận task chính không bị ảnh hưởng.
2. **(3 phút)** Hỏi `/btw` một câu *cần ngữ cảnh repo* và một câu *không cần* — so sánh chất lượng để nhớ quy tắc dùng. · 📄 [VS Code Docs: Cheat Sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Attach context cho câu hỏi cần ngữ cảnh: [attachments](../attachments/README.md)
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · FAQ: [../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md)
- Nguồn docs: [VS Code — AI features cheat sheet (Slash commands)](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

> Hỏi đúng kênh là một nửa nghệ thuật prompt: câu của task → chat chính, câu bên lề → `/btw`, đừng trộn hai thứ vào một.
