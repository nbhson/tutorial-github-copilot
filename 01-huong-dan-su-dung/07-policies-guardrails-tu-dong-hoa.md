# 07 — Policies & Guardrails Tự Động Hóa: Hooks + Các Lớp Ngoài Model (Chuẩn 2026)

> **Dành cho:** dev muốn "ép" Copilot tuân thủ quy tắc, và tech lead/admin dựng chuẩn cho team.
> **Vấn đề:** instructions là dặn miệng — model quên khi context dài; còn khoá thật phải chạy **ngoài** model. Bản cũ của bài này dạy "hooks preview, chỉ chạy Local": **sai** — docs mô tả hooks rất đầy đủ và chúng chạy ở Copilot CLI lẫn Copilot in the cloud.
> **Đọc xong:** viết được hook `preToolUse` đúng schema docs, hiểu exit code `2` = deny, và xếp mọi quy tắc vào đúng tầng: advisory → hook → server. **Thời gian:** ~35 phút.

## Mục tiêu bài học

Mục này cho bạn biết 35 phút nữa sẽ mang được gì về — như checklist trước khi khoá cổng.

- Viết được file hook `.github/hooks/*.json` đúng schema docs: `hooks` là **object keyed by event**, lọc bằng `matcher` — **không có field `if`**.
- Nói đúng hooks chạy ở đâu: Copilot CLI (đủ event) · Copilot in the cloud (subset) · Copilot app · VS Code (**Preview**) — và subset trên cloud chặt những gì.
- Dùng đúng mã quyết định: exit `2` = deny ở `preToolUse`/`permissionRequest`; `preToolUse` fail-closed nhưng **timeout luôn fail-open**.
- Xếp quy tắc vào stack 3 tầng (advisory / hook / law) và biết rule nào đã tới lúc nâng lên lớp server.

> **Tóm gọn 1 câu:** Rule nào bị quên 2 lần thì nâng tầng — từ dặn miệng lên hook chặn tool call, từ hook lên khoá server; docs đã mô tả hook đủ chi tiết để bạn không cần "hy vọng model nghe lời".

---

## 1. Hooks là gì — và chạy ở đâu (không phải "chỉ Local")

**Nôm na 1 câu:** Hook = chuông khói gắn vào vòng lặp agent: khói lên là còi tự kêu, không cần ai nhớ dặn. Docs định nghĩa: *"external commands that execute at specific lifecycle points during a session"* — khác instructions ở chỗ hook **chạy code thật**, không xin model tuân thủ.

| Surface | Hooks | Ghi chú theo docs |
|---|---|---|
| **Copilot CLI** | ✓ | đủ mọi event; chạy trên máy bạn, cùng shell với CLI |
| **Copilot in the cloud** | ✓ (subset) | chạy trong Linux sandbox ephemeral của mỗi job |
| **GitHub Copilot app** | ✓ | nhận repo hooks + hooks từ plugin |
| **VS Code** | **Preview** | cùng format với CLI; tạo/quản lý qua Agent Customizations editor |

**Subset trên Copilot in the cloud chặt gì** (docs ghi rõ từng dòng): chỉ `.github/hooks/*.json` trong repo được load (không có file user, không plugin); chỉ `bash`/`command` được tôn trọng (`powershell` bỏ qua); `notification` không fire và `permissionRequest` vô hiệu vì tool đã pre-approved → muốn ra quyết định thì dùng `preToolUse`, mà `"ask"` bị coi là `"deny"` vì không có ai để hỏi; sandbox mất khi job xong → muốn giữ log thì hook `type: "http"` gửi ra host được firewall cho phép.

> **Vì sao quan trọng?** Hooks là tầng enforcement mạnh nhất mà **dev tự làm được**: chặn tool call *trước khi nó chạy*, thậm chí đổi tham số trước khi thực thi (`modifiedArgs`) — không phụ thuộc việc model "có nhớ luật" hay không.
> **Nếu làm sai?** Tin vào định vị cũ "preview, chỉ Local, bỏ qua" → team dựng guard cho cloud agent bằng... lời dặn, trong khi một file JSON commit vào repo chặn được lệnh `rm -rf` ngay từ trước khi tool chạy.
> **Tóm gọn 1 câu:** Docs nguyên văn: *"Hooks are supported in two Copilot surfaces: Copilot CLI and Copilot in the cloud"* — chỉ VS Code là Preview; trên CLI và cloud, hooks là tính năng hiện hành.

## 2. Schema, event và exit code — viết hook đầu tiên

Một file hook = JSON `version: 1`; `hooks` là object keyed by event, mỗi event là mảng entry `{type, bash|powershell|command, matcher, timeoutSec}`. Recipe tối giản — chặn tool `bash` trước khi lệnh chạy:

```json
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "type": "command",
        "matcher": "bash",
        "command": "./.github/hooks/guard.sh",
        "timeoutSec": 5
      }
    ]
  }
}
```

Script `guard.sh` đầy đủ (allow/deny + demo `modifiedArgs`) → [`examples/07-4-guard-allow-deny.sh`](examples/07-4-guard-allow-deny.sh). Ba rule nền của schema:
- **`matcher` là regex** neo `^(?:PATTERN)$`, lọc theo `toolName` (với `preToolUse`/`postToolUse`/`permissionRequest`), `trigger` (`preCompact`), `agentName` (`subagentStart`) — **không có field `if`** như bản course cũ dạy. Regex sai → entry đó bị bỏ qua kèm cảnh báo.
- **camelCase và PascalCase đều chính thức** (`preToolUse` ↔ `PreToolUse`), nhưng PascalCase đổi payload sang format tương thích VS Code/Claude (snake_case, tool tên `Bash`/`Edit`…) → một script đừng trộn hai kiểu đọc field.
- **Input là JSON trên stdin**: `sessionId`, `cwd`, `toolName`, `toolArgs`… — session id và repo cần cho audit lấy từ đây.

| Event | Chạy khi | Bạn làm được gì |
|---|---|---|
| `sessionStart` | session mới bắt đầu / resume | tiếp thêm `additionalContext`; nhận cả `type: "prompt"` (chỉ event này, CLI interactive) |
| `sessionEnd` | session kết thúc | báo cáo/cleanup (`/clear` cũng fire, chạy detached) |
| `userPromptSubmitted` | user gửi prompt | quan sát/ghi log — output của hook file **không** được nhận ở event này |
| **`preToolUse`** | **trước mỗi tool chạy** | `permissionDecision: allow|deny|ask` + `permissionDecisionReason` + `modifiedArgs` — cửa duy nhất chặn *trước khi* lệnh chạy |
| `postToolUse` | tool thành công | `modifiedResult` hoặc `additionalContext` (nối bằng `\n\n`, cap 10 KB) |
| `postToolUseFailure` | tool thất bại | exit `2` = text đưa thêm cho model để nó tự chữa |
| `agentStop` | agent sắp kết thúc turn | `{"decision":"block","reason":…}` = bắt làm tiếp (coi runaway guard dưới) |
| `permissionRequest` | trước luồng permission | **CLI only**: `behavior: allow|deny` đi tắt cả permission flow — hợp cho `-p` CI |

| Mã exit | Nghĩa |
|---|---|
| `0` | thành công; stdout được parse là JSON quyết định |
| `2` | **deny** với `preToolUse`/`permissionRequest` (kể cả khi stdout báo `allow`); `postToolUseFailure` → `additionalContext`; event khác chỉ là warning |
| non-zero khác | `preToolUse`: **fail-closed** — từ chối tool ("hook errored"); event còn lại: ghi log rồi bỏ qua (fail-open) |
| timeout | **fail-open với MỌI event**, kể cả policy hooks — hook chậm không được phép âm thầm chặn việc; nâng `timeoutSec` nếu cần |

Ba chi tiết sống còn khi viết hook: **runaway guard** — 8 lần `block` liên tiếp thì CLI tự kết thúc turn, nên `agentStop` phải kiểm `stop_hook_active` để tự giới hạn; output của hook giới hạn **10 MiB/lần**; hook chạy **đồng bộ** — ghi log bằng append file, đừng gọi network đồng bộ, còn `notification` (CLI) là fire-and-forget đúng nghĩa. Muốn gọi service thay vì script: `type: "http"` (bắt buộc `https` cho `preToolUse`/`permissionRequest`; `http://localhost` cần `COPILOT_HOOK_ALLOW_LOCALHOST=1`).

> **Tóm gọn 1 câu:** `matcher` lọc, exit code quyết, `preToolUse` là cửa duy nhất chặn được tool *trước khi* nó chạy — mọi thứ khác chỉ "góp ý sau".

## 3. Đặt hook ở đâu, thứ tự load, và tầng "cấm tắt"

| Nguồn | Đường dẫn | Phạm vi |
|---|---|---|
| Repo | `.github/hooks/*.json` (commit) | team + Copilot in the cloud |
| User | `~/.copilot/hooks/` (hoặc `$COPILOT_HOME/hooks/`) | một máy, CLI |
| Inline trong settings | field `hooks` top-level trong `.github/copilot/settings.json` / `settings.local.json` (`.claude/settings.json` cũng được đọc) | repo / máy |
| Dotfiles cloud | `.copilot/hooks` | cá nhân hoá Copilot in the cloud |

- **CLI không còn đọc `~/.copilot/config.json` cho hooks** — bản course cũ ghi vậy là hết hiệu lực; hooks giờ đọc từ `settings.json`. Hooks Local cũ của harness khác cũng **không tự convert** sang Copilot harness — event + payload đổi, theo trang migrate-customizations.
- **Policy hooks** = tầng "cấm tắt" cho org: admin cài `/etc/github-copilot/policy.d/*.json` (Linux/macOS), `C:\ProgramData\GitHub\Copilot\policy.d` + registry (Windows); chạy trước mọi nguồn, `disableAllHooks` **không** tắt được, và chạy ngoài sandbox. `disableAllHooks`: đặt trong 1 file = chỉ tắt file đó (CLI + cloud); đặt top-level `settings.json` = CLI only.
- **Thứ tự load:** policy → user → project → plugins; mọi nguồn được **kết hợp** — cùng một event thì hook của cả máy lẫn repo đều chạy, không nguồn nào thay thế nguồn nào.
- **Verify:** khởi động CLI in `! Invalid hook configuration in FILE: REASON` cho file/entry lỗi; `jq . .github/hooks/*.json`; `chmod +x` script; pipe test payload vào script và soi exit code + stdout JSON; nếu session bật sandbox, chạy `/sandbox policy <lệnh-hook>` (→ `commands/copilot/model-agent/sandbox-policy/README.md`) để thấy hook cần quyền gì.

> **Tóm gọn 1 câu:** File trong `.github/hooks/` là của chung (team + cloud), file trong `~/.copilot/hooks/` là của riêng bạn, còn `policy.d` là của admin — dev không gỡ được. 📄 File `.github/hooks/guard.json` hoàn chỉnh do script sinh ra: [`examples/07-4-guard-allow-deny.sh`](examples/07-4-guard-allow-deny.sh).

## 4. Guardrail stack: advisory → hook → law

- **Advisory** = dặn miệng (instructions): model có thể quên khi context dài.
- **Semi-law** = hook: chặn một tool call cụ thể bằng code — nhưng dev vẫn sửa được file repo, nên **chưa phải security boundary**.
- **Law** = khoá server (branch protection, push protection, policy hooks): không ai tại bàn phím lách được.

| # | Lớp | Nôm na | Chặn ở đâu | Copilot override được? |
|---|---|---|---|---|
| 1 | Instructions | Dặn miệng | Prompt (advisory) | Có (quên được) — công thức: cấm rõ + hậu quả + việc đúng, cú pháp ở bài 03 |
| 2 | **Hooks** | Chuông khói chặn tool | `preToolUse`/`permissionRequest` (CLI, cloud, VS Code Preview) | File repo thì dev sửa được; policy hooks thì không |
| 3 | MCP allowlist + tool approval | Giữ chìa khóa | Client / org policy — matrix deny > ask > allow thuộc bài 10 | Khó |
| 4 | Content exclusion | Bịt mắt model | Server (GitHub) — xem mục 6 | Không |
| 5 | Pre-commit + linter | Soi hành lý lúc commit | Local git hook, chạy ngoài model | Không |
| 6 | Branch protection + required checks | Khóa cổng làng | Server (GitHub) | Không |
| 7 | Secret scanning/push protection + review gate | Máy soi + kiểm định cuối | Server (GitHub) | Không |

**Thứ tự nghĩ:** server-side > local deterministic (hook, pre-commit, exclusion) > advisory. **Rule nào bị quên 2 lần → nâng một lớp, đừng dặn lần thứ ba.**

Lớp 5 — **một recipe inline** (chọn đúng 1 công thức, đừng chạy song song 2 máy soi — lint 2 lần chậm commit). Recipe A · husky + lint-staged (Node, phổ biến nhất):

```bash
pnpm add -D husky lint-staged prettier eslint && pnpm exec husky init
# .husky/pre-commit:
#!/bin/sh
pnpm exec lint-staged
# package.json: { "lint-staged": { "*.{ts,tsx}": ["prettier --write", "eslint --max-warnings 0"] } }
```

- Recipe B (pre-commit framework + gitleaks, đa ngôn ngữ): [`examples/07-4-recipe-b-precommit-gitleaks.yaml`](examples/07-4-recipe-b-precommit-gitleaks.yaml) + [`examples/07-4-recipe-b-precommit-gitleaks.sh`](examples/07-4-recipe-b-precommit-gitleaks.sh). Recipe C (git hook thuần chặn push thẳng vào main, không dependency): [`examples/07-4-recipe-c-pre-push-block-main.sh`](examples/07-4-recipe-c-pre-push-block-main.sh). Các recipe hook nâng cao hơn: [`commands/copilot/system-knowledge/hooks/README.md`](commands/copilot/system-knowledge/hooks/README.md).
- Hai script hình mẫu cho lớp 2: guard allow/deny ([`examples/07-4-guard-allow-deny.sh`](examples/07-4-guard-allow-deny.sh)) và audit + gate ([`examples/07-4-sec-gate-audit.sh`](examples/07-4-sec-gate-audit.sh)) — `sessionStart`/`sessionEnd`/`postToolUse` log bằng cách **append file** (hook chạy đồng bộ nên việc trong hook phải nhẹ), id + repo lấy từ payload stdin.

> **Tóm gọn 1 câu:** Dặn miệng cho model, chuông khói cho tool call, khoá cổng cho server — mỗi loại quy tắc đúng một tầng, đừng trộn.

## 5. Org policies — 17 dòng, phần đầy đủ ở bài 16

- **Managed settings** (file-based / server / MDM): key có nguồn docs CLI + sandbox — `sandbox.enabled`, `sandbox.failIfUnavailable`, `sandbox.allowBypass`, `enabledPlugins`, `extraKnownMarketplaces`, `strictKnownMarketplaces`, `autoUpdates`; plugin bị quản lý hiện badge **Managed**. Chính sách per-surface ("Copilot in the cloud", "MCP servers in Copilot", "Editor preview features"…) tra ở supported-surfaces-for-policies.
- **Policy hooks** (`policy.d`) = enforcement mạnh nhất docs nêu cho hành vi agent; instructions **không** có policy "ép tuân thủ" nào — đừng tin ai nói có.
- **Tiền:** AI credits, 1 credit = $0.01, billing per-token; cơ chế ngân sách chính thức là **Bundled AI credits budget** + "Stop usage when budget limit is reached" (đặt $0 để chặn); code completions không trừ credit.
- **Audit:** event phía server tra bằng bộ lọc `operation:read/copilot` (session/review activity) — **không chứa prompt/session của client**; retention không có con số docs riêng cho Copilot → đừng quoting "180 ngày".
- **Network allowlist** (07 là chủ — bài 15 trỏ về): `https://*.githubcopilot.com/*` · `https://github.com/login/*` + `https://collector.github.com/*` · `https://copilot-telemetry.githubusercontent.com/telemetry` · `https://*.SUBDOMAIN.ghe.com` (data residency).
- Copilot app và Copilot CLI theo **2 bộ policy client riêng** — bật ở app không có nghĩa bật ở CLI.

> **Tóm gọn 1 câu:** Ở tầm org, vũ khí là managed settings + policy hooks — còn quy trình validate phần mở rộng và vận hành governance là việc của bài 16.

## 6. Content exclusion và các lớp server

**Content exclusion** = cấu hình **server-side** khiến file/path nhạy cảm không bao giờ được gửi lên model — khác `.gitignore` (gitignore chỉ bỏ qua git, model vẫn đọc được). **Có áp dụng cho Copilot in the cloud (bao gồm cloud sandbox) + code review + CLI** — bản cũ nói "cloud không bị ảnh hưởng" là sai. Cấu hình bởi repo admin / org owner; path kế thừa từ org cha; Business/Enterprise.

```text
Setup (repo/org Settings -> Copilot -> Content exclusion): them paths .env*, **/*credentials*, **/*secret*, certs/**, db/prod-dump/**
Verify: mo .env -> icon Copilot bao "excluded"; yeu cau doc file do -> phai tu choi; van doc duoc -> path sai hoac chua sync.
```

**4 giới hạn docs nêu — nhớ như in:** không phải biên an toàn filesystem; không đảm bảo third-party MCP tôn trọng; không áp cho symlink và repo trên remote filesystem; có thể bỏ sót truy cập gián tiếp. Phòng thủ thêm ở máy dev: `github.copilot.enable` theo language cho file nhạy cảm.

Lớp 6–7 (server): branch protection + required checks — copy-paste [`examples/07-7-1-lop-5-branch-protection-required-checks.sh`](examples/07-7-1-lop-5-branch-protection-required-checks.sh), hoặc Rulesets (Settings → Rules → Rulesets: Restrict deletions, Block force pushes, Require PR + status checks, Require Copilot code review). Secret scanning + push protection + review gate CI (grep CRITICAL trong `gh pr view --json reviews` → exit 1): cả 4 bước test trong [`examples/07-4-sec-gate-audit.sh`](examples/07-4-sec-gate-audit.sh). Review gate: Copilot review mặc định chỉ là **comment**, không phải approval; chi phí theo **review effort Lite/Balanced/Max ≈ $0.25/$1.50/$10 mỗi review** (as of 11/2026) + phút Actions — kinh tế chi tiết ở bài 15.

> **Tóm gọn 1 câu:** Exclusion bịt mắt model từ phía server nhưng không phải bức tường sắt — các lớp 6–7 (push protection, review gate, branch protection) mới là nơi "đã lọt cũng bị chặn".

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| `"hooks": [{ "event": "PreToolUse", "if": "Bash(git *)" }]` (array + `if`) | hook không load như bạn tưởng | object keyed by event + `"matcher": "bash"` regex (schema `version: 1`) |
| Nghĩ "hooks chỉ Local / preview vô dụng, cloud không chạy" | dựng guard sai chỗ | hooks chạy ở CLI + Copilot in the cloud (subset); VS Code Preview |
| `timeoutSec: 300` để "chắc chắn chặn" | hook chậm thì **fail-open** — tool vẫn chạy | giữ hook < 5s, test timeout tách riêng; muốn cứng dùng deny, không dùng delay |
| Chốt rule chỉ trong instructions | model quên khi context dài | rules hay quên → nâng tầng: hook chặn tool, rồi lớp server |
| "Bật content exclusion là file an toàn tuyệt đối" | MCP bên thứ ba / symlink vẫn lọt | exclusion + push protection + audit; 4 giới hạn docs ở mục 6 |
| Tin "audit log giữ 180 ngày, có policy instruction enforcement" | claim không nguồn docs | chỉ dẫn những gì docs.github.com có — mục 5 |

## Best practices (kèm vì sao)

- **Đặt guard hook trong `.github/hooks/` và commit.** *Vì sao:* nguồn repo là nguồn duy nhất cloud agent đọc — guard sống cùng job, không phụ thuộc máy dev nào cài gì.
- **Test hook bằng payload giả trên stdin trước khi tin nó chạy trong session.** *Vì sao:* "file hiện trong editor ≠ script đã execute"; exit code + stdout JSON sai là fail-open/fail-silent.
- **Tổ chức muốn cấm thật → policy hooks + managed settings, không phải file repo.** *Vì sao:* `disableAllHooks` và việc xóa file trong repo đều do dev làm được; policy hooks thì không.
- **Không log cả payload vào audit file.** *Vì sao:* payload chứa `toolArgs` — đường ngắn nhất để secret rò ra log; chỉ lấy `toolName`, `sessionId`, timestamp.

## Bài tập

1. **(15 phút)** Dựng `guard.sh` theo [`examples/07-4-guard-allow-deny.sh`](examples/07-4-guard-allow-deny.sh), commit `.github/hooks/guard.json`; pipe payload giả `{"toolName":"bash","toolArgs":{"command":"rm -rf /tmp/x"}}` → script phải exit 2; mở CLI session thật, gọi lệnh nguy hiểm → thấy "denied".
2. **(10 phút)** Thêm `sessionStart` + `sessionEnd` + `postToolUse` ghi `logs/copilot-audit.jsonl` (đăng ký theo mẫu JSON trong `examples/07-4-guard-allow-deny.sh`, script chỉ append file); đo thời gian hook — mỗi lần > 5s thì thu hẹp việc; sau đó chạy nốt phần test secret/review gate trong `examples/07-4-sec-gate-audit.sh`.
3. **(15 phút)** Bật content exclusion cho `.env*` và test như mục 6; chạy bài test secret giả + review gate trong `examples/07-4-sec-gate-audit.sh`; ghi lại lớp nào chặn ở bước nào.

## Link qua

- Công thức instructions + `applyTo` (lớp 1) → bài 03. · Matrix allow/ask/deny, permission levels → bài 10.
- MCP servers, secrets qua env, prune servers → bài 08. · Sandbox MXC + `/sandbox` CLI → bài 12.
- Kinh tế review effort + Rulesets → bài 15. · Validate extension/plugin, governance org → bài 16. · Plugin đóng gói hooks → bài 17.
- Hook Copilot dùng tên PascalCase + matcher semantics như Claude Code (tương thích có docs) — nhưng **chép file ≠ cùng runtime**: payload mỗi harness một kiểu. · Thực hành từng lệnh: [`commands/copilot/system-knowledge/hooks/README.md`](commands/copilot/system-knowledge/hooks/README.md).

## Reference

- GitHub — [Hooks reference](https://docs.github.com/en/copilot/reference/hooks-reference) (schema, events, exit codes, matcher, policy hooks, cloud sandbox) · [Hooks concept](https://docs.github.com/en/copilot/concepts/agents/hooks) (surfaces, performance, security) · [Using hooks with Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-hooks)
- VS Code — [Configure agent hooks (Preview)](https://code.visualstudio.com/docs/agent-customization/hooks) · [Cheat sheet hỗ trợ customization theo surface](https://docs.github.com/en/copilot/reference/customization-cheat-sheet) (docs GitHub)
- GitHub — [Content exclusion](https://docs.github.com/en/copilot/concepts/content-exclusion) · [Supported surfaces for policies](https://docs.github.com/en/copilot/reference/supported-surfaces-for-policies) · [About local sandboxing](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/understanding-local-sandboxing) · [Models & pricing (AI credits)](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) · [CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)

**Chốt:** Hook là chuông khói có schema, exit code và fail-policy rõ ràng — chạy từ CLI tới cloud, không còn là "đồ Local preview"; nhưng nó vẫn chỉ là semi-law: quy tắc sống còn thì đưa lên `policy.d` và khoá server, rule nào bị quên 2 lần là phải nâng tầng ngay.
