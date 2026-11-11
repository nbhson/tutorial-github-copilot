# /plan — khảo sát repo rồi đề xuất kế hoạch trước khi sửa file

> **Dành cho:** dev sắp để agent sửa nhiều file một lúc · **Vấn đề:** chạy thẳng task rồi giữa đường thấy hướng sai, phải hoàn tác · **Đọc xong:** gọi đúng `/plan` và biết khi nào nên lập kế hoạch, khi nào chạy thẳng (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) và Claude harness; Local harness dùng Plan agent built-in

## 1 câu nôm na

Kiến trúc sư vẽ bản vẽ rồi thợ mới khởi công. `/plan` bắt Copilot đọc code thật và trả về danh sách bước + điểm rủi ro để bạn duyệt — thay vì "vừa xây vừa sửa" như chạy thẳng Agent. Bản vẽ sai thì sửa trên giấy; code sửa sai thì mất cả buổi. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Vì sao dùng /plan?

Vì hầu hết giờ vứt đi không đến từ code dở, mà từ hướng đi sai — và hướng sai chỉ lộ ra sau khi đã sửa nửa repo. `/plan` trả giá sai lầm đó trên giấy:

- **Nghiên cứu trước khi sửa** — docs mô tả lệnh là "research + propose a plan": kế hoạch dựa trên repo thật, không dựa trên cấu trúc model tưởng tượng.
- **Duyệt lúc còn rẻ** — sửa vài đoạn kế hoạch nhẹ hơn nhiều so với hoàn tác hàng chục file.
- **Bàn giao được** — kế hoạch là thứ bạn paste sang chat mới hoặc đưa đồng nghiệp tiếp quản.

Docs ghi rõ tính sẵn có phụ thuộc surface: "Type `/` to see commands available in the current session" — `/plan` có ở Copilot harness và Claude harness; Local harness có **Plan agent** (agent built-in, không phải slash này).

> **Tóm gọn 1 câu:** `/plan` mua hộ bạn bước "đọc trước khi viết": việc khảo sát giao cho Copilot, bạn chỉ làm việc duyệt hướng đi. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** sửa trải nhiều file (migration, đổi interface dùng chung); chưa hiểu vùng code bạn sắp chạm; muốn chốt phương án trước khi tiêu AI credits.
- **ĐỪNG dùng khi:** sửa nhỏ đã rõ cách làm — nói thẳng Agent cho nhanh; hoặc task phải thử tay (chạy test mới biết lỗi). Docs không ghi `/plan` chạy cho Copilot cloud agent → đừng dùng ở surface đó. · 📄 [VS Code Docs: Choose a feature](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet#choose-a-feature)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Không thấy `/plan` khi gõ `/`? Có thể session đang ở Local harness (dùng Plan agent) — xem lại Session Target ở [bài 02](../../../../02-cac-be-mat-vscode-ide-web-cli.md) rồi hãy kết luận lỗi công cụ. · 📄 [VS Code Docs: Ask the current agent to plan](https://code.visualstudio.com/docs/agents/run/planning#ask-the-current-agent-to-plan)

## Ví dụ thật

Nghiệp vụ: bạn phải chuyển auth từ session cookie sang JWT, ước tính chạm ~10 file. Gọi `/plan đổi auth session sang JWT, danh sách file + thứ tự migration + cách test`, Copilot trả về kế hoạch theo giai đoạn: login/logout trước, middleware sau, test cho từng bước.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Code generation & editing](https://code.visualstudio.com/docs/agents/guides/prompt-examples#code-generation-and-editing)

**Kết quả mong đợi:** Một bản kế hoạch nêu đích danh đường dẫn file trong repo bạn, thứ tự bước, và điểm phải test lại.

**✅ Verify:** Copy 2–3 đường dẫn file trong kế hoạch và grep trong repo — file thật tồn tại là kế hoạch "có nghiên cứu", không ảo.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI:** thấy `/plan` không xuất hiện trong chat Local rồi kết luận "Copilot hỏng" — Local harness không có slash này, nó có Plan agent.
**✅ ĐÚNG:** kiểm tra harness bằng gõ `/` (docs: availability phụ thuộc chat surface, harness, role); ở Local thì chọn Plan agent, ở Copilot thì gõ `/plan`.

**Bài học:** slash và agent không phải một. `/plan` là lệnh của Copilot harness; Local tương đương của nó là một built-in agent — cùng ý tưởng "kế hoạch trước khi sửa", khác cách gọi. · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

## Lỗi thường gặp

📄 [VS Code Docs: Review and refine the plan](https://code.visualstudio.com/docs/agents/run/planning#review-and-refine-the-plan)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ `/` không thấy `/plan` | Session ở Local harness hoặc surface không hỗ trợ | Đổi Session Target về Copilot, hoặc dùng Plan agent ở Local |
| Kế hoạch chung chung, không nêu file | Mô tả task quá rộng, model không có gì mà research | Thu hẹp scope, chỉ thẳng folder/files cần khảo sát |
| Tưởng plan tự chạy thành code | Nhầm "propose plan" với thực thi | Duyệt/sửa plan xong mới giao Agent làm từng bước |
## So sánh với Claude Code

📄 [GitHub Docs: Third-party coding agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-third-party-coding-agents)

| Việc | Copilot (`/plan`) | Claude Code | Ghi chú |
|---|---|---|---|
| Khảo sát + đề xuất kế hoạch trước khi sửa | `/plan` (Copilot harness) | Plan mode — một *permission mode* của Claude harness | Cùng triết lý, khác cơ chế: của Copilot là slash, của Claude là mode |
| Bản kế hoạch trong chat Local | Plan agent (built-in của Local harness) | Không có tương đương trực tiếp | Local không có `/plan` theo docs |
## Best practices (kèm "vì sao")

- **Duyệt plan như duyệt PR: tìm file thiếu, bước thừa trước khi cho chạy.** *Vì sao?* Mỗi bước plan sai sẽ thành một loạt edits sai; chặn trên giấy rẻ hơn hoàn tác code.
- **Yêu cầu kế hoạch kèm cách test cho từng bước.** *Vì sao?* Không có bước verify, bạn chỉ phát hiện sai khi build đỏ.
- **Task dài thì paste plan sang chat mới để thực thi.** *Vì sao?* Chat vừa research vừa làm rất dễ phình context; plan gọn là "bản chỉ đường" để khởi động lại sạch.
- **Đừng `/plan` cho sửa 1–2 dòng.** *Vì sao?* Chi phí một vòng research + duyệt lớn hơn chính việc sửa. · 📄 [VS Code Docs: Plan first, then implement](https://code.visualstudio.com/docs/agents/best-practices#plan-first-then-implement)

## Bài tập nhỏ

1. **(3 phút)** Mở chat Copilot harness, gõ `/` và xác nhận `/plan` có trong danh sách lệnh của máy bạn.
2. **(10 phút)** Chọn một refactor bạn đang postpone, gọi `/plan` mô tả nó; grep lại 3 file kế hoạch nêu xem có thật không.
3. **(5 phút)** So sánh một plan do `/plan` sinh với cách bạn hay làm tay: kế hoạch thiếu ý nào, bạn thiếu file nào? · 📄 [VS Code Docs: Ask the current agent to plan](https://code.visualstudio.com/docs/agents/run/planning#ask-the-current-agent-to-plan)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · [Commands index](../../../README.md)
- Nguồn docs: [VS Code — AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [GitHub — Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- Bài liên quan: [bài 04 — Chat commands toàn tập](../../../../04-chat-commands-toan-tap.md) · [bài 02 — Các bề mặt](../../../../02-cac-be-mat-vscode-ide-web-cli.md)
- Cùng nhóm: [../tests/README.md](../tests/README.md) (sinh test) · Khác nhóm: [../../model-agent/agent-mode/README.md](../../model-agent/agent-mode/README.md) (chạy thẳng bằng Agent) · Local: [../../../local/model-agent/edit-mode/README.md](../../../local/model-agent/edit-mode/README.md)

> `/plan` không mất công sức — nó chỉ dời công sức từ "sửa code sai" sang "sửa mấy dòng kế hoạch", chỗ mà sửa rẻ hơn trăm lần.
