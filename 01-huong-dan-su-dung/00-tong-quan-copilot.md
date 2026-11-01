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

> **Tóm gọn 1 câu:** Bài này cho bạn bản đồ Copilot — 5 chế độ, vòng lặp agent, AI Credits — để chọn đúng "động cơ" cho đúng việc.

---

## 1. Copilot là gì? 5 chế độ + CLI

Mục này trả lời câu hỏi đầu tiên bạn cần: Copilot là cái gì, và có bao nhiêu cách dùng nó. Hiểu được cái này là tránh được 80% thất vọng.

**Câu trả lời nhanh:** Copilot không phải 1 công cụ duy nhất mà là các "động cơ" chạy chung 1 tài khoản. Hãy hình dung như hộp dụng cụ nhà bếp: dao gọt trái cây không dùng để chặt xương, và máy xay sinh tố không pha được cà phê. Bạn chọn động cơ theo kích thước việc.

| Chế độ | Bạn làm gì | Nó làm gì | Ví dụ |
|---|---|---|---|
| **Autocomplete** | Gõ code bình thường | Gợi ý dòng tiếp theo, `Tab` nhận | Gõ `def fetch_user(` → hiện gợi ý thân hàm |
| **Chat (Ask)** | Hỏi trong ô Chat | Trả lời bằng chữ, không sửa file | "Giải thích hàm này cho tôi" |
| **Edit** | Chọn vài files + ra lệnh | Sửa đúng các file bạn chọn | "Thêm null check cho 3 chỗ này" |
| **Agent** | Giao task mở | Tự tìm file, sửa, chạy test, lặp tới khi xong | "Thêm rate-limit cho POST /login" |
| **Coding agent** (github.com) | Assign issue cho `copilot` | Code trên cloud, mở PR | Assign issue #123 → có PR `copilot/fix-123` |

> **Cách đọc bảng này:** đọc theo cột dọc từ trên xuống — bạn ra tay ít dần, máy tự lo nhiều dần. Muốn biết chọn chế độ nào, tự hỏi: "tôi phải làm bao nhiêu?" — trả lời càng ngắn, càng nên dùng chế độ dưới bảng.

> **Nhớ ngay:** autocomplete đoán **dòng tiếp theo**. Agent giải **cả việc**. Câu hỏi phân biệt: bạn có cần nó tự đi tìm file và chạy test không? Có → Agent.

**Vì sao quan trọng?** Đa số thất vọng với Copilot đến từ **chọn sai chế độ**, không phải model dở. Giao task mở cho Ask mode → chỉ nhận chữ, tưởng "Copilot không sửa được file". Ngược lại, dùng Agent cho việc sửa 1 dòng → nó đọc 20 file, đốt AI Credits vô ích. Giống như thuê cả đội thợ xây để đóng 1 cái đinh — xong việc, nhưng tốn tiền oan.

**Copilot CLI** — đã **GA từ 03/2026** cho mọi subscriber trả phí: agentic workflows ngay trong terminal, đổi được nhiều model, tích hợp GitHub (repo/issue/PR). Khác với `gh copilot suggest/explain` (gh extension cũ, chỉ gợi ý/giải thích lệnh shell) — CLI GA là agent hoàn chỉnh. Nôm na: bản cũ là người bạn chỉ *chỉ đường*, bản GA là người *cầm lái luôn tay*. Chi tiết: [bài 02](./02-cac-be-mat-vscode-ide-web-cli.md).

### 1.1. Chọn chế độ nào? (cây hỏi 10 giây)

Mục này là "tấm thẻ tra nhanh": trả lời 1 câu là biết nên dùng chế độ nào, khỏi cần đọc lý thuyết.

```text
Gõ code quen tay?                → Autocomplete
Chưa hiểu code, chỉ hỏi?         → Ask mode
Biết rõ file nào cần sửa?        → Edit mode
Task mở, nhiều file, cần test?   → Agent mode
Muốn chạy qua đêm, ra PR?        → Coding agent (cloud)
Đang ở terminal?                 → Copilot CLI / gh copilot suggest-explain
```

Prompt tệ = kết quả tệ: cùng 1 task, "TypeError này nghĩa là gì?" (Ask, không context) khác hẳn "Trong apps/api, POST /orders crash khi thiếu customerId. Tìm root cause, fix, thêm regression test, chạy npm test -- --filter api. Đừng sửa gì ngoài phạm vi." — câu sau có **nơi nào**, **làm gì**, **check bằng gì**, **ranh giới**. Khác như giao việc cho thợ: "sửa ống nước" thì thợ phải đoán, còn "ống bếp rò bên dưới chậu, thay gioăng, xong thử xả nước cho tôi xem" thì không còn chỗ nào để hiểu sai.

> **Tóm gọn 1 câu:** Chọn chế độ theo kích thước việc — gõ code, hỏi, sửa vài file, giao cả task, hay chạy cloud — và viết prompt có nơi, việc, cách kiểm tra.

### 1.3. Copilot vs Claude Code — khác nhau ở đâu?

Mục này dành cho ai đã (hoặc định) dùng cả hai công cụ. Đọc để biết chúng khác nhau ở đâu, khỏi mất công soán nhầm.

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

> **Cách đọc bảng này:** đọc theo từng hàng là một việc cụ thể; so 2 cột giữa để thấy mỗi công cụ xử lý việc đó ra sao; cột phải là điểm cần nhớ nhất.

> Nếu quen Claude Code: khái niệm chuyển sang Copilot gần như 1-1 (instructions, agent loop, MCP, slash command) — chỉ khác *tên file* và *nơi chạy*. Copilot hơn ở **autocomplete + chọn model đa nhà cung cấp**; Claude Code mạnh ở **agentic mặc định + terminal-first**.

**Nếu nhầm thì sao?** Nghĩ "Copilot = autocomplete" (kiểu 2023) nên không thử Agent là mất nửa sức mạnh công cụ. 2026 Copilot còn có: Skills, MCP, custom agents, coding agent nhanh hơn 50% (changelog 19/03/2026), và **GPT-5.2-Codex GA từ 01/2026** trên VS Code, Chat trên github.com, GitHub Mobile, coding agent và CLI.

> **Tóm gọn 1 câu:** Copilot gồm nhiều động cơ dùng chung 1 tài khoản — chọn sai chế độ là nguyên nhân thất vọng số một.

---

## 2. Vòng lặp agent — chuyện gì xảy ra bên trong

Mục này mở nắp ca-pô cho bạn xem agent chạy thế nào. Hiểu được nó, bạn sẽ biết vì sao agent đôi khi "ngu", và cách nuôi nó cho khôn.

```text
BƯỚC 1 — NGHĨ:    model tự hỏi "cần đọc file nào, chạy lệnh gì để xác nhận?"
BƯỚC 2 — LÀM:     model gọi tool: read(auth.ts) + search("customerId") + terminal(npm test)
BƯỚC 3 — THẤY:    VS Code thực thi tool, trả kết quả: nội dung file / stdout / exit code
BƯỚC 4 — KIỂM TRA: chưa xong → quay lại BƯỚC 1. Xong → báo cáo + diff.
```

> **Điểm quan trọng nhất:** model không *chạm* disk. VS Code (harness) mới là cái mở file, chạy lệnh, đưa kết quả về model. Nôm na: model = kiến trúc sư vẽ bản vẽ, VS Code = đội thợ. Kiến trúc sư không tự ra công trường.

**Vì sao quan trọng?** Hiểu vòng lặp này là hiểu luôn: (a) policy chặn lệnh nằm ở VS Code chứ không ở model; (b) chat dài thì agent "quên đầu bài" (context đầy); (c) phải có lệnh verify — model chỉ *đọc kết quả*, không tự biết đúng/sai. Như người dịch điện thoại: chỉ đọc được nội dung bạn bấm vào, nó không thể biết bên đầu dây thực ra đang làm gì.

Ví dụ trace 1 task thật *"Thêm rate-limit cho POST /login"*: search `*login*` + grep → read 2 file → check `package.json` → hiện plan chờ duyệt → edit route + test → `npm test` FAIL (import sai) → fix → PASS → báo cáo diff. Tổng 7 turns, bạn chỉ gõ 1 prompt + bấm 1 lần duyệt.

### 2.2. Khi nào agent làm hỏng?

Mục này liệt kê những lúc agent "đổ với", để bạn nhận ra sớm và đỡ tốn credits. Biết dấu hiệu là biết đường tắt.

| Trạng thái | Dấu hiệu | Cách fix |
|---|---|---|
| Không tìm ra file đúng | Đọc lung tung, sửa sai chỗ | Viết instructions rõ + prompt files (bài 03, 05) |
| Báo "xong" nhưng test fail | Không chạy verify | Bắt agent chạy lệnh test *mỗi task* |
| Càng sửa càng nát (sau turn 15+) | Context đầy, quên đầu bài | Mở chat mới, chia nhỏ task |

> **Cách đọc bảng này:** cột giữa là điều bạn *thấy* trên màn hình — gặp đúng dấu hiệu đó thì kéo sang cột phải lấy cách xử lý ngay.

> **Quy tắc vàng:** agent 15 turns không tiến triển → dừng, mở chat mới, chia task nhỏ hơn.

> **Tóm gọn 1 câu:** Agent chỉ là vòng lặp "nghĩ → làm → thấy kết quả" do VS Code chạy hộ — hiểu nó là biết phải chia task nhỏ và bắt chạy verify.

---

## 3. 4 họ tool Copilot

Trước khi giao việc, bạn nên biết agent cầm trong tay những công cụ gì. Biết trước là không giật mình khi nó tự chạy lệnh — và biết tool nào đáng tin.

> Khi Agent mode "nghĩ", nó có 4 nhóm công cụ trong tay. Biết trước sẽ không ngạc nhiên khi thấy nó chạy lệnh gì.

**Nhóm 1 — Đọc & tìm (nhanh, rẻ, chạy local):** `read`/`#file`, `search`, `list`/`#folder`.
Mẹo tiết kiệm: luôn `search` trước, `read` sau. File >300 dòng → bảo agent đọc từng phần. Giống mở tủ lạnh: ngó qua trước, lấy đúng ngăn cần, đừng dọn cả tủ ra bàn.

**Nhóm 2 — Sửa & chạy (có thể phá, cần review):** `edit` (sửa file, hiện diff — duyệt từng hunk trước khi Accept), `create` (tạo file mới — check path đúng folder), `terminal` (chạy shell — có confirm trước lệnh nguy hiểm). Đây là nhóm "dao sắc" — hữu dụng nhất nhưng cũng nguy hiểm nhất, nên luôn soi diff trước khi gật đầu.

**Nhóm 3 — Mở rộng context:** `@workspace` (hỏi cả repo), `@terminal` (output terminal vừa chạy), `@vscode` (API/settings VS Code), `#fetch` (đọc URL/docs ngoài). Nôm na là mấy "tai" để agent nghe thêm thông tin từ xa.

**Nhóm 4 — MCP (công cụ ngoài, động):** MCP server là chương trình ngoài repo, phơi ra các "tools" để agent gọi khi cần dữ liệu ngoài. Nôm na: VS Code có sẵn quầy read/edit/terminal, ki-ốt MCP cho thêm GitHub, Postgres, Slack. Ví dụ: server `github` có tool `create_pr` → PR được tạo thật trên GitHub.

> 📄 **Code ví dụ:** [`examples/01-3-4-ho-tool-copilot.json`](examples/01-3-4-ho-tool-copilot.json)

> Quy tắc: giữ **3–6 servers**. Càng nhiều tool → model càng dễ chọn nhầm. Chi tiết: [bài 08](./08-mcp-ket-noi-cong-cu-ngoai.md).

> **Tóm gọn 1 câu:** Agent làm việc bằng 4 họ tool — đọc, sửa/chạy, mở rộng context, MCP — trong đó nhóm sửa/chạy và MCP cần bạn rà soát kỹ nhất.

---

## 4. AI Credits hoạt động thế nào

Mục này trả lời câu hỏi ai cũng thắc mắc: dùng Copilot tốn tiền kiểu gì, và sao tiền bay nhanh vậy. Đọc xong bạn biết đốt tiền chỗ nào để mà tiết kiệm.

> **AI Credits là gì?** Đơn vị đo chi phí dùng Copilot từ khi GitHub chuyển sang **usage-based billing (01/06/2026)** — thay thế thuật ngữ cũ "premium requests" (giờ là legacy). 1 AI credit = 0,01 USD; chi phí = giá mỗi token của model × số token, quy đổi ra credits. Tưởng như nước sinh hoạt: mỗi lít dùng bao nhiêu trả bấy nhiêu, chứ không phải đóng gói trọn gói năm.

**4 điều cần biết:**

1. **1 AI Credit = 0,01 USD.** Model mạnh tốn nhiều credits hơn model rẻ.
2. **Autocomplete KHÔNG trừ AI Credits** — thoải mái dùng.
3. **Mỗi turn agent = 1+ lượt gọi model** — task càng dài càng đắt.
4. **Instructions nạp lại MỖI turn** — instructions 600 dòng × 20 turns = 12.000 dòng "học lại" mỗi task.

### 4.1. Giá các gói (10/2026 — luôn check lại tại `github.com/settings/copilot`)

Mục này giúp bạn so giá nhanh. Đừng học thuộc — bảng này đổi theo thời gian, nên luôn mở link settings để kiểm chứng.

| Gói | Giá | Credits kèm | Hợp với ai |
|---|---|---|---|
| Free | 0 USD | Giới hạn thấp | Thử lần đầu |
| Pro | 10 USD/tháng | 1.500 AI credits/tháng (base 1.000 + flex 500) | Cá nhân, code nhẹ |
| Pro+ | 39 USD/tháng | 7.000 AI credits/tháng (base 3.900 + flex 3.100) | Cá nhân code nặng |
| Max | 100 USD/tháng | 20.000 AI credits/tháng (base 10.000 + flex 10.000) | Dùng agent cả ngày |
| Business | 19 USD/seat | 1.900 AI credits/seat/tháng | Team cần quản trị |
| Enterprise | 39 USD/seat | 3.900 AI credits/seat/tháng (pooled) | Corp, compliance |

> **Cách đọc bảng này:** cột "Credits kèm" là ngân hàng tháng của bạn — cột "base" là tiền chắc, "flex" là tiền dự phòng có thể giới hạn. So cột "Hợp với ai" với việc của bạn để chọn gói.

> Hết credits trong gói → chạy tiếp tính vào additional usage budget (admin có thể đặt spend cap). Plan trả phí được giảm 10% khi dùng auto model selection. Bài nào vẫn dạy "tiết kiệm premium requests" là bài cũ — thay bằng "AI Credits".

> **Tóm gọn 1 câu:** Chọn gói theo cột "Hợp với ai" — hết credits vẫn chạy tiếp nhưng tính vào budget thêm, nên định kỳ mở dashboard để biết mình đang đốt bao nhiêu.

### 4.2. Ví dụ tính nhẩm

Mục này chứng minh bằng số: instructions dài làm tốn tiền thế nào. Ngắn thôi, nhưng đáng đọc một lượt để "sợ" đúng chỗ.

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

> **Tóm gọn 1 câu:** Instructions phình gấp 4 lần là tiền đi đường tăng gấp 4 mỗi turn — một giờ dọn gọn đáng giá hơn cả tuần tối ưu prompt.

### 4.3. Checklist tiết kiệm (dán vào wiki team)

Mục này là "tấm to-do" mang đi dùng ngay. Tick đủ là tiền của bạn đỡ chảy máu mà không mất công sức gì.

- [ ] `copilot-instructions.md` < 200 dòng (`wc -l .github/copilot-instructions.md`)
- [ ] Checklist dài → tách sang prompt file / skill, không nhét vào instructions
- [ ] MCP ≤ 6 servers
- [ ] Task mới → chat mới (không nối vào history cũ)
- [ ] Model rẻ cho task dễ (giải thích), model mạnh cho task khó (refactor)
- [ ] Mọi task code phải có lệnh verify chạy thật

> **Tóm gọn 1 câu:** AI Credits tính theo token nạp mỗi turn — instructions gọn, chat mới mỗi task, model hợp việc là 3 cái đốt tiền ít nhất.

---

## 5. Bản đồ extension: 7 thứ hay bị nhầm

Mục này phân biệt 7 "đồ" trong hệ Copilot hay bị người mới nhầm lẫn cho nhau. Đọc để biết cái gì để đâu, khỏi nhét sai chỗ rồi tốn credits.

| Thứ | Là gì (nôm na) | Ví dụ | Dùng khi nào |
|---|---|---|---|
| **`copilot-instructions.md`** | Giấy dán đầu tủ lạnh — agent đọc *mọi* lần vào bếp | "Dùng pnpm. Test: `npm test -- --filter api`." | Quy ước mọi chat đều phải nhớ |
| **`*.instructions.md`** | Giấy dán riêng cho từng phòng | `applyTo: apps/api/**` → "Route không query DB trực tiếp" | Quy tắc chỉ đúng 1 thư mục |
| **Prompt files / Skills** | Công thức nấu ăn in sẵn, lôi ra khi cần | Gõ `/deploy` (prompt file) hoặc nói "deploy" → skill tự load | Việc lặp lại >3 lần |
| **Custom agents** | Thợ chuyên việc: thợ điện chỉ sửa điện | Agent `reviewer` chỉ đọc + comment, cấm sửa code | Task chuyên biệt, hẹp |
| **MCP** | Ki-ốt dịch vụ ngoài (DB, Slack, GitHub) | `mcp__github__create_pr` mở PR thật | Cần dữ liệu ngoài repo |
| **Extensions / Plugins** | Combo đóng gói (prompts + agents + MCP) để share | Extension `security-review` cho cả team | Share cho nhiều repo |
| **Copilot CLI / coding agent** | Agent ngoài IDE | CLI: agentic trong terminal; coding agent: assign issue → PR | Terminal workflow / việc qua đêm |

> **Cách đọc bảng này:** cột "Là gì (nôm na)" là chìa khóa — nhớ mỗi thứ bằng 1 hình đời thường. Cột cuối trả lời "cái này dùng khi nào" cho từng trường hợp.

**Quy tắc chọn nhanh:**

- Mọi chat phải nhớ → `copilot-instructions.md` (bài 03)
- 1 thư mục cụ thể → `*.instructions.md` (bài 03)
- Workflow lặp lại, gọi khi cần → prompt file / skill (bài 05)
- Persona chuyên biệt → custom agent (bài 06)
- Hệ thống ngoài → MCP (bài 08)

> **Nếu nhầm thì sao?** Nhét mọi thứ vào `copilot-instructions.md` (cả checklist 15 bước) → nạp lại *mỗi turn*, tốn credits + loãng trọng tâm. Cái gì "chỉ đúng lúc cần" thì để prompt file/skill, đừng để trong instructions.

> **Tóm gọn 1 câu:** Mỗi loại extension có một "nhà" riêng — dữ kiện để instructions, việc lặp để skill, luật cứng để hook nhỡ đâu.

---

## 6. Walkthrough 5 bước cho người mới

Mục này là con đường an toàn nhất cho lần dùng đầu: 5 bước, đúng thứ tự, 30 phút. Làm xong là bạn đã đi trọn vòng đời một task Copilot.

> Yêu cầu: đã cài xong (chưa cài → [bài 01](./01-cai-dat-va-xac-thuc.md)). 30 phút đầu nên làm đúng thứ tự này.

**Bước 1 — Mở Chat trong repo thật (2 phút)**

> 📄 **Code ví dụ:** [`examples/02-6-walkthrough-5-buoc-cho-nguoi-moi.sh`](examples/02-6-walkthrough-5-buoc-cho-nguoi-moi.sh)

**Bước 2 — Kiểm tra Copilot đọc đúng repo (5 phút)**

```text
Gõ trong Chat:
"Đọc README + package.json, tóm tắt: project này là gì,
chạy dev bằng lệnh nào, test bằng lệnh nào. Không sửa gì, chỉ trả lời."
```

Nếu câu trả lời sai → Copilot chưa đọc đúng repo. Fix trước khi đi tiếp.

**Bước 3 — Viết instructions tối thiểu (5 phút)**

Mục đích: đưa cho agent "cuốn sổ nội quy" ngắn. Như dán tờ giấy ghi lệnh test + lệnh chạy dev lên bàn — mọi người vào làm đều biết phải làm gì.

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

> 📄 **Code ví dụ:** [`examples/03-6-walkthrough-5-buoc-cho-nguoi-moi.sh`](examples/03-6-walkthrough-5-buoc-cho-nguoi-moi.sh)

> **Tóm gọn 1 câu:** Làm lần đầu cứ theo 5 bước: mở Chat, kiểm tra Copilot hiểu repo, viết instructions ngắn, giao task nhỏ, đóng session sạch.

---

## 7. Hiểu nhầm thường gặp + bài tập

Mục này "tiêm vaccine": liệt kê những hiểu nhầm phổ biến nhất kèm sự thật, rồi cho bài tập để tự kiểm chứng.

### 7.1. Hiểu nhầm hay gặp nhất

| Hiểu nhầm | Sự thật |
|---|---|
| "Copilot là chatbot, hỏi gì đáp nấy" | Có 5 chế độ. Ask mode = chỉ chữ. Muốn sửa file → Edit/Agent |
| "Agent tự nghĩ tự làm, không cần kiểm tra" | Agent = junior dev nhanh nhưng ẩu. Bạn là reviewer bắt buộc |
| "MCP cài vào là xong" | MCP server chạy *ngoài* VS Code, có thể rớt mạng, sai key. Check `/mcp` mỗi lần |
| "Instructions càng dài càng khôn" | Nạp lại *mỗi turn*. Dài = tốn tiền + loãng trọng tâm. Giữ <200 dòng |
| "Model mạnh nhất luôn tốt nhất" | Mạnh = đắt. Giải thích code → model rẻ. Refactor khó → model mạnh |
| "premium requests" là thuật ngữ hiện tại | Legacy từ 01/06/2026 — giờ là **AI Credits** (usage-based) |

> **Cách đọc bảng này:** cột trái là câu bạn sẽ nghe đồng nghiệp nói — cột phải là sự thật cần nhớ. Gặp ai nói câu trái, lập tức nhớ sang câu phải.

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

> **Tóm gọn 1 câu:** Sai lầm thường gặp đều có chung gốc: tin lời nói thay vì verify, và nhét mọi thứ vào một chỗ.

### 7.3. Bài tập thực hành

Đọc mà không làm thì mau quên — 4 bài tập dưới đây khiến bạn tự chạm vào từng khái niệm một lần, mới nhớ lâu.

1. **(15 phút) Trace 1 vòng lặp thật:** giao task nhỏ ở Agent mode, xong hỏi Copilot "liệt kê từng turn: bạn nghĩ gì, gọi tool gì, thấy kết quả gì". So với sơ đồ mục 2.
2. **(15 phút) Đo tiền đã đốt:** mở `github.com/settings/copilot`, xem AI Credits trước/sau 1 task dài. Model nào tốn nhất? Đề xuất 1 thay đổi cụ thể.
3. **(20 phút) Phân loại extension:** lấy 5 nhu cầu thật của team, điền bảng mục 5: thuộc `instructions` / `prompt file` / `custom agent` / `MCP` / `extension`? Giải thích 1 câu mỗi ô.
4. **(20 phút) Walkthrough chuẩn:** làm đủ 5 bước mục 6 trên 1 repo thật. Liệt kê 3 điều bạn *hiểu sai* trước khi đọc bài này.

> **Tóm gọn 1 câu:** Đọc xong phải làm tay — trace 1 vòng lặp, đo credits trước/sau, phân loại extension, và đi trọn walkthrough 5 bước.

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

> **Cách đọc bảng này:** cột trái là nhu cầu của bạn lúc này — kéo sang cột phải lấy đúng bài cần đọc, khỏi phải đọc tuần tự cả series.

## Reference

- GitHub Copilot docs: https://docs.github.com/copilot
- VS Code Copilot docs: https://code.visualstudio.com/docs/copilot
- Billing / AI Credits: https://github.com/settings/copilot

> **Chốt cả bài:** Copilot không phải 1 công cụ mà là nhiều "động cơ" — chọn đúng động cơ cho đúng cỡ việc, giữ context sạch, và luôn bắt nó chạy lệnh verify. Làm đúng 3 điều đó là bạn đã ở top 10% người dùng Copilot.
