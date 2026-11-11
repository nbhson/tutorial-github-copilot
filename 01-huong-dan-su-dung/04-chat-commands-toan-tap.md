# 04 — Chat Commands Toàn Tập (Bảng Tra Cứu Slash Của Cả Series)

> **Dành cho:** người mới lẫn dev đã dùng Copilot — bài này là index slash commands dùng chung cho cả series.
> **Vấn đề:** gõ prompt tự nhiên dài dòng, tốn turns để làm rõ, và không biết lệnh nào *tồn tại trên surface nào*.
> **Đọc xong:** tra đúng nhóm lệnh + cột availability theo docs, chạy được công thức 5 lệnh mở repo, tự giải thích khi một lệnh "biến mất".
> **Cách dùng:** tìm nhóm → đọc 1 dòng mô tả → click link sang `commands/<bucket>/<nhóm>/<lệnh>/README.md` (vd `commands/copilot/chat-session/clear/`). **Thời gian:** ~20 phút đọc + tra cứu dần.

## Mục tiêu bài học

Bài này để **tra**, không phải để thuộc — đọc xong bạn cần làm được bốn việc.

- Phân đúng ký hiệu: `/` chạy lệnh, `#` gắn file/vùng chọn, `Chat: …` là lệnh palette — và vì sao `@` participants đã deprecated.
- Tra được **4 bảng nhóm + bảng slash chính thức hay bị bỏ sót (mục 6)**, availability chép nguyên văn docs VS Code.
- Chạy được **công thức 5 lệnh session đầu** và walkthrough Ask → Plan → Agent trên repo thật.
- Tự debug khi một lệnh vắng mặt: đúng availability, bị plan/org khoá, hay lệnh chưa từng tồn tại.

> **Tóm gọn 1 câu:** đây là từ điển slash — tìm nhóm, đọc cột availability, rồi hãy gõ; đừng nhớ lệnh bằng trí giác.

---

## 1. Cách đọc index này

**Là gì (1 câu):** commands là đường tắt đã kiểm chứng — `/` gọi lệnh như đọc số món, `#` đưa đúng hóa đơn cho người phục vụ xem, còn `Chat: …` là những việc docs không cho một slash tương ứng.

> **⚠️ Đọc trước khi tra nhóm lệnh "tùy biến" (nguyên văn docs VS Code):** ở **Copilot harness**, `/agents` `/instructions` `/skills` **KHÔNG có trong Chat view** — quản lý bằng **Agent Customizations editor** (lệnh `Chat: Open Customizations`); chỉ `/prompts` và `/hooks` là có ở Copilot. `/skills` và `/create-skill` chỉ là shortcut của **Local harness**.
> `@` participants (`@workspace`, `@terminal`) đã **deprecated, không được Copilot harness hỗ trợ** — thay bằng `#`-mentions, nút **Add Context**, hoặc để agent tự gather ngữ cảnh repo → [participants](commands/local/model-agent/participants/README.md).

Docs ghi nguyên văn: *"Type `/` to see commands available in the current session. Availability depends on the chat surface, harness, role, and enabled features."* — mọi cột **Availability** bên dưới theo câu đó. **Vì sao phải học?** Prompt tự nhiên linh hoạt nhưng tốn token và thiếu determinism (cùng một yêu cầu, mỗi lần model hiểu một kiểu); lệnh gắn đúng scope ngay turn 1, rẻ hơn 3–5 turns hỏi lại — mẫu dán thẳng vào Chat (biến thể file `.prompt.md` có frontmatter `mode`/`tools` — chạy ở Local: [`templates/.github/prompts/review-pr.prompt.md`](../templates/.github/prompts/review-pr.prompt.md)):

```text
#file:src/routes/orders.ts #selection fix crash khi thieu customerId,
them regression test, chay npm test xac nhan.
```

Phím chính thức (bảng đầy đủ ở [shortcuts](commands/copilot/chat-session/shortcuts/README.md)): mở Chat view `Ctrl+Alt+I` (macOS `⌃⌘I`) · chat mới `Ctrl+N` (`⌘N`) · inline chat trong editor **và** terminal `Ctrl+I` (`⌘I`) · **Quick Chat `Ctrl+Shift+Alt+L`** (`⇧⌥⌘L`).

> **Tóm gọn 1 câu:** gõ `/` để xem, `#` để gắn — và đọc availability trước khi đổ lỗi cho công cụ.

## 2. Nhóm 1 — Chat session (7)

Vòng đời một phiên chat: mở, tìm lại, lưu, quay lui — như giấy tờ trên bàn làm việc.

| Lệnh / thao tác | Là gì (nôm na) | Availability | Chi tiết |
|---|---|---|---|
| `Ctrl+N` / nút `+` | Chat mới sạch cho task kế tiếp (`/new` **không phải** việc này — `/new` ở nhóm 3) | mọi surface | [new-chat](commands/copilot/chat-session/new-chat/README.md) |
| `/clear` | Mở chat mới + archive/mark chat hiện tại là done | chat reference | [clear](commands/copilot/chat-session/clear/README.md) |
| **Panel Session History** · **Resume in Terminal** | Mở lại chat cũ và tiếp nối phiên trước — chưa từng có slash cho hai việc này (CLI: `copilot --continue`) | Chat view / Agents window · terminal | [history](commands/copilot/chat-session/history/README.md) · [resume](commands/copilot/chat-session/resume/README.md) |
| **`Chat: Export Chat…`** | Lưu hội thoại ra file để share | Command Palette | [export](commands/local/chat-session/export/README.md) |
| `Ctrl+I` · Quick Chat `Ctrl+Shift+Alt+L` | Inline chat ngay tại dòng code đang chọn · hỏi nhanh không rời editor | editor + terminal · Chat view | [inline-chat](commands/copilot/chat-session/inline-chat/README.md) · [quick-chat](commands/copilot/chat-session/quick-chat/README.md) |
| **Restore Checkpoint** | Khôi phục file + history tại một request; **không** hoàn tác terminal/deploy | `chat.checkpoints.enabled` default on | [checkpoints](commands/copilot/chat-session/checkpoints/README.md) |
| **Add Context** · `#file` `#selection` · kéo-thả | Gắn file, vùng chọn, ảnh, output lỗi, issue | mọi surface | [attachments](commands/copilot/chat-session/attachments/README.md) |

## 3. Nhóm 2 — Model & Agent (8)

Đổi "động cơ" (model), "người làm" (agent), "nơi chạy" (Session Target) — bản chất harness ở bài 02 §3.1.

| Lệnh / thao tác | Là gì (nôm na) | Availability | Chi tiết |
|---|---|---|---|
| **Model picker** | Đổi model giữa chat (mạnh/rẻ tùy task) | menu trên ô chat; `/models` = "a local chat", CLI là `/model` | [model-picker](commands/copilot/model-agent/model-picker/README.md) |
| **Ask · Plan · Agent** | built-in agents: chỉ hỏi · research rồi đề xuất plan · tự sửa và chạy lệnh | built-in của Copilot harness | [Ask](commands/copilot/model-agent/ask-mode/README.md) · [Plan](commands/copilot/code-actions/plan/README.md) · [Agent](commands/copilot/model-agent/agent-mode/README.md) |
| **Edit** | Sửa các file bạn tự chọn | mode riêng của **Local harness**; Copilot thay bằng Plan/Agent | [edit-mode](commands/local/model-agent/edit-mode/README.md) |
| **Custom agent** | Agent riêng trong `.github/agents/` (bài 06) | Local: `/agents`; Copilot: Customizations editor + picker | [custom-agent](commands/copilot/model-agent/custom-agent/README.md) |
| **Session Target — Choose a harness** | Chọn harness + nơi session chạy | picker trong Chat view / Agents window | [session-target](commands/copilot/model-agent/session-target/README.md) |
| **Permission level** | Duyệt/cho phép lệnh nhạy cảm: Manual · Assisted · Allow all (bài 10) | Copilot harness | [policy-approval](commands/copilot/model-agent/policy-approval/README.md) |
| **AI Credits** | Xem tiêu phí của account/plan | dashboard `github.com/settings/copilot` · CLI `/limits` | [ai-credits](commands/copilot/model-agent/ai-credits/README.md) |
| **Copilot cloud agent** · cloud session | Giao issue trên GitHub.com → agent làm async, mở PR; hoặc chạy phiên trên hạ tầng GitHub (`feature(cloud-sessions)`) | GitHub.com — **không phải slash trong editor**; cloud là execution target, không phải harness | [assign](commands/cloud/model-agent/coding-agent-assign/README.md) · [PR](commands/cloud/model-agent/coding-agent-pr/README.md) · [cloud-agent-session](commands/cloud/model-agent/cloud-agent-session/README.md) |

## 4. Nhóm 3 — Code actions (6)

Việc nhỏ một bước trên code đang chọn: bôi đen rồi gọi lệnh, khỏi mô tả dài dòng.

| Lệnh / thao tác | Là gì (nôm na) | Availability | Chi tiết |
|---|---|---|---|
| `/explain` `/fix` `/tests` | Giải thích / sửa / sinh test cho selection (`/setupTests` = Experimental) | chat reference — nhóm "editor" | [explain](commands/copilot/code-actions/explain/README.md) · [fix](commands/copilot/code-actions/fix/README.md) · [tests](commands/copilot/code-actions/tests/README.md) |
| `/doc` | Sinh docstring cho hàm | **từ editor inline chat** | [doc](commands/copilot/code-actions/doc/README.md) |
| `/new` · `/newNotebook` | **Scaffold** workspace, file hoặc notebook (KHÔNG phải "mở chat mới") | chat reference | [new](commands/copilot/code-actions/new/README.md) |
| **Optimize · Refactor** | Tối ưu perf / cấu trúc lại mà giữ behavior | inline chat `Ctrl+I` và lightbulb — docs **không có** slash `/optimize` `/refactor` | [optimize](commands/copilot/code-actions/optimize/README.md) · [refactor](commands/copilot/code-actions/refactor/README.md) |
| **✨ cạnh ô commit message** · **✨ cạnh ô title trong Create Pull Request view** | Sinh commit message từ diff đã stage · sinh PR title + body từ diff (docs 11/2026 dạy nút ✨, utility model `chat.utilitySmallModel`; PR template tự điền) | Source Control · Pull Requests view | [commit-message](commands/copilot/code-actions/commit-message/README.md) · [pr-desc](commands/copilot/code-actions/pr-desc/README.md) |
| **Lỗi terminal → `Ctrl+I`** | Biến log đỏ thành task cho agent (thao tác, **không phải** `@terminal`) | inline chat trong terminal | [debug-terminal](commands/copilot/code-actions/debug-terminal/README.md) |

## 5. Nhóm 4 — System & Knowledge (8)

"Hậu trường": cái gì đang được nạp, cắm thêm công cụ gì, chặn gì. docs VS Code: *"In the Chat view, all are available with **Local**. Only `/prompts` and `/hooks` are available with **Copilot**."*

| Lệnh / thao tác | Là gì (nôm na) | Availability | Chi tiết |
|---|---|---|---|
| `/instructions` · `/skills` · `/agents` · `/prompts` · `/hooks` (+ `/create-agent` `/create-instructions` `/create-skill` `/create-prompt` `/create-hook`) | Cấu hình / sinh customization type tương ứng; riêng file `.prompt.md` mà `/prompts` liệt kê **chỉ chạy ở Local harness** | Chat view: **Local có tất cả; Copilot chỉ `/prompts` và `/hooks`**; `/create-*` = "in a local agent session" → Copilot dùng **`Chat: Open Customizations`** | [instructions](commands/copilot/system-knowledge/instructions/README.md) · [agent-skill](commands/copilot/system-knowledge/agent-skill/README.md) · [prompt-file](commands/local/system-knowledge/prompt-file/README.md) · [custom-agent](commands/copilot/model-agent/custom-agent/README.md) |
| **MCP servers** | Xem/thêm server và tool | Copilot đọc `.mcp.json` (root) + `~/.copilot/mcp-config.json`; docs **không có** slash `/mcp` | [mcp](commands/copilot/system-knowledge/mcp/README.md) · [add](commands/copilot/system-knowledge/mcp-add/README.md) · [`.vscode/mcp.json` = Local](commands/local/system-knowledge/vscode-mcp-json/README.md) — 📄 file mẫu 3 transports: [`examples/01-cach-goi-copy-paste.sh`](commands/local/system-knowledge/vscode-mcp-json/examples/01-cach-goi-copy-paste.sh)+[`02-vi-du-that.sh`](commands/local/system-knowledge/vscode-mcp-json/examples/02-vi-du-that.sh) |
| **Copilot connectors** | MCP do GitHub quản lý, cấp tool cho harness | **chỉ Copilot harness** — editor → Connect | [connector](commands/copilot/system-knowledge/connector/README.md) |
| **Content exclusion** | File Copilot không được đọc | github.com → Settings; áp dụng cả Copilot in the cloud + code review + CLI | [content-exclusion](commands/cloud/system-knowledge/content-exclusion/README.md) |
| **Copilot status dashboard** · CLI `/status` · Telemetry | Account, plan, usage + consent gửi code telemetry | github.com/settings/copilot · Copilot CLI; OTel chạy cho **cả** Local & Copilot (bài 13) | [status](commands/copilot/system-knowledge/status/README.md) · [login](commands/copilot/system-knowledge/login/README.md) · [logout](commands/copilot/system-knowledge/logout/README.md) · [telemetry](commands/copilot/system-knowledge/telemetry/README.md) |
| **`Chat: Provide Feedback…`** | Gửi feedback về một câu trả lời | Command Palette | [bug-feedback](commands/copilot/system-knowledge/bug-feedback/README.md) |
| **Enterprise knowledge base** | Hỏi tri thức team (docs, wiki) ngay trên GitHub.com | GitHub.com (Enterprise) | [knowledge-base](commands/cloud/system-knowledge/knowledge-base/README.md) |
| `gh copilot suggest` / `explain` | Gợi ý / giải thích lệnh shell | terminal — **extension cộng đồng của GitHub CLI**, không thuộc docs nào | [suggest](commands/local/system-knowledge/cli-suggest/README.md) · [explain](commands/local/system-knowledge/cli-explain/README.md) |

> Copilot Extensions (GitHub App, gọi bằng `@`) đã **retired 10/11/2025** — đường mở rộng hiện hành là Agent Plugins (mục 6) + MCP + connectors → [bài 09](./09-extensions-marketplaces.md).

## 6. Slash chính thức hay bị bỏ sót (availability chép nguyên văn docs VS Code)

| Lệnh | Mục đích (docs) | Availability | Chi tiết |
|---|---|---|---|
| `/plan` | research + đề xuất plan | Copilot & Claude (Local có **Plan agent**) | [plan](commands/copilot/code-actions/plan/README.md) |
| `/compact` | nén ngữ cảnh hội thoại | Local, Copilot, Claude | [compact](commands/copilot/chat-session/compact/README.md) |
| `/fork` · `/fork <title>` · `/fork prompt <…>` | fork hội thoại kèm history | cần **Agent Host session** được hỗ trợ | [fork](commands/copilot/chat-session/fork/README.md) |
| `/btw <câu hỏi>` | side chat ngoài lề | **không có ở Local** & Codex-extension | — |
| `/models` · `/tools` | mở model picker / cấu hình tools | "a local chat" | [model-picker](commands/copilot/model-agent/model-picker/README.md) |
| `/init` | sinh/cập nhật workspace instructions | "a local agent session" | [instructions](commands/copilot/system-knowledge/instructions/README.md) |
| `/troubleshoot` · `/debug` | phân tích debug logs · mở Chat Debug view | local **hoặc Copilot CLI session** · `/debug` ở Chat view, **không phải Agents window** | [troubleshoot](commands/copilot/chat-session/troubleshoot/README.md) |
| `/sandbox policy` | xem effective sandbox policy | **Copilot session** | [sandbox-policy](commands/copilot/model-agent/sandbox-policy/README.md) |
| `/yolo` · `/autoApprove` (+ `/disableYolo` `/disableAutoApprove`) | permission / Autopilot (bài 10) | "supported local or Copilot CLI session" | [policy-approval](commands/copilot/model-agent/policy-approval/README.md) |
| `/rename <name>` · `/help` | đổi tên / liệt kê lệnh + agent | "a local chat" · "a local **Ask** chat" | [help](commands/local/chat-session/help/README.md) |
| `/plugin list\|install\|update\|enable\|disable\|uninstall\|marketplace add\|browse\|remove` | quản lý Agent Plugins (bài 17) | **chỉ Copilot harness session** | [plugins](commands/copilot/system-knowledge/plugins/README.md) |
| `/<skill-name>` (vd `/webapp-testing`) | gọi agent skill / reusable prompt theo tên | mọi harness (skill) — bài 05 | [agent-skill](commands/copilot/system-knowledge/agent-skill/README.md) |

> **Tóm gọn 1 câu:** lệnh có trong docs mà không thấy trong list của bạn thì gần như luôn là **đúng availability rồi**, không phải bug.

## 7. Công thức 5 lệnh session đầu — chỉ dùng lệnh có trong index (làm 1 lần/repo)

Nghi thức "khai trương" repo, giống kiểm tra máy trước khi lái đường dài:

1. `Ctrl+Alt+I` mở Chat → chốt **model** + **Session Target** (nhóm 2) — biết mình đang chạy harness nào.
2. **`Chat: Open Customizations`** → xem repo đang nạp gì: instructions, skills, MCP, hooks (bài 03/05/08).
3. **`/sandbox policy`** trong một Copilot session → đọc effective policy; phía org xem **settings → policies** (bài 10/16).
4. **`/plan`** với task thật đầu tiên → để agent research + đề xuất plan, duyệt rồi mới cho sửa.
5. **`/clear`** khi đổi task; session dài mà còn liên quan thì **`/compact`** — conversation "đuối" là tín hiệu cần nén.

## 8. Walkthrough: sửa một bug bằng lệnh (10 phút)

```text
# Buoc 1 - Ask (hieu truoc, dung sua): chon built-in agent "Ask" tren picker
Repo nay POST /orders nam o dau, lenh dev/test/lint la gi? #file:package.json

# Buoc 2 - task mo, sua nhieu file: /plan research + de xuat plan, duyet xong moi sang Agent
/plan Trong apps/api, POST /orders crash khi thieu customerId. Tim root cause,
fix, them regression test, chay npm test xac nhan.

# Buoc 3 - viec nho tren selection: boi den ham -> Ctrl+I -> /explain roi /fix
# (dung mo Agent cho viec mot dong); doi task: /clear, dan dai ma con lien quan: /compact
/fix them null check cho params, giu nguyen API shape
```

Git flow (✨ ở ô commit message, ✨ ở Create Pull Request view — bản palette `Chat: Commit Staged…`/`Pull: Create PR…` có thể vẫn còn trong một số build), lỗi terminal bằng Terminal Inline Chat và bản tương đương khi đứng ở shell (`copilot -p "…"`, `copilot --continue`) — `gh copilot` là extension cộng đồng đã archived, không phải đường hiện hành (xem `commands/local/system-knowledge/cli-suggest/`) xem ở 📄 [`./examples/04-chat-commands-toan-tap/git-flow-va-lenh-terminal.sh`](./examples/04-chat-commands-toan-tap/git-flow-va-lenh-terminal.sh).

## 9. Khi lệnh hoặc model "biến mất"

- **Đọc availability trước, nghi gating sau:** `/plugin` chỉ Copilot harness session; `/help` `/rename` `/models` `/tools` chỉ local chat; trong nhóm customization, Copilot chỉ có `/prompts` và `/hooks`.
- **Model & AI Credits:** model mạnh tiêu phí nhiều hơn. Billing hiện hành là **AI Credits** (1 credit = $0.01, trừ theo token; code completions **không** bị trừ) — hết thì đổi model rẻ ở picker, xem dashboard, CLI `/limits` (bài 14).
- **Org policy & BYOK:** managed settings có thể khoá model/harness/customization — kiểm chứng bằng `Developer: Policy Diagnostics` (bài 10/16).
- **Flow 30 giây:** gõ `/` xem list thật → `Chat: Open Customizations` xem gì đang nạp → so cột availability mục 6 → vẫn mờ thì `/troubleshoot` (local hoặc Copilot CLI).

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| "`/` `@` `#` là một nhà, dùng cái nào cũng được" | `@` không chạy ở Copilot harness → prompt im lặng mất ngữ cảnh | `/` chạy lệnh, `#` gắn file/selection; participants đã deprecated → Add Context hoặc để agent tự gather |
| "Gõ `/new` để mở chat mới" | nhận về một workspace/file/notebook scaffold, không phải chat trắng | chat mới: `Ctrl+N` hoặc `/clear`; `/new` = scaffold (nhóm 3) |
| "Kênh customization nào cũng có slash" | gõ `/instructions` `/skills` ở Copilot session → không thấy, tưởng hỏng | Copilot: **Agent Customizations editor** (`Chat: Open Customizations`); các slash đó là của Local |
| "`/history` `/export` `/resume` bị gỡ khỏi Copilot" | đi tìm slash chưa từng tồn tại | dùng panel **Session History**, `Chat: Export Chat…`, **Resume in Terminal** / `copilot --continue` |
| "Lệnh vắng mặt là Copilot hỏng" | mất nửa ngày debug công cụ | availability theo surface/harness/role/enabled features — tra mục 6 trước |
| "Việc một dòng cũng mở Agent" | Agent đọc chục file, đốt credits oan | `/explain` `/fix` trên selection; việc mở → `/plan` rồi mới Agent |

**Bài học:** bảng slash nào cũng có cột availability — đọc nó rẻ hơn đọc debug log.

## Best practices

- **Gắn `#file:`/`#selection` ngay turn 1.** *Vì sao?* tiết kiệm nguyên một turn agent quét repo đoán file — loại token rẻ nhất là token không phải trả.
- **`/clear` mỗi task; dài mà còn liên quan → `/compact`; muốn thử hướng khác từ conversation cũ → `/fork` (cần Agent Host session).** *Vì sao?* context sạch giảm "hallucination thừa kế", compact giữ đà mà rẻ, fork giữ history cho cả hai nhánh.
- **Tra cột availability trước khi kết luận lệnh mất; việc chạm nhiều file luôn bắt đầu bằng `/plan`; repo mới thì chạy công thức mục 7 một lần.** *Vì sao?* quá nửa "bug reported" là tra nhầm chỗ, một plan sai sửa 10 file khó hoàn tác hơn chạy lại lần hai, và lỗi gating phát hiện trong 5 phút rẻ hơn 5 ngày (org đông người: thêm `Developer: Policy Diagnostics`).

## Bài tập

1. **(10 phút) Phím:** mở Chat view, chat mới, inline chat (editor và terminal), Quick Chat bằng đúng 4 phím mục 1 — ghi lại mỗi phím mở surface nào (Quick Chat là `Ctrl+Shift+Alt+L`, **không phải** `Ctrl+Alt+I`).
2. **(20 phút) Inventory + break-in repo:** gõ `/` liệt kê lệnh máy bạn **thật sự có**, so với mục 2–6 và ghi lý do cho lệnh thiếu theo cột availability; sau đó chạy công thức 5 lệnh mục 7 trên repo thật, mỗi bước ghi 1 câu output, đọc effective policy của `/sandbox policy`.
3. **(10 phút) Git flow:** làm theo 📄 [`./examples/04-chat-commands-toan-tap/git-flow-va-lenh-terminal.sh`](./examples/04-chat-commands-toan-tap/git-flow-va-lenh-terminal.sh) — liệt kê thao tác nào đúng ngay, thao tác nào phải sửa tay.

## Link qua

- **Bảng mapping Copilot ↔ Claude Code** → bài 00 (chủ sở hữu so sánh). · Harness & bề mặt, Session Target → bài 02. · File đứng sau `/instructions` → bài 03.
- Agent Skills và gọi `/<skill-name>` → bài 05. · Custom agents (`/agents` + picker) → bài 06. · Hooks → bài 07. · MCP & connectors → bài 08.
- Permission levels, Autopilot → bài 10. · Checkpoint & `/fork` → bài 11. · CLI `/usage` `/limits`, `copilot --continue` → bài 12. · Agent Plugins → bài 17. · Copilot Extensions **đã retired 10/11/2025** → [bài 09](./09-extensions-marketplaces.md).

## Reference

- VS Code — [AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) (nguồn duy nhất cho bảng slash + phím) · [Add context](https://code.visualstudio.com/docs/chat/copilot-chat-context) · [Tools reference](https://code.visualstudio.com/docs/agents/reference/tools-reference) · [Manage sessions](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions) (`/compact`, `/fork`) · [Inline chat](https://code.visualstudio.com/docs/chat/inline-chat) · [Agent Customizations editor](https://code.visualstudio.com/docs/agent-customization/overview)
- VS Code — [Prompt files](https://code.visualstudio.com/docs/agent-customization/prompt-files) · [Agent plugins](https://code.visualstudio.com/docs/agent-customization/agent-plugins) · [Approvals & permission levels](https://code.visualstudio.com/docs/agents/run/approvals) (kèm lệnh permission/Autopilot) · [Agent sandboxing](https://code.visualstudio.com/docs/agents/run/agent-sandboxing) (`/sandbox policy`) · [Migrate customizations](https://code.visualstudio.com/docs/agent-customization/migrate-customizations) (participants deprecated) · [Move to Copilot harness](https://code.visualstudio.com/docs/agents/run/move-to-copilot)
- GitHub — [Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference) (`/status`, `/cost`) · [Models and pricing — AI Credits](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) · [About Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent)

**Chốt:** bài 04 để **mở ra tra**, không để đọc hết — tìm nhóm → đọc availability → gõ lệnh; và bạn thôi trả tiền cho những turn "file nào nhỉ?".
