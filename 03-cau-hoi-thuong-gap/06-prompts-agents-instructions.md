# FAQ 06 — Prompts, Agents & Instructions

> **Vấn đề:** "đã tạo file mà Copilot không biết" — prompt không hiện trong picker, `applyTo` không ăn, frontmatter hỏng... gần hết các ca này do sai đường dẫn / sai glob / sai frontmatter. 10 câu dưới đây trả lời đủ, kèm cách test.

## Bảng tổng hợp: file nào để ở đâu (2026)

| Loại file | Đường dẫn chuẩn | Kích hoạt | Trạng thái 2026 |
|---|---|---|---|
| Project instructions | `.github/copilot-instructions.md` | Tự động mọi chat/completion | Chính thức |
| Path instructions | `.github/instructions/*.instructions.md` | Tự động khi file khớp `applyTo` | Chính thức |
| Agent Skill | `.github/skills/<ten>/SKILL.md` | Model tự gọi khi khớp `description` | **Khuyến nghị (chạy Local + Cloud + CLI)** |
| Custom agent | `.github/agents/*.agent.md` | Chọn trong agent picker | Chính thức |
| Prompt tái dùng (legacy) | `.github/prompts/*.prompt.md` | Gọi tay `/tên-prompt` | **Deprecated cho Agent Host** (Local vẫn chạy) |

---

## 1. File nào Copilot tự load, file nào phải gọi tay?

**Trả lời 1 câu:** Tự load `copilot-instructions.md` (mọi lúc) + `*.instructions.md` khớp `applyTo`; gọi tay `*.prompt.md` (slash, legacy) + custom agent (chọn trong picker); còn Skill thì model tự gọi theo `description` — chuẩn khuyến nghị 2026.

```bash
find .github -type f | sort
# Kỳ vọng:
# .github/copilot-instructions.md
# .github/instructions/backend-api.instructions.md
# .github/prompts/review-pr.prompt.md
# .github/agents/tester.agent.md
# .github/skills/review-pr/SKILL.md
```

> "Đã tạo file mà Copilot không biết" — check đường dẫn + tên file trước tiên (đuôi phải là `.instructions.md` chứ không phải `.md` trơn).

## 2. `applyTo` viết sao cho đúng?

**Trả lời 1 câu:** `applyTo` là glob phải khớp đúng root thật của repo (thường cần `**/` đầu và quote khi có `*`) — viết theo `ls`/`find` thật, đừng đoán.

```yaml
# Đúng cho repo apps/api + apps/web:
applyTo: "apps/api/**/*"           # backend-api.instructions.md
applyTo: "apps/web/**/*.{ts,tsx}"  # frontend-react.instructions.md
```

```bash
# Test glob khớp file nào: rỗng = glob sai
ls apps/api/**/*.ts 2>/dev/null | head -5
```

> Glob sai root là lý do số 1 khiến instructions "không load".

## 3. Frontmatter lỗi — các bẫy phổ biến?

**Trả lời 1 câu:** 4 bẫy: thiếu cặp `---` mở/đóng, sai key (`applyTo` phải camelCase), quên quote glob có `*`, liệt kê `tools` không tồn tại.

```bash
head -8 .github/prompts/review-pr.prompt.md   # 2 dòng đầu + cuối phải là ---
```

```markdown
---
mode: agent
description: Review PR theo checklist correctness/security/tests
tools: [github-mcp, search, edit]
---
```

> Prompt/agent "không hiện trong picker" — 70% là frontmatter hỏng. `tools` sai tên làm agent lỗi lúc chạy — thử bỏ hẳn `tools` để test, rồi thêm lại từng cái.

## 4. `copilot-instructions.md` bao nhiêu dòng là vừa?

**Trả lời 1 câu:** Giữ **<200 dòng** — dài quá context phình, phần cuối bị cắt, rule quan trọng chìm. Phần dài tách sang `*.instructions.md` theo path, procedure dài tách thành `SKILL.md`.

```bash
wc -l .github/copilot-instructions.md .github/instructions/*.md
# >200 dòng ở file chính -> tách bớt
```

**Ví dụ:** file chính 350 dòng (React + API + deploy) → tách React sang `frontend-react.instructions.md`, deploy sang skill → còn 120 dòng.

## 5. Instructions không load — checklist 6 bước?

**Trả lời 1 câu:** Đi đúng thứ tự: tên file/đường dẫn → `applyTo` đúng glob → file có khớp glob → reload IDE → mở chat mới → hỏi admin (org policy có thể tắt custom instructions).

```bash
ls .github/instructions/*.instructions.md
head -6 .github/instructions/backend-api.instructions.md
# Rồi: reload IDE + mở chat mới + hỏi "liệt kê quy tắc backend đang áp dụng"
```

> **Chat cũ giữ context cũ** — mở chat mới trước khi kết luận instructions sai.

## 6. Prompt files (`*.prompt.md`) — legacy

**Trả lời 1 câu:** Prompt file là kịch bản đóng gói (frontmatter ép mode + tools + body từng bước) gọi bằng `/tên-file` — kết quả nhất quán, share được team, nhưng **deprecated cho Agent Host** (chỉ chạy Local). Việc mới nên dùng Agent Skill.

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

> Repo chỉ chạy Local và đã có prompt file ổn → giữ tạm, port dần sang Skill.

## 7. Custom agent (`*.agent.md`) viết sao, khi nào cần?

**Trả lời 1 câu:** Custom agent = persona chuyên môn (`description` + `tools` giới hạn) — cần khi muốn tách việc (đọc ồn giao explorer) hoặc ép kỷ luật (tester chỉ báo PASS/FAIL); task 1-2 file thì chat thường + instructions đủ.

```markdown
<!-- .github/agents/explorer.agent.md -->
---
description: Trinh sát chỉ-đọc, trả về list files sẽ sửa/đọc
tools: [search]
---
# Explorer
- CHỈ đọc, KHÔNG sửa file, KHÔNG chạy lệnh ghi.
- Trả về: danh sách file liên quan + thứ tự đọc đề xuất.
```

Mẫu sẵn trong `templates/.github/agents/`.

## 8. Agent Skills (`SKILL.md`) khác gì prompt/agent?

**Trả lời 1 câu:** Skill là gói **mô tả + procedure + tools** mà model **tự phát hiện và gọi** khi task khớp `description` — chạy mọi harness (Local + Cloud + CLI), khác prompt (gọi tay, deprecated cho Cloud) và custom agent (phải chọn trong picker).

```markdown
<!-- .github/skills/review-pr/SKILL.md -->
---
name: review-pr
description: Dùng khi user nhờ review PR, diff, hoặc kiểm tra code trước merge. Không dùng cho việc viết feature mới.
---
# Review PR skill
...procedure + checklist + lệnh git diff...
```

| Tiêu chí | Prompt file (legacy) | Custom agent | Agent Skill (chuẩn 2026) |
|---|---|---|---|
| Kích hoạt | Gọi tay `/tên` | Chọn trong picker | Model tự gọi theo `description` |
| Chạy ở đâu | Local/VS Code | Harness có picker | Mọi harness |
| Khi nào dùng | Việc lặp đã có, chỉ Local | Tách việc / ép kỷ luật | Procedure tự áp |

> **Model không gọi skill:** `description` quá mơ hồ là lý do phổ biến nhất — viết theo cặp "dùng khi..." / "không dùng cho...".

## 9. Thứ tự ưu tiên khi nhiều instructions cùng khớp 1 file?

**Trả lời 1 câu:** Mạnh → yếu: prompt hiện tại > `*.instructions.md` khớp path cụ thể > `copilot-instructions.md` > org policy (trần cứng) — cái cụ thể/gần hơn luôn thắng.

```bash
# Tìm mọi instructions có thể "đánh nhau"
grep -h "applyTo" .github/instructions/*.md
# 2 file cùng khớp 1 path -> gộp hoặc thu hẹp glob
```

> Đừng viết 2 instructions mâu thuẫn cho cùng path — hành vi sẽ khó đoán.

## 10. Test instructions mới có hiệu quả không?

**Trả lời 1 câu:** 3 phép thử trong chat mới: **test load** (hỏi quy tắc, phải kể đúng), **test hành vi** (task vi phạm phải bị từ chối), **test nhiễu** (task ngoài scope không bị ảnh hưởng).

```bash
# Test 1+3 trong 1 chat mới:
# "Liệt kê quy tắc áp dụng cho apps/api/auth.ts.
#  Sau đó giải thích hàm map trong JS (không liên quan backend)."
# Đạt: kể đúng rules backend + trả lời JS bình thường
```

**Ví dụ:** thêm "NEVER sửa migrations" → test "sửa giúp migration 003" → Copilot phải từ chối + đề xuất tạo migration mới. 2 phút test đỡ 2 tuần "sao nó không nghe".

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. `find .github -type f | sort` — đúng đường dẫn + tên file.
2. `head -8` từng file — frontmatter đủ `---` + key đúng.
3. Glob `applyTo` đối chiếu `ls` thật.
4. Reload IDE + mở chat mới.
5. Hỏi admin: org có tắt custom instructions không.

Tham khảo chéo: [bài 05](05-policies-guardrails-faq.md) (quy tắc ALWAYS/NEVER) · [bài 02](02-model-context-premium.md) (context + nhiễu) · [bài 07](07-custom-agents-coding-agent-workflows.md) (custom agent workflows) · [../templates/README.md](../templates/README.md).
