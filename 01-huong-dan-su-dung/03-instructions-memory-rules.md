# 03 — Instructions, Memory & Rules (File Quan Trọng Nhất Copilot)

> **Dành cho:** dev đã dùng Copilot Chat nhưng chưa có file instructions chuẩn cho repo.
> **Vấn đề:** agent đoán lệnh sai, chạy sai style, đụng vào file generated — vì repo không có file hướng dẫn.
> **Đọc xong:** viết được `.github/copilot-instructions.md` <200 dòng, tách rules theo `applyTo` globs, tương thích `AGENTS.md`, hiểu instruction hierarchy. **Thời gian:** ~30 phút.

## Mục tiêu bài học

- Viết được `copilot-instructions.md` gọn **<200 dòng**, mọi lệnh đã verify.
- Phân biệt rõ **3 loại file**: `copilot-instructions.md` / `*.instructions.md` / `AGENTS.md`.
- Tách rules theo **`applyTo` glob** hẹp nhất, hiểu **token economics** — vì sao 1 dòng thừa bị tính tiền N lần.

---

## 1. Vì sao instructions là file quan trọng nhất?

Instructions là nơi bạn dạy Copilot biết repo của bạn — một lần viết, mọi task sau đều được lợi.

- **Là gì (1 câu):** file markdown do bạn viết, Copilot đọc ở đầu mỗi chat và nhớ suốt phiên.
- **Nôm na:** tờ dặn dò dán trên tủ lạnh cho người giúp việc: "chó ăn 2 bữa, đừng mở cửa sau".
- **Ví dụ:** dòng `Test focused: npm test -- --filter api` giúp agent không chạy nhầm `pnpm test` full 20 phút.

```text
Cơ chế: instructions được inject vào system prompt ở đầu chat.
Mỗi turn, agent nạp lại toàn bộ context: instructions + history + tool results.
=> 1 dòng thừa trong instructions = trả AI Credits N lần (N = số turns).

Vì sao quan trọng: luật đúng thì mọi task sau tự đúng mà không phải nhắc lại;
luật sai thì mọi task sau đều sai theo.
Nếu làm sai: không có instructions, agent tự đoán lệnh test + style (và đoán sai);
nhét 500 dòng wiki vào thì trả tiền cho rác mỗi turn + loãng trọng tâm.
```

> **Kỳ vọng / Verify:** mở chat mới, hỏi "Liệt kê 3 lệnh dev/test/lint + 2 thứ NEVER". Trả lời khớp file = instructions đã load. Sai = check setting `useInstructionFiles` (bài 01).

---

## 2. 3 loại file — phân biệt và đặt ở đâu

Bảng này là xương sống của cả bài:

| Loại file | Nằm ở đâu | Là gì (nôm na) | Ví dụ | Khi nào dùng |
|---|---|---|---|---|
| **1. `copilot-instructions.md`** | `.github/` (1 file duy nhất, commit git) | Nội quy cả nhà, đọc mọi lần vào nhà | "Dùng pnpm. Test: `pnpm vitest run...`. NEVER commit thẳng main." | Quy ước mọi task đều cần (<200 dòng) |
| **2. `*.instructions.md`** | `.github/instructions/` (mỗi file có `applyTo`) | Nội quy từng phòng, chỉ đọc khi vào phòng đó | `applyTo: "apps/api/**"` → "Route không query DB trực tiếp" | Quy tắc chỉ đúng 1 subtree (mỗi file <50 dòng, tối đa ~8 files) |
| **3. `AGENTS.md`** | Repo root (chuẩn mở) | Nội quy khu phố, đội thợ nào cũng hiểu | "Dev: `npm run dev`. Test: `npm test`." | Viết 1 lần để Copilot + Claude Code + Codex đều dùng được |

```bash
# Copy-paste: tạo đủ 3 loại file trong 1 phút
mkdir -p .github/instructions
touch .github/copilot-instructions.md AGENTS.md .github/instructions/api.instructions.md
ls -la .github/copilot-instructions.md .github/instructions/ AGENTS.md 2>&1
# Kỳ vọng: ls hiện đủ 3 paths. Sau đó paste mẫu mục 3 + 4.

# Kiểm tra độ phình:
wc -l .github/copilot-instructions.md .github/instructions/*.instructions.md 2>/dev/null
# Mục tiêu: repo-wide file <200 dòng.
```

### 2.1. Instruction hierarchy (thứ tự thắng khi xung đột)

```text
user settings < org policy < repo copilot-instructions.md < *.instructions.md (applyTo cụ thể)
```

- File **cụ thể hơn thắng**: rule trong `api.instructions.md` thắng rule chung khi sửa file trong `apps/api/`.
- **Org policy (Business/Enterprise) thắng mọi thứ** — admin cấm thì repo không mở được.
- Quy tắc team: personal preferences (ngôn ngữ trả lời) để ở user settings; mọi thứ team dùng chung phải vào repo files + commit.

```json
// .vscode/settings.json — repo-level (commit cho team) để bật instructions:
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true
}

// ~/.config/Code/User/settings.json — personal (KHÔNG commit), instructions riêng:
{
  "github.copilot.chat.codeGeneration.instructions": [
    { "text": "Trả lời bằng tiếng Việt, ngắn gọn. Code comments không dấu." }
  ]
}
```

---

## 3. 2 instructions mẫu hoàn chỉnh (copy-paste)

> Mỗi mẫu <100 dòng, lệnh đã verify, rules check được. Thay `<...>` bằng project bạn.

### 3.1. Mẫu A — Web app (Next.js + Postgres + pnpm)

```markdown
# Project: Acme Shop Web — Next.js 15 storefront + API routes

## Tech Stack
- Next.js 15 (App Router), TypeScript strict, Tailwind, Prisma + Postgres 16
- Auth: NextAuth v5. Tests: Vitest + Playwright

## Commands (VERIFIED 2026-10 — chay lai neu doi toolchain)
- Dev: `pnpm dev` (web :3000, can `.env.local` tu 1Password "Acme dev")
- DB migrate: `pnpm prisma migrate dev`
- Test focused: `pnpm vitest run apps/web/src/app/login/`
- Test full: `pnpm test` (khong chay khi chi sua 1 file — dung focused)
- Lint: `pnpm eslint apps/web/src --max-warnings 0`
- Full check truoc PR: `pnpm lint && pnpm test && pnpm build`

## Architecture
- `apps/web/src/app/` routes (server components mac dinh)
- `apps/web/src/server/` owns DB access; client KHONG import prisma truc tiep
- `packages/ui/` design system; `packages/contracts/` zod schemas dung chung

## Code Style
- API errors shape `{ code, message, requestId }`, status dung (400/401/403/404/422/500)
- File >300 dong thi tach; component >150 dong thi tach; khong `any`

## Rules
- ALWAYS chay focused test sau khi sua; paste output vao bao cao
- ALWAYS `pnpm prisma migrate dev --name <ten>` khi doi schema, KHONG sua SQL tay
- NEVER commit truc tiep main, NEVER sua `src/generated/` va migration da merge
```

### 3.2. Mẫu B — API (Node Express + Postgres + npm)

```markdown
# Project: Acme API — Express + Postgres 16 + TypeScript

## Commands (VERIFIED 2026-10)
- Dev: `npm run dev` (api :4000, can `.env` tu 1Password "Acme dev")
- Test focused: `npm test -- --filter api --testPathPattern=orders`
- Lint: `npm run lint`

## Architecture
- `src/routes/` HTTP layer mong; `src/services/` business logic; `src/db/` query only
- Route KHONG query DB truc tiep — goi qua service
- Zod schemas o `src/contracts/`, dung chung validator + test fixtures

## Rules
- ALWAYS tra loi loi dang `{ code, message }`, KHONG leak stack trace ra client
- ALWAYS them regression test khi fix bug
- NEVER doi schema DB trong cung PR voi logic (tach 2 PRs)
- Migration chi tien (forward-only), KHONG viet down migration pha du lieu
```

> Mẫu Python (FastAPI + `uv` + pytest + ruff) cùng cấu trúc: thêm rule "ALWAYS chay `ruff` truoc `pytest`", "dung timezone-aware datetime", "DB session per-request qua dependency".

---

## 4. Rules patterns + applyTo globs

> `*.instructions.md` là file rules theo đường dẫn: đầu file có `applyTo: "glob"`, chỉ load khi task chạm vào path đó. Nôm na: biển báo trong phòng thí nghiệm — ai vào phòng đó mới cần đọc.

```markdown
---
applyTo: "apps/api/**"
---

# API rules — chi ap dung khi sua file trong apps/api/

- Route KHONG query DB truc tiep, goi qua `src/services/`.
- Moi endpoint POST phai co zod schema o `src/contracts/` + test 400-case.
- Verify: `npm test -- --filter api --testPathPattern=<ten-file>`.
```

| Pattern | `applyTo` | Khi dùng |
|---|---|---|
| `apps/api/**` | Backend only | Rules DB/service/validation |
| `apps/web/src/app/**` | Routes only | Rules server/client component |
| `tests/**/*.test.ts` | Tests only | Rules fixtures, không mock quá tay |
| `db/migrations/**` | Migrations | Forward-only, idempotent, KHÔNG sửa migration đã merge — tạo migration mới |
| `*.md` | Docs | Rules giọng văn, heading style |

> Giới hạn: đừng tạo >8 files `*.instructions.md` — nhiều quá model khó chọn. Mỗi file <50 dòng.
> **Kỳ vọng / Verify:** sửa 1 file trong `apps/api/` rồi hỏi agent "rules nào đang áp cho folder này?" — phải kể ra nội dung file. Sửa file ngoài subtree mà rule vẫn áp = glob quá rộng.

---

## 5. AGENTS.md portability — viết 1 lần, chạy mọi agent

`AGENTS.md` là file chuẩn mở ở root repo, Copilot + Claude Code + Codex + Gemini đều đọc. Để thứ **chung** (commands, architecture, style) vào `AGENTS.md`; thứ **riêng Copilot** (`@workspace` hints, MCP usage) vào `copilot-instructions.md`. Không copy-paste nguyên văn — trùng lặp = trả tiền 2 lần mỗi turn.

```text
Thứ tự load khi có cả 2: AGENTS.md (chung) -> .github/copilot-instructions.md (riêng Copilot, thắng khi xung đột)
```

```markdown
<!-- AGENTS.md — mau toi thieu (copy-paste) -->
# AGENTS.md — Acme API

## Commands (VERIFIED 2026-10)
- Dev: `npm run dev` (can `.env`)
- Test: `npm test -- --filter api`
- Lint: `npm run lint`

## Rules
- ALWAYS chay focused test sau khi sua.
- NEVER commit truc tiep main.
```

```bash
# Kiem tra trung lap (chay moi thang):
diff <(sort AGENTS.md) <(sort .github/copilot-instructions.md) | head -30
# Trung >50% -> gop bot: chung o AGENTS, rieng o instructions.
```

---

## 6. Front-load và tách nhỏ (đừng phình file)

Model đọc instructions từ trên xuống, chú ý đầu file hơn cuối. Thứ tự gợi ý:

```text
1. Commands verify (dau tien — agent can chay dung lenh truoc khi nghi gi khac)
2. NEVER list (ranh gioi cung)
3. ALWAYS list (gate verify)
4. Architecture + style (sau cung)
```

| Dấu hiệu file phình | Tách thành |
|---|---|
| Checklist deploy 40 dòng trong instructions | `.github/skills/<ten>/SKILL.md` (bài 05) |
| Rules chỉ đúng cho `apps/api/**` | `.github/instructions/api.instructions.md` |
| Persona review riêng (chỉ đọc, không sửa) | `.github/agents/reviewer.agent.md` (bài 06) |
| Schema/format dài (endpoints, error codes) | File `docs/` + 1 dòng link trong instructions |
| Quy ước team chung nhiều repo | Org-level instructions (Business/Enterprise) |

```markdown
## Tham khao (khong paste noi dung vao day)
- Error codes: xem `docs/error-codes.md` (agent tu doc khi can).
- Deploy checklist: nói "deploy" để skill tự load (không chay tay tung buoc).
```

---

## 7. Walkthrough viết instructions từ 0

> 30 phút, làm 1 lần/repo. Chuẩn bị: repo thật + Copilot Chat (Agent mode).

```text
Bước 1 — Thu thập sự thật (10 phút): Chat (Ask mode):
"Doc README + package.json, tra loi: (1) project la gi, (2) dev/test/lint bang lenh nao,
(3) cay thu muc 2 tang dau, (4) file nao la generated (khong duoc sua tay)."

Bước 2 — Verify lệnh (10 phút, quan trọng nhất): chay TAY tung lenh,
giu lenh PASS, xoa lenh FAIL. Chi ghi lenh PASS + ngay verify.

Bước 3 — Viết file <200 dòng (7 phút): theo mẫu A/B mục 3.
wc -l .github/copilot-instructions.md  # >200 -> cat bot cau chung chung, giu lenh + NEVER/ALWAYS.

Bước 4 — Test (3 phút): mo chat MOI, go:
"Liet ke 3 lenh dev/test/lint cua repo + 2 thu NEVER duoc lam."
# Ky vong: tra loi khop file vua viet. Sai -> sua file, lap lai.
```

Checklist xong khi: `wc -l` <200 · mọi lệnh PASS tay (có ngày VERIFIED) · chat mới trả lời đúng · không trùng >50% với `AGENTS.md`.

---

## 8. Hiểu nhầm thường gặp + pitfalls

| Hiểu nhầm | Sự thật |
|---|---|
| "3 loại file là 1, viết vào đâu cũng được" | 3 phạm vi khác nhau: cả nhà / từng phòng / cả khu phố |
| "`applyTo: **` cho chắc ăn" | Glob rộng = load mọi lúc = tốn credits + dễ áp sai chỗ. Glob hẹp nhất (`apps/api/**`) |
| "Copy nguyên `AGENTS.md` sang instructions" | Trùng lặp = trả tiền 2 lần mỗi turn. Chung → AGENTS, riêng → instructions |
| "Ghi lệnh đoán, agent tự sửa khi fail" | Agent chạy sai lệnh 3 lần là cháy credits + loạn context. Mọi lệnh phải PASS tay + ghi ngày VERIFIED |
| "Viết 1 lần là xong mãi mãi" | Toolchain đổi là instructions thành rác — verify lại + ghi ngày mới |
| "Rules chung chung ('viết code sạch')" | Không check được. Viết lại dạng check được ("file >300 dòng thì tách") |
| "Để secret trong instructions" | File này commit vào git — chỉ ghi "lấy từ 1Password <tên>", KHÔNG paste giá trị |

```text
❌ SAI: copilot-instructions.md 500 dòng, copy cả trang "Getting Started" của framework
✅ ĐÚNG: giữ <200 dòng, chỉ lệnh hay dùng + NEVER/ALWAYS; phần dài đẩy sang docs/ hoặc skill

❌ SAI: chép lệnh test từ README cũ, agent chạy 3 lần đều fail
✅ ĐÚNG: chạy tay từng lệnh, chỉ ghi lệnh PASS + ngày VERIFIED

❌ SAI: applyTo: "**" để rule nào cũng áp — file load mọi lúc
✅ ĐÚNG: applyTo: "apps/api/**" — load đúng lúc chạm subtree đó
```

**Best practices:** giữ <200 dòng (nạp mỗi turn) · mọi lệnh PASS tay + ngày VERIFIED · rule check được, không chung chung · 1 sự thật 1 nơi · front-load commands + NEVER lên đầu · KHÔNG bao giờ commit secret.

---

## 9. So sánh với Claude Code

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| File luật repo | `.github/copilot-instructions.md` | `CLAUDE.md` ở repo root | Cùng ý tưởng: file trong repo là "luật" |
| Rules theo thư mục | `*.instructions.md` + `applyTo` glob | `CLAUDE.md` đặt trong thư mục con | Cơ chế khác (glob vs cây thư mục), cùng mục đích |
| File chung nhiều agent | `AGENTS.md` | `AGENTS.md` | Chuẩn chung thật — cả hai đều đọc |
| Tách file / import | Tách `*.instructions.md` | `@path` import trong `CLAUDE.md` | Cùng ý tưởng "chia nhỏ, chỉ nạp khi cần" |
| Tầng cá nhân vs repo | User settings + repo files | Memory user-level + project `CLAUDE.md` | Cùng phân tầng "cá nhân vs team" |

> Nếu bạn quen Claude Code: chuyển sang Copilot gần như 1-1 — `CLAUDE.md` → `copilot-instructions.md`, `.claude/commands/` → prompt files/skills. Khác biệt chính là cơ chế **glob `applyTo`** so với **file theo cây thư mục**; `AGENTS.md` là chuẩn dùng chung cho cả hai.

---

## Bài tập nhỏ

1. **(20 phút) Cắt file phình:** lấy `copilot-instructions.md` hiện tại, cắt xuống <200. Mỗi dòng xóa ghi lý do 5 chữ ("agent tự suy ra được", "chuyển sang skill"...).
2. **(15 phút) Tách applyTo:** tìm 3 rules chỉ đúng 1 subtree, tách thành `*.instructions.md` glob hẹp. Test sửa file trong/ngoài subtree.
3. **(15 phút) AGENTS.md dedupe:** nếu có cả 2 files, chạy `diff` mục 5, gộp trùng lặp. Đo lại `wc -l` cả 2.
4. **(15 phút) Verify drill:** chạy tay lại toàn bộ lệnh trong instructions, lệnh FAIL thì sửa ngay, ghi ngày mới. Làm định kỳ mỗi khi đổi toolchain.

## Link chéo + Reference

- **Bài 00** — token economics · **Bài 01** — bật `useInstructionFiles` · **Bài 02** — config theo surface · **Bài 05** — checklist dài tách sang skill · **Bài 07** — org policy + secrets.
- VS Code custom instructions: https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- GitHub Copilot docs: https://docs.github.com/copilot · AGENTS.md: https://agents.md

> **Chốt bài 03:** instructions là file rẻ nhất và lãi nhất bạn từng viết — một lần dọn <200 dòng, mọi task sau tự đúng lệnh và đúng style. Viết ngắn, viết thứ kiểm chứng được, giữ mỗi sự thật đúng một nơi.
