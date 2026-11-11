# Tips 07 — Thiết Kế Skills & Prompts Tái Dùng: Viết 1 Lần, Cả Team Hưởng

> **Dành cho:** team 2 người trở lên đang fix bug / review / release mỗi người một kiểu.
> **Vấn đề:** prompt gõ tay lặp lại mỗi lần, output không đồng nhất, đồng nghiệp hỏi "prompt hôm qua đâu?" mà bạn không nhớ.
> **Đọc xong:** đóng gói được Agent Skills, prompt files và instructions để cả team gọi ra cùng một format.
> **Thời gian:** ~20 phút đọc + ~35 phút làm walkthrough cuối bài.

> **Lưu ý 2026:** prompt files `.prompt.md` **chỉ chạy ở Local harness** (VS Code docs — docs GitHub không gọi chúng là "deprecated"); Copilot harness không nạp chúng. Việc mới nên ưu tiên **Agent Skills** (`SKILL.md`, chuẩn mở, chạy ở cả Copilot harness lẫn Local). Bài này dạy cả 2, khuyến nghị skill.

## 1. Vì sao phải tái dùng?

Mục này cho bạn thấy "bệnh" chung của team khi ai cũng giữ prompt riêng trong đầu. Nhận ra bệnh rồi mới thấy vì sao cần đóng gói.

Dấu hiệu bạn đang "nợ" prompt: mỗi lần gặp bug là gõ lại từ đầu, mỗi lần một kiểu. Đồng nghiệp hỏi "prompt hôm qua là gì?" thì bạn lục mãi không ra. Team 5 người thì có 5 cách dặn Copilot. Luật quan trọng phải nhắc miệng mỗi phiên chat — nhắc thiếu là quên.

```text
Trước: gõ 10 dòng mỗi lần × 20 lần = 200 dòng + 20 kiểu khác nhau
Sau:  viết 1 file 30 dòng, gọi lại 20 lần, output đồng nhất
```

> Rule: **prompt dùng >2 lần thì đóng gói thành file. Luật áp mọi turn thì thành instructions.**

Bản chất nợ prompt không nằm ở việc gõ 10 dòng. Nó nằm ở chỗ mỗi lần gõ, bạn *sót một dòng khác nhau*. Đóng gói giống như viết công thức nấu ăn ra giấy thay vì nhớ trong đầu: lần nào cũng đủ nguyên liệu, không bỗng dưng thiếu muối.

> **Tóm gọn 1 câu:** Prompt mà phải gõ lại từ đầu nhiều lần là nợ — đóng gói thành file để lần nào cũng ra cùng một kết quả. · 📄 [VS Code Docs: Reuse customizations across harnesses](https://code.visualstudio.com/docs/agent-customization/overview#reuse-customizations-across-harnesses)

## 2. Cơ chế: 3 loại tài sản tái dùng

Mục này giải thích 3 loại "tài sản" bạn có thể đóng gói, và khác nhau ở chỗ nào. Hiểu được khác biệt này thì sau này mới chọn đúng loại, không nhét sai chỗ.

| Loại | File | Kích hoạt | Khi dùng |
|---|---|---|---|
| Prompt files (legacy, Local) | `.github/prompts/*.prompt.md` | Gọi tay `/tên-file` | Task lặp: bug, review, research |
| Instructions | `.github/copilot-instructions.md` + `*.instructions.md` | Tự áp mọi turn / theo glob | Luật, convention, cấm địa |
| Skills (chuẩn 2026) | `.github/skills/*/SKILL.md` | Copilot tự nhận diện theo description | Procedure nhiều bước: release, migrate |

> **Cách đọc bảng này:** mỗi dòng là 1 loại tài sản. Cột **File** cho biết đặt ở đâu, cột **Kích hoạt** cho biết nó chạy khi nào (bạn chủ động gọi hay Copilot tự bật), cột **Khi dùng** là tình huống phù hợp nhất.

```text
Prompt = bạn gọi khi cần (chủ động).
Instructions = tự chạy ngầm (bị động).
Skill = procedure dài, Copilot tự biết khi nào dùng.
```

Nói đời thường cho dễ nhớ: prompt file giống cuốn công thức bạn tự mở ra khi nấu — muốn dùng thì mới lấy. Instructions giống tờ giấy dán luật lên cửa tủ lạnh: ai vào bếp cũng thấy, khỏi ai nhắc. Skill giống quy trình vận hành từng bước (SOP): Copilot tự biết lúc nào cần lật ra dùng.

Nơi đặt chuẩn:

```text
.github/
  copilot-instructions.md          # luật chung <200 dòng
  instructions/
    payments.instructions.md       # applyTo: src/payments/**
  prompts/                         # legacy, chỉ Local
    team-bug.prompt.md
  skills/
    team-bug/SKILL.md              # chuẩn 2026, chạy cả Copilot harness lẫn Local
```

Chọn nhanh, tránh nhét sai chỗ: nhét luật 1 dòng vào prompt file thì mỗi lần phải nhớ gọi — mệt. Nhét quy trình 10 bước vào prompt file thì nó phình ra, quên nửa sau. Nhét task lặp vào instructions thì nó nạp lại mỗi turn — tốn credit vô ích.

> **Tóm gọn 1 câu:** Ba loại khác nhau ở cách kích hoạt — prompt file bạn tự gọi, instructions tự chạy ngầm, skill là quy trình dài Copilot tự nhận diện. 📄 File thật từng loại: [`../templates/.github/prompts/review-pr.prompt.md`](../templates/.github/prompts/review-pr.prompt.md) · [`../templates/.github/copilot-instructions.md`](../templates/.github/copilot-instructions.md) · [`../templates/.github/skills/review-pr/SKILL.md`](../templates/.github/skills/review-pr/SKILL.md). · 📄 [GitHub Docs: Comparing customizations](https://docs.github.com/en/copilot/concepts/customizations/comparing-customizations)

## 3. Prompt files (.prompt.md) — legacy, chỉ Local

Mục này giới thiệu cách đóng gói đời đầu. Giờ nó chỉ chạy trên Local/VS Code, nhưng nhiều repo cũ vẫn đang dùng nên bạn cần nhận ra nó.

Frontmatter là khối `---` ngay đầu file — giống dòng ghi trên bìa hộp: khai báo mode, tools và mô tả để Copilot biết chạy kiểu gì:

```markdown
---
mode: agent       # ask | edit | agent
tools: [search, read, edit, test]
description: Fix bug tối thiểu + regression test
---
```

**Ví dụ — team-bug.prompt.md (copy-paste):**

```markdown
## Nhiệm vụ
Fix bug mô tả trong ${input:bugDescription} tại ${input:scope}.

## Steps
1. Đọc ${input:scope} + test liên quan, giải thích root cause 3 bullet.
2. Fix tối thiểu, không đổi public API, không refactor lan man.
3. Thêm 1 regression test cover case này.
4. Chạy `npm test -- ${input:scope}` và dán log pass/fail.
   Đỏ thì fix tiếp trong message này (tối đa 3 lần).

## Ràng buộc
- Đừng đụng src/generated/, đừng commit thẳng main.
- Không xóa/sửa test cũ để cho xanh.

## Output
- ## Evidence: log test + git diff --stat
```

Gọi: `/team-bug scope=src/payments bugDescription="refund quá 30 ngày bị 500"`

Cú pháp `${input:tên}` là chỗ trống để điền — giống mẫu đơn có ô trống, gọi lúc nào Copilot hỏi lần đó.

> Repo cũ đã có prompt file → giữ chạy Local, port dần sang skill.

> **Tóm gọn 1 câu:** Prompt file = 1 file markdown có frontmatter + variables, gọi bằng `/tên-file`; chỉ chạy Local nên việc mới nên chuyển sang skill. · 📄 [VS Code Docs: Prompt file reference](https://code.visualstudio.com/docs/agent-customization/prompt-files#prompt-file-reference)

## 4. Instructions: luật tự áp theo scope

Mục này nói về loại thứ hai: luật không cần gọi, đến turn nào cũng tự áp. File root áp cho cả repo; file scoped áp đúng từng thư mục.

"Scope" nghĩa là phạm vi áp dụng. Ta giới hạn bằng `applyTo` với một glob. Glob đơn giản là mẫu so khớp đường dẫn, giống bộ lọc: `src/payments/**` nghĩa là "mọi file trong src/payments".

**Root instructions (<200 dòng):**

```markdown
# .github/copilot-instructions.md

## Stack
- Node 20, TypeScript strict, pnpm.

## Luật hay sai nhất (front-load lên đầu)
- Luôn chạy `npm test -- <scope>` trước khi kết luận done.
- Không sửa `src/generated/`, không commit thẳng main.
- Mọi API mới phải có test trong `__tests__/`.

## Lệnh hay dùng
- test: `npm test -- <scope>` · lint: `npm run lint` · build: `npm run build`
```

**Scoped instructions theo glob:**

```markdown
---
applyTo: "src/payments/**"
---

## Riêng payments
- Refund >30 ngày phải hỏi duyệt, không tự quyết.
- Mọi API mới phải có idempotency-key header.
- Không gọi trực tiếp DB, qua repository layer.
```

Ba điểm kiểm tra chất lượng. Một: glob càng hẹp càng tốt (`src/payments/**` tốt hơn `src/**`) — hẹp thì ít gây tác dụng phụ ngoài ý muốn. Hai: mỗi file scoped giữ dưới 50 dòng, chỉ chứa luật riêng scope đó. Ba: luật chung để ở root một chỗ, đừng lặp lại ở các file con — lặp là khi sửa sẽ sót.

> **Tóm gọn 1 câu:** Instructions là luật tự áp không cần gọi — luật chung để root, luật riêng từng module tách file với `applyTo` glob hẹp. · 📄 [VS Code Docs: Instruction formats & settings](https://code.visualstudio.com/docs/agent-customization/custom-instructions#instruction-formats-and-settings)

## 5. Skills (SKILL.md): procedure nhiều bước

Mục này nói về loại mạnh nhất chuẩn 2026. Procedure nghĩa là quy trình nhiều bước — khi nó vượt quá 5 bước, prompt file sẽ phình và dễ quên, nên tách thành skill.

Skill giống bộ SOP dán ở quầy pha chế: ai làm đúng việc đó thì lật ra, làm theo từng bước, khỏi nhớ trong đầu. Copilot đọc `description` trong SKILL.md và tự biết lúc nào cần dùng.

**Ví dụ — skills/release/SKILL.md (copy-paste):**

```markdown
---
name: release
description: Dùng khi cần release version mới: bump, changelog, tag, verify CI.
allowed-tools: [shell, edit]
---

# Release procedure

## 1. Kiểm tra
- `git status` sạch, đang ở main, pull mới nhất.
- `npm test` + `npm run build` xanh mới tiếp tục.

## 2. Bump + changelog
- Bump version trong package.json (patch/minor/major theo yêu cầu).
- Thêm mục CHANGELOG.md: ngày + 3 bullet thay đổi từ git log.

## 3. Tag + push
- Commit `chore: release vX.Y.Z`, tag `vX.Y.Z`, push + tag.
- Chờ CI xanh trên tag, dán link run.

## 4. Không làm
- Không release khi CI đỏ, không force push tag.
```

Gọi tự nhiên: `"Dùng skill release để release patch tuần này."` — Copilot tự nhận diện description khớp → load procedure.

**Khi nào tách skill:** procedure >5 bước và dùng >1 lần/tháng; cần nhận tham số lúc gọi (viết tự do sau `/skill`) + checks + rollback; muốn Copilot tự trigger. Không tách khi chỉ 2–3 bước (prompt file đủ) hoặc luật 1 dòng (instructions đủ). Cứ nghĩ như chia đồ trong nhà: đồ dùng hàng ngày để ngăn gần tay, đồ ít dùng cất kho — skill là "kho" cho quy trình dài.

> **Tóm gọn 1 câu:** Skill là file SKILL.md mô tả quy trình nhiều bước, Copilot đọc description tự kích hoạt — quy trình nào dài và dùng nhiều thì nên tách thành skill.

> Bảo mật: skill tải từ repo ngoài có thể chứa prompt injection / script độc hại — luôn đọc kỹ SKILL.md và script tham chiếu trước khi cài, chỉ pre-approve `shell`/`bash` cho skill bạn hoàn toàn tin. · 📄 [VS Code Docs: SKILL.md file format](https://code.visualstudio.com/docs/agent-customization/agent-skills#skillmd-file-format)

## 6. Few-shot + variables chuẩn

Mục này dạy 2 chiêu làm prompt đáng tin hơn: biến (variables) để điền chỗ thay đổi, và few-shot để cho Copilot "học theo mẫu".

Few-shot nghĩa là "cho xem vài ví dụ mẫu" — như dạy thợ phụ bằng cách làm mẫu một lần, thay vì miêu tả suông cả ngày. Variables là các "ô trống" trong mẫu đơn, gọi lúc nào điền lúc đó:

| Cú pháp | Ý nghĩa | Ví dụ |
|---|---|---|
| `${input:tên}` | Hỏi khi gọi | `${input:scope}` |
| `${input:tên:default}` | Có default | `${input:planFile:plan.md}` |
| `${selection}` | Đoạn đang bôi | Dùng cho edit |
| `${file}` | File đang mở | Dùng cho review |

> **Cách đọc bảng này:** cột **Cú pháp** là cách viết trong prompt file, cột **Ý nghĩa** cho biết Copilot xử lý nó thế nào khi chạy, cột **Ví dụ** là tình huống hay dùng nhất.

> ⚠️ Các biến `${input:...}`, `${selection}`, `${file}` là của **prompt file (Local harness)** — docs **không** khai báo biến nội suy nào cho `SKILL.md`. Truyền thêm dữ liệu cho skill: viết tự do sau lệnh gọi, vd `/team-bug scope=src/auth bug="refund 500"` — và tham chiếu file bằng link markdown hoặc `#file:` đường dẫn tương đối tới `SKILL.md`.

Mọi prompt file/skill nên có **1 ví dụ input → output đúng** ở cuối để Copilot bắt chước:

```markdown
## Ví dụ đúng
Input: scope=src/payments, bug="refund 10k order #123 bị 500"
Output đúng:
- Root cause 3 bullet + file:line
- Fix 5 dòng trong refund.ts:42, giữ export
- Regression test 1 case, `npm test -- payments` xanh
- Evidence: log + diff --stat chỉ chạm src/payments/**
```

Lợi ích: output đồng nhất, dễ review, Copilot ít sáng tạo bừa. Người mới đọc ví dụ là hiểu cách dùng ngay — tiết kiệm cả buổi bàn luận. 📄 Prompt few-shot thành file: [`../templates/.github/prompts/add-table.prompt.md`](../templates/.github/prompts/add-table.prompt.md).

> **Tóm gọn 1 câu:** Variables biến chỗ hay đổi thành ô điền, few-shot cho 1 ví dụ đúng để Copilot bắt chước — cả hai giúp output đồng nhất mỗi lần gọi. · 📄 [VS Code Docs: Tips for effective prompts](https://code.visualstudio.com/docs/agent-customization/prompt-files#tips-for-writing-effective-prompts)

## 7. Walkthrough: đóng gói 1 prompt team — 35 phút

Mục này là bài thực hành tổng hợp: biến một prompt bạn đang gõ tay thành tài sản cả team dùng được, trong 35 phút.

| Phút | Việc | Làm gì |
|---|---|---|
| 0–5 | Chọn mẫu | Lấy prompt bug bạn ưng nhất (Tips 02 Mẫu 1) |
| 5–15 | Viết file | Tạo `.github/skills/team-bug/SKILL.md` + few-shot (Local-only: `.github/prompts/team-bug.prompt.md` legacy có `${input}`) |
| 15–20 | Test | Nói "fix bug scope=src/auth" trên bug thật (skill tự load), sửa output chưa chuẩn |
| 20–25 | Tách luật | Chuyển dòng NEVER chung vào copilot-instructions.md, chỉ giữ luật riêng bug trong skill |
| 25–30 | Share | Commit + PR, nhờ 1 đồng nghiệp trigger thử, ghi feedback 3 dòng |
| 30–35 | Version | Thêm vào README team: khi nào dùng skill, khi nào review |

> **Tóm gọn 1 câu:** Chọn 1 prompt dùng nhiều → viết thành skill có variables + few-shot → test trên task thật → tách luật chung → commit cho cả team. 📄 2 script tạo nhanh: [`../01-huong-dan-su-dung/examples/05-agent-skills-reusable-workflows/walkthrough-5-phut-skill-au-tien-cua.sh`](../01-huong-dan-su-dung/examples/05-agent-skills-reusable-workflows/walkthrough-5-phut-skill-au-tien-cua.sh) · [`../01-huong-dan-su-dung/examples/00-tong-quan-copilot/port-prompt-file-cu-sang-skill.sh`](../01-huong-dan-su-dung/examples/00-tong-quan-copilot/port-prompt-file-cu-sang-skill.sh).

> **Cách đọc bảng này:** mỗi dòng là 1 mốc thời gian trong 35 phút. Cột **Phút** là khung giờ, cột **Việc** là tên bước, cột **Làm gì** là hành động cụ thể cần xong trong mốc đó. · 📄 [VS Code Docs: Create a customization](https://code.visualstudio.com/docs/agent-customization/overview#create-a-customization)

## 8. Bảng tra nhanh: dùng loại nào?

Mục này là "bảng cử nhân" để lôi ra tra khi phân vân — đối chiếu nhu cầu hiện tại với cột giữa là biết dùng gì ngay.

| Nhu cầu | Dùng gì | Gọi thế nào |
|---|---|---|
| Task lặp (bug/review/research) | **Skill** (chuẩn 2026) | Tự trigger khi khớp description (mọi harness) |
| Task lặp trong repo cũ chạy Local | Prompt file (legacy) | `/tên-file var=...` |
| Luật áp mọi turn | Root instructions | Tự áp, không cần gọi |
| Luật riêng 1 module | Scoped instructions + applyTo | Tự áp khi chạm glob |
| Procedure >5 bước | **Skill** | Tự trigger / gọi tên skill |
| Hỏi 1 lần, không tái dùng | Chat thường | Gõ tay + new chat |

> **Cách đọc bảng này:** tìm dòng khớp nhu cầu của bạn ở cột **Nhu cầu**, rồi nhìn cột **Dùng gì** để chọn và cột **Gọi thế nào** để biết cách kích hoạt.

> Quy tắc ngón tay: **1 dòng → instructions, 1 task lặp → skill (2026) / prompt file (legacy Local), 1 quy trình dài → skill.**

> **Tóm gọn 1 câu:** Phân vân thì tra bảng: task lặp → skill/prompt file, luật chung → instructions, hỏi 1 lần rồi thôi → gõ tay trong chat. · 📄 [VS Code Docs: Customization building blocks](https://code.visualstudio.com/docs/agents/concepts/customization#customization-building-blocks)

## 9. Pitfalls + cách fix

Mục này liệt kê các lỗi hay gặp khi đóng gói prompt, kèm triệu chứng để bạn tự soi và cách sửa. Pitfall nghĩa là "bẫy" — chỗ ai cũng té ít nhất một lần.

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Prompt file 200 dòng | Copilot quên nửa sau | <60 dòng + variables + 1 ví dụ |
| Thiếu mode/tools | Research lại sửa code | Ask cho research, agent cho implement + giới hạn tools |
| Không có variables | Mỗi lần vẫn sửa tay | `${input:...}` + default cho mọi chỗ đổi |
| Không có few-shot | Output mỗi lần một kiểu | Thêm 1 ví dụ input → output đúng |
| Instructions 600 dòng | Quên, chậm | Root <200 dòng, riêng tách applyTo files |
| Glob quá rộng | Luật payments áp cả auth | Thu hẹp applyTo, 1 file 1 scope |
| Skill description chung chung | Không bao giờ trigger | 1–2 câu use-case + trigger keywords |
| Không version/commit | Mỗi máy một bản | Commit `.github/` + skills/ vào repo (xem Tips 09) |

> **Cách đọc bảng này:** cột **Pitfall** là cái bẫy, cột **Triệu chứng** là dấu hiệu cho thấy bạn đã dính bẫy, cột **Fix** là cách xử lý tương ứng.

Ba lỗi khó chịu nhất:

```text
❌ SAI: tạo .github/prompts/release.prompt.md cho quy trình 8 bước (chỉ chạy Local)
✅ ĐÚNG: tạo .github/skills/release/SKILL.md (chuẩn mở, chạy ở cả Copilot harness lẫn Local)

❌ SAI: lặp "không commit main" trong cả 5 file *.instructions.md
✅ ĐÚNG: luật chung ở copilot-instructions.md, file con chỉ giữ luật riêng scope
```

> **Tóm gọn 1 câu:** File quá dài, thiếu variables, thiếu ví dụ và glob quá rộng là 4 cái bẫy phổ biến nhất — kiểm tra 4 điểm này trước khi share cho team. 📄 Frontmatter `applyTo` mẫu: [`03-4-mau-python-rules.instructions.md`](../01-huong-dan-su-dung/examples/03-instructions-memory-rules/mau-python-rules.instructions.md). · 📄 [VS Code Docs: Agent Skills common issues](https://code.visualstudio.com/docs/agent-customization/agent-skills#common-issues)

## 10. Bài tập cuối bài

Mục này là phần về nhà. Làm đủ 3 bài thì bạn mới thực sự "biết" chứ không chỉ "đọc hiểu" — mỗi bài ra một tài sản dùng được thật.

**Bài 1 (15 phút):** Lấy prompt dùng >2 lần/tuần, lưu thành `.github/prompts/my-first.prompt.md` (frontmatter + variables + few-shot) — file này chỉ chạy ở Local harness. Gọi lại `/my-first` trên task thật, so output trước/sau.

**Bài 2 (20 phút):** Rút gọn copilot-instructions.md <200 dòng, tách 2 files applyTo cho 2 modules hay sai nhất. Test: nhờ Copilot sửa file trong scope, xem luật riêng có áp không?

**Bài 3 (30 phút):** Chọn 1 procedure >5 bước (release/migrate/onboarding), viết `skills/<tên>/SKILL.md` theo mẫu mục 5. Nhờ Copilot dùng cho task thật, ghi lại bước nào còn thiếu.

> Đạt: sau 1 tháng, team bạn có ≥3 skills/prompts + instructions gọn + 1 skill dài, mọi output đồng format.

> **Tóm gọn 1 câu:** Làm hết 3 bài tập để biến kiến thức thành tài sản thật: 1 prompt file, bộ instructions gọn, và 1 skill cho quy trình dài — giấy làm bài + file đối chiếu: [`02-1-session-target-picker.md`](../01-huong-dan-su-dung/examples/00-tong-quan-copilot/session-target-picker.md) · [`../templates/.github/`](../templates/.github/).

## Tham khảo chéo

- [Tips 02](./02-prompt-engineering.md) — 6 mẫu prompt để đóng gói
- [Tips 04](./04-verification-done-that.md) — verify prompt files
- [Tips 06](./06-policies-guardrails-recipes.md) — guardrails bằng instructions
- [Tips 09](./09-teamwork-chuan-hoa.md) — commit + share cho team
- [Tips 03](./03-plan-first-workflow.md) — plan prompt file

> **Chốt Tips 07:** prompt gõ 2 lần là đã thành nợ — 1 dòng thì để instructions, 1 task lặp thì đóng gói thành file, quy trình dài thì viết `SKILL.md` theo chuẩn chung để dùng lại ở mọi harness.
