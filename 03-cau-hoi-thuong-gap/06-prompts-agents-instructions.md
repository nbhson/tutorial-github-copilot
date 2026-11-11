# FAQ 06 — Prompts, Agents & Instructions

> **Vấn đề:** "đã tạo file mà Copilot không biết" — prompt không hiện trong picker, `applyTo` không ăn, frontmatter hỏng... gần hết các ca này do sai đường dẫn / sai glob / sai frontmatter. 10 câu dưới đây trả lời đủ, kèm cách test.

## Bảng tổng hợp: file nào để ở đâu (2026)

| Loại file | Đường dẫn chuẩn | Kích hoạt | Trạng thái 2026 |
|---|---|---|---|
| Project instructions | `.github/copilot-instructions.md` | Tự động mọi chat/completion | Chính thức |
| Path instructions | `.github/instructions/*.instructions.md` | Tự động khi file khớp `applyTo` | Chính thức |
| Agent Skill | `.github/skills/<ten>/SKILL.md` | Model tự gọi khi khớp `description` | **Khuyến nghị (chạy cả Copilot harness lẫn Local harness)** |
| Custom agent | `.github/agents/*.agent.md` | Chọn trong agent picker | Chính thức |
| Prompt tái dùng | `.github/prompts/*.prompt.md` | Gọi tay `/tên-prompt` | **Chỉ chạy ở Local harness (VS Code)** — Copilot harness không nạp |

> **Cách đọc bảng này:** đây là "địa chỉ nhà" của từng loại file — cột **Đường dẫn chuẩn** phải khớp từng ký tự, cột **Kích hoạt** cho biết tự chạy hay phải gọi tay, cột **Trạng thái 2026** cảnh báo cái nào đang cũ — 📄 file thật cho từng dòng: [`../templates/.github/`](../templates/.github/). · 📄 [VS Code Docs: Choose a customization scope](https://code.visualstudio.com/docs/agent-customization/overview#choose-a-customization-scope)

---

## 1. File nào Copilot tự load, file nào phải gọi tay?

**Trả lời 1 câu:** Tự load `copilot-instructions.md` (mọi lúc) + `*.instructions.md` khớp `applyTo`; gọi tay `*.prompt.md` (slash, chỉ Local harness) + custom agent (chọn trong picker); còn Skill thì model tự gọi theo `description` — chuẩn khuyến nghị 2026.

Ví von cho dễ phân: instructions là tạp dước đeo sẵn vào việc (tự áp mỗi lần vào bếp), prompt file là công thức phải mở ra đọc, còn Skill là đầu bếp biết tự nhìn thấy món order mà vào bếp.

> 📄 **Code ví dụ:** [`./examples/02-model-context-premium/file-nao-copilot-tu-load-file-nao.sh`](./examples/02-model-context-premium/file-nao-copilot-tu-load-file-nao.sh)

> "Đã tạo file mà Copilot không biết" — check đường dẫn + tên file trước tiên (đuôi phải là `.instructions.md` chứ không phải `.md` trơn). · 📄 [VS Code Docs: Discovery & activation](https://code.visualstudio.com/docs/agents/reference/custom-instructions-reference#discovery-and-activation)

## 2. `applyTo` viết sao cho đúng?

**Trả lời 1 câu:** `applyTo` là glob phải khớp đúng root thật của repo (thường cần `**/` đầu và quote khi có `*`) — viết theo `ls`/`find` thật, đừng đoán.

> 📄 **Code ví dụ:** [`./examples/06-prompts-agents-instructions/applyto-viet-sao-cho-ung.yaml`](./examples/06-prompts-agents-instructions/applyto-viet-sao-cho-ung.yaml)

> 📄 **Code ví dụ:** [`./examples/06-prompts-agents-instructions/applyto-viet-sao-cho-ung.sh`](./examples/06-prompts-agents-instructions/applyto-viet-sao-cho-ung.sh)

> Glob sai root là lý do số 1 khiến instructions "không load". · 📄 [VS Code Docs: Apply instructions to specific files](https://code.visualstudio.com/docs/agent-customization/custom-instructions#apply-instructions-to-specific-files-or-tasks)

## 3. Frontmatter lỗi — các bẫy phổ biến?

**Trả lời 1 câu:** 4 bẫy: thiếu cặp `---` mở/đóng, sai key (`applyTo` phải camelCase), quên quote glob có `*`, liệt kê `tools` không tồn tại.

> 📄 **Code ví dụ:** [`./examples/06-prompts-agents-instructions/frontmatter-loi-cac-bay-pho-bien.sh`](./examples/06-prompts-agents-instructions/frontmatter-loi-cac-bay-pho-bien.sh)

```markdown
---
mode: agent
description: Review PR theo checklist correctness/security/tests
tools: [github-mcp, search, edit]
---
```

> Prompt/agent "không hiện trong picker" — 70% là frontmatter hỏng. `tools` sai tên làm agent lỗi lúc chạy — thử bỏ hẳn `tools` để test, rồi thêm lại từng cái. · 📄 [VS Code Docs: Troubleshoot instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions#troubleshoot-instructions)

## 4. `copilot-instructions.md` bao nhiêu dòng là vừa?

**Trả lời 1 câu:** Giữ **<200 dòng** — dài quá context phình, phần cuối bị cắt, rule quan trọng chìm. Phần dài tách sang `*.instructions.md` theo path, procedure dài tách thành `SKILL.md`.

> 📄 **Code ví dụ:** [`./examples/06-prompts-agents-instructions/copilot-instructions-md-bao-nhieu-dong-la.sh`](./examples/06-prompts-agents-instructions/copilot-instructions-md-bao-nhieu-dong-la.sh) · 📄 [VS Code Docs: Context window & compaction](https://code.visualstudio.com/docs/agents/concepts/context#context-window-and-compaction)

**Ví dụ:** file chính 350 dòng (React + API + deploy) → tách React sang `frontend-react.instructions.md`, deploy sang skill → còn 120 dòng.

## 5. Instructions không load — checklist 6 bước?

**Trả lời 1 câu:** Đi đúng thứ tự: tên file/đường dẫn → `applyTo` đúng glob → file có khớp glob → reload IDE → mở chat mới → hỏi admin (org policy có thể tắt custom instructions).

> 📄 **Code ví dụ:** [`./examples/02-model-context-premium/instructions-khong-load-checklist-6-buoc.sh`](./examples/02-model-context-premium/instructions-khong-load-checklist-6-buoc.sh)

> **Chat cũ giữ context cũ** — mở chat mới trước khi kết luận instructions sai. · 📄 [VS Code Docs: Verify your instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions#verify-your-instructions)

## 6. Prompt files (`*.prompt.md`) — chỉ Local harness

**Trả lời 1 câu:** Prompt file là kịch bản đóng gói (frontmatter ép mode + tools + body từng bước) gọi bằng `/tên-file` — kết quả nhất quán, share được team, nhưng **chỉ chạy ở Local harness (VS Code)**, Copilot harness không nạp. Việc mới nên dùng Agent Skill.

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

> 📄 **Code ví dụ:** [`./examples/06-prompts-agents-instructions/prompt-files-prompt-md-legacy.sh`](./examples/06-prompts-agents-instructions/prompt-files-prompt-md-legacy.sh)

> Repo chỉ chạy Local và đã có prompt file ổn → giữ tạm, port dần sang Skill. · 📄 [VS Code Docs: Prompt file locations](https://code.visualstudio.com/docs/agent-customization/prompt-files#locations)

## 7. Custom agent (`*.agent.md`) viết sao, khi nào cần?

**Trả lời 1 câu:** Custom agent = hướng dẫn + `tools` giới hạn cho một vai chuyên môn — cần khi muốn tách việc (đọc ồn giao explorer) hoặc ép kỷ luật (tester chỉ báo PASS/FAIL); task 1-2 file thì chat thường + instructions đủ.

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

Mẫu sẵn trong `templates/.github/agents/`. · 📄 [VS Code Docs: Custom agent file structure](https://code.visualstudio.com/docs/agents/reference/custom-agent-file-reference#file-structure)

## 8. Agent Skills (`SKILL.md`) khác gì prompt/agent?

**Trả lời 1 câu:** Skill là gói **mô tả + procedure + tools** mà model **tự phát hiện và gọi** khi task khớp `description` — chạy ở cả Copilot harness lẫn Local harness, khác prompt file (gọi tay, chỉ Local) và custom agent (phải chọn trong picker).

```markdown
<!-- .github/skills/review-pr/SKILL.md -->
---
name: review-pr
description: Dùng khi user nhờ review PR, diff, hoặc kiểm tra code trước merge. Không dùng cho việc viết feature mới.
---
# Review PR skill
...procedure + checklist + lệnh git diff...
```

| Tiêu chí | Prompt file (chỉ Local) | Custom agent | Agent Skill (chuẩn 2026) |
|---|---|---|---|
| Kích hoạt | Gọi tay `/tên` | Chọn trong picker | Model tự gọi theo `description` |
| Chạy ở đâu | Local/VS Code | Harness có picker | Mọi harness |
| Khi nào dùng | Việc lặp đã có, chỉ Local | Tách việc / ép kỷ luật | Procedure tự áp |

> **Cách đọc bảng này:** dọc cột **Tiêu chí** so ba cách đóng gói như so ba cách giao hàng: gọi tay (prompt), chọn thủ công (custom agent), hay tự nhận việc (Skill) — cột nào thắng ở hàng "Kích hoạt" và "Chạy ở đâu" là lời giải cho vì sao 2026 khuyến nghị Skill.

> **Model không gọi skill:** `description` quá mơ hồ là lý do phổ biến nhất — viết theo cặp "dùng khi..." / "không dùng cho...". · 📄 [VS Code Docs: Skills vs custom instructions](https://code.visualstudio.com/docs/agent-customization/agent-skills#agent-skills-vs-custom-instructions)

## 9. Thứ tự ưu tiên khi nhiều instructions cùng khớp 1 file?

**Trả lời 1 câu:** Mạnh → yếu: prompt hiện tại > `*.instructions.md` khớp path cụ thể > `copilot-instructions.md` > org policy (trần cứng) — cái cụ thể/gần hơn luôn thắng.

> 📄 **Code ví dụ:** [`./examples/06-prompts-agents-instructions/thu-tu-uu-tien-khi-nhieu-instructions.sh`](./examples/06-prompts-agents-instructions/thu-tu-uu-tien-khi-nhieu-instructions.sh)

> Đừng viết 2 instructions mâu thuẫn cho cùng path — hành vi sẽ khó đoán. · 📄 [VS Code Docs: Resolve conflicting instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions#resolve-conflicting-instructions)

## 10. Test instructions mới có hiệu quả không?

**Trả lời 1 câu:** 3 phép thử trong chat mới: **test load** (hỏi quy tắc, phải kể đúng), **test hành vi** (task vi phạm phải bị từ chối), **test nhiễu** (task ngoài scope không bị ảnh hưởng).

> 📄 **Code ví dụ:** [`./examples/06-prompts-agents-instructions/test-instructions-moi-co-hieu-qua-khong.sh`](./examples/06-prompts-agents-instructions/test-instructions-moi-co-hieu-qua-khong.sh) · 📄 [VS Code Docs: Verify the improvement](https://code.visualstudio.com/docs/agents/guides/customize-copilot-guide#step-3-verify-the-improvement)

**Ví dụ:** thêm "NEVER sửa migrations" → test "sửa giúp migration 003" → Copilot phải từ chối + đề xuất tạo migration mới. 2 phút test đỡ 2 tuần "sao nó không nghe".

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. `find .github -type f | sort` — đúng đường dẫn + tên file.
2. `head -8` từng file — frontmatter đủ `---` + key đúng.
3. Glob `applyTo` đối chiếu `ls` thật.
4. Reload IDE + mở chat mới.
5. Hỏi admin: org có tắt custom instructions không.

📄 Script debug 6 bước: [`./examples/02-model-context-premium/instructions-khong-load-checklist-6-buoc.sh`](./examples/02-model-context-premium/instructions-khong-load-checklist-6-buoc.sh).

Tham khảo chéo: [bài 05](05-policies-guardrails-faq.md) (quy tắc ALWAYS/NEVER) · [bài 02](02-model-context-premium.md) (context + nhiễu) · [bài 07](07-custom-agents-coding-agent-workflows.md) (custom agent workflows) · [../templates/README.md](../templates/README.md).

> **Tóm gọn 1 câu:** File Copilot không load chỉ có 3 thủ phạm: sai địa chỉ, sai giấy khai sinh (frontmatter), sai vùng phủ (glob) — soi ba chỗ đó theo thứ tự là tìm ra 90% ca. · 📄 [VS Code Docs: Troubleshoot customization issues](https://code.visualstudio.com/docs/agent-customization/overview#troubleshoot-customization-issues)
