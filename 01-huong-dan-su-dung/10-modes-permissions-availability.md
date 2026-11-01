# 10 — Modes, Permissions & Availability (Ask/Edit/Agent + Interactive/Plan/Autopilot + Plans)

> **Dành cho:** dev đã dùng Copilot Chat muốn chọn đúng mode cho từng task, set tool approval cho team, kèm admin cần biết plan nào có tính năng gì (bài 10 của series).
> **Vấn đề:** chọn sai mode thì phí AI Credits, allow hết thì agent tự chạy lệnh nguy hiểm, còn "setting không thấy" thì hầu hết kết luận nhầm là bug.
> **Đọc xong:** chọn đúng Ask/Edit/Agent + persona (Interactive/Plan/Autopilot) cho từng task, set tool approval theo thứ tự thắng `deny > ask > allow`, dùng đúng permission level + sandbox, hiểu AI Credits, tra được khác biệt giữa các plan.

## Mục tiêu bài học

- Chọn đúng mode (Ask/Edit/Agent) và đúng persona (Interactive/Plan/Autopilot) cho từng cỡ việc; cấu hình tool approval `allow/ask/deny`, thuộc quy tắc **deny thắng mọi nơi**.
- Phân biệt 3 thứ dễ gộp làm một: **model** (não) · **session target/harness** (nơi + ai thực thi) · **permission level** (mức tự duyệt).
- Bọc an toàn khi để agent chạy tự động: sandbox + worktree riêng + git sạch; và tra được "sao không thấy setting X?" — thường là do plan, không phải bug.

> **Tóm gọn 1 câu:** Chọn đúng mode và persona, siết quyền theo `deny > ask > allow`, bọc agent bằng sandbox + git sạch — vậy là bạn cầm lái thay vì bị lái.

---

## 1. Vì sao modes + permissions?

Mục này giải thích hai thứ cần phân biệt trước khi config: mode (agent tự chủ tới đâu) và permission (được chạm vào gì).

**Nôm na:** Modes là 3 nấc số xe — Ask = chỉ nghe, Edit = chạy chậm trong sân, Agent = tự chạy xa. Permissions là người gác cổng: cho, hỏi, hay cấm. Agent có quyền đọc files + chạy shell + gọi MCP. Không gate thì 1 prompt-injection trong issue text đủ khiến nó chạy lệnh xóa hay exfiltrate `.env`.
- Allow hết để "cho nhanh" → 1 prompt nhiễm độc là agent tự chạy lệnh phá. Siết quá tay (deny cả read-only lặp lại) → bấm Allow mỏi tay rồi bấm mù. Mục tiêu: **nới việc đọc, siết việc ghi/xoá/chạy**.
- Files quản lý: `.vscode/settings.json` (team, commit) + user settings (personal) + org policy (admin, đè cả 2). **Thứ tự thắng: org policy > team settings > personal; deny ở đâu cũng thắng allow.**

> **Tóm gọn 1 câu:** Mode là nấc số, permission là người gác cổng — nới việc đọc, siết việc ghi/xoá/chạy.

---

## 2. 3 modes: Ask / Edit / Agent

| Mode | Copilot được làm gì | Khi dùng | Ví dụ |
|---|---|---|---|
| **Ask** | Chỉ đọc + trả lời | Hỏi hiểu code, task mới chưa rõ scope | `"Giải thích auth flow"` |
| **Edit** | Sửa đúng files bạn chỉ | Sửa nhỏ 1–3 files đã biết rõ | `"Đổi label button X"` |
| **Agent** | Tự plan + sửa + chạy test + iterate | Task multi-file, refactor, feature mới | `"Migrate auth sang session + chạy tests"` |

> **Cách đọc bảng này:** Mỗi dòng là một mode — cột 2 cho biết Copilot được làm gì, cột 3 chỉ khi nào nên dùng, cột 4 là ví dụ câu bạn gõ vào Chat.

```text
Cây chọn mode 10 giây: Task mới chưa hiểu scope → Ask (đọc + outline). Đã biết
file nào, sửa nhỏ → Edit. Multi-file / cần chạy test / tự iterate → Agent.
# Verify: Agent cho việc 1 dòng = phí AI Credits + rủi ro lan scope.
# Đổi mode: Chat dropdown · Ctrl+I inline → Tab xoay · keybinding github.copilot.chat.setMode.
```

**Agent mode (mode nguy hiểm nhất) — 4 dây cương:**

```text
Agent loop: plan → edit → run terminal/tests → đọc lỗi → fix → lặp.
- Scope: chỉ mở folders/files task cần (đừng mở cả monorepo). Approval: terminal/MCP = ask (mục 4).
- Stop: nút Stop khi lan scope; sai 2 lần → dừng, re-prompt (bài 11).
- Undo: git diff review trước accept; checkpoint chat (bài 11).
```

> **Tóm gọn 1 câu:** Việc nhỏ dùng Ask/Edit, việc nhiều file mới dùng Agent — và Agent luôn cần dây cương: scope hẹp, approval để ask, review diff trước khi accept.

### 2.1. Agent personas (UI mới): Interactive / Plan / Autopilot

| Persona | Mức tự chủ | Khi dùng |
|---|---|---|
| **Interactive** | Thấp — duyệt trước mỗi thay đổi/shell | Việc cần trông, repo chưa có test |
| **Plan** | Không sửa code — chỉ đọc rồi ra kế hoạch | Task mở/lớn, cần duyệt trước |
| **Autopilot** | Cao — tự chạy tới khi xong, tự duyệt tool | Việc dài/lặp, tin scope + đã bật sandbox (mục 4.4) |

> **Cách đọc bảng này:** Mỗi dòng là một kiểu lái — cột 2 là mức tự chủ tăng dần từ trên xuống, cột 3 cho biết tình huống nào nên chọn loại nào.

```text
Nơi chọn: VS Code dropdown agent ở khung Chat; CLI: Shift+Tab xoay standard →
plan → autopilot, hoặc copilot --mode=... (copilot --plan --mode autopilot:
plan xong tự chuyển, KHÔNG chờ duyệt).
# Plan KHÔNG sửa file dù bạn bảo "cứ code đi" — muốn code thì đổi Interactive.

Autopilot = tự duyệt tool + tự lặp tới xong. Bọc an toàn trước khi bật:
- Bật sandboxing cho terminal (mục 4.4) — mạnh hơn auto-approve rules.
- Autopilot vẫn trừ AI Credits như chat interactive.
- Cap chi phí (CLI): /goal "<objective>" --max-ai-credits N → tới cap tự pause.
# TUYỆT ĐỐI không Autopilot trên repo chưa có test hoặc git chưa sạch.

Autopilot vs Allow all: Autopilot = mức tự chủ của agent (tự chạy tới đích, tự
tiếp tục sau lỗi); Allow all = permission level tắt phê duyệt tool (chỉ bỏ popup,
không tự bảo đảm xong task). Cả hai nên bọc bằng sandbox + worktree riêng + git sạch.
```

> **Tóm gọn 1 câu:** Interactive là làm một bước hỏi một bước, Plan chỉ vẽ bản đồ không đụng code, Autopilot tự lái tới đích — càng tự chủ càng cần bọc sandbox + git sạch.

### 2.2. Session Target / harness: Local / Copilot / Cloud

Model = "não"; **harness** = "tay chân + nhà xưởng" (ai thực thi tool, chạy ở đâu). Hãy tưởng tượng: cùng một đầu bếp (model), nhưng nấu ở bếp nhà, bếp quán, hay bếp công ty (harness) thì ra món và cách làm khác nhau. Đổi Session Target **không phải** đổi model.

| Target | Harness chạy ở đâu | Truy cập code | Chọn khi |
|---|---|---|---|
| **Local** | Extension host VS Code (máy bạn) | Workspace hiện tại | Cần tool built-in/extension, model cấu hình trong VS Code (gồm BYOK) |
| **Copilot** | Agent Host (nền Copilot SDK), chạy nền, nhiều phiên song song | Folder hiện tại hoặc worktree cô lập | Session chạy nền, nhiều phiên song song; session mở lại được ở cửa sổ khác |
| **Cloud** | Hạ tầng remote của provider | 1 GitHub repo → mở PR | Task gọn, async, cần team review. KHÔNG truy cập tool/context local |

> **Cách đọc bảng này:** Mỗi dòng là một nơi chạy session — cột 2 cho biết code được thực thi ở đâu, cột 4 là tình huống nên chọn nơi đó.

```text
- Handoff: đổi target giữa phiên mang theo history; chỉ khởi tạo được từ session Local.
  Copilot → Cloud: gõ /delegate trong session Copilot.
- Local dùng tool extension + hook Local; Copilot/Agent Host đọc MCP từ
  .mcp.json + ~/.copilot/mcp-config.json + nạp SDK Policy Hooks.
# Verify: Session Target control ở đáy khung Chat; Agent Sessions sidebar xem mọi session.
```

> **Tóm gọn 1 câu:** Model là bộ não, harness là nhà xưởng — Local chạy trên máy bạn, Copilot chạy nền nhiều phiên, Cloud chạy trên GitHub và kết thúc bằng PR.

---

## 3. Model picker + AI Credits (tóm tắt — chi tiết bài 14)

```text
- Model rẻ (việc hàng ngày): GPT-5.6 Luna, MAI-Code-1.1-Flash, Gemini 3.8 Flash,
  Claude Haiku 5.5. Model mạnh (task khó): Claude Opus 5.5 / Sonnet 5.5,
  GPT-6.1 Sol, GPT-6 Astra, Gemini 4 Argon — tốn credits nhiều hơn.
- Auto model selection: route theo sức khỏe hệ thống + độ khó task; plan trả phí
  giảm 10% credits. 3 tier Efficiency/Balance/Intelligence (từ 14/09/2026) đổi
  cách route, KHÔNG đổi giá hay pool model. Free/Student: bắt buộc Auto.
# Quy tắc team: default model rẻ, khó mới đổi mạnh + ghi lý do.
# Check bill: github.com/settings/copilot → Usage → AI Credits.
```

> **"Premium requests" là cách gọi cũ (legacy). Từ 01/06/2026 Copilot tính bằng AI Credits** (usage-based billing): **1 AI credit = $0.01**, chi phí = giá per-token × số token. **Code completions và next edit suggestions KHÔNG trừ AI Credits** trên mọi plan trả phí.

> **Tóm gọn 1 câu:** AI Credits là tiền xu nội bộ của Copilot — việc thường ngày dùng model rẻ, còn autocomplete thì miễn phí hoàn toàn.

---

## 4. Tool approval: allow / ask / deny (copy-paste)

### 4.1. Settings mẫu team (commit)

> 📄 **Code ví dụ:** [`examples/01-4-1-settings-mau-team-commit.jsonc`](examples/01-4-1-settings-mau-team-commit.jsonc)

### 4.2. Patterns + thứ tự thắng

```text
ALLOW:  search, read, fetch, github read-only; terminal read-only (git diff/status/log).
ASK:    terminal (pnpm, docker, kubectl), browser click, MCP write, edit ngoài scope.
DENY:   rm -rf, sudo, chmod 777, curl | sh, DB prod write, deploy prod, đọc .env/*secret*.

Thứ tự thắng (thuộc lòng): deny > ask > allow (trong cùng scope);
org policy > team .vscode/settings.json > personal → deny ở đâu cũng thắng allow nơi khác.
```

`managed-settings.json` (enterprise) dùng cùng bộ `permissions.deny/ask/allow`: `ask` KHÔNG bị bypass/YOLO mode; lệnh không khớp rule nào → mặc định hỏi; allowlist thực tế = giao (intersection) các nguồn; `permissions.disableBypassPermissionsMode` tắt hẳn bypass mode.

> **Tóm gọn 1 câu:** Chọn pattern allow cho việc đọc, ask cho việc ghi/chạy, deny cho việc nguy hiểm — và nhớ thứ tự thắng: deny > ask > allow, org policy > team > personal.

### 4.3. Permissions UI: Manual / Assisted / Allow all

Núm ga tự duyệt của cả session, nằm TRƯỚC bộ allow/ask/deny per-tool:

| Level | Là gì | Tôn trọng allow/ask/deny? | Khi dùng |
|---|---|---|---|
| **Manual** (mặc định) | Hỏi trước mỗi tool cần duyệt | Có | Mặc định, việc thường ngày |
| **Assisted** (experimental) | LLM judge chấm rủi ro từng tool call: an toàn → tự chạy, còn lại → hỏi | Không — judge có thể chấm sai | Giảm mỏi tay nhưng vẫn có lưới (bật `chat.assistedPermissions.enabled`, chỉ Agent Host) |
| **Allow all** | Tự duyệt HẾT, không popup | Không — override toàn bộ | Gần như không bao giờ — thay bằng sandbox |

> **Cách đọc bảng này:** Ba dòng là ba mức của núm ga tự duyệt — cột 3 quan trọng nhất: mức đó còn tôn trọng bộ allow/ask/deny bạn đã đặt hay không.

```text
CLI parity (Copilot CLI): /permissions [default|assisted|allow-all|show] — /allow-all
và /yolo = alias; --allow-all-tools | --allow-all-urls | --yolo. Org:
permissions.disableBypassPermissionsMode="allow-auto-only" → chặn full allow-all
nhưng vẫn cho /permissions assisted. Org ẩn/hạ mức: ChatToolsAutoApprove (ẩn
Assisted + Allow all + Autopilot), ChatToolsEligibleForAutoApproval + TerminalEnableAutoApprove.
```

> **Tóm gọn 1 câu:** Để Manual cho việc hàng ngày, Assisted khi mỏi tay mà vẫn muốn lưới an toàn, còn Allow all thì gần như đừng bao giờ bật — thay bằng sandbox.

### 4.4. Sandboxing for terminal

> **Update 07/10/2026 — Local sandboxing GA:** có ở Copilot CLI + Copilot app + VS Code sessions dùng Agent Host (miễn phí). Chạy bằng Microsoft eXecution Container (MXC), dịch 1 policy chung ra OS controls Windows/macOS/Linux (gồm WSL2): giới hạn files/dirs, internet + local network, Git/GitHub CLI credentials; áp được cho local MCP/language servers. Enterprise enforce qua managed settings — dev không nới được. Sandbox áp cho tool execution bất kể model nào.

| Sandbox | Hệ quả |
|---|---|
| **Tắt** (mặc định) | Quy tắc permission/approval khác vẫn áp dụng; lệnh cần duyệt vẫn hỏi |
| **Bật** | Giới hạn file + mạng; lệnh TRONG sandbox auto-approve (đã bị giới hạn) |

> **Cách đọc bảng này:** Hai dòng là hai vị trí công tắc sandbox — cột phải cho biết điều gì thay đổi với các lệnh agent chạy.

> 📄 **Code ví dụ:** [`examples/02-4-4-sandboxing-for-terminal.jsonc`](examples/02-4-4-sandboxing-for-terminal.jsonc)

```text
3 điều đừng quên: (1) Sandbox KHÔNG phải máy ảo, không thay thế bảo mật hệ thống;
(2) bật sandbox không mặc định chặn hết mạng — xem allowNetwork; (3) lệnh bị chặn xin
chạy NGOÀI sandbox (nếu allowUnsandboxedCommands=true) → approve = bỏ giới hạn, chỉ
approve khi thật tin. Kết hợp chuẩn: Autopilot + Sandbox on + worktree riêng + git sạch (bài 11).
```

> **Tóm gọn 1 câu:** Sandbox giống cái chuồng nuôi cho lệnh agent — trong chuồng thì tự chạy thoải mái vì đã bị khoá chân, còn xin ra ngoài chuồng thì bạn phải duyệt tay.

## 5. Content exclusion + duplication detection + telemetry

```text
Content exclusion (server-side, Copilot không override — admin): github.com →
repo/org → Settings → Copilot → Content exclusion → Add:
  .env*  **/*credentials*  **/*secret*  certs/**  db/prod-dump/**
Verify: mở .env → Copilot icon "excluded"; chat "@workspace đọc .env" → từ chối.
Client bổ sung: "github.copilot.enable": { "*": true, "plaintext": false, "env": false }. Chi tiết: bài 07 mục 5.

Duplication detection (suggestions matching public code): Org Settings → Copilot →
Policies → Block (khuyên dùng) hoặc Allow; Copilot Business: Blocked mặc định.
Khi bị block: đừng copy tay lách — viết lại theo cách team hoặc check license
reference Copilot hiện; ghi vào PR nếu dùng code public.
```

```text
Telemetry / audit:
- Client: "telemetry.telemetryLevel": "off" (off|error|crash|all) — tắt local được.
- Org audit log (Business+): filter action:copilot — ghi thay đổi plan/settings/
  policy + hoạt động agent trên github.com; giữ 180 ngày; KHÔNG chứa prompt/session
  data (muốn log prompt → custom hooks, vd CLI events → logging riêng).
- Enterprise managed settings: khoá "telemetry" OTLP endpoint, protocol,
  captureContent, lockCaptureContent... (bài 13 + 15). Tắt local ≠ hết log server-side.
```

---

## 6. Plans: Individual vs Business vs Enterprise

| Khả năng | Individual | Business | Enterprise |
|---|---|---|---|
| Chat + autocomplete + Edit/Agent modes + model picker/AI Credits | ✓ (credits cá nhân) | ✓ (credits gộp org + analytics) | ✓ (+ custom models/BYOK) |
| **Content exclusion** | ✗ | ✓ | ✓ |
| Org policy (extensions, MCP, tool approval) + audit logs/usage analytics | ✗ | ✓ | ✓ (+ API, SIEM) |
| SSO/SAML, SCIM, domain verification | ✗ | ✓ (SSO) | ✓ (+ SCIM, compliance, ZDR) |
| Copilot code review required check + coding agent (assign issue → PR) | ✗ / ✓ (repo public/personal) | ✓ | ✓ (+ org controls) |
| Custom models / IP indemnity | ✗ | Hạn chế | ✓ |

> **Cách đọc bảng này:** Mỗi dòng là một khả năng, mỗi cột là một gói — dấu ✓/✗ cho biết gói đó có hay không; nhiều "setting không thấy" đơn giản vì gói chưa đủ cao.

### 6.1. Bảng giá + AI Credits (10/2026)

| Plan | Giá | AI Credits kèm/tháng |
|---|---|---|
| Free · Student/Teacher | $0 | allowance nhỏ |
| Pro | $10/tháng | 1.500 (base 1.000 + flex 500) |
| Pro+ | $39/tháng | 7.000 (base 3.900 + flex 3.100) |
| Max | $100/tháng | 20.000 (base 10.000 + flex 10.000) |
| Business | $19/seat/tháng | 1.900/seat (gộp pooled ở billing entity) |
| Enterprise | $39/seat/tháng | 3.900/seat (gộp pooled) |

> **Cách đọc bảng này:** Mỗi dòng là một gói — cột giữa là giá tháng, cột cuối là số AI Credits kèm theo; gói càng đắt càng có nhiều credits.

```text
Cơ chế (usage-based billing, hiệu lực 01/06/2026):
- 1 AI credit = $0.01. Chi phí = giá per-token × số token. Completions + next edit
  suggestions không trừ credits (plan trả phí); plan trả phí dùng auto model giảm 10%.
- Code review tốn AI credits + phút Actions (ước tính Lite $0.05–$1, Balanced
  $0.25–$5 mỗi review — chi tiết bài 15 mục 6).
- Hết credits included → "additional usage budget" áp dụng (đặt được cap).
- Paid usage policy (cho phép chi vượt pool) BẬT MẶC ĐỊNH — admin phải tắt để chặn;
  user hết hạn mức xin tăng budget, admin approve/adjust/deny (GA 09/2026).
# Gặp "sao không thấy setting X?" → tra bảng trên trước khi kết luận bug.
```

> **Tóm gọn 1 câu:** Một credit đáng $0.01 và chỉ chat/agent mới trừ — plan trả phí dùng Auto được giảm 10%, còn hết credits thì admin nên đặt cap budget từ trước.

> **Code review:** có trên Pro/Pro+/Max/Business/Enterprise (Free chỉ "Review selection" trong VS Code); mặc định kiểu **Comment** (không tính phê duyệt bắt buộc); effort mặc định **Balanced** từ 28/09/2026 (trước đó Lite).

---

## 7. Hiểu nhầm + troubleshooting

| Hiểu nhầm | Sự thật |
|---|---|
| "Allow hết cho nhanh" | Sai. Chỉ read-only mới allow, còn lại ask/deny |
| "Instructions cấm là đủ, khỏi approval deny" | Sai. Instructions là advisory (quên được). Lệnh nguy hiểm → deny + branch protection (bài 07) |
| "Personal allow mở được org deny" | Sai. Deny thắng mọi nơi — sửa policy gốc |
| "Ask mode lỗi vì không sửa được" | Sai. Thiết kế vậy — muốn sửa → Edit/Agent |
| "Dùng model mạnh mặc định cho nhanh" / "Bật Auto là đắt hơn" | Sai. Hết AI Credits nhanh — default rẻ, khó mới đổi mạnh; Auto plan trả phí giảm 10%, đổi tier không đổi giá |
| "Tắt telemetry local là hết log" | Sai. Org audit log (Business+) ghi server-side |
| "Setting không thấy = bug" | Sai. Tra bảng plans (mục 6) trước — Individual thiếu nhiều setting org |
| "Copilot có PreToolUse hooks như Claude" | Đúng một phần — hooks in-process (`.github/hooks/*.json`) nhưng **preview + chỉ Local**, không phải security boundary (bài 17) |

> **Cách đọc bảng này:** Cột trái là lời đồn hay gặp, cột phải là sự thật — nhớ cột phải là đủ để tự vệ trong review.

```text
"Setting X không thấy / không có tác dụng?"
├─ 1. Plan gì? (Individual không có org policy/content exclusion/audit)
├─ 2. Scope nào thắng? (org > team > personal; deny ở đâu cũng thắng)
├─ 3. Reload window; org policy đợi ~5–30 phút sync · 4. Mode đúng chưa? (Ask không sửa dù allow)
├─ 5. Gõ "@" — extension chưa cài thì không có @-mention
├─ 6. Model không hiện? (pool khác nhau theo surface + plan; Free/Student bắt buộc Auto)
└─ 7. Vẫn không có → docs.github.com/copilot + Community Discussion
```

> **Tóm gọn 1 câu:** Trước khi kêu bug, lần lượt hỏi: đúng plan chưa, đúng scope chưa, reload chưa, mode đúng chưa — chín trên mười case là trả lời được ở đây.

---

## 8. So sánh với Claude Code + best practices + link chéo

| Việc | Copilot | Claude Code |
|---|---|---|
| Nơi đặt luật | `.vscode/settings.json` + org policy + user settings | `settings.json` allow/ask/deny + `PreToolUse` hooks |
| Thứ tự thắng | `deny > ask > allow`; org > team > personal | allow/ask/deny; hooks deny thắng bypass |
| Mode agent | Ask/Edit/Agent + persona Interactive/Plan/Autopilot | Mặc định agentic, `/rewind`, `/branch` |
| Ranh giới cứng | Org policy + server gates (branch protection, push protection, review required) | Hooks + permission deny |
| Undo phiên | Timeline / fork chat / `git restore` (không có `/rewind`) | `/rewind` có sẵn |

> **Cách đọc bảng này:** Mỗi dòng là một việc cài đặt — so xem cùng việc đó Copilot đặt luật ở đâu và Claude Code đặt ở đâu.

**Best practices (kèm "vì sao"):** chọn mode theo kích thước việc (Agent cho việc một dòng là cách đốt AI Credits nhanh nhất) · nới việc đọc (allow), siết việc ghi/chạy (ask/deny) — terminal và MCP write có thể xoá hoặc gửi dữ liệu ra ngoài · deny-first ở org/team, đừng lách bằng personal — deny thắng mọi nơi · bọc Autopilot/Allow all bằng sandbox + worktree riêng + git sạch · gặp "setting không thấy" thì tra plan trước khi báo bug.

**Link chéo:** Bài 03 (instructions vs permissions) · Bài 06 (`tools`/`model` trong frontmatter agent) · Bài 07 (content exclusion + branch protection) · Bài 08 (tool approval theo MCP server) · Bài 09 (org allow/block extensions) · Bài 11 (scope Agent mode bằng worktree + undo) · Bài 12 (coding agent permissions trên cloud) · Bài 17 (hooks preview).

> **Tóm gọn 1 câu:** Hai công cụ khác tên nhưng chung nguyên tắc — nới đọc, siết ghi, deny thắng mọi nơi, và luôn có ranh giới cứng phía ngoài agent.

---

> **Chốt bài 10:** mode quyết định agent tự chủ tới đâu, permission quyết định nó được chạm vào gì. Nắm được `deny > ask > allow` và "nới đọc, siết ghi" là bạn kiểm soát được agent thay vì để nó kiểm soát máy bạn. *(Hết bài 10. Tiếp theo: Bài 11 — Git worktrees & checkpoints.)*
