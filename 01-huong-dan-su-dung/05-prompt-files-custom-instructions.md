# 05 — Agent Skills & Custom Instructions (Tái Dùng Workflow Lặp Lại — Chuẩn 2026)

> **Dành cho:** dev đã dùng Copilot Chat ở mức cơ bản (xong bài 03–04) và muốn bớt gõ prompt lặp — không cần biết DevOps hay tự xây tool.
> **Vấn đề:** việc lặp lại (deploy, review, migrate, sinh test) phải paste lại checklist dài mỗi lần → tốn token, dễ quên bước, team mỗi người một kiểu.
> **Đọc xong:** viết được Agent Skill `.github/skills/<ten>/SKILL.md` (chuẩn khuyến nghị 2026), đặt custom instructions đúng chỗ, biết khi nào mới cần Agent Plugin. **Thời gian:** ~30 phút.
>
> **Lưu ý 2026:** `.prompt.md` (prompt files) **deprecated cho Agent Host sessions** (Copilot/Cloud) — vẫn chạy trên Local/VS Code nhưng việc mới nên ưu tiên **Agent Skills** (`SKILL.md`, chuẩn mở, port mọi nơi). Bài này dạy cả 2, khuyến nghị skill cho việc mới.

## Mục tiêu bài học

- Viết được **1 Agent Skill** `.github/skills/<ten>/SKILL.md` đúng chuẩn 2026, agent tự load khi khớp từ khóa.
- Phân biệt **instructions vs skill vs agent vs plugin** và chọn đúng thứ cho từng việc.
- **Port prompt file cũ** (`.prompt.md`) sang skill để chạy được cả Local lẫn Cloud.
- Biết khi nào mới cần **Agent Plugin** (≥3 repos cùng chuẩn) thay vì skill lẻ.

---

## 1. Agent Skill là gì?

**Nôm na 1 câu:** Agent Skill là **sổ tay nghề chuẩn, tự động** — việc nào lặp lại thì ghi công thức 1 lần trong `SKILL.md`. Agent "nghe" bạn nói "deploy" là tự mở đúng trang sổ, khỏi dặn lại, khỏi gõ `/`.

**Analogie:** Prompt file như tin nhắn ghim trong nhóm (phải chủ động mở xem). Skill như trợ lý đứng cạnh — nghe "nấu phở" là tự mở đúng trang phở.

```text
KHÔNG skill (paste tay mỗi lần):
Bạn: "deploy staging giúp anh. Nhớ: check git status, migration dry-run,
  deploy, smoke test endpoints docs/endpoints.md, báo cáo PASS/FAIL..."
  → 100 tokens mỗi lần, dễ quên bước 2.

CÓ skill (.github/skills/deploy-checklist/SKILL.md):
Bạn: "deploy staging giúp" (không cần gõ /)
Agent: tự load SKILL.md đúng ngữ cảnh → chạy 5 bước → báo cáo.
```

**Vị trí chuẩn 2026:**

```text
.github/skills/<ten>/SKILL.md        team dùng chung, commit git (KHUYÊN DUNG — chuẩn mở)
~/.copilot/skills/<ten>/SKILL.md     cá nhân (nếu IDE hỗ trợ)
<plugin>/skills/<ten>/SKILL.md       theo Agent Plugin (mục 6, bài 09)

# Legacy (vẫn chạy trên Local/VS Code, deprecated cho Agent Host):
.github/prompts/<ten>.prompt.md       cũ — port sang skill (mục 4.3)
```

**Khác instructions ở chỗ:** instructions load cho **mọi chat**; skill chỉ load **khi khớp từ khóa** → rẻ hơn. Skill **không tự chạy, không kết nối ra ngoài** — nó là văn bản + scripts Copilot đọc và làm theo.

> **Vì sao quan trọng?** Việc lặp lại là chỗ tốn thời gian và dễ sai nhất. Đóng thành skill 1 lần thì mọi lần sau agent tự chạy đủ bước, cả team dùng chung một chuẩn — và chạy được trên mọi harness (Local, Copilot, Cloud, CLI, app) nhờ chuẩn mở.
>
> **Nếu làm sai?** `SKILL.md` dài như wiki (>100 dòng) → agent bỏ bước giữa chừng; `description` chung chung → skill không bao giờ tự load; để secret trong skill rồi commit → lộ key.

---

## 2. Sơ đồ: instructions vs skill vs agent vs plugin

```text
Bạn nói/gõ → Việc gì?
- Fact cần MỌI chat        -> copilot-instructions.md (load luôn)
- Việc lặp, gõ khi cần     -> prompt file /ten (legacy, chỉ Local)
- Việc lặp, tự khớp        -> Agent Skill SKILL.md (KHUYÊN DUNG 2026, chạy mọi harness)
- Persona chuyên biệt      -> custom agent .agent.md (bài 06)
- Share nhiều repos        -> Agent Plugin / Extension (bundle skills + agents + MCP)
```

> So sánh: skill là *nội dung* agent chạy; agent là "ai chạy" (persona + tools). MCP là *cánh tay vươn ra ngoài*; skill chứa *cách dùng* MCP — cặp bài trùng. Extension/plugin là *hộp đóng gói* skill lẻ để share.

---

## 3. Giải phẫu SKILL.md (2026 — khuyến nghị)

Mỗi Agent Skill là **1 folder**: `SKILL.md` (frontmatter `name` + `description` + thân markdown Steps) + files hỗ trợ (`scripts/`, `references/`, `examples/`). Agent *tự* mở khi thấy từ khóa khớp description.

```markdown
---
name: deploy-checklist
description: 'Deploy staging/prod voi checklist migrate + smoke test.
  Dung khi user noi deploy, release, ship, xuat ban.'
---

# Deploy checklist

## Steps

1. `git status --short` phai sach, neu khong dung va bao.
2. Chay migration dry-run: `scripts/migrate.sh --dry-run $ARG`.
3. Deploy bang lenh da verify trong `.github/copilot-instructions.md`.
4. Smoke test endpoints trong `references/endpoints.md`.
5. Ghi ket qua theo `examples/output.md`.
```

**Biến + files hỗ trợ:**

- `${input}` — args sau câu trigger (vd "deploy staging" → `input=staging`).
- `${workspaceFolder}` — repo root, dùng khi cần đường dẫn tuyệt đối.
- `scripts/` — lệnh chạy được (bash/python), agent gọi trực tiếp.
- `references/` — tài liệu dài agent đọc khi cần.
- `examples/` — output mẫu để agent làm theo đúng format.

**Frontmatter — từng field:**

| Field | Nôm na | Ý nghĩa | Ai dùng lúc nào |
|---|---|---|---|
| `name` | Tên gói mì (duy nhất) | `kebab-case`, khớp tên folder | Đặt 1 lần, không đổi |
| `description` | **Nhãn dán ngoài hộp (quan trọng nhất)** | Câu đầu = **trigger từ khóa** user nói thật; quyết định agent tự load hay không | Luôn cập nhật khi thêm từ khóa mới |
| Thân `SKILL.md` | Công thức nấu ăn | Steps đánh số + NEVER + Output mẫu (<100 dòng) | Việc có >3 steps |
| `scripts/` `references/` `examples/` | Dụng cụ / sách tra / món mẫu | Lệnh chạy, tài liệu dài, output mẫu | Checklist dài >50 dòng, cần output nhất quán |

> **Verify skill đã load (copy-paste test):** tạo skill + chat "deploy staging giúp" (KHÔNG gõ `/`) → agent phải tự load, chạy 5 bước, báo cáo theo examples. Không trigger → description thiếu từ khóa "deploy" (sửa câu đầu).

---

## 4. Mẫu + migration

### 4.1. Mẫu A — Skill `review-pr`

```markdown
# .github/skills/review-pr/SKILL.md
---
name: review-pr
description: 'Review PR tim bug + security + missing test.
  Dung khi user noi review, phan tich PR, kiem tra diff, "review #123".'
---

# Review PR

## Steps
1. Doc diff (PR hoac branch hien tai): files nao doi, muc dich la gi.
2. Tim: (a) bug logic, (b) loi security (injection, authz, leak secret),
   (c) thieu test cho logic moi, (d) pha vo quy uoc trong `.github/copilot-instructions.md`.
3. KHONG nitpick style (linter lo). Chi bao loi that + file:line cu the.
4. Ket luan: APPROVE / REQUEST_CHANGES + top 3 van de theo thu tu nghiem trong.

## Cam
- NEVER sua code trong luoc review (chi doc + comment).
- NEVER de secret trong output.

## Output mau
- [file:line] Mo ta loi — vi sao sai — goi y sua 1-2 dong.
```

### 4.2. Mẫu B — Skill `add-table` (script đi kèm)

```markdown
# .github/skills/add-table/SKILL.md
---
name: add-table
description: 'Them table/column moi (forward-only migration + model + test).
  Dung khi user noi "them bang", "them cot", "migration moi".'
---

# Add table
## Steps
1. Doc schema hien tai + 1 migration mau gan nhat (copy convention).
2. Tao migration forward-only (KHONG sua migration da merge).
3. Update model + zod schema + seed neu can.
4. Chay: `scripts/migrate.sh dev` + focused test + lint. Paste output vao bao cao.

## Cam
- NEVER doi schema DB trong cung PR voi logic phuc tap (tach 2 PRs).
- NEVER viet down migration pha du lieu.
```

```bash
# .github/skills/add-table/scripts/migrate.sh (chmod +x)
#!/bin/sh
case "$1" in
  dev)  pnpm migrate:dev ;;     # chay local
  dry)  pnpm migrate:dry ;;     # dry-run truoc khi chay that
  *)    echo "Dung: $0 dev|dry" ; exit 1 ;;
esac
```

### 4.3. Port prompt file cũ sang skill (migration 5 phút)

```bash
# Bước 1: tạo folder skill mới:
mkdir -p .github/skills/deploy-checklist/{scripts,references,examples}
touch .github/skills/deploy-checklist/SKILL.md

# Bước 2: copy body .github/prompts/deploy.prompt.md vào SKILL.md,
# giữ `description` (đây là trigger). Đổi name theo tên folder.

# Bước 3: tách steps dài >50 dòng vào references/ (nếu có).

# Bước 4: xóa prompt file cũ sau khi skill pass test:
rm .github/prompts/deploy.prompt.md

# Verify: chat "deploy staging" (KHÔNG gõ /) → skill tự load.
```

---

## 5. Custom instructions đặt ở đâu?

Skill là "công thức cho việc cụ thể". Ngược lại, **custom instructions** là "quy ước nền" áp cho mọi chat — chi tiết cú pháp đã ở bài 03, ở đây chỉ cần biết **đặt file nào cho ai đọc**:

| File | Ai đọc | Khi nào dùng |
|---|---|---|
| `.github/copilot-instructions.md` | Mọi ai mở repo (team) | Quy ước repo: framework, lệnh test, style — **đặt 1 file này trước đã** |
| `~/.copilot/copilot-instructions.md` | Chỉ bạn (mọi repo) | Sở thích cá nhân: "trả lời tiếng Việt", "ngắn gọn" |
| `.github/instructions/*.instructions.md` + `applyTo` | Mọi ai, chỉ với file khớp glob | Quy ước theo vùng: `**/*.test.ts` → "dùng vitest" |
| `.github/skills/<ten>/SKILL.md` | Agent, khi khớp từ khóa | Việc lặp có nhiều bước (chủ đề chính bài này) |
| `AGENTS.md` | Coding agent + nhiều harness khác | Repo chuẩn mở — Copilot coding agent đọc (bài 07) |

**Harness hỗ trợ (10/2026):**

| Bề mặt | Skill `SKILL.md` | Prompt file (legacy) | Instructions |
|---|---|---|---|
| VS Code / IDE (Local) | ✓ | ✓ (deprecated) | ✓ |
| Copilot Chat trên github.com | ✓ | ✗ | ✓ |
| Copilot Cloud / coding agent | ✓ | ✗ | ✓ |
| Copilot CLI | ✓ | ✗ | ✓ (repo) |

> Điểm rơi: **prompt file chỉ còn đúng 1 bề mặt** (Local) — đó là lý do 2026 chuẩn hóa về skill.

---

## 6. Agent Plugin — khi nào mới đáng?

Skill là 1 folder trong repo. **Agent Plugin** (bài 09 chi tiết) là **hộp đóng gói** nhiều skills + agents + MCP servers để **cài 1 phát vào nhiều repos** — như cài extension.

| Tình huống | Dùng | Vì sao |
|---|---|---|
| 1 việc lặp, 1 repo | Skill trong repo | Nhẹ, không thêm phụ thuộc |
| 1 việc lặp, 2–3 repos copy-paste | Skill copy (chấp nhận) | Vẫn đơn giản hơn quản lý plugin |
| Chuẩn team: skills + agents + MCP giống nhau ở **≥3 repos** | Agent Plugin | Update 1 nơi, mọi repos nhận |
| Cần bán/phân phối cho bên ngoài | Extension (marketplace) | Có versioning + cài đặt qua UI |

> Đừng bắt đầu bằng plugin. Skill trước, plugin khi sao chép thứ 3.

---

## 7. Walkthrough 5 phút — skill đầu tiên của bạn

```bash
# 1. Tạo folder + file (repo root):
mkdir -p .github/skills/gen-test && echo "" > .github/skills/gen-test/SKILL.md
# 2. Paste nội dung bên dưới vào SKILL.md (sửa theo repo của bạn)
# 3. Commit + push (skill dùng chung cho cả team):
git add .github/skills/gen-test && git commit -m "add gen-test skill" && git push
# 4. Verify: chat "viet test cho src/utils/date.ts" (KHÔNG gõ /)
#    → agent phải tự load skill, viết test, chạy test.
#    Không tự load? Sửa câu ĐẦU của description — thêm đúng từ bạn hay gõ.
```

```markdown
# .github/skills/gen-test/SKILL.md
---
name: gen-test
description: 'Viet unit test cho file/bien doi vua doi.
  Dung khi user noi viet test, them test, test file nay.'
---
# Viet unit test
## Steps
1. Doc file duoc chi dinh + 1 test gan nhat (copy convention: ten, describe/it, fixture).
2. Viet test cho: happy path 1, edge case 2, error path 1.
3. Chay test focused (lenh trong copilot-instructions.md), paste output.
## Cam
- NEVER mock nhung gi khong hieu — doc source truoc khi mock.
```

## 8. Pitfalls

| Lỗi | Hậu quả | Sửa |
|---|---|---|
| `description` chung chung ("helpful helper") | Skill không bao giờ tự load | Câu đầu liệt kê **từ khóa user nói thật**: "deploy, release, ship" |
| `SKILL.md` > 100 dòng | Agent bỏ bước giữa chừng, tốn context | Steps ≤ 10; phần dài xuống `references/`, script xuống `scripts/` |
| Đặt secret/API key trong skill rồi commit | Lộ key public | Skill chỉ chứa cách dùng; key nằm trong secrets (bài 08) |
| Gõ `/deploy` rồi thắc mắc "skill khác gì prompt file" | Nhầm 2 cơ chế | `/` = prompt file (gõ tay, legacy); skill = **không gõ gì**, agent tự khớp |
| Skill tự chạy deploy thật khi chỉ nói suông | Deploy nhầm môi trường | Thêm "NEVER deploy without explicit confirm trong message" + luôn dry-run trước |

**SAI → ĐÚNG:**

```text
SAI:  description: "Giúp các việc liên quan đến code"
ĐÚNG: description: "Deploy staging/prod voi checklist. Dung khi user noi deploy, release, ship."

SAI:  150 dòng steps trong SKILL.md, secrets nằm ở bước 3
ĐÚNG: ≤10 steps, chi tiết dài ở references/, lệnh ở scripts/, không secret
```

---

## 9. Đối chiếu Claude Code (nếu bạn song song cả 2)

| Khái niệm | Copilot (2026) | Claude Code |
|---|---|---|
| Skill mở | `.github/skills/<ten>/SKILL.md` | `.claude/skills/<ten>/SKILL.md` — cùng frontmatter `name`/`description` |
| Instructions nền | `.github/copilot-instructions.md` | `CLAUDE.md` (+ `AGENTS.md` chung) |
| Slash command | prompt file (legacy) | `.claude/commands/<ten>.md` (vẫn là cách chính) |
| Hot-reload skills | theo phiên IDE | có từ 2.1.0 (01/2026) |

Cùng format frontmatter nên skill viết cho Copilot **port qua Claude Code gần như nguyên văn** — chỉ đổi folder.

---

## Bài tập

1. Tạo skill `gen-test` (mục 7) cho repo của bạn, verify agent tự load khi chat không gõ `/`.
2. Chọn 1 prompt file `.prompt.md` đang có (nếu có) → port sang skill theo mục 4.3, xóa file cũ sau khi pass test.
3. Tìm chỗ team bạn lặp nhiều nhất (deploy? review? release note?) → đóng thành skill thứ 2, mô tả `description` bằng đúng từ đồng đội hay gõ.

## Link qua

- Cú pháp đầy đủ `copilot-instructions.md` + `applyTo` → bài 03.
- Custom agent (persona + tools riêng) → bài 06.
- Đóng gói nhiều skill thành Agent Plugin → bài 09.
- Skill + MCP cùng nhau (agent gọi tool ngoài theo quy trình) → bài 08.

## Reference

- GitHub Docs — [Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills) · [Custom instructions](https://docs.github.com/en/copilot/customization/custom-instructions)
- Blog — [About Copilot agent skills](https://github.blog/ai-and-ml/github-copilot/about-copilot-agent-skills/)

**Chốt:** việc lặp lại ≥2 lần thì đáng thành skill — `description` là trigger, thân file <100 dòng, phần nặng xuống `scripts/` + `references/`. Việc mới → skill, đừng tạo prompt file mới.
