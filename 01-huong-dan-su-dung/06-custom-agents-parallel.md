# 06 — Custom Agents & Chạy Song Song (Parallel Copilot)

> **Dành cho:** dev đã xong bài 03–05, muốn tách việc research/review cho agent riêng và chạy nhiều việc cùng lúc.
> **Vấn đề:** chat chính ôm hết research + code + test → context đầy nhanh, kết quả lẫn lộn, không chạy nổi 2 việc cùng lúc.
> **Đọc xong:** viết được file `.agent.md` đúng docs (khóa `tools`, chọn `model`), hiểu subagent, chạy song song 3 sessions không giẫm chân nhau. **Thời gian:** ~35 phút.
>
> **Lưu ý 2026:** bài dạy cho **Copilot harness** (mặc định của khoá). `@workspace` là chat participant **đã deprecated, không chạy ở Copilot harness** — nhiều người vẫn hỏi vì bản cũ từng dạy vậy; nay agent **tự gather workspace context** bằng tools `search`/`read`, không cần `@` mention ([lệnh liên quan](commands/local/model-agent/participants/README.md)).

## Mục tiêu bài học

Mục này cho biết hết bài bạn làm được gì — đọc xong biết ngay có đáng đầu tư 35 phút hay không.

- Viết được **1 custom agent** `.github/agents/<TEN>.agent.md` đúng format docs, đọc bảng frontmatter là biết field nào thuộc harness nào.
- Hiểu **subagent**: việc đọc 50 files chạy ở context riêng, chat chính chỉ nhận kết quả gọn — và tên tool delegation khác nhau giữa hai harness.
- Chạy **song song ≤3 sessions** theo 3 pattern (parallel / chain / adversarial) mà vẫn review nổi.

> **Tóm gọn 1 câu:** Hết bài bạn có "nhân viên ảo" chuyên trách — persona riêng, tools khóa chặt, trả báo cáo gọn — và biết điều phối 3 việc cùng lúc.

---

## 1. Vì sao cần custom agent?

**Định nghĩa 1 câu:** Custom agent là hồ sơ "nhân viên" của Copilot: instructions riêng (body markdown) + danh sách tools khóa trong frontmatter + model riêng — chọn từ **Agent dropdown** trong session, hoặc để agent khác gọi làm **subagent** chạy ở context riêng rồi trả về kết quả gọn.

```text
KHÔNG agent: "auth flow thế nào?" → chat chính tự đọc 50 files → context đầy → câu hỏi sau quá tải.
CÓ agent:    "dùng Explorer khảo sát auth flow, trả summary ≤15 dòng" → Explorer đọc 50 files
             ở context riêng → chat chính còn chỗ trống để implement.
```

**Lợi ích:** giữ context sạch (50 files vào, 15 dòng ra); enforce chuẩn team (reviewer luôn check đúng danh mục); tái dùng cross-repo (commit `.github/agents/`, teammate clone là dùng); việc dễ route sang model rẻ.
**Giá phải trả:** mỗi lượt delegation thêm overhead (nạp instructions + tool definitions) — task 1 bước mà spawn là lỗ.

> **Vì sao quan trọng?** Đây là đơn vị duy nhất khóa được *ai được dùng tool gì*: "agent chỉ đọc" không phải lời hứa, mà là allowlist `tools` mà model không vượt được.
> **Nếu làm sai?** Spawn cho task 1 file → overhead ăn hết phần lời. "Cho full tools cho mạnh" → agent read-only sửa lung tung ngoài scope.
> **Tóm gọn 1 câu:** Việc đọc nhiều files thì thuê agent riêng để chat chính sạch; việc lẻ tẻ thì hỏi thẳng, đừng thuê.

## 2. Chọn công cụ trong 30 giây

| Bạn muốn | Dùng gì |
|---|---|
| Hỏi nhanh về vài files | Hỏi thẳng agent — nó **tự gather workspace context** (tools `search`/`read`), không cần `@` mention |
| Quy trình lặp nhiều bước cho MỘT việc | Agent Skill (bài 05) |
| Persona + tools khóa + model riêng, dùng lặp lại | **Custom agent — bài này** |
| Task độc lập ~30 phút, không cần trông | Copilot cloud agent (bài 12) |

Cú pháp nhanh: [custom-agent](commands/copilot/model-agent/custom-agent/README.md).

> **Tóm gọn 1 câu:** Hỏi nhanh → chat thẳng; quy trình → skill; "con người chuyên trách" → custom agent.

## 3. Giải phẫu file `.agent.md`

**Vị trí file:**

```text
.github/agents/<TEN>.agent.md     # repo-level, commit cho team (KHUYEN DUNG); nhan ca duoi .md
~/.copilot/agents/<TEN>.agent.md  # user-level, moi repo. Agent user cua Local nam trong VS Code
                                  # profile storage -> muon chay o harness khac: chuyen ra day
```

**Tạo agent (Copilot harness):** chạy **`Chat: Open Customizations`** (⇧⌘P) → tab **Agents** → **New Agent (+)** cạnh **Workspace** hoặc **User**. Cách nhanh nhất: chọn harness ở **Session Target** rồi ra lệnh — *"Create a custom agent named explorer for read-only codebase research"* — hoặc chạy **`Chat: New Custom Agent`**. Docs không liệt kê slash `/create-agent` cho harness này: đừng dạy lệnh đó như cách chuẩn.

**Frontmatter — các field có trong docs:**

| Field | Ý nghĩa | Harness |
|---|---|---|
| `name` | Tên trong Agent dropdown; mặc định = tên file | chung |
| `description` | Agent làm gì, khi nào dùng — **Copilot schema bắt buộc** | chung |
| `tools` | Allowlist. Alias Copilot: `execute` `read` `edit` `search` `agent` `web` `todo`; `*` = hết; tool mở rộng `<server>/*` | chung |
| `model` | ID model lấy từ **picker**; mảng = danh sách ưu tiên (dùng model khả dụng đầu); bỏ trống = theo model session | chung |
| `model-policy` · `reasoning-effort` | `preferred`/`required` · mức suy nghĩ theo khả năng model | Copilot |
| `skills` | Nạp skill (bài 05) vào context agent | Copilot |
| `agents` | Whitelist subagent được gọi: `['A','B']`, `['*']` = hết, `[]` = cấm — kèm `agent` trong `tools` | Local |
| `user-invocable` · `disable-model-invocation` | `false` = ẩn khỏi dropdown (subagent-only) · `true` = không cho agent khác gọi làm subagent | chung |
| `target` | `vscode` \| `github-copilot`: schema để **editor** đọc file — KHÔNG đổi harness chạy session; editor gạch field lạ nhưng validate ổn ≠ runtime hỗ trợ | chung |
| `hooks` | Hooks scoped cho riêng agent (bài 07) | chung |
| `mcp-servers` | Server MCP gắn riêng agent (bài 08) | Copilot |
| `deferred-tool-loading` · `strict-tools-list` · `include-custom-instructions` | nạp tool theo yêu cầu · bỏ tool chuẩn không khai tường minh · có nạp instructions repo — ít dùng, xem file reference | Copilot |
| `handoffs` | Nút chuyển việc sang agent kế tiếp — **chỉ Local**; Copilot không nhận | Local |
| `infer` | **Deprecated** — thay bằng `user-invocable` + `disable-model-invocation` | Local |

**Body** là instructions: docs khuyến nghị role hẹp + output cụ thể ("report findings with file and line") thay vì persona chung chung. Ở Copilot harness, body được **nối sau custom instructions và thắng khi mâu thuẫn**. Lưu ý nguyên văn của docs: dòng "do not edit" trong body **không phải permission boundary** — thứ chặn thật sự là `tools`.

**Verify sau khi lưu:** file hiện trong tab Agents của Customizations editor, không lỗi frontmatter → mở session **đúng harness** → chọn agent ở **Agent dropdown** (không phải gõ `@`) → giao việc nhỏ, soi tool activity: agent read-only phải KHÔNG sửa được file.

> **Tóm gọn 1 câu:** Frontmatter nói agent *được phép gì*, body nói nó *làm thế nào* — thiếu một trong hai là recruit người không có hợp đồng.

## 4. Mẫu đầy đủ: `explorer` — trinh sát chỉ nhìn

> Lưu vào `.github/agents/explorer.agent.md`, commit, rồi verify như mục 3. Body viết như viết skill (bài 05): steps đánh số, output bắt buộc, cấm rõ.

```markdown
---
name: Explorer
description: Read-only khao sat codebase, tra summary gon. Dung khi can tim files
  lien quan, hieu module, map dependencies truoc khi sua.
tools: ['read', 'search']
---
Bạn là Explorer. Chỉ đọc, KHÔNG sửa.

Quy trình:
1. search tên file/symbol → read phần liên quan (không đọc cả file 1000 dòng).
2. Ghi lại mỗi file 1 dòng: path + vai trò + có cần sửa không.

Output (bắt buộc, tối đa 30 dòng):
- Files sẽ sửa: path + 1 câu vì sao
- Files chỉ đọc tham khảo: path + 1 câu
- Rủi ro: chỗ nào dễ vỡ nếu sửa

Cấm: lan man lịch sử, paste cả file vào report, đề xuất refactor ngoài scope.
```

```text
# Goi mau: "dung Explorer khao sat cac file lien quan toi POST /login va rate-limit"
# Verify: summary <=30 dong; git status sach — khong mot dong code bi thay doi.
```

Ba mẫu còn lại nằm trong `examples/`; ở đây chỉ cần khung:

- **Planner** — [`examples/06-2-agent-planner.agent.md`](examples/06-2-agent-planner.agent.md): `tools: ['read', 'search']`; đọc code → viết `plans/<date>-<task>.md` theo khung Goals / Non-goals / Files / Steps+verify / Risks; output = path + 10 dòng; **không tự implement**.
- **Security reviewer** — [`examples/06-2-agent-security-reviewer.agent.md`](examples/06-2-agent-security-reviewer.agent.md): `tools: ['read', 'search', 'execute']`; `git diff` → soi injection / authZ / secrets / crypto yếu / SSRF; output ≤10 findings `[CRITICAL|HIGH|MED|LOW] file:line — fix`; không sửa hộ.
- **Tester** — [`examples/06-2-agent-tester.agent.md`](examples/06-2-agent-tester.agent.md): `tools: ['execute', 'read']`; lấy lệnh test từ instructions; focused trước, full suite chỉ khi được xin; output `PASS (n/n)` / `FAIL (x/y)` + 1 dòng root-cause guess.

> **Tóm gọn 1 câu:** Một mẫu hoàn chỉnh để bắt chước, ba khung để mở rộng — tất cả đều khóa `tools` đúng việc, không ai "cho mạnh" bằng full tools.

## 5. Subagents: giao việc nặng, giữ chat chính sạch

```text
Subagent = agent chạy trong context riêng, trả về kết quả gọn cho agent chính
(nguồn: code.visualstudio.com/docs/agents/run/subagents):
- Copilot harness delegate bằng tool native `task`; Local dùng `agent/runSubagent` —
  migrate coordinator phải sửa cả ten tool trong instructions, args không giống nhau.
- Giao tay: "dùng subagent khảo sát X, không đổi file, trả file liên quan + recommendation".
- Agent chỉ làm subagent: `user-invocable: false`; Local siết danh sách gọi bằng `agents: [...]`.
- Subagent KHÔNG kế history chat chính → lệnh giao phải tự chứa: goal, context, actions được phép, kết quả mong.
```

> **Nếu làm sai?** Giao việc mở ("sửa chỗ nào thấy ổn") → subagent dùng tool ngoài phạm vi và bạn không biết nó đã làm gì. Luôn kèm "không đổi file" + output format, rồi xem subagent chat (Agents window hiện nó dạng read-only trong session).

## 6. Chạy song song + orchestration patterns

Ba cửa chạy nhiều việc cùng lúc: **multi-chat** — mỗi chat một việc, không paste output chat này sang chat kia; **session chạy nền** — Copilot harness session chạy tiếp khi bạn làm việc khác, theo dõi ở Agents window; **cloud** — giao issue cho Copilot cloud agent, sáng review PR (bài 12). Trần thực hành: **≤3 sessions concurrent** — quá số đó bạn không review nổi.

```text
Pattern A — Parallel research (chưa hiểu codebase): 2 explorer đi riêng (auth | DB)
  → gom 2 summaries vào chat chính → plan → implement.
Pattern B — Chain (task khó multi-file): explorer → planner → BẠN duyệt → implement
  → tester → reviewer.
Pattern C — Adversarial review (PR chạm auth/payment): implementer viết code ||
  reviewer ở chat tươi, không biết implementer nghĩ gì → hết định kiến → bắt lỗi tác giả mù.
  Reviewer quá khắt → dặn "chỉ flag lỗi thực sự".
```

> 📄 **Code ví dụ:** [`examples/03-5-chay-song-song-3-cach.sh`](examples/03-5-chay-song-song-3-cach.sh) — mỗi session một worktree/branch riêng (bài 11).

Muốn nhẩm cost trước khi fan-out? AI Credits tính per-token theo model — bảng giá + công thức là việc của bài 00/14, ở đây chỉ cần nhớ: **model rẻ cho việc đọc, model mạnh cho việc quyết**.

> **Tóm gọn 1 câu:** Chọn pattern theo độ khó của task; ≤3 sessions vì bottleneck cuối cùng luôn là tốc độ review của bạn.

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| `tools: ['read', 'grep']` | `grep` không phải alias docs — tool mất, agent tự xoay | dùng alias chuẩn: `execute` `read` `edit` `search` `agent` `web` `todo` |
| Tin dòng "không được sửa file" trong body là ranh giới an toàn | model vẫn thử, instruction không phải permission boundary | chặn bằng allowlist `tools`, body chỉ hướng dẫn |
| Khai `handoffs:` cho agent chạy Copilot | Copilot schema không nhận field này (Local only) | chuỗi việc bằng subagent (mục 5), `handoffs` chỉ dùng ở Local |
| `model: claude-sonnet-5` hard-code | ID model đổi theo quý → agent âm thầm không chạy được | ID lấy từ **picker**, hoặc mảng ưu tiên, hoặc bỏ trống; `infer` deprecated → dùng 2 field invocation |
| `description` dài 500 ký tự "cho kỹ" | auto-trigger kém, người đọc chán | 1–2 câu: làm gì + khi nào dùng, chi tiết dồn body |

**Bài học:** mọi field lạ với harness đều fail *âm thầm* — editor gạch được thì sửa, editor không báo mà agent không hiện lên dropdown là bạn tự phải soi Customizations editor.

## Best practices

- **Một agent = một vai, tools tối thiểu.** *Vì sao?* Instructions càng hẹp model càng ít lang thang; allowlist nhỏ là guard thật sự duy nhất (docs: instruction "do not edit" không chặn được).
- **Commit agent vào `.github/agents/`, đừng chỉ để `~/.copilot/agents/`.** *Vì sao?* User agent chỉ mình bạn thấy — chuẩn team chết khi bạn nghỉ.
- **Đổi `target` khi cần edit đúng schema, không nhầm với chỗ chạy.** *Vì sao?* `target` chỉ quyết định editor validate file theo schema nào; harness chạy session do **Session Target** quyết định.
- **Test bằng "câu dụ" trước khi tin agent read-only.** *Vì sao?* Đây là cách nhanh nhất chứng minh allowlist có hiệu lực thật, không chỉ nằm trên frontmatter.

## Bài tập

1. **(15 phút)** Tạo `explorer.agent.md` (mục 4) qua Customizations editor; verify 3 bước ở cuối mục 3, gồm cả câu dụ "sửa luôn giúp anh".
2. **(10 phút)** Cài 3 agent trong `examples/` vào `.github/agents/`, chạy Pattern B trên một task multi-file thật.
3. **(10 phút)** Giao một task cho subagent với 2 lệnh: một "mở", một tự chứa (goal/context/actions/output) — so sánh kết quả nhận về và số dòng bạn phải đọc.

## Link qua

- Skill 1 bước vs agent đa bước: bài 05 · Fact nền: bài 03 · Hooks trong frontmatter agent: bài 07 · Agent gọi MCP tools + `mcp-servers`: bài 08 · Permission levels: bài 10.
- Worktree/branch mỗi session: bài 11 · Copilot cloud agent (hàng 4 mục 2): bài 12 · Agent Plugins phân phối nguyên bộ: bài 17 · `.claude/agents/` song song Claude Code: bài 02.
- Tra cứu nhanh file agent: [commands/copilot/model-agent/custom-agent](commands/copilot/model-agent/custom-agent/README.md).

## Reference

- VS Code — [Custom agents](https://code.visualstudio.com/docs/agent-customization/custom-agents) · [Custom agent file reference](https://code.visualstudio.com/docs/agents/reference/custom-agent-file-reference) (frontmatter, harness compatibility) · [Subagents](https://code.visualstudio.com/docs/agents/run/subagents)
- GitHub — [About custom agents (Copilot CLI)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-custom-agents) · [Custom agents configuration (cloud agent)](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- Cộng đồng — [Awesome Copilot agents](https://github.com/github/awesome-copilot/blob/main/docs/README.agents.md)

**Chốt:** Custom agent đáng tạo khi một vai trò lặp lại cần đúng ba thứ: instructions riêng, tools khóa chặt, model chọn tay. Còn lại — hỏi thẳng, hoặc spawn subagent đúng lúc — chat chính sạch là win, không phải có nhiều agent trong dropdown.
