# Commands — Index tra cứu 60 lệnh Copilot 2026

> **Dành cho:** ai cần tra nhanh 1 trong 60 lệnh · **Đọc xong:** tìm đúng lệnh theo harness (Copilot / Local / Cloud), mở README chi tiết của nó (~3 phút).
> Khoá học mặc định dạy **Copilot harness**. Hai bucket còn lại là vùng di sản và vùng cloud: `local/` = lệnh/đường dẫn **chỉ chạy ở Local harness** (Edit mode, prompt files, `@`-participants, `gh copilot`, `.vscode/mcp.json`); `cloud/` = những thứ diễn ra **ngoài máy bạn** (cloud agent, content exclusion, knowledge base).

## Tra theo harness — 3 câu hỏi

1. **Bạn đang gõ trong Chat view VS Code / Copilot CLI?** → bucket [`copilot/`](./copilot/README.md) (45 lệnh).
2. **Lệnh cũ không chạy / file cấu hình cũ không được đọc?** → bucket [`local/`](./local/README.md) (9) — kiểm xem nó có phải của Local harness không.
3. **Việc diễn ra trên GitHub.com / cloud agent?** → bucket [`cloud/`](./cloud/README.md) (6).

Nguồn sự thật của cây này: [`bucket.tsv`](./bucket.tsv) — mỗi slug một dòng `slug → nhóm → harness`.

## Tra theo 4 nhóm việc

Mỗi nhóm có README riêng liệt kê từng lệnh kèm khi nào dùng:

| Nhóm | Việc | Copilot (45) | Local (9) | Cloud (6) |
|---|---|---|---|---|
| [Chat & phiên](./copilot/chat-session/README.md) | mở đầu, gắn scope, nén, tìm lại, phím tắt | [13 lệnh](./copilot/chat-session/README.md) | [export, help, rename](./local/chat-session/README.md) | — |
| [Model & agent](./copilot/model-agent/README.md) | chọn mode/model/target, credits, sandbox | [8 lệnh](./copilot/model-agent/README.md) | [edit-mode, participants](./local/model-agent/README.md) | [3 phiên cloud agent](./cloud/model-agent/README.md) |
| [Code actions](./copilot/code-actions/README.md) | /explain /fix /tests /doc /commit /pr /setupTests… | [12 lệnh](./copilot/code-actions/README.md) | — | — |
| [System & kiến thức repo](./copilot/system-knowledge/README.md) | status/login/MCP/skills/hooks/plugins/telemetry | [12 lệnh](./copilot/system-knowledge/README.md) | [gh copilot, prompt file, .vscode/mcp.json](./local/system-knowledge/README.md) | [exclusion, KB, audit-log](./cloud/system-knowledge/README.md) |

## 5 lệnh nên biết trước (Copilot harness)

| Lệnh | 1 dòng | Chi tiết |
|---|---|---|
| `Ctrl+N` / `/new` | phiên sạch cho task mới | [new-chat](./copilot/chat-session/new-chat/README.md) |
| `Attach` / `#file` | gắn đúng scope vào prompt | [attachments](./copilot/chat-session/attachments/README.md) |
| Ask / Plan / Agent | chọn mức tự chủ | [ask-mode](./copilot/model-agent/ask-mode/README.md) · [plan](./copilot/code-actions/plan/README.md) · [agent-mode](./copilot/model-agent/agent-mode/README.md) |
| Review diff rồi Accept | chất lượng quyết định bởi bạn | [agent-mode](./copilot/model-agent/agent-mode/README.md) |
| `/status` | 30 giây chẩn đoán mọi thứ_health_ | [status](./copilot/system-knowledge/status/README.md) |

> 60 lệnh nghe nhiều, nhưng nắm 4 thói quen — mở phiên mới mỗi task, gắn scope bằng `#file`, chọn đúng mode/Session Target, review diff trước khi Accept — là bạn đã dùng đúng phần lớn rồi.

## Khuôn mỗi README lệnh

**lệnh làm gì (1 câu nôm na) → vì sao dùng → khi nào dùng/không dùng → cách gọi (copy-paste) → ví dụ thật + Verify → ❌ SAI / ✅ ĐÚNG → so sánh Claude Code → Best practices kèm "vì sao" → bài tập → nguồn docs**. Dòng `> **Harness:** … · **Surface:** …` ngay dưới title cho biết lệnh chạy ở đâu — đọc nó trước khi copy lệnh sang môi trường khác.

## Lỗi tra cứu thường gặp (❌ SAI / ✅ ĐÚNG)

**❌ SAI — thấy lệnh "mất" là kết luận docs sai:** nhiều lệnh (`/history`, `/export`, `/summarize`, Edit mode) đổi chỗ hoặc chuyển về Local harness — kiểm dòng Harness của bucket tương ứng trước.

**✅ ĐÚNG — tra ba bước:** (1) `bucket.tsv` xác định slug thuộc harness nào; (2) README của slug đọc dòng Harness/Surface; (3) không thấy lệnh trong UI → mở [Agent Customizations editor](../17-agent-customizations-hub.md) hoặc `Chat: Show Chat Panels` — nhiều thứ giờ là card/chuỗi lệnh, không phải slash.

**Bài học:** "lệnh mất" thường là *đổi chỗ*, không phải *mất chức năng*.

## Tham khảo

- Bài tổng: [04 — Chat commands toàn tập](../04-chat-commands-toan-tap.md) (bảng slash của cả series) · [02 — Các bề mặt](../02-cac-be-mat-vscode-ide-web-cli.md) (harness nào chạy gì) · [17 — Agent Customizations editor](../17-agent-customizations-hub.md).
- [CHEATSHEET.md](../../CHEATSHEET.md) — tra 1 phút không cần mở từng folder · [../examples/](../examples/) — mẫu copy-paste cấp bài.
- VS Code: [AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · GitHub: [Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference).

> **Chốt:** tra lệnh = tra harness trước, lệnh sau. 45 slug `copilot/` là thứ bạn dùng hằng ngày; 9 slug `local/` giải thích vì sao lệnh cũ không chạy; 6 slug `cloud/` cho việc diễn ra khi bạn tắt máy.
