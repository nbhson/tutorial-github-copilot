# Chat: Export Chat… — Lưu hội thoại ra file để share

> **Dành cho:** dev muốn lưu hoặc chia sẻ hội thoại · **Vấn đề:** kết quả hay nằm trong chat, không đưa được cho teammate/wiki · **Đọc xong:** export ra file sạch, không lọt secrets (~2 phút)
> **Harness:** Local (+ alias CLI) · **Surface:** VS Code Chat view / Agents window — cần Local harness; đường VS Code là lệnh Command Palette (không có slash `/export`); **Copilot CLI lại có `/export` = alias `/share`**

## 1 câu nôm na

Chụp lại toàn bộ cuộc trò chuyện thành một bản riêng để lưu wiki hoặc gửi teammate. Docs liệt kê hai đường: **`Chat: Export Chat...`** (Command Palette) cho ra file **JSON** gồm mọi prompts/responses, và chuột-phải trong Chat view → **Copy All** / **Copy Final Response** cho nội dung **Markdown** vào clipboard.

Khác với copy-paste thủ công từng đoạn: hai cách trên giữ nguyên thứ tự hội thoại và khối code, nên đọc lại không bị lộn xộn. Đây cũng là phao cứu sinh: còn việc dở mà sắp `/clear` (mở chat mới + archive chat hiện tại) thì lưu trước. · 📄 [VS Code Docs: Agents (concept)](https://code.visualstudio.com/docs/agents/concepts/agents)

## Vì sao dùng Chat: Export Chat…?

Giá trị thật của một phiên chat thường nằm ở **đoạn giữa** — những lần thử sai, quyết định chốt, đoạn code cuối cùng. Bản export biến mạch hội thoại đó thành tài sản dùng lại được:

- **Bàn giao context** — người khác đọc file là nắm được bạn đã đi tới đâu.
- **Lưu vào wiki** — biến một lần debug thành tài liệu nội bộ.
- **Backup trước khi cắt** — `/clear` bắt đầu chat mới và archive/chat hiện tại bị đánh dấu done; export là bảo hiểm cho mạch bạn vừa đi.

**Nếu làm sai thì sao?** Rủi ro lớn nhất là **lọt secrets** — docs cảnh báo hẳn một dòng: file export và message đã copy "có thể chứa prompt, phản hồi hoặc kết quả tool nhạy cảm". Nếu bạn từng attach file chứa token rồi export nguyên, token đó đi theo. Ngoài ra chat 50+ turns export thẳng sẽ thành file khó đọc.

> **Tóm gọn 1 câu:** Export là hành động *công khai hoá* — thứ gì trong chat cũng ra khỏi chat, nên hãy soát secrets trước khi share. · 📄 [VS Code Docs: Agents (concept)](https://code.visualstudio.com/docs/agents/concepts/agents)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** chat ra kết quả hay muốn lưu cho team; cần gửi context cho người khác tiếp tục; sắp `/clear` mà còn việc dở.
- **ĐỪNG dùng khi:** chat ngắn, không có gì đáng lưu — export chỉ tạo file rác trong repo. Muốn người khác *tiếp tục làm việc* chứ không chỉ đọc, dùng share session (sync) thay vì export file.
- **Cho ai:** người cần bàn giao context, hoặc team muốn lưu chat hay vào wiki. · 📄 [VS Code Docs: Pick the right tool](https://code.visualstudio.com/docs/agents/best-practices#pick-the-right-tool-for-the-task)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Mở Chat view trước (chọn **Local** ở Session Target), rồi gọi `Chat: Export Chat...` từ Command Palette. Không thấy slash `/export` trong Chat view là **đúng** — `/export` chỉ có ở **Copilot CLI** (alias `/share`), không có trong VS Code Chat. · 📄 [VS Code Docs: Export or copy a conversation](https://code.visualstudio.com/docs/agents/run/sessions/session-history#export-or-copy-a-conversation)

## Ví dụ thật

Nghiệp vụ: bạn vừa cùng Copilot chốt xong cách xử lý retry cho `apiClient`, muốn lưu vào wiki team để người sau khỏi mò lại.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Crafting effective prompts](https://code.visualstudio.com/docs/agents/guides/prompt-examples#tips-for-crafting-effective-prompts)

**Kết quả mong đợi:** File JSON (hoặc bản Markdown đã copy) chứa đủ turns + code blocks; share được, secrets đã soát.

**✅ Verify:** Mở file export, đọc lại 1 lượt thấy đủ ý, và `grep -iE "token|secret|password" <file>` trả 0 kết quả là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — export nguyên xi một chat từng attach file có token, rồi đẩy lên wiki:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — soát secrets trước, nén phần dài, rồi mới export:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

**Bài học:** Thứ tự đúng là *nén → soát → export*. Đảo bước soát ra sau bước share là lúc trả giá đắt nhất.

## Lỗi thường gặp

📄 [VS Code Docs: Debug Chat Interactions](https://code.visualstudio.com/docs/agents/agent-troubleshooting/chat-debug-view)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| File export lọt secrets | Attach file chứa token rồi export nguyên | Soát trước khi share; xóa token khỏi file rồi export lại |
| Export quá dài khó đọc | Chat 50+ turns | `/compact` trước rồi export bản gọn |
| Không thấy `/export` trong menu `/` (Chat view) | Không có slash này trong VS Code Chat | Dùng `Chat: Export Chat...` (palette) / Copy All; trong **Copilot CLI** thì có `/export` = `/share` |
| Cần Markdown mà file ra JSON | Nhầm hai đường | JSON = `Chat: Export Chat...`; Markdown = Copy All / Copy Final Response |
## So sánh với Claude Code

📄 [GitHub Docs: Choosing & delegating agent work](https://docs.github.com/en/copilot/concepts/agent-capabilities/choosing-and-delegating-agent-work)

| Việc | Copilot (`Chat: Export Chat...`) | Claude Code | Ghi chú |
|---|---|---|---|
| Lưu hội thoại ra file | Lệnh palette, xuất **JSON** đủ prompts/responses | `/export [filename]` (CLI) = alias `/share`, xuất **plain text** | Copilot VS Code dùng palette, Copilot CLI có slash `/export` — đừng nhầm hai surface |
| Lấy bản Markdown để dán vào wiki | Chuột-phải → Copy All / Copy Final Response | Copy từ transcript trong terminal | Copilot có sẵn menu copy phân lớp |
| Soát secrets trước khi share | Bạn là người kiểm | Bạn là người kiểm | Không công cụ nào tự che secret |
## Best practices (kèm "vì sao")

- **Export ngay khi chat vừa ra kết quả hay.** *Vì sao?* Để lâu, bạn quên mất phiên nào đáng lưu và chat có thể bị archive.
- **Chốt một folder chuẩn cho chat export** (ví dụ `docs/chats/`). *Vì sao?* Có quy ước thì team biết tìm ở đâu, không rải file khắp repo.
- **`/compact` trước khi export chat dài.** *Vì sao?* Bản gọn dễ đọc hơn và vẫn giữ file + quyết định quan trọng.
- **Luôn soát secrets trước khi commit file export.** *Vì sao?* Một token lọt vào git history thì gỡ rất phiền.
- **Đưa file export vào `.gitignore` nếu nó chứa nội dung nội bộ.** *Vì sao?* Export là bản copy ra ngoài chat — không có gì đảm bảo nó sạch nếu bạn quên kiểm. · 📄 [VS Code Docs: Share a session](https://code.visualstudio.com/docs/agents/run/sessions/session-history#share-a-session)

## Bài tập nhỏ

1. **(3 phút)** Export một chat ngắn bằng `Chat: Export Chat...`, mở file JSON và đếm xem có đủ turns bạn nhớ không.
2. **(5 phút)** Trên cùng một chat dài 30+ turns: export bản thô, rồi `/compact` và export bản gọn — so độ dễ đọc.
3. **(5 phút)** Rà một chat cũ có attach file, đánh dấu chỗ suýt lọt secret, rút ra checklist soát 3 dòng cho team. · 📄 [VS Code Docs: Export or copy a conversation](https://code.visualstudio.com/docs/agents/run/sessions/session-history#export-or-copy-a-conversation)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Cheatsheet: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · FAQ: [troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md) · Tips: [context hygiene](../../../../../02-tips-thuc-chien/01-context-hygiene.md)
- Nguồn docs: [VS Code — Session history (Export or copy a conversation)](https://code.visualstudio.com/docs/agents/run/sessions/session-history#export-or-copy-a-conversation) · [VS Code — Manage agent sessions](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions) · [VS Code — AI features cheat sheet (slash commands)](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)
- Nén trước khi export: [compact](../../../copilot/chat-session/compact/README.md) · Cắt context sau khi lưu: [new-chat](../../../copilot/chat-session/new-chat/README.md) · Chẩn đoán lệnh thiếu: [help](../help/README.md)

> Export là lúc biến một lần chat tốn kém thành tài liệu — nhưng nhớ: thứ gì trong chat cũng đi ra file, kể cả secret nếu bạn quên soát.
