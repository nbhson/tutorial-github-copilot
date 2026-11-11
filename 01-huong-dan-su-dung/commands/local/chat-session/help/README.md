# /help — Bản đồ lệnh khả dụng ở máy bạn

> **Dành cho:** người mới cài, hoặc người đang nghi một lệnh không tồn tại · **Vấn đề:** không biết ở máy mình có lệnh gì, plan/version nào · **Đọc xong:** mở được bản đồ lệnh và đối chiếu với list thực tế (~2 phút)
> **Harness:** Local · **Surface:** VS Code Chat (Local harness) — docs ghi rõ `/help` "liệt kê lệnh và agent trong một local Ask chat"; cần Local harness, không chạy trong Copilot harness

## 1 câu nôm na

Hỏi lễ tân "ở đây có những dịch vụ gì?" trước khi gọi món. `/help` liệt kê slash command, agent và mode khả dụng **đúng theo máy của bạn** — docs cũng nói thẳng lý do: khả dụng của một lệnh "phụ thuộc chat surface, harness, role và các tính năng đang bật".

Điểm mấu chốt: cùng một lệnh có thể có trên máy đồng nghiệp mà không có trên máy bạn, vì hai máy khác harness/plan/version — `/help` là cách phân biệt "lệnh không tồn tại ở đây" với "lệnh có mà bạn gọi sai cú pháp". · 📄 [VS Code Docs: Agents (concept)](https://code.visualstudio.com/docs/agents/concepts/agents)

## Vì sao dùng /help?

Rất nhiều thắc mắc "sao lệnh này không chạy" thực ra là câu hỏi về **khả dụng**: đang ở harness nào, plan nào, version nào. `/help` trả lời trực tiếp:

- **Biết mình có gì** — không đoán mò theo tài liệu của người khác.
- **Phân biệt hai loại lỗi** — "không có lệnh" khác hẳn "gọi sai cú pháp".
- **Onboard nhanh** — thành viên mới mở `/help` là có bản đồ.

**Nếu làm sai thì sao?** Ngộ nhận phổ biến: thấy `/help` máy đồng nghiệp có lệnh mà máy mình không có, liền kết luận "extension lỗi". Thực ra thường là khác harness/plan/version. Xem ❌/✅.

> **Tóm gọn 1 câu:** `/help` là bản đồ lệnh của riêng máy bạn — thiếu lệnh thường là chuyện harness/plan/version, không phải extension hỏng. · 📄 [VS Code Docs: Agents (concept)](https://code.visualstudio.com/docs/agents/concepts/agents)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** mới cài và chưa biết có lệnh gì; nghi một lệnh vắng mặt do harness/plan/version; onboard thành viên mới.
- **ĐỪNG dùng khi:** bạn cần *cách dùng chi tiết* một lệnh — `/help` chỉ liệt kê, không dạy cú pháp; hãy mở README của lệnh đó. Cũng đừng tìm `/help` trong session Copilot harness: dùng menu `/` và Agent Customizations editor thay thế.
- **Cho ai:** người mới onboard nhanh, và tech lead đối chiếu máy mình với máy đồng nghiệp. · 📄 [VS Code Docs: Pick the right tool](https://code.visualstudio.com/docs/agents/best-practices#pick-the-right-tool-for-the-task)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Session của bạn phải đang ở **Local** (chọn ở **Session Target**) thì `/help` mới xuất hiện. Kiểm nhanh: gõ `/` trong ô Chat, tìm `/help`; không thấy thì đọc hướng dẫn ở [troubleshoot](../../../copilot/chat-session/troubleshoot/README.md) trước khi kết luận lỗi công cụ. · 📄 [VS Code Docs: Cheat Sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

## Ví dụ thật

Nghiệp vụ: bạn đọc tài liệu thấy có `/tests` để sinh test, nhưng gõ vào máy mình thì không thấy. Thay vì loay hoay, mở `/help` để xem thực tế máy mình có gì.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Crafting effective prompts](https://code.visualstudio.com/docs/agents/guides/prompt-examples#tips-for-crafting-effective-prompts)

**Kết quả mong đợi:** List slash/agent/mode khả dụng đúng harness + plan + version máy bạn.

**✅ Verify:** Gõ `/` so list trong `/help` với list thực tế — khớp là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — thấy thiếu lệnh rồi kết luận ngay là extension hỏng:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — đối chiếu `/help` với dashboard trạng thái để tìm đúng nguyên nhân:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

**Bài học:** "Không có lệnh" thường là chuyện harness/plan/version, không phải lỗi cài đặt. `/help` + Copilot status dashboard là cặp chẩn đoán.

## Lỗi thường gặp

📄 [VS Code Docs: Troubleshoot agents in VS Code](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| List trong `/help` khác máy đồng nghiệp | Khác harness/plan/version | So dashboard trạng thái 2 máy (bấm Copilot ở Status Bar), ghi rõ harness đang chọn |
| Đọc `/help` vẫn không hiểu lệnh nào | Thiếu ví dụ | Mở README tương ứng trong `commands/` tra từng lệnh |
| Lệnh có trong `/help` mà gõ không ăn | Nhầm cú pháp hoặc thiếu argument | Đọc mục Cách gọi của lệnh đó; nhiều lệnh có dạng `/tên <nội dung>` |
| Gõ `/help` không ra trong session Copilot | Docs đặt `/help` ở local Ask chat | Dùng menu `/` để xem lệnh khả dụng; mở `Chat: Open Customizations` để xem customization |
## So sánh với Claude Code

📄 [GitHub Docs: Choosing & delegating agent work](https://docs.github.com/en/copilot/concepts/agent-capabilities/choosing-and-delegating-agent-work)

| Việc | Copilot (`/help`) | Claude Code | Ghi chú |
|---|---|---|---|
| Xem bản đồ lệnh khả dụng | `/help` (local Ask chat) + menu `/` | `/help` và menu `/` | Cùng ý tưởng: liệt kê lệnh hiện có |
| Liệt kê customization theo loại | `/agents`, `/instructions`, `/skills`, `/hooks` (Local) | `/agents`, `/skills`, `/mcp`, `/plugin` | Copilot gom vào Agent Customizations editor |
| Chẩn đoán thiếu lệnh | So plan + version ở dashboard trạng thái | So version/plan | Cả hai đều bị ảnh hưởng bởi gói/phiên bản |
## Best practices (kèm "vì sao")

- **Mở `/help` ngay sau khi cài, ghi lại plan + harness.** *Vì sao?* Biết chính xác máy mình có gì rẻ hơn nhiều so với đoán theo tài liệu chung.
- **Thiếu lệnh thì so dashboard trạng thái trước khi báo lỗi.** *Vì sao?* Phần lớn "thiếu lệnh" là khác harness/plan/version, không phải bug.
- **Đừng dùng `/help` thay tài liệu chi tiết.** *Vì sao?* Nó chỉ liệt kê; cú pháp và ví dụ phải đọc README lệnh đó.
- **Với session Copilot harness, dùng menu `/` + `Chat: Open Customizations`.** *Vì sao?* Docs chỉ đặt `/help` ở local Ask chat — tìm nó trong Copilot session là đi tìm thứ docs không hứa. · 📄 [VS Code Docs: Crafting effective prompts](https://code.visualstudio.com/docs/agents/guides/prompt-examples#tips-for-crafting-effective-prompts)

## Bài tập nhỏ

1. **(2 phút)** Mở `/help` (session Local), ghi lại plan + version + danh sách lệnh của máy bạn.
2. **(5 phút)** Chọn một lệnh có trong `/help`, mở README tương ứng trong `commands/` để học cú pháp.
3. **(5 phút)** Switch sang session Copilot harness, gõ `/` và so list với `/help` lúc nãy — list nào mất? Vì sao (docs nói khả dụng phụ thuộc harness)? · 📄 [VS Code Docs: Cheat Sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · FAQ: [troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md) · Bài: [04 — Chat commands](../../../../04-chat-commands-toan-tap.md)
- Nguồn docs: [VS Code — AI features cheat sheet (Slash commands + ghi chú khả dụng)](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [VS Code — Prompt files (Agent Customizations editor, `Chat: Open Customizations`)](https://code.visualstudio.com/docs/agent-customization/prompt-files) · [VS Code — Workspace context (Copilot status dashboard)](https://code.visualstudio.com/docs/agents/reference/workspace-context)
- Khi lệnh có mà gọi không ăn: [attachments](../../../copilot/chat-session/attachments/README.md) (gắn context) và [shortcuts](../../../copilot/chat-session/shortcuts/README.md) (phím tắt) · Chẩn đoán: [troubleshoot](../../../copilot/chat-session/troubleshoot/README.md) · Trạng thái: [status](../../../copilot/system-knowledge/status/README.md)

> `/help` trả lời câu "máy tôi có gì", không trả lời câu "dùng thế nào" — và nó chỉ trả lời khi bạn đang ở đúng harness.
