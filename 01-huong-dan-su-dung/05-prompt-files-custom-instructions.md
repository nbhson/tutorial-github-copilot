# 05 — Agent Skills & Custom Instructions (Tái Dùng Workflow Lặp Lại — Chuẩn 2026)

> **Dành cho:** dev đã xong bài 03–04, dùng được Copilot Chat cơ bản, và thấy mình gõ đi gõ lại cùng một prompt. Không cần biết DevOps hay tự xây tool.
> **Vấn đề:** việc lặp lại (deploy, review, migrate, sinh test) giống như mỗi sáng phải chép lại cùng một tờ ghi chú dài — tốn token, dễ quên bước, ai trong team cũng nhớ một kiểu.
> **Đọc xong:** bạn viết được Agent Skill `.github/skills/<ten>/SKILL.md` (chuẩn khuyến nghị 2026), biết đặt custom instructions đúng chỗ, và biết lúc nào mới cần Agent Plugin. **Thời gian:** ~30 phút.
>
> **Lưu ý 2026:** `.prompt.md` (prompt files) **deprecated cho Agent Host sessions** (Copilot/Cloud) — vẫn chạy trên Local/VS Code nhưng việc mới nên ưu tiên **Agent Skills** (`SKILL.md`, chuẩn mở, port mọi nơi). Bài này dạy cả 2, khuyến nghị skill cho việc mới.

## Mục tiêu bài học

- Viết được **1 Agent Skill** `.github/skills/<ten>/SKILL.md` đúng chuẩn 2026 — agent tự load khi nghe đúng từ khóa, không bạn phải gọi.
- Phân biệt **instructions vs skill vs agent vs plugin** — biết việc nào thì lấy đồ nào, như chọn đúng dụng cụ trong hộp đồ nghề.
- **Port prompt file cũ** (`.prompt.md`) sang skill để chạy được cả Local lẫn Cloud.
- Biết khi nào mới cần **Agent Plugin** (≥3 repos cùng chuẩn) thay vì skill lẻ.

> **Tóm gọn 1 câu:** Sau bài này, việc gì lặp lại bạn đóng thành skill một lần rồi để agent tự chạy mỗi lần sau.

---

## 1. Agent Skill là gì?

**Nôm na 1 câu:** Agent Skill là **sổ tay nghề chuẩn, tự động** — việc nào lặp lại thì ghi công thức 1 lần trong `SKILL.md`. Agent "nghe" bạn nói "deploy" là tự mở đúng trang sổ, khỏi dặn lại, khỏi gõ `/`.

**Analogie:** Prompt file giống tờ giấy ghi chú bạn phải tự rút khỏi túi mỗi lần cần. Skill thì như trợ lý đứng cạnh: nghe bạn nói "nấu phở" là tự giở đúng trang phở trong sổ tay.

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

**Khác instructions ở chỗ:** instructions giống nội quy dán ở cửa nhà — ai vào cũng thấy, load cho **mọi chat**. Skill thì chỉ mở **khi khớp từ khóa** → nhẹ hơn, rẻ hơn. Skill **không tự chạy, không kết nối ra ngoài** — nó là văn bản + scripts Copilot đọc và làm theo, như cuốn sách hướng dẫn chứ không phải người máy tự đi làm.

> **Vì sao quan trọng?** Việc lặp lại là chỗ tốn thời gian và dễ sai nhất. Đóng thành skill 1 lần thì mọi lần sau agent tự chạy đủ bước, cả team dùng chung một chuẩn — và chạy được trên mọi harness (Local, Copilot, Cloud, CLI, app) nhờ chuẩn mở.
>
> **Nếu làm sai?** `SKILL.md` dài như wiki (>100 dòng) → agent bỏ bước giữa chừng; `description` chung chung → skill không bao giờ tự load; để secret trong skill rồi commit → lộ key.
>
> **Tóm gọn 1 câu:** Skill là sổ tay nghề ghi sẵn công thức việc lặp — bạn chỉ cần nói tên việc, agent tự giở đúng trang ra làm.

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
>
> **Tóm gọn 1 câu:** Chọn đồ theo việc: fact cần mọi chat → instructions, việc lặp → skill, persona riêng → custom agent, share nhiều repos → plugin.

---

## 3. Giải phẫu SKILL.md (2026 — khuyến nghị)

Mục này mổ xẻ một file `SKILL.md` xem bên trong có gì. Biết cấu trúc rồi thì bạn tự viết được skill đầu tiên ở mục 7.

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

> **Cách đọc bảng này:** Cột "Field" là tên thành phần trong file, "Nôm na" là hình ảnh đời thường để nhớ nhanh, cột "Ý nghĩa" nói rõ nó làm gì, cột cuối cho biết khi nào cần dùng đến.

> **Verify skill đã load (copy-paste test):** tạo skill + chat "deploy staging giúp" (KHÔNG gõ `/`) → agent phải tự load, chạy 5 bước, báo cáo theo examples. Không trigger → description thiếu từ khóa "deploy" (sửa câu đầu).
>
> **Tóm gọn 1 câu:** `description` là nhãn dán ngoài hộp — viết đúng từ user hay nói thì skill mới được tự mở.

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

> 📄 **Code ví dụ:** [`examples/01-4-2-mau-b-skill-add-table-script.sh`](examples/01-4-2-mau-b-skill-add-table-script.sh)

### 4.3. Port prompt file cũ sang skill (migration 5 phút)

> 📄 **Code ví dụ:** [`examples/02-4-3-port-prompt-file-cu-sang-skill.sh`](examples/02-4-3-port-prompt-file-cu-sang-skill.sh)

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

> **Cách đọc bảng này:** Cột "File" là vị trí đặt file, "Ai đọc" cho biết ai sẽ soi file đó, cột "Khi nào dùng" là tình huống nên chọn nó.

**Harness hỗ trợ (10/2026):**

| Bề mặt | Skill `SKILL.md` | Prompt file (legacy) | Instructions |
|---|---|---|---|
| VS Code / IDE (Local) | ✓ | ✓ (deprecated) | ✓ |
| Copilot Chat trên github.com | ✓ | ✗ | ✓ |
| Copilot Cloud / coding agent | ✓ | ✗ | ✓ |
| Copilot CLI | ✓ | ✗ | ✓ (repo) |

> **Cách đọc bảng này:** Mỗi dòng là một "bề mặt" (nơi chạy Copilot), mỗi cột là một cơ chế; dấu ✓ nghĩa là chạy được, ✗ là không.

> Điểm rơi: **prompt file chỉ còn đúng 1 bề mặt** (Local) — đó là lý do 2026 chuẩn hóa về skill.
>
> **Tóm gọn 1 câu:** Custom instructions là quy ước nền cho mọi chat, còn skill là công thức cho từng việc lặp — đặt đúng chỗ là agent tự đọc.

---

## 6. Agent Plugin — khi nào mới đáng?

Skill là 1 folder trong repo. **Agent Plugin** (bài 09 chi tiết) là **hộp đóng gói** nhiều skills + agents + MCP servers để **cài 1 phát vào nhiều repos** — như cài extension trình duyệt một lần rồi mọi máy đều có.

| Tình huống | Dùng | Vì sao |
|---|---|---|
| 1 việc lặp, 1 repo | Skill trong repo | Nhẹ, không thêm phụ thuộc |
| 1 việc lặp, 2–3 repos copy-paste | Skill copy (chấp nhận) | Vẫn đơn giản hơn quản lý plugin |
| Chuẩn team: skills + agents + MCP giống nhau ở **≥3 repos** | Agent Plugin | Update 1 nơi, mọi repos nhận |
| Cần bán/phân phối cho bên ngoài | Extension (marketplace) | Có versioning + cài đặt qua UI |

> **Cách đọc bảng này:** Cột "Tình huống" mô tả cảnh bạn đang gặp, hai cột còn lại trả lời "lấy đồ nào" và "tại sao" — đọc từ trên xuống theo mức độ lan rộng tăng dần.

> Đừng bắt đầu bằng plugin. Skill trước, plugin khi sao chép thứ 3.
>
> **Tóm gọn 1 câu:** Plugin chỉ đáng khi bạn đang chép tay cùng một bộ skills sang từ repo thứ 3 trở lên.

---

## 7. Walkthrough 5 phút — skill đầu tiên của bạn

> 📄 **Code ví dụ:** [`examples/03-7-walkthrough-5-phut-skill-au-tien-cua.sh`](examples/03-7-walkthrough-5-phut-skill-au-tien-cua.sh)

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

> **Cách đọc bảng này:** Cột "Lỗi" là chuyện hay gặp, "Hậu quả" là chuyện xấu xảy ra sau đó, cột "Sửa" là cách chữa — tra theo cột đầu khi gặp sự cố.

**SAI → ĐÚNG:**

```text
SAI:  description: "Giúp các việc liên quan đến code"
ĐÚNG: description: "Deploy staging/prod voi checklist. Dung khi user noi deploy, release, ship."

SAI:  150 dòng steps trong SKILL.md, secrets nằm ở bước 3
ĐÚNG: ≤10 steps, chi tiết dài ở references/, lệnh ở scripts/, không secret
```

> **Tóm gọn 1 câu:** Pitfall lớn nhất là viết `description` chung chung — skill có hay đến mấy mà không được gọi thì cũng như không.

---

## 9. Đối chiếu Claude Code (nếu bạn song song cả 2)

| Khái niệm | Copilot (2026) | Claude Code |
|---|---|---|
| Skill mở | `.github/skills/<ten>/SKILL.md` | `.claude/skills/<ten>/SKILL.md` — cùng frontmatter `name`/`description` |
| Instructions nền | `.github/copilot-instructions.md` | `CLAUDE.md` (+ `AGENTS.md` chung) |
| Slash command | prompt file (legacy) | `.claude/commands/<ten>.md` (vẫn là cách chính) |
| Hot-reload skills | theo phiên IDE | có từ 2.1.0 (01/2026) |

> **Cách đọc bảng này:** Cột "Khái niệm" là cùng một ý niệm ở hai hệ, hai cột còn lại cho biết tên gọi/tính năng tương ứng — so theo hàng dọc.

Cùng format frontmatter nên skill viết cho Copilot **port qua Claude Code gần như nguyên văn** — chỉ đổi folder, như đổi tủ đựng mà giữ nguyên đồ.

> **Tóm gọn 1 câu:** Skill giữa Copilot và Claude Code giống nhau tới 90% — chép file, đổi đường dẫn, xong.

---

## Bài tập

1. Tạo skill `gen-test` (mục 7) cho repo của bạn, verify agent tự load khi chat không gõ `/`.
2. Chọn 1 prompt file `.prompt.md` đang có (nếu có) → port sang skill theo mục 4.3, xóa file cũ sau khi pass test.
3. Tìm chỗ team bạn lặp nhiều nhất (deploy? review? release note?) → đóng thành skill thứ 2, mô tả `description` bằng đúng từ đồng đội hay gõ.

> **Tóm gọn 1 câu:** Bài tập cốt lõi là tạo 1 skill thật và chứng minh nó tự load — không gõ `/` mà agent vẫn hiểu.

## Link qua

- Cú pháp đầy đủ `copilot-instructions.md` + `applyTo` → bài 03.
- Custom agent (persona + tools riêng) → bài 06.
- Đóng gói nhiều skill thành Agent Plugin → bài 09.
- Skill + MCP cùng nhau (agent gọi tool ngoài theo quy trình) → bài 08.

> **Tóm gọn 1 câu:** Instructions chi tiết ở bài 03, agent ở bài 06, MCP ở bài 08, plugin ở bài 09.

## Reference

- GitHub Docs — [Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills) · [Custom instructions](https://docs.github.com/en/copilot/customization/custom-instructions)
- Blog — [About Copilot agent skills](https://github.blog/ai-and-ml/github-copilot/about-copilot-agent-skills/)

> **Tóm gọn 1 câu:** Cần nguồn chính thống thì đọc GitHub Docs và blog của GitHub — hai link này là gốc.

**Chốt:** việc lặp lại ≥2 lần thì đáng thành skill — `description` là trigger, thân file <100 dòng, phần nặng xuống `scripts/` + `references/`. Việc mới → skill, đừng tạo prompt file mới.
