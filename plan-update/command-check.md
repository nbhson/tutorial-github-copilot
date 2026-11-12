# command-check — Audit lệnh trong `01-huong-dan-su-dung/commands/` so với docs hiện tại

> Ngày chạy: **2026-11-12** · Giờ UTC: theo docs tải về.
> Quy tắc: **không đoán** — mỗi kết luận có kèm mệnh đề đối chiếu docs; nguồn là bản markdown tải trực tiếp hôm nay:
> - [VS Code — AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet.md) (184 dòng, lấy 2026-11-12)
> - [GitHub Docs — Copilot CLI command reference](https://raw.githubusercontent.com/github/docs/main/content/copilot/reference/copilot-cli-reference/cli-command-reference.md) (1807 dòng, lấy 2026-11-12)

## 1. Trạng thái thư mục (đo thật trên đĩa)

- Slug README trên đĩa: **57** (copilot 43 · local 8 · cloud 6).
- `bucket.tsv`: **58 dòng** = 57 slug trên đĩa + dòng `extensions … REMOVE` (đã không còn thư mục trên đĩa — nhất quán).
- `commands/README.md` tự nhận "57 lệnh" → khớp số đĩa.

## 2. Kết quả rà soát lệnh "chết" / "thiếu" (điểm chính)

| # | Slug | Trạng thái docs hiện tại | Kết luận |
|---|---|---|---|
| 1 | `copilot/system-knowledge/status` | CLI ref **không có `/status`** — chỉ có `/statusline`, `/footer`, `/usage`, `/session info` | ⚠️ **Sai claim trong plan 04 §95** ("docs có `/status` CLI") → gắn nhãn: VS Code = status dashboard; CLI = `/usage` + `/session info` |
| 2 | `copilot/model-agent/ai-credits` (`premium-requests→ai-credits`) | `/usage` là tên đúng; **không có `/cost`** (plan 04 §96 ghi "→ `/cost`" là sai) | ⚠️ sửa ref thành `/usage` + `--max-ai-credits` + `/limits` |
| 3 | `copilot/system-knowledge/extensions` | đã REMOVE trong tsv, không có thư mục | ✅ không có gì phải làm thêm |
| 4 | `local/chat-session/help` | cheat sheet: `/help` gắn "… in a **local** Ask chat" | ✅ đúng Local |
| 5 | `local/chat-session/export` | VS Code: `Chat: Export Chat…` (palette, chưa xác nhận cho Copilot session); CLI có **`/export`** = alias `/share` | ⚠️ ghi rõ "Local chat + CLI alias", không khẳng định Copilot session |
| 6 | `copilot/chat-session/compact` | cheat sheet + CLI đều có `/compact` | ✅ đúng |
| 7 | `copilot/code-actions/plan` | cheat sheet + CLI đều có `/plan` | ✅ đúng |

## 3. Lệnh CÓ trong docs hiện tại nhưng CHƯA có slug (cần THÊM)

> Đây là phần "lệnh thiếu thì thêm". Nhóm theo bề mặt docs xác nhận.

### 3a. CLI interactive (`/` trong `copilot` session) — chưa có slug

| Lệnh CLI | Nguồn (dòng cli-reference) | Gợi ý nhóm |
|---|---|---|
| `/usage` (metrics/token, AIC) | 642 | model-agent (`ai-credits`) |
| `/context` (context window visualization) | 570 | chat-session |
| `/env` (environment details đang nạp) | 577 | system-knowledge |
| `/session` `/sessions` (info/checkpoints/…/delete) | 625 | chat-session (`resume`) |
| `/settings` `/config` (show/set, `--repo/--local`) | 626 | system-knowledge |
| `/permissions [default\|assisted\|allow-all\|show]`, `/permissions reset` | 598-599 | model-agent (`policy-approval`) |
| `/limits set max-ai-credits`, `/limits unset` | 589-591 | model-agent (`ai-credits`) |
| `/sandbox config/status/policy/enable/disable` + `/sandbox ca` | 621-622 | model-agent (`sandbox-policy`) |
| `/skills list/info/add/remove/reload` | 628-633 | system-knowledge (`agent-skill`) |
| `/plugin` (dashboard/install/update/uninstall/marketplace) | 601-610 | system-knowledge (`plugins`) |
| `/worktree`, `/move`, `/diff`, `/undo` `/rewind`, `/search` `/find` | 649-651, 575, 640, 623 | chat-session / code-actions |
| `/review` (code review agent), `/security-review`, `/rubber-duck` | 620, 624, 620 | code-actions |
| `/delegate` (remote PR), `/pr view/create/fix/auto/automerge` | 573, 611 | code-actions (`pr-desc`) |
| `/research TOPIC` | 615 | system-knowledge |
| `/autopilot` `/goal`, `/every`, `/after`, `/changelog`, `/chronicle`, `/ask` `/btw` | 563, 578, 558, 564, 565, 561 | chat-session / model-agent |
| `/update` `/upgrade`, `/version`, `/restart`, `/user show/list/switch`, `/logout` | 641, 644, 617, 643, 594 | system-knowledge (`logout`) |
| `/fork` `/branch` (session fork), `/resume` `/continue` | 648, 618 | chat-session (`fork`/`resume`) |
| `/voice`, `/theme`, `/vim`, `/tasks`, `/terminal-setup`, `/keep-alive` `/caffeinate`, `/statusline` `/footer`, `/copy`, `/cwd` `/cd` | 646, 638, 645, 636, 637, 588, 634, 571, 572 | -- (tra cứu nhanh, ưu tiên P2) |

### 3b. VS Code Chat (cheat sheet) — chưa có slug

| Lệnh | Ghi chú docs | Gợi ý |
|---|---|---|
| `/setupTests` (Experimental) | cheat sheet: "Get help choosing and setting up a test framework" | code-actions (`tests`) |
| `/newNotebook` | cheat sheet: scaffold workspace/file/notebook | code-actions (`new`) |
| `/debug` | cheat sheet: "Open the Chat Debug view from the Chat view" | chat-session (`troubleshoot`) |
| `/tools` | cheat sheet: "configure tools for a local chat" | model-agent |
| `/create-agent` `/create-instructions` `/create-skill` `/create-prompt` `/create-hook` | cheat sheet: "in a local agent session" | → Local |
| `/<name>` (skill/prompt invoke) | cheat sheet | system-knowledge (`agent-skill`) |

## 4. Lệnh KHÔNG tồn tại trong docs hiện tại (cần XOÁ hoặc đổi claim — đã kiểm kê: không có slug nào chứng minh được là "chết hoàn toàn")

- Không tìm thấy nguồn docs nào trong 2 file cho: `/autoApprove`, `/history` (dạng slash), `/summarize` (đã rename `compact`), `/review-pr`, `/create-demo`, `/extensions` (retired). — Nhất quán với plan 04 §"Không tạo slug": các mục này **đã không còn** trong tree.

## 5. Độ lệch plan 04 so với docs NGÀY NAY (cần sửa khi chạy kế hoạch)

| Dòng plan 04 | Plan cũ nói | Docs hiện tại | Việc cần làm |
|---|---|---|---|
| §95 `status` | "/status có trong CLI" | **không có** `/status`; có `/statusline`, `/usage`, `/session info` | sửa kết luận, không đổi bucket |
| §96 `telemetry` | "/usage → CLI `/cost`" | **không có** `/cost`; đúng tên là `/usage` | sửa ref |
| § recipe W2 | move theo bucket cũ | slug `status`/`ai-credits` vẫn copilot → không đổi move | giữ nguyên |

## 6. So sánh với `PLAN_UPDATE.md` (đối chiếu hai bản audit)

> `PLAN_UPDATE.md` = audit gốc, **phạm vi VS Code Chat** ("current, Nov 2026"). `command-check.md` = bản này, mở rộng thêm lớp CLI. Điểm giống/khác:

### Khớp (không cần tranh cãi)
- 57 slug (43/8/6) + `extensions` REMOVE — khớp đĩa.
- VS Code THIẾU chung: `/setupTests`, `/rename`, `/init` (chưa có slug riêng), `/create-agent` `/create-instructions` `/create-skill` `/create-prompt` `/create-hook`, `/debug`, `/btw`.
- Copilot OK chung: `/plan` `/compact` `/fork` `/clear` `/sandbox policy` `/plugin` `/prompts` `/hooks` `/yolo`(policy-approval).
- Nguyên tắc: giữ cấu trúc folder; sửa metadata/index trước, tránh gãy link.

### Lệch — dung hòa
| Vấn đề | PLAN_UPDATE.md | Bản này (docs tải 2026-11-12) | Xử lý |
|---|---|---|---|
| Phạm vi | VS Code Chat; `/settings` `/config` = ngoài phạm vi | đưa CLI vào (mục 3a) | mở rộng riêng lớp CLI — không đụng kết luận của PLAN |
| `/explain` `/fix` `/tests` `/doc` `/new` | ⚠️ observed Local-only / smart-action UI | cheat sheet vẫn list (mâu thuẫn) | chốt theo PLAN (đã test thật) → giữ slug, gắn "check bằng `/` trên máy" |
| `/agents` `/instructions` `/skills` `/troubleshoot` | Local-only | Chat view: đúng Local; CLI vẫn có `/skills` `/instructions` `/agent` `/subagents` (587,635,559) | "Local-only" = Chat view; CLI có bản riêng |
| `/init`, `/rename` | thiếu / ghi chú | CLI có `/init` (586), `/rename` (614) | thêm vào danh sách THIẾU lớp CLI |

### Kết luận scope (đề xuất)
1. **Không xoá** slug nào (không có lệnh nào chứng minh "chết hoàn toàn" trong docs hiện tại).
2. **Thêm** theo danh sách gộp: VS Code (`setupTests`, `rename`, `init`, `create-*`, `debug`, `btw`) + CLI (xem §3a).
3. **Sửa claim**: `status` (bỏ `/status` → `/usage` + `/session info`), `ai-credits` (`/usage`, không phải `/cost`), `export` (Local chat + CLI alias `/share`).


## 7. Kế thừa từ `PLAN_UPDATE.md` (gộp để xoá file này — không mất thông tin)

> Đây là toàn bộ nội dung phân loại của `PLAN_UPDATE.md` (được giữ nguyên, đã đối chiếu ở §6).

### 7.1 Bảng đối chiếu slash chính thức VS Code Copilot ↔ slug repo

| Slash chính thức (docs) | Slug repo | Trạng thái |
|---|---|---|
| `/plan` | `plan` | ✅ copilot |
| `/explain` `/fix` `/tests` | `explain` `fix` `tests` | ⚠️ observed Local-only / smart action UI |
| `/doc` | `doc` | ⚠️ inline chat smart action |
| `/setupTests` (Exp) | — | ❌ THIẾU — cần thêm |
| `/new` `/newNotebook` | `new` | ⚠️ smart action |
| `/compact` | `compact` | ✅ |
| `/fork` | `fork` | ✅ |
| `/clear` | `clear` | ✅ |
| `/rename <name>` `/help` | `help` (local) | ⚠️ `rename` THIẾU — cần thêm |
| `/models` `/tools` | `model-picker` | ⚠️ slash chỉ local chat |
| `/init` | — (gộp vào `instructions`) | ⚠️ chưa có slug riêng — cần thêm hoặc ghi chú |
| `/agents` `/instructions` `/skills` | `custom-agent` `instructions` `agent-skill` | ❌ Local-only (đã ghi chú Harness: Local) |
| `/prompts` `/hooks` | `prompt-file` `hooks` | ✅ Copilot |
| `/create-agent` `/create-instructions` `/create-skill` `/create-prompt` `/create-hook` | — | ❌ THIẾU — cần thêm |
| `/troubleshoot` | `troubleshoot` | ❌ Local-only (đã ghi chú) |
| `/debug` | — | ❌ THIẾU — cần thêm |
| `/sandbox policy` | `sandbox-policy` | ✅ Copilot |
| `/<name>` (skill/prompt) | `agent-skill` | ✅ |
| `/btw` | — | ❌ THIẾU (side chat) — cần thêm |
| `/yolo` `/autoApprove` | `policy-approval` | ✅ (gộp) |
| `/plugin ...` | `plugins` | ✅ Copilot |
| `/settings` `/config` (CLI) | — | ngoài phạm vi VS Code (CLI) — xem §3a |

### 7.2 Nguyên tắc audit (kế thừa nguyên văn)

- Không đoán: mọi thay đổi phải đối chiếu docs chính thức hoặc test thực tế; ghi rõ nguồn.
- Availability phụ thuộc surface/harness/role/tính năng — luôn khuyến nghị gõ `/` để kiểm tra máy thật.
- Giữ nguyên cấu trúc folder hiện tại cho đến khi xác nhận harness, chỉ sửa metadata trước để tránh gãy link.

