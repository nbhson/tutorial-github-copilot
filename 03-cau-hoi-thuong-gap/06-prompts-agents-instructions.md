# FAQ 06 — Prompts, Agents & Instructions

> Nhóm Tùy biến tri thức · 10 câu hỏi deep-dive · Đọc xong fix mọi ca "không load, applyTo sai, frontmatter lỗi"

Prompt file không hiện trong picker, `applyTo` không ăn, frontmatter hỏng... gần hết các ca "đã tạo file mà Copilot không biết" nằm trong 10 câu dưới đây. Mỗi câu giữ đúng 5 nhịp: **hỏi ngắn** → **trả lời 1 câu** → **giải thích + ví dụ** → **làm thế nào** → **nếu vẫn lỗi thì làm gì**, kèm một dòng **khi nào áp dụng**. Dán nguyên khối code vào terminal/IDE là chạy.

## Mục tiêu bài học

- Phân biệt **ai kích hoạt cái gì**: file tự load, file gọi tay, và file model tự gọi.
- Viết **`applyTo`** đúng root repo (đối chiếu `ls`/`find` thật, không đoán).
- Né **4 bẫy frontmatter** khiến prompt/agent "không hiện trong picker".
- Biết ngưỡng **`<200 dòng`** cho `copilot-instructions.md` và cách tách phần dài.
- **Test** instructions mới bằng 3 phép thử: load, hành vi, nhiễu.

## Sơ đồ tư duy nhanh (đọc 30 giây)

```mermaid
flowchart TD
    A[Can tai su dung?] --> B{Tan suat?}
    B -->|Moi file .md| C[copilot-instructions.md auto-load]
    B -->|Theo folder| D[*.instructions.md + applyTo]
    B -->|Goi tay| E[*.prompt.md slash]
    B -->|Viec on ao| F[*.agent.md custom agent]
    B -->|Tu kich hoat| G[SKILL.md Agent Skills]
```

## Bảng tổng hợp: file nào để ở đâu (2026)

| Loại file | Đường dẫn chuẩn | Kích hoạt | Trạng thái 2026 |
|---|---|---|---|
| Project instructions | `.github/copilot-instructions.md` | Tự động mọi chat/completion | Chính thức |
| Path instructions | `.github/instructions/*.instructions.md` | Tự động khi file khớp `applyTo` | Chính thức |
| Agent Skill | `.github/skills/<ten>/SKILL.md` | Model tự gọi khi khớp `description` | **KHUYÊN DUNG (chạy Local + Cloud + CLI)** |
| Custom agent | `.github/agents/*.agent.md` | Chọn trong agent picker | Chính thức |
| Prompt tái dùng (legacy) | `.github/prompts/*.prompt.md` | Gọi tay `/tên-prompt` | **Deprecated cho Agent Host** (Local vẫn chạy) |

---

## 1. File nào Copilot tự load, file nào phải gọi tay?

> **Hỏi ngắn gọn:** _File nào Copilot tự load, file nào phải gọi tay?_

**Trả lời 1 câu:** Copilot tự load `copilot-instructions.md` (mọi lúc) và `*.instructions.md` khớp `applyTo`; `*.prompt.md` và custom agent phải gọi/chọn tay, còn skill thì model tự gọi theo `description`.

**Giải thích chi tiết + ví dụ:**

- **Tự load:** `copilot-instructions.md` (mọi lúc) + `*.instructions.md` khớp `applyTo` (khi đụng file tương ứng).
- **Gọi tay:** `*.prompt.md` (slash command trong chat — **legacy, deprecated cho Agent Host**), custom agent (chọn trong picker rồi chat).
- **Model tự quyết:** Skills (`SKILL.md` có `description`) — model đọc mô tả skill rồi tự gọi khi task khớp, bạn không cần nhớ tên. **Chuẩn khuyến nghị 2026 (chạy mọi harness).**

### Làm thế nào

Cây thư mục chuẩn (đứng ở root repo):

```bash
# Cây thư mục chuẩn (đứng ở root repo)
find .github -type f | sort
# Kỳ vọng:
# .github/copilot-instructions.md
# .github/instructions/backend-api.instructions.md
# .github/prompts/review-pr.prompt.md
# .github/agents/tester.agent.md
# .github/skills/review-pr/SKILL.md
```

**Ví dụ cụ thể:** hỏi về API mà Copilot không theo chuẩn backend → check `find .github` thấy thiếu `backend-api.instructions.md` → copy từ templates.

> **Khi nào áp dụng:** khi "đã tạo file mà Copilot không biết" — check đường dẫn + tên file trước tiên.

> **Nếu vẫn lỗi thì...** kiểm tra lại đúng đuôi file (`.instructions.md` chứ không phải `.md` trơn), mở chat mới, rồi gửi kèm output `find .github -type f` cho admin nếu org có thể đã tắt custom instructions.

---

## 2. `applyTo` viết sao cho đúng (glob hay sai nhất)?

> **Hỏi ngắn gọn:** _`applyTo` viết sao cho đúng (glob hay sai nhất)?_

**Trả lời 1 câu:** `applyTo` là glob phải khớp đúng root thật của repo (thường cần `**/` đầu và quote khi có `*`), nên viết theo `ls`/`find` thật chứ đừng đoán.

**Giải thích chi tiết + ví dụ:** `applyTo` là glob quyết định instructions nào "ăn" vào file nào. Sai phổ biến:

- `applyTo: backend/**` nhưng code thật ở `apps/api/**` → không khớp.
- `applyTo: **/*.ts` muốn chỉ frontend nhưng ăn cả backend.
- Quên `**/` đầu → chỉ khớp root, không khớp sâu.

### Làm thế nào

Đối chiếu glob với cây file thật trước khi commit:

```yaml
# Đúng cho repo apps/api + apps/web:
# backend-api.instructions.md
applyTo: "apps/api/**/*"
# frontend-react.instructions.md
applyTo: "apps/web/**/*.{ts,tsx}"
```

```bash
# Test glob khớp file nào (bash): liệt kê file sẽ "ăn" instructions đó
ls apps/api/**/*.ts 2>/dev/null | head -5   # nếu rỗng -> glob sai
```

**Ví dụ cụ thể:** repo NestJS ở `services/api/src/**` → `applyTo: "services/api/**/*"` (lấy theo root thật, không đoán).

> **Khi nào áp dụng:** mỗi khi tạo/sửa `*.instructions.md` — đối chiếu glob với `ls`/`find` thật.

> **Nếu vẫn lỗi thì...** so `applyTo` với `ls`/`find` thật thêm một lần; nhớ quote glob có `*`; nếu repo là monorepo đặt trong subfolder, thử thêm `**/` ở đầu.

---

## 3. Frontmatter lỗi — các bẫy phổ biến?

> **Hỏi ngắn gọn:** _Frontmatter lỗi — các bẫy phổ biến?_

**Trả lời 1 câu:** Frontmatter lỗi thường do thiếu cặp `---` mở/đóng, sai tên key (phải là `applyTo` camelCase), quên quote glob, hoặc liệt kê `tools` không tồn tại.

**Giải thích chi tiết + ví dụ:** Frontmatter = block `---` đầu file chứa metadata (`mode`, `agent`, `tools`, `applyTo`, `description`). Bẫy top:

1. Thiếu `---` mở/đóng → cả file thành body, metadata mất.
2. Sai tên key (`applyto`, `ApplyTo`) → key đúng là `applyTo` (camelCase).
3. Quên quote glob có `*` → YAML parse sai (`applyTo: **/*` phải quote).
4. `tools:` liệt kê tool không tồn tại → agent lỗi lúc chạy.

### Làm thế nào

Kiểm tra frontmatter bằng mắt rồi bằng script:

```bash
# Check frontmatter 1 file: 5 dòng đầu phải là --- ... ---
head -8 .github/prompts/review-pr.prompt.md

# Validate YAML frontmatter bằng python (cắt block --- đầu)
python3 - <<'PY'
import re
text = open('.github/prompts/review-pr.prompt.md').read()
m = re.match(r'^---\n(.*?)\n---\n', text, re.S)
print("FRONTMATTER OK" if m else "THIEU/SAI frontmatter")
import yaml if False else None
PY
```

**Ví dụ mẫu đúng:**

```markdown
---
mode: agent
description: Review PR theo checklist correctness/security/tests
tools: [github-mcp, search, edit]
---
```

> **Khi nào áp dụng:** khi prompt/agent "không hiện trong picker" — 70% là frontmatter hỏng.

> **Nếu vẫn lỗi thì...** chạy lại script validate và đảm bảo `---` là dòng đầu tiên (không có dòng trống hay ký tự BOM trước nó); soát kỹ chính tả key `applyTo`/`description` và tên tool trong `tools`.

---

## 4. `copilot-instructions.md` bao nhiêu dòng là vừa, dài quá sao?

> **Hỏi ngắn gọn:** _`copilot-instructions.md` bao nhiêu dòng là vừa, dài quá sao?_

**Trả lời 1 câu:** Giữ file chính dưới ~200 dòng, phần dài tách sang `*.instructions.md` theo path hoặc `SKILL.md` cho procedure.

**Giải thích chi tiết + ví dụ:** Giữ **<200 dòng**. Dài quá → context phình, phần cuối bị cắt, quan trọng chìm. Cách gọn:

- File chính: stack + lệnh verified + rules ALWAYS/NEVER (ngắn gọn).
- Chi tiết theo path → `instructions/*.instructions.md`.
- Procedure dài (deploy, add-table) → **`.github/skills/<ten>/SKILL.md`** (chuẩn 2026, khuyến nghị). `*.prompt.md` (legacy) vẫn chạy Local.

### Làm thế nào

Đo độ dài trước khi tách:

```bash
# Đo độ dài + tìm chỗ cắt
wc -l .github/copilot-instructions.md .github/instructions/*.md
# >200 dòng ở file chính -> tách bớt sang instructions con
```

**Ví dụ cụ thể:** file chính 350 dòng (cả chuẩn React + API + deploy) → tách React sang `frontend-react.instructions.md`, deploy sang `deploy.prompt.md` → chính còn 120 dòng.

> **Khi nào áp dụng:** mỗi quý review 1 lần, hoặc khi thêm stack mới vào repo.

> **Nếu vẫn lỗi thì...** nếu đã tách mà vẫn nặng, kiểm tra file chính và instructions con có lặp nội dung không; đo lại `wc -l` rồi cắt phần "nice-to-have" xuống skill.

---

## 5. Instructions không load — checklist 6 bước?

> **Hỏi ngắn gọn:** _Instructions không load — checklist 6 bước?_

**Trả lời 1 câu:** Đi đúng 6 bước: tên file/đường dẫn → `applyTo` đúng glob → file có khớp glob → reload IDE → mở chat mới → hỏi admin về org policy.

**Giải thích chi tiết + ví dụ:** Đi đúng thứ tự:

1. Tên file đúng `*.instructions.md` trong `.github/instructions/`?
2. Frontmatter có `applyTo` đúng glob?
3. File đang sửa có khớp glob? (test bằng `ls` ở câu 2)
4. IDE đã reload sau khi thêm file?
5. Chat mới hay chat cũ? (chat cũ giữ context cũ → mở chat mới)
6. Org policy có tắt custom instructions không? (hỏi admin)

### Làm thế nào

Chạy 1 lèo 4 check đầu rồi reload:

```bash
# Chạy 1 lèo 4 check đầu
ls .github/instructions/*.instructions.md
head -6 .github/instructions/backend-api.instructions.md
ls apps/api/controller.ts 2>/dev/null || find . -name "*.ts" -path "*api*" | head -3
# Rồi: reload IDE + mở chat mới + hỏi "liệt kê quy tắc backend đang áp dụng"
```

**Ví dụ cụ thể:** thêm `backend-api.instructions.md` mà hỏi vẫn sai chuẩn → phát hiện chat cũ từ hôm qua → mở chat mới → instructions ăn ngay.

> **Khi nào áp dụng:** mọi ca instructions "không ăn" — 90% rơi vào 6 bước này.

> **Nếu vẫn lỗi thì...** nếu hết 6 bước vẫn không load, ghi lại chính xác bạn hỏi gì và Copilot trả gì, rồi mở issue kèm log + ảnh chụp để admin kiểm tra org policy.

---

## 6. Prompt files (`*.prompt.md`) gọi thế nào, khác gì chat thường? (**legacy**)

> **Hỏi ngắn gọn:** _Prompt files (`*.prompt.md`) gọi thế nào, khác gì chat thường?_

**Trả lời 1 câu:** Prompt file là kịch bản đóng gói (frontmatter + body từng bước) gọi bằng `/tên-file`, khác chat thường ở chỗ ép mode + tools + steps cố định nên kết quả nhất quán và share được cả team.

**Giải thích chi tiết + ví dụ:** Prompt file = **kịch bản đóng gói**: frontmatter (`mode`, `agent`, `tools`) + body hướng dẫn từng bước. Gọi bằng `/tên-file` trong chat (không cần `.prompt.md`) hoặc nút Run trong editor.

> **Lưu ý 2026:** Prompt file **deprecated cho Agent Host** (Copilot/Cloud) — chỉ chạy Local/VS Code. Việc mới nên dùng **Agent Skill** (câu 8) vì chạy được mọi harness. Nếu repo bạn chỉ chạy Local và đã có prompt file ổn, giữ tạm — port dần (bài 05 mục 3.3).

Khác chat thường: prompt ép **mode + tools + steps cố định** → kết quả nhất quán giữa các lần, share được cả team.

| Tiêu chí | Prompt file (`*.prompt.md`) | Chat thường |
|---|---|---|
| Cách gọi | Gõ `/tên-file` (không cần đuôi) | Gõ câu hỏi tự do |
| Mode + tools | Ép cố định trong frontmatter | Tùy ngữ cảnh, đổi mỗi lần |
| Các bước | Kịch bản từng bước cố định | Bạn tự viết mỗi lần |
| Kết quả | Nhất quán giữa các lần | Thay đổi theo cách hỏi |
| Chia sẻ team | Có (commit vào repo) | Không (chỉ trong chat) |
| Khi nào dùng | Việc lặp >3 lần/tuần (review, deploy, tạo table) | Hỏi ad-hoc, task 1 lần |

### Làm thế nào

Đây là mẫu một prompt file hoàn chỉnh:

```markdown
---
mode: agent
description: Review PR theo checklist
tools: [search, edit]
---
# Review PR
1. Lấy diff: `git diff main...HEAD --stat`
2. Check correctness / security / tests theo checklist
3. Trả về: Critical / Major / Minor + gợi ý sửa cụ thể
```

```bash
# Trong chat gọi: /review-pr  (không gõ đuôi .prompt.md)
```

**Ví dụ cụ thể:** `templates/.github/prompts/review-pr.prompt.md` → copy vào repo → chat `/review-pr` → mọi PR được review cùng 1 checklist.

> **Khi nào áp dụng:** việc lặp lại >3 lần/tuần (review, deploy, tạo table) → đóng gói thành prompt.

> **Nếu vẫn lỗi thì...** kiểm tra frontmatter và tên gọi đúng `/tên-file` (không đuôi); nhớ prompt file chỉ chạy Local — muốn chạy Cloud/CLI thì port sang Agent Skill.

---

## 7. Custom agent (`*.agent.md`) viết sao, khi nào cần?

> **Hỏi ngắn gọn:** _Custom agent (`*.agent.md`) viết sao, khi nào cần?_

**Trả lời 1 câu:** Custom agent là persona chuyên môn (`description` + `tools` giới hạn) nên cần khi muốn tách việc hoặc ép kỷ luật, còn task 1-2 file thì chat thường + instructions là đủ.

**Giải thích chi tiết + ví dụ:** Custom agent = persona chuyên môn (explorer chỉ-đọc, tester chạy test, security-reviewer soi bảo mật) với `description` + `tools` giới hạn. Cần khi: muốn tách việc (đọc ồn giao explorer), hoặc ép kỷ luật (tester chỉ báo PASS/FAIL).

Không cần khi: task đơn giản 1-2 file — chat thường + instructions đủ.

### Làm thế nào

Viết tối thiểu `description` + `tools` + ranh giới:

```markdown
---
description: Trinh sát chỉ-đọc, trả về list files sẽ sửa/đọc
tools: [search]
---
# Explorer
- CHỈ đọc, KHÔNG sửa file, KHÔNG chạy lệnh ghi.
- Trả về: danh sách file liên quan + thứ tự đọc đề xuất.
```

```bash
ls .github/agents/  # explorer.agent.md tester.agent.md security-reviewer.agent.md
```

**Ví dụ cụ thể:** task refactor lớn → gọi explorer trước (lấy bản đồ file) → rồi mới agent sửa → ít lạc, ít tốn quota.

> **Khi nào áp dụng:** task multi-file hoặc cần kỷ luật đọc-trước-sửa-sau. Mẫu sẵn trong `templates/.github/agents/`.

> **Nếu vẫn lỗi thì...** kiểm tra `tools` có tên hợp lệ không (tool sai làm agent lỗi lúc chạy) — thử bỏ hẳn `tools` để test, rồi thêm lại từng cái một.

---

## 8. Agent Skills 2026 (`SKILL.md`) khác gì prompt/agent? (chuẩn khuyến nghị)

> **Hỏi ngắn gọn:** _Agent Skills 2026 (`SKILL.md`) khác gì prompt/agent?_

**Trả lời 1 câu:** Skill (`SKILL.md`) là gói mô tả + procedure + tools mà model tự phát hiện và gọi theo `description`, chạy mọi harness — khác prompt (gọi tay, deprecated cho Cloud) và custom agent (phải chọn trong picker).

**Giải thích chi tiết + ví dụ:** Skill = gói **mô tả + procedure + tools** theo chuẩn Agent Skills 2026 (chuẩn mở), model **tự phát hiện và gọi** khi task khớp `description` — bạn không cần nhớ tên để gọi. Prompt phải gọi tay (và deprecated cho Cloud); skill thì model tự biết + chạy mọi harness.

Cấu trúc: `.github/skills/<ten>/SKILL.md` với frontmatter `name` + `description` rõ ràng (description càng cụ thể, model càng gọi đúng).

| Tiêu chí | Prompt file (legacy) | Custom agent | Agent Skill (chuẩn 2026) |
|---|---|---|---|
| Cách kích hoạt | Gọi tay `/tên` | Chọn trong agent picker | Model tự gọi theo `description` |
| Đóng gói | Kịch bản steps | Persona + `tools` | Mô tả + procedure + tools |
| Chạy ở đâu | Local/VS Code | Harness có picker | Mọi harness (Local + Cloud + CLI) |
| Trạng thái 2026 | Deprecated cho Agent Host | Chính thức | Khuyến nghị |
| Khi nào dùng | Việc lặp đã có sẵn, chỉ chạy Local | Tách việc / ép kỷ luật theo vai | Procedure tự áp, không cần nhớ tên lệnh |

### Làm thế nào

Một skill tối thiểu trông như sau:

```markdown
---
name: review-pr
description: Dùng khi user nhờ review PR, diff, hoặc kiểm tra code trước merge. Không dùng cho việc viết feature mới.
---
# Review PR skill
...procedure + checklist + lệnh git diff...
```

**Ví dụ cụ thể:** user gõ "review giúp PR này" → model đọc descriptions các skills → tự nạp `review-pr` → chạy checklist chuẩn team mà user không cần gõ `/review-pr`.

> **Khi nào áp dụng:** procedure team muốn "tự động áp" mà không cần training member nhớ tên lệnh. Mẫu: `templates/.github/skills/review-pr/SKILL.md`.

> **Nếu vẫn lỗi thì...** `description` quá mơ hồ là lý do phổ biến nhất khiến model không gọi — viết lại theo cặp "dùng khi..." và "không dùng cho...".

---

## 9. Thứ tự ưu tiên khi nhiều instructions cùng khớp 1 file?

> **Hỏi ngắn gọn:** _Thứ tự ưu tiên khi nhiều instructions cùng khớp 1 file?_

**Trả lời 1 câu:** Thứ tự mạnh→yếu là prompt hiện tại > `*.instructions.md` khớp path cụ thể > `copilot-instructions.md` > org policy (trần cứng), và cái cụ thể/gần hơn luôn thắng.

**Giải thích chi tiết + ví dụ:** Thứ tự (mạnh → yếu, gần thắng xa):

1. Prompt hiện tại bạn gõ (gần nhất, thắng hết).
2. `*.instructions.md` khớp path cụ thể (VD `apps/api/**` thắng `**/*`).
3. `copilot-instructions.md` (nền chung).
4. Org policy (trần cứng — cấm là cấm dù instructions cho phép).

Mâu thuẫn thì cái cụ thể + gần hơn thắng. Vì vậy đừng viết 2 instructions mâu thuẫn nhau cho cùng path.

### Làm thế nào

Grep hết mọi `applyTo` để thấy file nào có thể đánh nhau:

```bash
# Tìm mọi instructions có thể ăn vào 1 file
grep -l "applyTo" .github/instructions/*.md
grep -h "applyTo" .github/instructions/*.md
# Nếu 2 file cùng khớp 1 path -> gộp hoặc làm rõ ranh giới glob
```

**Ví dụ cụ thể:** `backend-api.instructions.md` (`apps/api/**`) + `general.instructions.md` (`**/*`) cùng khớp `apps/api/x.ts` → quy tắc backend cụ thể được ưu tiên.

> **Khi nào áp dụng:** khi 2 instructions "đánh nhau" — thu hẹp glob để mỗi file chỉ bị 1 instructions chi phối mạnh.

> **Nếu vẫn lỗi thì...** grep lại toàn bộ `applyTo` và thu hẹp glob để mỗi file chỉ một instructions chi phối; xóa hẳn cặp instructions mâu thuẫn thay vì cố đoán cái nào thắng.

---

## 10. Test instructions mới thêm có hiệu quả không?

> **Hỏi ngắn gọn:** _Test instructions mới thêm có hiệu quả không?_

**Trả lời 1 câu:** Chạy 3 test — test load (chat mới hỏi quy tắc), test hành vi (task vi phạm phải bị từ chối), test nhiễu (task ngoài scope không bị ảnh hưởng).

**Giải thích chi tiết + ví dụ:** 3 test nhanh sau khi thêm/sửa:

1. **Test load:** chat mới → "liệt kê quy tắc đang áp dụng cho `apps/api/x.ts`" → xem nó kể đúng không.
2. **Test hành vi:** giao task nhỏ vi phạm quy tắc → xem nó có tuân thủ (VD bảo sửa migration bị cấm → phải từ chối).
3. **Test nhiễu:** hỏi task ngoài scope → đảm bảo instructions hẹp không làm hỏng task khác.

### Làm thế nào

Gộp test 1 + 3 vào một chat mới:

```bash
# Test 1+3 trong 1 chat mới:
# "Liệt kê quy tắc áp dụng cho apps/api/auth.ts.
#  Sau đó giải thích hàm map trong JS (không liên quan backend)."
# Đạt: kể đúng rules backend + trả lời JS bình thường (không nhồi backend context)
```

**Ví dụ cụ thể:** thêm quy tắc "NEVER sửa migrations" → test: "sửa giúp migration 003" → Copilot phải từ chối + đề xuất tạo migration mới.

> **Khi nào áp dụng:** sau mọi lần sửa instructions — 2 phút test đỡ 2 tuần "sao nó không nghe".

> **Nếu vẫn lỗi thì...** chạy lại 3 test trong chat mới; nếu test hành vi fail, soát lại câu chữ quy tắc (ALWAYS/NEVER) và vị trí file xem đã đúng chỗ chưa.

---

## So sánh với Claude Code

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| File luật trong repo | `.github/copilot-instructions.md` + `.github/instructions/*.instructions.md` | `CLAUDE.md` (kể cả `CLAUDE.md` lồng theo thư mục) + `.claude/` | Cùng tư tưởng "file trong repo là luật"; khác tên file và thư mục |
| Kích hoạt theo path | `applyTo` glob trong frontmatter | `CLAUDE.md` đặt theo thư mục con | Copilot khớp bằng glob; Claude Code dựa vào vị trí thư mục — không có `applyTo` tương đương |
| Slash command tự tạo | `*.prompt.md` (legacy) / Skill | `.claude/commands/` | Cùng ý tưởng: đóng gói quy trình gọi tay |
| Persona / tách việc | Custom agent `*.agent.md` (chọn trong picker) | Subagent (`.claude/agents/`) | Cả hai tách vai + giới hạn tools |
| Procedure tự áp | Agent Skill `.github/skills/<ten>/SKILL.md` | Claude Code cũng hỗ trợ Agent Skills (`SKILL.md`) | Cùng chuẩn Agent Skills; khác thư mục đặt file |
| Tool ngoài repo | MCP (`.vscode/mcp.json`) | MCP | Cùng chuẩn giao thức |

> **Không đưa vào bảng vì chưa đủ chắc chắn:** thứ tự ưu tiên khi nhiều instructions cùng khớp một file, và chi tiết hành vi auto-load của từng harness — chưa đối chiếu nguồn chính thức nên không dám khẳng định, tránh bịa.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. `find .github -type f | sort` — đúng đường dẫn + tên file.
2. `head -8` từng file — frontmatter đủ `---` + key đúng.
3. Glob `applyTo` đối chiếu `ls` thật.
4. Reload IDE + mở chat mới.
5. Hỏi admin: org có tắt custom instructions không.

```bash
find .github -type f | sort && head -6 .github/instructions/*.md .github/prompts/*.md 2>/dev/null
```

> Nếu đi hết 5 bước vẫn không được: (1) làm lại với scope gọn hơn (1 file/selection), (2) đổi model bằng `/model` rồi chạy lại, (3) kiểm tra lại chính mục này, (4) hỏi admin (policy/seat) hoặc mở issue kèm log + ảnh chụp lỗi.

---

## Best practices (kèm "vì sao")

- **Đặt file đúng chỗ, đúng đuôi.** *Vì sao?* Copilot auto-load theo đường dẫn/tên — sai chỗ (hoặc thiếu `.instructions.md`) thì file không bao giờ "ăn".
- **Mọi `applyTo` phải đối chiếu `ls`/`find` thật.** *Vì sao?* Glob sai root là lý do số 1 khiến instructions "không load".
- **Giữ `copilot-instructions.md` <200 dòng.** *Vì sao?* File này nạp lại mỗi turn — càng dài càng tốn credits và loãng trọng tâm.
- **Procedure dài thì đóng thành Skill, không nhồi vào instructions.** *Vì sao?* Skill chỉ nạp khi đúng context, lại chạy được cả Local + Cloud + CLI (chuẩn 2026).
- **Đừng viết 2 instructions mâu thuẫn cùng path.** *Vì sao?* Cái cụ thể hơn thắng, nên hành vi trở nên khó đoán và khó debug.
- **Luôn test bằng chat mới (load/hành vi/nhiễu).** *Vì sao?* Chat cũ giữ context cũ, dễ khiến bạn tưởng instructions sai trong khi thật ra chỉ là chat bẩn.

---

## Tham khảo chéo

- Viết quy tắc ALWAYS/NEVER: [bài 05](05-policies-guardrails-faq.md). Context + nhiễu: [bài 02](02-model-context-premium.md).
- Custom agent workflows: [bài 07](07-custom-agents-coding-agent-workflows.md). Mẫu copy ngay: [../templates/README.md](../templates/README.md).

> **Chốt bài 06:** đúng chỗ, đúng tên, `applyTo` phải đối chiếu bằng `ls` thật, và luôn test bằng chat mới — làm đủ 4 điều đó là hết 90% ca "không load".
