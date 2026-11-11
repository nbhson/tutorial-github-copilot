# 07 — Biên bản verify tay (5 câu còn treo từ `05` §0b)

Trạng thái: **chưa có ai chạy 5 câu này trong session thật.** Khoá học đang được viết theo *giả định* ở cột 3; nếu kết quả khác, làm theo cột 4 rồi chạy lại `bash plan-update/scripts/qa.sh`.

Cách đo: mở VS Code bản mới nhất + Copilot CLI (`copilot --version`), mỗi câu ~3 phút, tổng ~15 phút. Ghi kết quả vào cột "Kết quả thật" rồi cập nhật file bị ảnh hưởng.

| # | Câu hỏi | Giả định hiện tại (đang dạy vậy) | Nếu kết quả khác | Kết quả thật |
|---|---|---|---|---|
| 1 | `Chat: Open Command Palette → Chat: Export Chat…` có chạy trong **Copilot harness session**? | **Không chắc** → slug ở `commands/local/chat-session/export/`, README ghi "verify trong session thật" | Nếu **có**: `git mv commands/local/chat-session/export commands/copilot/chat-session/export`, sửa `bucket.tsv` (`export chat-session copilot`), đổi 2 group README (`local/chat-session` bỏ dòng export, `copilot/chat-session` thêm), sửa link trong `commands/copilot/chat-session/{clear,history,new-chat,compact}/README.md` + bài 11 | |
| 2 | Quick Chat (`Ctrl+Shift+Alt+L`) mở được khi session đang Copilot harness? | **Có** → `commands/copilot/chat-session/quick-chat/` | Nếu **không**: move sang `local/`, sửa `bucket.tsv`, `commands/README.md` (43/7 → 42/8), bài 02 §2 + bài 10 ghi "Local" | |
| 3 | `/rename` có trong session Copilot harness? (docs chỉ hứa "in a local chat") | Dạy theo docs: **local Ask chat** → bài 04 + `commands/copilot/chat-session/history/README.md` ghi nhãn "Local" | Nếu Copilot harness cũng có: bỏ nhãn Local ở 2 chỗ | |
| 4 | `Restore Checkpoint` / "Chat: Show Checkpoints" hiện trong session Copilot harness? | **Có** → `commands/copilot/chat-session/checkpoints/` + bài 11 dạy 4 cơ chế | Nếu **không**: move slug sang `local/`, bài 11 giữ giải thích nhưng gắn block "⚠️ Local harness" ≤6 dòng | |
| 5 | Copilot CLI: slash nào có thật trong số `/status` `/settings` `/permissions` `/plugin` `/sandbox` `/model` `/compact` `/resume`? | docs GitHub xác nhận `/status` `/sandbox` `/plugin` `/permissions` `/limits` → các slug tương ứng đứng `copilot/`; `/model` (CLI) ≠ `/models` (VS Code local); `/resume` **không** có ở CLI → dạy `copilot --continue` | Chạy `copilot` → gõ `/` và chụp lại list; nếu khác, sửa "Cách gọi" của slug liên quan + bài 04 | |

## Ghi chú "nguồn mỏng" (fact đang dạy nhưng căn cứ chưa cứng)

| Fact | Đang dạy ở | Căn cứ hiện có | Xử lý khi có thời gian |
|---|---|---|---|
| Availability của `/btw` ("không có ở Local & Codex extension") | bài 04 §6 | chỉ có trong snapshot cheat sheet 10/11/2026 (`plan-update/02` §2), bản live hôm nay không còn dòng này | kiểm lại trang cheat sheet; nếu mất hẳn → bỏ dòng, dẫn `approvals` |
| `/plugin` + `copilot plugin …` là slash CLI/harness | bài 04 §6, `commands/copilot/system-knowledge/plugins/` | docs GitHub `cli-plugin-reference` + VS Code `agent-plugins.md` (không nằm trong bảng cheat sheet) | ổn — đã có URL, chỉ cần giữ nhãn "Copilot harness/CLI" |
| Copilot Memory phủ tới surface nào (cloud agent?) | bài 03 §7 | docs VS Code xác nhận session Copilot + `Chat: Show Memory Files`; docs GitHub không nói cloud agent | chạy verify #6 (mở cloud agent session, hỏi "bạn nhớ gì về repo này") |
| `Chat: Export Chat…` chạy được ở Copilot session? | `commands/local/chat-session/export/` (giả định: KHÔNG) | docs VS Code liệt kê command, không ghi rõ harness | verify #1 — nếu có thì move slug sang `copilot/` |
| Ngưỡng "file < 2.000 dòng" cho ghost text · `Copilot: Check Status` | bài 01 §3/§6 | không có URL — kế thừa bản cũ | đã gắn nhãn "kinh nghiệm thực hành" hoặc cắt khi review |

## Ghi chú biên bản (11/11/2026)

- **Sweep URL docs toàn repo (111 URL):** 16 URL chết đã map sang trang live mới (đối chiếu nội dung từng trang đích): `about-cloud-agent` → `concepts/agents/cloud-agent/about-cloud-agent` · `pages-and-features/copilot-cli` → `concepts/copilot-surfaces/copilot-cli` (khái niệm) hoặc `reference/copilot-cli-reference/cli-command-reference` (tra cờ) · `about-local-sandboxing` → `understanding-local-sandboxing` · `private-and-hybrid-indices` → `concepts/prompting-and-context/repository-indexing` · `coping-with-copilot/model-deprecation` → `concepts/models/fallback-and-lts-models` · `configure-modes-and-permissions` → `how-tos/copilot-cli/use-copilot-cli/allowing-tools` · `cli-versus-vs-code` đã bị gỡ → dùng `concepts/copilot-surfaces/copilot-cli` · VS Code: legacy tree `docs/copilot/*`, `docs/chat/reference/*`, `docs/applied-resources/use-github-repository-search`, `docs/capabilities/copilot/telemetry`, `docs/agents/run/agent-hooks` → `agent-customization/{hooks,language-models}`, `agents/reference/{hooks-reference,workspace-context}`, `agents/run/chat-view`, `agents/guides/{monitoring-agents,explore-a-codebase}`, `docs/setup/copilot`. Khi cite trang mới, kiểm lại bằng curl (đổi tree là việc của Microsoft, không báo trước).
- **Copilot Memory:** bỏ nhãn public preview; fact mới đã ghi vào `02` dòng Memory (mặc định bật, 90 vs 28 ngày, repo-local jsonl experimental).
- **Slug mới ngoài kế hoạch:** `copilot/system-knowledge/hooks` (tạo 11/11 vì bài 04/07 link `/hooks` trong khi plan 04 §3 chỉ duyệt 9 slug mới) và `cloud/system-knowledge/audit-log` (folder W5e tạo bị một agent khác xoá mất 11/11 — đã dựng lại README 95 dòng + 2 examples, nạp `gh api` mẫu `--paginate` + `@tsv`). Đích cuối: **copilot 43 · local 8 · cloud 6 = 57**; README gốc/CHEATSHEET/index các bucket đã đổi 55→57.
- **CLI `/permissions`:** trang `allowing-tools` live ghi nhận giá trị `show|assisted|manual|allow-all` — "manual không hợp lệ" (hàng `/permissions` trong `06`) là theo trang cũ đã gỡ; bài 10 + slug `policy-approval` đang dạy 3 mức Manual/Assisted/Allow all → khớp docs live.
- **Vòng URL thứ 2 (sau khi W5c/W5d/W5e ghi):** 7 URL chết mới phát sinh (agent viết lại URL cũ) — đã map + verify: `agents/chat/sessions`→`agents/concepts/sessions` · `docs/copilot/references/troubleshooting`→`agents/agent-troubleshooting/troubleshooting` · `about-cloud-agent` (remaining) · `concepts/administration-and-usage/audit-log`→`reference/enterprise-administrators/agentic-audit-log-events` · `about-local-sandboxing` (remaining)→`understanding-local-sandboxing` · GH `migrate-customizations`→VS Code `agent-customization/migrate-customizations` · REST `copilot-content-exclusion-management`→how-to `configure-content-exclusion/exclude-content-from-copilot`. Sweep cuối: **118/118 URL docs = 200**.
- **W5f không ghi được file** (commands/README mới + 3 bucket README + audit-log không nằm trên đĩa khi phiên kết thúc) — parent đã tự viết: `commands/README.md` (57 lệnh), `copilot/README.md` (43), `local/README.md` (8), `cloud/README.md` (6) + dựng lại slug `cloud/system-knowledge/audit-log` theo schema docs live (`actor:Copilot`, `action/actor_is_agent/agent_session_id/user`, 180 ngày, streamed usage records preview) — bảng event `copilot.*` tự chế đã bị xoá vì không có nguồn.
- 5 câu verify tay ở bảng trên vẫn **chưa ai chạy**.

## Ghi chú kỹ thuật

- `bucket.tsv` (`01-huong-dan-su-dung/commands/bucket.tsv`) là **nguồn duy nhất** cho map slug → bucket; gate 7 của `qa.sh` so nó với cây thư mục, nên mọi lần đổi bucket phải sửa cả hai.
- Sau khi move: chạy `node plan-update/scripts/linkcheck.js` (phải 0 gãy).
- Mọi khẳng định "docs nói vậy" trong bài/slug đều có URL ở `plan-update/02-chuan-doi-chieu-docs.md`; khi verify trái với docs, ghi rõ "docs nói X · thực tế Y (ngày đo)" vào `02` rồi mới sửa nội dung — tránh sửa theo một lần đo may rủi.

- **Chốt W5c/W5e + đồng bộ (11/11):** 30 file `.sh` trong `commands/**/examples` bỏ dấu thanh ở dòng comment (giữ ký hiệu ✨💡→❌✅); bảng group README + bài 04 + CHEATSHEET + FAQ 01 đồng bộ về luồng docs mới — `Ctrl+N` (mở chat), ✨ ô commit message / ✨ Create PR view, Terminal Inline Chat `Ctrl+I`, `/limits`+`/usage` thay `/cost`, `/new` = scaffold workspace/file/notebook (không phải mở chat), `gh copilot` ghi nhãn extension cộng đồng đã archived.
