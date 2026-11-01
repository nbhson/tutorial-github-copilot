# 06 — Custom Agents & Chạy Song Song (Parallel Copilot)

> **Dành cho:** dev đã dùng Copilot Chat cơ bản (xong bài 03–05), muốn tách việc ra cho agent riêng và chạy nhiều việc cùng lúc.
> **Vấn đề:** chat chính làm hết research + code + test → context đầy nhanh, kết quả lẫn lộn, và không chạy nổi 2 việc cùng lúc.
> **Đọc xong:** viết được 4 custom agents hoàn chỉnh, chọn đúng công cụ trong 30 giây, chạy song song 3 sessions không giẫm chân nhau, và nhẩm được cost AI Credits trước khi fan-out. **Thời gian:** ~40 phút.

## Mục tiêu bài học

Mục này cho biết hết bài bạn làm được gì — đọc xong biết ngay có đáng đầu tư 40 phút hay không.

- Viết được **4 custom agents** (explorer, planner, security-reviewer, tester), hiểu từng field trong `.agent.md` và chọn đúng công cụ trong 30 giây (`@workspace` / agent / skill / coding agent).
- Chạy song song **3 sessions** (mỗi session 1 branch/worktree) không conflict, route việc dễ sang model rẻ.

> **Tóm gọn 1 câu:** Hết bài bạn có 4 "nhân viên ảo" chuyên trách và biết điều phối 3 việc cùng lúc mà không giẫm chân nhau.

---

## 1. Vì sao cần custom agent?

Mục này giải thích lý do phải tách việc cho agent riêng. Nếu không tách, chat chính của bạn sẽ như một người vừa đi chợ, vừa nấu cơm, vừa trông con — cuối cùng việc gì cũng dở.

**Định nghĩa 1 câu:** Custom agent là "nhân viên" Copilot có persona riêng + danh sách tools khóa trong frontmatter + model riêng — chạy ở session riêng rồi trả về **tóm tắt**. Nôm na: bạn thuê ô sin làm ở căn phòng riêng. Nó xong việc chỉ đưa bạn tờ báo cáo, chứ không kéo cả đống rác phòng nó sang nhà bạn.

```text
 KHÔNG agent: "auth flow thế nào?" → Copilot đọc 50 files → context đầy → câu hỏi kế bị quá tải.
 CÓ agent: "dùng agent explorer map auth flow, trả summary 15 dòng" → explorer đọc 50 files
 ở session riêng → trả đúng 15 dòng. Chat chính còn trống chỗ để implement.
```

**Lợi ích:** giữ context sạch (explorer đọc 50 files, chat chính nhận 15 dòng); enforce chuẩn team (reviewer luôn check OWASP); tái dùng cross-repo (commit `.github/agents/`, teammate clone là dùng); tiết kiệm AI Credits (việc dễ → model rẻ).

**Giá phải trả:** mỗi lần spawn tốn overhead (nạp instructions + tool definitions). Task 1 bước ("đọc file X") spawn = lỗ; research 50 files = lời.

```text
 Quy tắc chọn nhanh (30 giây):
 - Hỏi cho biết <5 files      → hỏi trực tiếp @workspace, đừng spawn.
 - >10 files hoặc cần persona → spawn custom agent.
 - Chỉ là "làm theo chuẩn X"  → viết instructions/skill (bài 03, 05), đừng spawn.
 # Verify: đếm files task bạn sắp làm (search trước). <5 → hỏi trực tiếp.
```

> **Nếu làm sai?** Spawn agent cho task 1 file → overhead ăn hết phần lời. Cho agent read-only full tools "cho mạnh" → nó sửa lung tung ngoài scope. Khóa bằng `tools` — xem mục 3.

> **Tóm gọn 1 câu:** Việc cần đọc nhiều files thì thuê agent riêng để chat chính sạch; việc lẻ tẻ thì hỏi thẳng đừng thuê.

---

## 2. `@workspace` vs custom agent — chọn 30 giây

Mục này dạy bạn chọn đúng công cụ chỉ trong 30 giây, tránh việc thuê thám tử chỉ để hỏi "nhà vệ sinh ở đâu".

`@workspace` là **hỏi anh bảo vệ tòa nhà** — biết hết, hỏi gì đáp nấy, nhanh. Custom agent là **thuê thám tử** — giao việc, trả báo cáo gọn, có bộ chuẩn riêng. "Phòng 302 ở đâu?" → hỏi bảo vệ. "Điều tra 30 hộ tầng 3" → thuê thám tử.

| Cách | Khi nào | Ví dụ |
|---|---|---|
| `@workspace` | Hỏi nhanh, task 1 lần | `@workspace auth flow hoạt động thế nào?` |
| Custom agent | Việc lặp, cần chuẩn cố định | `dùng agent explorer map auth flow` |
| Skill (bài 05) | Quy trình lặp 1 bước | chat "deploy staging" → skill tự load |
| Coding agent (GitHub) | Task độc lập ~30 phút, không cần trông | Assign issue #123 cho `copilot` (bài 11/12) |

> **Cách đọc bảng này:** Cột "Khi nào" là dấu hiệu để chọn — đọc hàng khớp với tình huống của bạn nhất rồi dùng đúng "Cách" đó.

**Điểm khác biệt quyết định:** `@workspace` dùng tools mặc định của bạn. Custom agent **khóa tools** trong frontmatter — dù bạn dụ "sửa luôn giúp anh" thì agent read-only vẫn không sửa được. Đây là guard, không phải bug.

> **Tóm gọn 1 câu:** Hỏi nhanh thì dùng `@workspace`, việc cần đúng chuẩn và lặp lại mới nên giao cho custom agent.

---

## 3. Anatomy file `.agent.md`

Mục này mổ xẻ file `.agent.md` — đọc xong bạn tự viết được agent đầu tiên thay vì chỉ copy mẫu.

File `.agent.md` = **frontmatter (thẻ căn cước: tên, khi nào gọi, tools, model)** + **body (JD: quy trình, output mẫu, cấm gì)**. Hiểu nôm na: frontmatter là phần "hồ sơ nhân viên" dán ngoài cửa, body là bản mô tả công việc chi tiết trong phòng.

**Vị trí file (2026):**

```text
 .github/agents/<ten>.agent.md     # repo-level, commit cho team (KHUYÊN DUNG)
 .vscode/agents/<ten>.agent.md     # legacy VS Code, vẫn chạy
 ~/.copilot/agents/<ten>.agent.md  # personal, mọi repo (tùy bản VS Code)
```

**Frontmatter — từng field (khung thật xem agent explorer ở mục 4.1):**

| Field | Nôm na | Bắt buộc? | Ý nghĩa |
|---|---|---|---|
| `name` | Tên nhân viên | Có | Slug để gọi: `dùng agent explorer ...` |
| `description` | Khi nào gọi anh này | Có | Quyết định auto-trigger. 1–2 câu, nhiều từ khóa user nói thật |
| `tools` | Chìa khóa kho | Nên có | Allowlist. Read-only agents khóa `edit` |
| `model` | Lương (rẻ/đắt) | Nên có | Việc dễ → model rẻ; việc khó → model mạnh |
| `handoff` | Cách bàn giao | Tùy | `summary-only` = chỉ trả tóm tắt (giữ chat chính sạch) |
| `target` | Chạy ở đâu | Tùy | Local → `vscode`; giao cloud → `github-coding-agent` |

> **Cách đọc bảng này:** Cột "Nôm na" giải nghĩa field bằng lời đời thường; cần biết có bắt buộc hay không thì nhìn cột "Bắt buộc?".

**`handoff` — 3 kiểu bàn giao:**

| Giá trị | Chat chính nhận gì | Khi nào dùng |
|---|---|---|
| `summary-only` | Vài dòng summary | Giữ chat chính sạch (explorer/reviewer/tester) |
| `full` | Toàn bộ nội dung agent thấy | Cần xem chi tiết để tự quyết |
| `plan-file` | Path file plan + tóm tắt 10 dòng | Task multi-file cần duyệt trước khi code (planner) |

> **Cách đọc bảng này:** Chọn theo "Khi nào dùng" — cột giữa cho biết bạn sẽ nhận lại gì trên chat chính sau khi agent xong việc.

**Body** viết như viết skill (bài 05): steps đánh số, lệnh cụ thể, output format bắt buộc, non-goals rõ (xem 4 agent mẫu dưới).

**Verify sau khi tạo:** mở Chat MỚI → gõ `/` hoặc `@` phải thấy agent; thử dụ agent read-only sửa code → phải bị chặn bởi allowlist `tools`.

> **Tóm gọn 1 câu:** `.agent.md` gồm frontmatter khai báo agent là ai và body quy định nó làm gì, cấm gì — viết xong nhớ mở chat mới để load.

---
## 4. 4 agents mẫu hoàn chỉnh (copy-paste)

> Đặt vào `.github/agents/`. Commit. Mở Chat view mới để load.

### 4.1. Agent 1 — Explorer (read-only research)

**Nôm na:** Ông trinh sát chỉ nhìn, cấm sờ hiện trường.

```markdown
# .github/agents/explorer.agent.md
---
name: explorer
description: Research codebase read-only, trả summary gọn. Dùng khi cần tìm files liên quan, hiểu module, map dependencies trước khi sửa.
tools: [search, read, grep]
# model: để trống → model rẻ nhất available (việc đọc không cần flagship)
handoff: summary-only
---

Bạn là explorer. Chỉ đọc, KHÔNG sửa.

Quy trình:
1. Bắt đầu bằng search tên file/symbol → grep nội dung → read top 5-10 files liên quan nhất.
2. Không đọc cả file 1000 dòng — đọc phần liên quan (symbol, function).
3. Ghi lại: mỗi file 1 dòng (path + vai trò + có cần sửa không).

Output (bắt buộc, tối đa 30 dòng):
- **Files sẽ sửa**: path + 1 câu vì sao
- **Files chỉ đọc tham khảo**: path + 1 câu
- **Rủi ro**: chỗ nào dễ vỡ nếu sửa

Cấm: lan man lịch sử, paste cả file vào report, đề xuất refactor ngoài scope.
```

```text
 # Gọi mẫu: dùng agent explorer tìm mọi file liên quan tới POST /login rate-limit
 # Verify: summary ≤30 dòng, không 1 dòng code bị thay đổi
```

> **Tóm gọn 1 câu:** Explorer là "trinh sát chỉ nhìn": đọc hết mà không sửa nổi một dòng, trả về bản tóm tắt ngắn cho chat chính.

### 4.2. Agent 2 — Planner (viết plan, không đụng source)

**Nôm na:** Ông kiến trúc sư chỉ vẽ bản vẽ, cấm cầm búa đóng.

```markdown
# .github/agents/planner.agent.md
---
name: planner
description: Viết implementation plan chi tiết (goals/files/steps/verify). Dùng khi task multi-file cần duyệt trước khi code.
tools: [search, read, grep]
model: claude-sonnet-5
handoff: plan-file
---

Bạn là planner. Viết plan, KHÔNG sửa source.

Quy trình:
1. Đọc code liên quan (search → grep → read như explorer).
2. Viết plan vào `plans/<YYYYMMDD>-<ten-task>.md` theo khung:
   - Goals (đo được) / Non-goals (nói rõ không làm gì)
   - Files (sửa file nào, mỗi file làm gì)
   - Steps (từng bước + lệnh verify sau mỗi bước)
   - Risks (chỗ dễ vỡ + rollback)
3. Trình plan, chờ duyệt. Không tự implement.

Output: path plan file + tóm tắt 10 dòng để chat chính duyệt nhanh.
```

```text
 # Gọi mẫu: dùng agent planner viết plan migrate auth JWT → session, ghi vào plans/
 # Verify: có plans/*.md đủ 5 mục, không sửa source
```

> **Tóm gọn 1 câu:** Planner chỉ vẽ bản vẽ (plan trong `plans/`) chứ không đóng đinh — bạn duyệt plan xong mới cho người khác code.

### 4.3. Agent 3 — Security reviewer (read-only + git diff)

**Nôm na:** Ông thanh tra chỉ soi lỗi, cấm sửa hộ (để người viết tự sửa mà nhớ).

```markdown
# .github/agents/security-reviewer.agent.md
---
name: security-reviewer
description: Review code tìm lỗ hổng bảo mật. Dùng khi có diff chạm auth/input/crypto/payment.
tools: [read, grep, search]
model: claude-sonnet-5
handoff: summary-only
---

Bạn là security reviewer. Chỉ đọc, không sửa.

Quy trình:
1. `git diff --stat` → scope. Diff >20 files → báo quá lớn, review theo batch.
2. Đọc diff (`git diff main...HEAD`) + file test kèm (có test cho path mới?).
3. Check theo: injection, authZ, secrets, crypto yếu, SSRF, mass assignment, rate-limit thiếu.

Output: tối đa 10 findings `[CRITICAL|HIGH|MED|LOW] file:line — mô tả — fix`.
Không finding = nói rõ "đã check X, Y, Z — không thấy issue" (đừng im lặng).
```

```text
 # Verify (test thật): tạo PR cố ý có SQL injection (concat string vào query),
 # gọi "dùng agent security-reviewer review PR này".
 # Kỳ vọng: bắt được lỗi + gắn CRITICAL + chỉ đúng file:line.
```

> **Tóm gọn 1 câu:** Security reviewer là thanh tra chỉ soi và báo lỗi kèm mức độ, tuyệt đối không sửa hộ để người viết tự sửa mà nhớ.

### 4.4. Agent 4 — Tester (chạy test, báo pass/fail)

**Nôm na:** Ông kiểm định chỉ bấm máy test rồi dán tem PASS/FAIL, cấm sửa máy.

```markdown
# .github/agents/tester.agent.md
---
name: tester
description: Chạy tests liên quan, báo pass/fail + root-cause guess. Dùng sau mỗi change để verify.
tools: [run-terminal, read]
# model: để trống → model rẻ nhất available (chạy test không cần flagship)
handoff: summary-only
---

Bạn là tester. Chạy test, báo cáo, không sửa source.

Quy trình:
1. Đọc copilot-instructions.md lấy lệnh test focused (vd `pnpm --filter @acme/api test <path>`).
2. Chạy focused trước, full chỉ khi được yêu cầu rõ.
3. Test flaky (pass/fail ngẫu nhiên) → ghi "FLAKY" + dừng đoán, không argue.
4. Fail → báo: lệnh chạy, failures (tối đa 10 dòng log quan trọng), 1-line root-cause guess.

Output:
- `PASS (n/n)` hoặc `FAIL (x/y)` + failures gọn
- Root-cause guess 1 dòng (ghi rõ là guess) + lệnh đã chạy để chat chính reproduce
```

> 📄 **Code ví dụ:** [`examples/01-4-4-agent-4-tester-chay-test-bao.sh`](examples/01-4-4-agent-4-tester-chay-test-bao.sh)

> **Mẹo:** `description` quá dài (>500 ký tự) → auto-trigger kém. Giữ 1–2 câu, chi tiết dồn vào body.

> **Tóm gọn 1 câu:** Tester chỉ bấm máy chạy test rồi dán tem PASS/FAIL kèm phán đoán nguyên nhân, không tự tay sửa code.

---

## 5. Chạy song song: 3 cách

Mục này chỉ ra 3 đường chạy nhiều việc cùng lúc — chọn đường nào tùy việc đó chạy local hay cloud, và bạn có muốn trông nó hay không.

**Cách 1 — VS Code multi-chat** (local, xem kết quả ngay) · **Cách 2 — multi coding-agent sessions** (cloud, giao qua đêm sáng review PRs) · **Cách 3 — Agent Task nền** (local, việc ồn chạy background trong khi bạn code tay).

```text
 Cách 1 — multi-chat: Ctrl+Shift+I mở thêm Chat view → "+" new session.
   Chat 1: "dùng agent explorer map auth flow" | Chat 2: "dùng agent planner viết plan"
   Chat 3 (bạn code tay phần critical). KHÔNG paste output chat này sang chat kia.
   Gom: copy 2 summaries vào chat chính → implement.

 Cách 2 — coding agent cloud: mở issue → Assign to Copilot (hoặc CLI dưới).
   Mỗi issue 1 session → 1 branch copilot/* + 1 PR draft riêng (bài 11).

 Cách 3 — Agent Task nền: Chat view → "New Agent Task": "đọc logs CI 2000 dòng
   + tóm tắt 10 dòng" → chạy nền, ping khi xong; chat không thấy 2000 dòng gốc.
```

> 📄 **Code ví dụ:** [`examples/02-5-chay-song-song-3-cach.sh`](examples/02-5-chay-song-song-3-cach.sh)

> 📄 **Code ví dụ:** [`examples/03-5-chay-song-song-3-cach.sh`](examples/03-5-chay-song-song-3-cach.sh)

> Trần thực tế: **N ≤ 3 concurrent**. Quá con số đó bạn không review nổi + bill AI Credits nổ.

> **Tóm gọn 1 câu:** Cùng lúc chạy tối đa 3 sessions — nhiều hơn là bạn tự đào hố review và tiền điện.

---

## 6. Orchestration patterns + cost math (AI Credits)

Mục này cho bạn 3 "kịch bản đạo diễn" để phối agent, kèm cách bấm máy tính tiền trước khi bấm nút chạy — để không ôm hờn bill cuối tháng.

AI Credits là "xăng" của Copilot: mỗi lần model chạy là tốn một ít. Muốn đi xa thì tính trước xem xe tốn bao nhiêu lít.

```text
 Pattern A — Parallel research (task mới, chưa biết gì về codebase):
   2 explorers đi riêng (auth flow | DB schema) → gom 2 summaries → plan → implement.

 Pattern B — Chain (task khó multi-file, cần duyệt từng nấc):
   explorer → planner → BẠN duyệt → Agent mode implement → tester → reviewer.

 Pattern C — Adversarial review (PR quan trọng chạm auth/payment):
   implementer viết code || reviewer fresh-chat (không biết implementer nghĩ gì)
   → không định kiến → bắt được lỗi implementer tự mù.
   Reviewer quá khắt → dặn "chỉ flag lỗi thực sự, đừng over-engineer".
```

> **Cách tính tiền hiện tại là AI Credits** (usage-based từ 01/06/2026): **1 credit = 0,01 USD**; chi phí 1 lượt = giá per-token của model × số token, quy đổi ra credits. Model mạnh (Claude Opus 5, GPT-5.2-Codex) tốn nhiều credits, model rẻ tốn ít — hồi premium requests có multiplier x1–x10, giờ multiplier biến mất nhưng model mạnh vẫn đắt hơn. **Code completion và next edit suggestions KHÔNG trừ AI Credits.**

```text
 Công thức nhẩm:
   cost_session ≈ số turns × mức credits của model; total ≈ N_sessions × cost_session.
   (Plan trả phí dùng auto model selection được giảm 10%.)

 Ví dụ 1 — 3 sessions song song (2 explorer model rẻ + 1 implement model mạnh):
   ≈ tương đương 1 session đọc 50 files trực tiếp, nhưng chat chính sạch → còn chỗ implement. Lời.
 Ví dụ 2 — task 1 bước "đọc file X": spawn = overhead + 1 turn; hỏi @workspace = 1 turn → ĐỪNG spawn.
 Ví dụ 3 — 5 coding agents overnight: ~100 đơn vị + 5 PR phải review sáng mai.
   Đáng khi deadline dí, không đáng ngày thường.
```

Check bill: `github.com/settings/copilot` → Usage → AI Credits theo ngày/user. Mỗi thứ 6 hỏi: "tuần rồi sessions nào đáng, sessions nào phí?"

> **Tóm gọn 1 câu:** Chọn pattern theo độ khó của task và luôn nhẩm cost trước — thứ 6 hàng tuần soi bill để bỏ session phí.

---

## 7. Pitfalls + hiểu nhầm

| Hiểu nhầm / pitfall | Sự thật / Fix |
|---|---|
| "Spawn agent luôn nhanh hơn" | Task <5 files spawn lỗ overhead. >10 files hoặc cần persona riêng mới spawn |
| "`@workspace` và custom agent là 1" | `@workspace` = hỏi nhanh tools mặc định; agent = khóa tools + persona + model |
| "Cho agent full tools cho mạnh" | Read-only agents phải khóa `edit` — dù dụ "sửa luôn" cũng không sửa được (guard) |
| "Chạy 5 sessions cho nhanh" | Trần 3 — quá là bill nổ + review không xuể + conflict branch |
| "`description` viết dài cho kỹ" | >500 ký tự → auto-trigger kém. 1–2 câu nhiều từ khóa, chi tiết dồn body |
| Tester chạy full suite 20 phút | Body tester: focused trước, full chỉ khi yêu cầu rõ |

> **Cách đọc bảng này:** Cột trái là điều bạn hay tưởng lầm, cột phải là sự thật và cách xử — đối chiếu trước khi gặp sự cố.

> **Tóm gọn 1 câu:** Đa số hiểu nhầm xoay quanh "nhiều = tốt": thực tế là khóa tools chặt, chạy ít session, mô tả ngắn gọn thì mới hiệu quả.

---

## Bài tập

Phần này là chỗ thực hành — đọc không làm thì kiến thức vẫn chỉ nằm trên giấy.

1. **(20 phút)** Cài 4 agents mục 4. Test explorer + tester lên repo thật — so sánh số turns vs hỏi trực tiếp.
2. **(20 phút)** Chạy pattern B cho 1 task multi-file: explorer → planner → duyệt → implement → tester.
3. **(15 phút)** Pattern C: implementer viết, reviewer fresh-chat review — đếm findings reviewer bắt được mà implementer miss. Rồi fan-out 2 explorers model rẻ, tra usage dashboard: theo công thức mục 6 có đáng không?

> **Tóm gọn 1 câu:** Cài 4 agents, chạy 3 patterns trên repo thật, rồi dùng số liệu cost tự kết luận có đáng hay không.

## Link qua

Phần này chỉ đường sang các bài liên quan — muốn đào sâu mảng nào thì theo link đó.

- Skill 1 bước vs custom agent multi-bước → bài 05. Instructions cho facts nền → bài 03.
- Khóa `tools` agent + MCP allowlist (defense in depth) → bài 07. Agents gọi MCP tools → bài 08.
- Mỗi session 1 worktree + branch `copilot/*` → bài 11. Coding agent assign + CI → bài 12.

> **Tóm gọn 1 câu:** Skill/instructions ở bài 03–05, khóa tools ở bài 07–08, chạy cloud ở bài 11–12 — bài này là điểm hẹn của tất cả.

**Chốt:** Chat chính đừng ôm hết — việc ồn giao cho agent hẹp đã khóa tools, gom về vài dòng summary. Việc <5 files hỏi trực tiếp; trần 3 session song song; thứ bạn không review nổi thì không tính là đã xong.
