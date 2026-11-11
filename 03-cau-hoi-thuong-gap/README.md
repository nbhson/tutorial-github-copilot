# 03 — Câu hỏi thường gặp (11 bài, tra cứu khi kẹt)

> **Dành cho:** ai đang kẹt với GitHub Copilot — từ người mới tới dev đã dùng, cần tra cứu nhanh.
> **Vấn đề:** 11 nhóm câu hỏi lặp đi lặp lại (tài khoản, model, MCP, policy, lỗi...) khiến bạn phải tìm documentation khắp nơi.
> **Đọc xong:** mở đúng file trong 30 giây, trả lời được ngay nhờ mục "Trả lời 1 câu". **Thời gian:** ~5 phút đọc mục lục.

Coi nhóm này như một tủ thuốc, không phải cuốn sách để đọc từ đầu tới cuối: bạn tra triệu chứng, tìm đúng "ngăn", lấy đúng bài. Mỗi bài gồm ~10 câu hỏi theo cấu trúc gọn: **Trả lời 1 câu → giải thích + lệnh copy-paste → "Vẫn lỗi thì sao?" cuối file**. Bận thì chỉ đọc "Trả lời 1 câu"; rảnh thì làm theo lệnh.

| # | Chủ đề | Link |
|---|--------|------|
| 01 | Tài khoản, pricing, cài đặt | [01-tai-khoan-pricing-cai-dat.md](./01-tai-khoan-pricing-cai-dat.md) |
| 02 | Model, context & AI Credits | [02-model-context-premium.md](./02-model-context-premium.md) |
| 03 | Modes & permissions | [03-modes-permissions.md](./03-modes-permissions.md) |
| 04 | MCP FAQ | [04-mcp-faq.md](./04-mcp-faq.md) |
| 05 | Policies & guardrails FAQ | [05-policies-guardrails-faq.md](./05-policies-guardrails-faq.md) |
| 06 | Prompts, agents, instructions | [06-prompts-agents-instructions.md](./06-prompts-agents-instructions.md) |
| 07 | Custom agents, cloud agent workflows | [07-custom-agents-coding-agent-workflows.md](./07-custom-agents-coding-agent-workflows.md) |
| 08 | Lỗi thường gặp & troubleshooting | [08-loi-thuong-gap-troubleshooting.md](./08-loi-thuong-gap-troubleshooting.md) |
| 09 | Bảo mật, quyền, riêng tư | [09-bao-mat-quyen-rieng-tu.md](./09-bao-mat-quyen-rieng-tu.md) |
| 10 | CI, SDK, review, Web | [10-ci-sdk-review-web.md](./10-ci-sdk-review-web.md) |
| 11 | Copilot Spaces, Spark, Workspace | [11-spaces-spark-workspace.md](./11-spaces-spark-workspace.md) |

> **Cách đọc bảng này:** dọc cột **#** là danh mục 11 "ngăn thuốc", cột **Chủ đề** cho biết mỗi ngăn chữa gì — tìm đúng chủ đề rồi mở link, không cần đọc lần lượt từ 01 tới 11.

## Gặp lỗi X → đọc bài nào?

Mục này là bàn phân loại tiếp nhận: kể triệu chứng, được chỉ ngay ngăn thuốc cần mở — đừng tự chẩn đoán trước khi tra.

Không cần đọc từ đầu: bắt đúng triệu chứng bạn đang gặp, rồi nhảy thẳng tới bài tương ứng.

- Không đăng nhập / thắc mắc giá / seat / trial / policy chặn → **bài 01**
- Model nào ngon, chi phí AI Credits, tràn context, BYOK → **bài 02**
- Bị chặn tool, không hiểu Ask/Edit/Agent, approval hoài → **bài 03**
- MCP tools không hiện, auth fail, secrets → **bài 04**
- Instruction không ăn, muốn pre-commit / branch protection → **bài 05**
- Prompt/agent/instructions không load, applyTo sai, frontmatter lỗi → **bài 06**
- Custom agent chạy loạn, cloud agent conflict / PR fail → **bài 07**
- Copilot offline, mất gợi ý, chat error, CLI fail → **bài 08** trước
- Sợ lộ code, training, secret scanning, audit logs, ZDR → **bài 09**
- Actions + cloud agent, SDK, auto review, bản Web/Mobile → **bài 10**
- Spaces / Spark / Workspace là gì, còn sống không, truy cập ở đâu → **bài 11**

## So sánh với Claude Code

| Việc | GitHub Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Tra cứu theo triệu chứng | 11 bài FAQ + bảng "lỗi nào đọc câu nào" | Docs Anthropic theo chủ đề + `/help` trong phiên | Cùng cách tra: tìm đúng chỗ, đừng đọc tuần tự |
| Hỏi ngay trong công cụ | Copilot Chat (`/help`, `/status` ở CLI) | `/help`, hỏi trực tiếp trong phiên terminal | Cả hai đều có trợ giúp tại chỗ |
| Luật repo | `.github/copilot-instructions.md` + `AGENTS.md` | `CLAUDE.md` | Cùng tư tưởng: file trong repo là "luật" |
| Cấu hình MCP | Copilot harness: [`.mcp.json`](../templates/.mcp.json) ở root + `~/.copilot/mcp-config.json` (key `mcpServers`) · Local harness (VS Code): [`.vscode/mcp.json`](../templates/.vscode/mcp.json) (key `servers`) | `.mcp.json` + cấu hình user | Cùng chuẩn giao thức, khác đường dẫn |
| Tài khoản & quota | Gói cá nhân/team + AI Credits (1 credit = $0,01) | Theo gói Claude/subscription hoặc API key | Đơn vị đo khác nhau — đọc bài 01/02 để tính |
| Debug lỗi | Bảng lỗi + thứ tự debug 7 bước (bài 08) | Log phiên terminal + docs troubleshooting Anthropic | Thứ tự "auth → mạng → version → phiên mới" gần giống nhau |

> **Tóm gọn 1 câu:** Nhóm FAQ là tủ thuốc gia đình: triệu chứng gì tra đúng ngăn đó, uống đúng liều ("Trả lời 1 câu" trước, steps sau) — tự khỏi thì khỏi mất công đi khám.

> **Đọc bảng này thế nào:** phần lớn khái niệm chuyển gần 1-1 (luật trong repo, MCP, slash command), chỉ khác *tên file* và *bề mặt chạy*. Điểm khác đáng nhớ: Copilot có sẵn bảng lỗi + chỉ báo trực quan (status bar) trong khi Claude Code terminal-first — lỗi hiện ngay nơi bạn gõ lệnh.

Quay về: [../README.md](../README.md) · Bài tổng: [../01-huong-dan-su-dung/00-tong-quan-copilot.md](../01-huong-dan-su-dung/00-tong-quan-copilot.md).

> **Chốt nhóm FAQ:** tra đúng triệu chứng, đọc "Trả lời 1 câu" trước, rồi mới làm theo steps — 11 bài này để bạn tự gỡ phần lớn ca kẹt mà không phải chờ ai.
