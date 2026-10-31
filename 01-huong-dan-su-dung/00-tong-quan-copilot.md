# 00 — Tổng Quan Copilot: Từ Autocomplete Tới Agent

> **Dành cho:** người mới dùng GitHub Copilot, và dev đã quen autocomplete nhưng chưa thử agent.
> **Vấn đề:** một tài khoản có nhiều cách làm việc — cái nào dùng khi nào, vòng lặp agent chạy ra sao, tốn bao nhiêu AI Credits.
> **Đọc xong:** phân biệt được 5 chế độ + Copilot CLI, giải thích được vòng lặp agent trong 2 phút, ước lượng được AI Credits, làm xong task đầu tiên.
> **Thời gian:** ~25 phút đọc + ~30 phút làm walkthrough cuối bài.

## Mục tiêu bài học

- Phân biệt **5 chế độ** (Autocomplete, Ask, Edit, Agent, Coding agent) + **Copilot CLI**, biết chế độ nào hợp việc nào.
- Hiểu **vòng lặp agent 4 bước** và vì sao model không tự chạm vào máy bạn.
- Ước lượng được **AI Credits** và biết các hành động cắt phí lớn nhất.
- Làm xong **walkthrough 5 bước**: từ mở Chat tới 1 task agent chạy thật.

---

## 1. Copilot là gì? 5 chế độ + CLI

**Câu trả lời nhanh:** Copilot không phải 1 công cụ duy nhất mà là các "động cơ" chạy chung 1 tài khoản. Bạn chọn động cơ theo kích thước việc.

| Chế độ | Bạn làm gì | Nó làm gì | Ví dụ |
|---|---|---|---|
| **Autocomplete** | Gõ code bình thường | Gợi ý dòng tiếp theo, `Tab` nhận | Gõ `def fetch_user(` → hiện gợi ý thân hàm |
| **Chat (Ask)** | Hỏi trong ô Chat | Trả lời bằng chữ, không sửa file | "Giải thích hàm này cho tôi" |
| **Edit** | Chọn vài files + ra lệnh | Sửa đúng các file bạn chọn | "Thêm null check cho 3 chỗ này" |
| **Agent** | Giao task mở | Tự tìm file, sửa, chạy test, lặp tới khi xong | "Thêm rate-limit cho POST /login" |
| **Coding agent** (github.com) | Assign issue cho `copilot` | Code trên cloud, mở PR | Assign issue #123 → có PR `copilot/fix-123` |

> **Nhớ ngay:** autocomplete đoán **dòng tiếp theo**. Agent giải **cả việc**. Câu hỏi phân biệt: bạn có cần nó tự đi tìm file và chạy test không? Có → Agent.

**Vì sao quan trọng?** Đa số thất vọng với Copilot đến từ **chọn sai chế độ**, không phải model dở. Giao task mở cho Ask mode → chỉ nhận chữ, tưởng "Copilot không sửa được file". Ngược lại, dùng Agent cho việc sửa 1 dòng → nó đọc 20 file, đốt AI Credits vô ích.

**Copilot CLI** — đã **GA từ 03/2026** cho mọi subscriber trả phí: agentic workflows ngay trong terminal, đổi được nhiều model, tích hợp GitHub (repo/issue/PR). Khác với `gh copilot suggest/explain` (gh extension cũ, chỉ gợi ý/giải thích lệnh shell) — CLI GA là agent hoàn chỉnh. Chi tiết: [bài 02](./02-cac-be-mat-vscode-ide-web-cli.md).

### 1.1. Chọn chế độ nào? (cây hỏi 10 giây)

```text
Gõ code quen tay?                → Autocomplete
Chưa hiểu code, chỉ hỏi?         → Ask mode
Biết rõ file nào cần sửa?        → Edit mode
Task mở, nhiều file, cần test?   → Agent mode
Muốn chạy qua đêm, ra PR?        → Coding agent (cloud)
Đang ở terminal?                 → Copilot CLI / gh copilot suggest-explain
```

Prompt tệ = kết quả tệ: cùng 1 task, "TypeError này nghĩa là gì?" (Ask, không context) khác hẳn "Trong apps/api, POST /orders crash khi thiếu customerId. Tìm root cause, fix, thêm regression test, chạy npm test -- --filter api. Đừng sửa gì ngoài phạm vi." — câu sau có **nơi nào**, **làm gì**, **check bằng gì**, **ranh giới**.

### 1.3. Copilot vs Claude Code — khác nhau ở đâu?

| Việc | GitHub Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Chạy ở đâu | VS Code / JetBrains / Neovim / github.com / CLI | CLI trong terminal (và IDE extension) | Copilot phủ nhiều bề mặt hơn |
| Autocomplete | Có (điểm mạnh, miễn phí AI Credits) | Không phải trọng tâm | Copilot mạnh ở gõ code từng dòng |
| Chọn model | Đổi ngay trong Chat: GPT-5.2-Codex / Claude / Gemini | Gắn với model Anthropic | Copilot cho chọn "bộ não" |
| Cấu hình repo | `.github/copilot-instructions.md` + `AGENTS.md` | `CLAUDE.md` + `.claude/` | Cùng tư tưởng: file trong repo là "luật" |
| Agent mode | Ask/Edit/Agent + custom agents | Mặc định là agent | Claude Code agentic mặc định; Copilot leo thang từng bước |
| Slash command tự tạo | Prompt files / Skills | `.claude/commands/` | Tương đương về ý tưởng |
| MCP (tool ngoài) | Có (`.vscode/mcp.json`) | Có | Cùng chuẩn giao thức |
| Kiểm chứng | Bạn là người chạy test | Bạn là người chạy test | **Không agent nào tự chịu trách nhiệm đúng/sai** |

> Nếu quen Claude Code: khái niệm chuyển sang Copilot gần như 1-1 (instructions, agent loop, MCP, slash command) — chỉ khác *tên file* và *nơi chạy*. Copilot hơn ở **autocomplete + chọn model đa nhà cung cấp**; Claude Code mạnh ở **agentic mặc định + terminal-first**.

**Nếu nhầm thì sao?** Nghĩ "Copilot = autocomplete" (kiểu 2023) nên không thử Agent là mất nửa sức mạnh công cụ. 2026 Copilot còn có: Skills, MCP, custom agents, coding agent nhanh hơn 50% (changelog 19/03/2026), và **GPT-5.2-Codex GA từ 01/2026** trên VS Code, Chat trên github.com, GitHub Mobile, coding agent và CLI.

---

## 2. Vòng lặp agent — chuyện gì xảy ra bên trong

```text
BƯỚC 1 — NGHĨ:    model tự hỏi "cần đọc file nào, chạy lệnh gì để xác nhận?"
BƯỚC 2 — LÀM:     model gọi tool: read(auth.ts) + search("customerId") + terminal(npm test)
BƯỚC 3 — THẤY:    VS Code thực thi tool, trả kết quả: nội dung file / stdout / exit code
BƯỚC 4 — KIỂM TRA: chưa xong → quay lại BƯỚC 1. Xong → báo cáo + diff.
```

> **Điểm quan trọng nhất:** model không *chạm* disk. VS Code (harness) mới là cái mở file, chạy lệnh, đưa kết quả về model. Nôm na: model = kiến trúc sư vẽ bản vẽ, VS Code = đội thợ. Kiến trúc sư không tự ra công trường.

**Vì sao quan trọng?** Hiểu vòng lặp này là hiểu luôn: (a) policy chặn lệnh nằm ở VS Code chứ không ở model; (b) chat dài thì agent "quên đầu bài" (context đầy); (c) phải có lệnh verify — model chỉ *đọc kết quả*, không tự biết đúng/sai.

Ví dụ trace 1 task thật *"Thêm rate-limit cho POST /login"*: search `*login*` + grep → read 2 file → check `package.json` → hiện plan chờ duyệt → edit route + test → `npm test` FAIL (import sai) → fix → PASS → báo cáo diff. Tổng 7 turns, bạn chỉ gõ 1 prompt + bấm 1 lần duyệt.

### 2.2. Khi nào agent làm hỏng?

| Trạng thái | Dấu hiệu | Cách fix |
|---|---|---|
| Không tìm ra file đúng | Đọc lung tung, sửa sai chỗ | Viết instructions rõ + prompt files (bài 03, 05) |
| Báo "xong" nhưng test fail | Không chạy verify | Bắt agent chạy lệnh test *mỗi task* |
| Càng sửa càng nát (sau turn 15+) | Context đầy, quên đầu bài | Mở chat mới, chia nhỏ task |

> **Quy tắc vàng:** agent 15 turns không tiến triển → dừng, mở chat mới, chia task nhỏ hơn.

---

## 3. 4 họ tool Copilot

> Khi Agent mode "nghĩ", nó có 4 nhóm công cụ trong tay. Biết trước sẽ không ngạc nhiên khi thấy nó chạy lệnh gì.

**Nhóm 1 — Đọc & tìm (nhanh, rẻ, chạy local):** `read`/`#file`, `search`, `list`/`#folder`.
Mẹo tiết kiệm: luôn `search` trước, `read` sau. File >300 dòng → bảo agent đọc từng phần.

**Nhóm 2 — Sửa & chạy (có thể phá, cần review):** `edit` (sửa file, hiện diff — duyệt từng hunk trước khi Accept), `create` (tạo file mới — check path đúng folder), `terminal` (chạy shell — có confirm trước lệnh nguy hiểm).

**Nhóm 3 — Mở rộng context:** `@workspace` (hỏi cả repo), `@terminal` (output terminal vừa chạy), `@vscode` (API/settings VS Code), `#fetch` (đọc URL/docs ngoài).

**Nhóm 4 — MCP (công cụ ngoài, động):** MCP server là chương trình ngoài repo, phơi ra các "tools" để agent gọi khi cần dữ liệu ngoài. Nôm na: VS Code có sẵn quầy read/edit/terminal, ki-ốt MCP cho thêm GitHub, Postgres, Slack. Ví dụ: server `github` có tool `create_pr` → PR được tạo thật trên GitHub.

```json
// .vscode/mcp.json — mẫu tối thiểu (copy-paste, sửa path)
{
  "servers": {
    "github": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"] }
  }
}
```

> Quy tắc: giữ **3–6 servers**. Càng nhiều tool → model càng dễ chọn nhầm. Chi tiết: [bài 08](./08-mcp-ket-noi-cong-cu-ngoai.md).

---

## 4. AI Credits hoạt động thế nào

> **AI Credits là gì?** Đơn vị đo chi phí dùng Copilot từ khi GitHub chuyển sang **usage-based billing (01/06/2026)** — thay thế thuật ngữ cũ "premium requests" (giờ là legacy). 1 AI credit = 0,01 USD; chi phí = giá mỗi token của model × số token, quy đổi ra credits.

**4 điều cần biết:**

1. **1 AI Credit = 0,01 USD.** Model mạnh tốn nhiều credits hơn model rẻ.
2. **Autocomplete KHÔNG trừ AI Credits** — thoải mái dùng.
3. **Mỗi turn agent = 1+ lượt gọi model** — task càng dài càng đắt.
4. **Instructions nạp lại MỖI turn** — instructions 600 dòng × 20 turns = 12.000 dòng "học lại" mỗi task.

### 4.1. Giá các gói (10/2026 — luôn check lại tại `github.com/settings/copilot`)

| Gói | Giá | Credits kèm | Hợp với ai |
|---|---|---|---|
| Free | 0 USD | Giới hạn thấp | Thử lần đầu |
| Pro | 10 USD/tháng | 1.500 AI credits/tháng (base 1.000 + flex 500) | Cá nhân, code nhẹ |
| Pro+ | 39 USD/tháng | 7.000 AI credits/tháng (base 3.900 + flex 3.100) | Cá nhân code nặng |
| Max | 100 USD/tháng | 20.000 AI credits/tháng (base 10.000 + flex 10.000) | Dùng agent cả ngày |
| Business | 19 USD/seat | 1.900 AI credits/seat/tháng | Team cần quản trị |
| Enterprise | 39 USD/seat | 3.900 AI credits/seat/tháng (pooled) | Corp, compliance |

> Hết credits trong gói → chạy tiếp tính vào additional usage budget (admin có thể đặt spend cap). Plan trả phí được giảm 10% khi dùng auto model selection. Bài nào vẫn dạy "tiết kiệm premium requests" là bài cũ — thay bằng "AI Credits".

### 4.2. Ví dụ tính nhẩm

```text
Giả định:
- copilot-instructions.md = 150 dòng ≈ 2.500 tokens
- Task 10 turns → instructions nạp lại 10 lần = 25.000 tokens input

Nếu instructions phình lên 600 dòng (~10.000 tokens):
- 10 turns × 10.000 = 100.000 tokens → chênh lệch 75.000 tokens/task
- 20 tasks/tuần × 75.000 = 1,5 triệu tokens/tuần vứt qua cửa sổ

Kết luận: 1 giờ dọn instructions gọn (bài 03) tiết kiệm hơn 1 tuần tối ưu prompt.
Kiểm chứng: dashboard github.com/settings/copilot
```

### 4.3. Checklist tiết kiệm (dán vào wiki team)

- [ ] `copilot-instructions.md` < 200 dòng (`wc -l .github/copilot-instructions.md`)
- [ ] Checklist dài → tách sang prompt file / skill, không nhét vào instructions
- [ ] MCP ≤ 6 servers
- [ ] Task mới → chat mới (không nối vào history cũ)
- [ ] Model rẻ cho task dễ (giải thích), model mạnh cho task khó (refactor)
- [ ] Mọi task code phải có lệnh verify chạy thật

---

## 5. Bản đồ extension: 7 thứ hay bị nhầm

| Thứ | Là gì (nôm na) | Ví dụ | Dùng khi nào |
|---|---|---|---|
| **`copilot-instructions.md`** | Giấy dán đầu tủ lạnh — agent đọc *mọi* lần vào bếp | "Dùng pnpm. Test: `npm test -- --filter api`." | Quy ước mọi chat đều phải nhớ |
| **`*.instructions.md`** | Giấy dán riêng cho từng phòng | `applyTo: apps/api/**` → "Route không query DB trực tiếp" | Quy tắc chỉ đúng 1 thư mục |
| **Prompt files / Skills** | Công thức nấu ăn in sẵn, lôi ra khi cần | Gõ `/deploy` (prompt file) hoặc nói "deploy" → skill tự load | Việc lặp lại >3 lần |
| **Custom agents** | Thợ chuyên việc: thợ điện chỉ sửa điện | Agent `reviewer` chỉ đọc + comment, cấm sửa code | Task chuyên biệt, hẹp |
| **MCP** | Ki-ốt dịch vụ ngoài (DB, Slack, GitHub) | `mcp__github__create_pr` mở PR thật | Cần dữ liệu ngoài repo |
| **Extensions / Plugins** | Combo đóng gói (prompts + agents + MCP) để share | Extension `security-review` cho cả team | Share cho nhiều repo |
| **Copilot CLI / coding agent** | Agent ngoài IDE | CLI: agentic trong terminal; coding agent: assign issue → PR | Terminal workflow / việc qua đêm |

**Quy tắc chọn nhanh:**

- Mọi chat phải nhớ → `copilot-instructions.md` (bài 03)
- 1 thư mục cụ thể → `*.instructions.md` (bài 03)
- Workflow lặp lại, gọi khi cần → prompt file / skill (bài 05)
- Persona chuyên biệt → custom agent (bài 06)
- Hệ thống ngoài → MCP (bài 08)

> **Nếu nhầm thì sao?** Nhét mọi thứ vào `copilot-instructions.md` (cả checklist 15 bước) → nạp lại *mỗi turn*, tốn credits + loãng trọng tâm. Cái gì "chỉ đúng lúc cần" thì để prompt file/skill, đừng để trong instructions.

---

## 6. Walkthrough 5 bước cho người mới

> Yêu cầu: đã cài xong (chưa cài → [bài 01](./01-cai-dat-va-xac-thuc.md)). 30 phút đầu nên làm đúng thứ tự này.

**Bước 1 — Mở Chat trong repo thật (2 phút)**

```bash
code /path/to/repo-cua-ban
# Ctrl+Shift+P → "Chat: New Chat" (hoặc Ctrl+Alt+I) → chọn Agent mode
```

**Bước 2 — Kiểm tra Copilot đọc đúng repo (5 phút)**

```text
Gõ trong Chat:
"Đọc README + package.json, tóm tắt: project này là gì,
chạy dev bằng lệnh nào, test bằng lệnh nào. Không sửa gì, chỉ trả lời."
```

Nếu câu trả lời sai → Copilot chưa đọc đúng repo. Fix trước khi đi tiếp.

**Bước 3 — Viết instructions tối thiểu (5 phút)**

```markdown
<!-- .github/copilot-instructions.md — mẫu tối thiểu (copy-paste, sửa lại) -->
# Project: Acme API — Node 20 + Express + Postgres

## Commands (đã xác minh 2026-10)
- Dev: `npm run dev` (cần `.env` từ 1Password "Acme dev")
- Test: `npm test -- --filter api`
- Lint: `npm run lint`

## Rules
- ALWAYS chạy focused test sau khi sửa.
- NEVER commit trực tiếp main.
```

**Bước 4 — Giao task nhỏ có lệnh check (10 phút)**

```text
"Chạy linter của repo, fix 3 lỗi đầu tiên, chạy lại lint để xác nhận.
Chỉ sửa files liên quan, không động config."
```

Quan sát: nó đọc file → sửa → chạy lệnh → đọc output → sửa tiếp. Đây chính là vòng lặp ở mục 2.

**Bước 5 — Đóng session sạch (3 phút)**

```bash
# Xem usage: github.com/settings/copilot (số AI credits đã dùng)
# Mở chat mới cho task kế tiếp — không nối task mới vào history cũ (tốn + nhiễu)
```

---

## 7. Hiểu nhầm thường gặp + bài tập

### 7.1. Hiểu nhầm hay gặp nhất

| Hiểu nhầm | Sự thật |
|---|---|
| "Copilot là chatbot, hỏi gì đáp nấy" | Có 5 chế độ. Ask mode = chỉ chữ. Muốn sửa file → Edit/Agent |
| "Agent tự nghĩ tự làm, không cần kiểm tra" | Agent = junior dev nhanh nhưng ẩu. Bạn là reviewer bắt buộc |
| "MCP cài vào là xong" | MCP server chạy *ngoài* VS Code, có thể rớt mạng, sai key. Check `/mcp` mỗi lần |
| "Instructions càng dài càng khôn" | Nạp lại *mỗi turn*. Dài = tốn tiền + loãng trọng tâm. Giữ <200 dòng |
| "Model mạnh nhất luôn tốt nhất" | Mạnh = đắt. Giải thích code → model rẻ. Refactor khó → model mạnh |
| "premium requests" là thuật ngữ hiện tại | Legacy từ 01/06/2026 — giờ là **AI Credits** (usage-based) |

### 7.2. Ba pitfall ❌ SAI / ✅ ĐÚNG

```text
❌ SAI: (Ask mode) "Sửa bug login giúp tôi"      → chỉ trả lời chữ, không đụng file
✅ ĐÚNG: (Agent mode, có scope) "Trong src/auth, fix login email có dấu bị 500,
        chạy npm test -- auth, báo cáo diff."

❌ SAI: "Xong chưa?" → "Rồi nhé!" → bạn đi deploy
✅ ĐÚNG: "Chạy npm test -- auth rồi dán output cho tôi." → đọc log mới tin

❌ SAI: copilot-instructions.md 600 dòng, gồm cả checklist deploy 15 bước
✅ ĐÚNG: instructions <200 dòng; checklist deploy tách ra prompt file/skill
```

**Bài học chung:** chọn chế độ *trước* khi viết prompt; tính đúng do lệnh verify quyết định, không do lời nói; cái gì "chỉ đúng lúc cần" thì đừng để trong instructions.

### 7.3. Bài tập thực hành

1. **(15 phút) Trace 1 vòng lặp thật:** giao task nhỏ ở Agent mode, xong hỏi Copilot "liệt kê từng turn: bạn nghĩ gì, gọi tool gì, thấy kết quả gì". So với sơ đồ mục 2.
2. **(15 phút) Đo tiền đã đốt:** mở `github.com/settings/copilot`, xem AI Credits trước/sau 1 task dài. Model nào tốn nhất? Đề xuất 1 thay đổi cụ thể.
3. **(20 phút) Phân loại extension:** lấy 5 nhu cầu thật của team, điền bảng mục 5: thuộc `instructions` / `prompt file` / `custom agent` / `MCP` / `extension`? Giải thích 1 câu mỗi ô.
4. **(20 phút) Walkthrough chuẩn:** làm đủ 5 bước mục 6 trên 1 repo thật. Liệt kê 3 điều bạn *hiểu sai* trước khi đọc bài này.

---

## Đi tiếp tới đâu?

| Bạn muốn... | Đọc bài |
|---|---|
| Chưa cài / chưa rõ pricing | [01 — Cài đặt + xác thực](./01-cai-dat-va-xac-thuc.md) |
| Biết dùng ở đâu cho đúng | [02 — Các bề mặt](./02-cac-be-mat-vscode-ide-web-cli.md) |
| Viết instructions hiệu quả | [03 — Instructions + memory + rules](./03-instructions-memory-rules.md) |
| Đóng gói việc lặp lại thành workflow | [05 — Agent Skills & prompt files](./05-prompt-files-custom-instructions.md) |
| Nối DB / Slack / GitHub vào agent | [08 — MCP](./08-mcp-ket-noi-cong-cu-ngoai.md) |
| Hub Customizations 2026 | [17 — Agent Customizations Hub](./17-agent-customizations-hub.md) |

## Reference

- GitHub Copilot docs: https://docs.github.com/copilot
- VS Code Copilot docs: https://code.visualstudio.com/docs/copilot
- Billing / AI Credits: https://github.com/settings/copilot

> **Chốt cả bài:** Copilot không phải 1 công cụ mà là nhiều "động cơ" — chọn đúng động cơ cho đúng cỡ việc, giữ context sạch, và luôn bắt nó chạy lệnh verify. Làm đúng 3 điều đó là bạn đã ở top 10% người dùng Copilot.
