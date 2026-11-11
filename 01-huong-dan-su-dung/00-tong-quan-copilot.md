# 00 — Tổng Quan Copilot: Từ Autocomplete Tới Agent

> **Dành cho:** người mới dùng GitHub Copilot, và dev đã quen autocomplete nhưng chưa thử agent.
> **Vấn đề:** một tài khoản có nhiều cách làm việc — chế độ nào dùng khi nào, agent chạy ra sao bên trong, harness nào đang "cầm lái", tốn bao nhiêu AI credits.
> **Đọc xong:** phân biệt được 5 chế độ + Copilot CLI, giải thích được vòng lặp agent và 5 Session Target trong 2 phút, ước lượng được AI credits.
> **Thời gian:** ~25 phút đọc. Thao tác cài đặt và session đầu tiên: bài 01.

## Mục tiêu bài học

Mục này cho bạn biết sau 25 phút sẽ mang được gì về — như xem bản đồ trước khi đặt chân vào vùng đất.

- Phân biệt **5 chế độ** (Autocomplete · Ask · Edit · Agent · Copilot in the cloud) + **Copilot CLI**, biết chế độ nào hợp việc nào.
- Giải thích được **vòng lặp agent 4 bước** và vai trò **agent harness** — vì sao model không tự chạm vào máy bạn.
- Chọn đúng **Session Target** (Local · Copilot · Claude · Codex · Cloud) và vì sao cả khoá mặc định dùng **Copilot harness**.
- Ước lượng được **AI credits** và biết 3 chỗ đốt tiền nhiều nhất.

> **Tóm gọn 1 câu:** Bài này là bản đồ Copilot — chế độ, vòng lặp, harness, tiền — để chọn đúng "động cơ" cho đúng việc và không trả tiền lầm động cơ.

---

## 1. Copilot là gì? 5 chế độ + CLI

**Câu trả lời nhanh:** Copilot không phải một công cụ duy nhất mà là các "động cơ" chạy chung một tài khoản — như hộp dụng cụ nhà bếp: dao gọt trái cây không dùng để chặt xương. Bạn chọn động cơ theo kích thước việc.

| Chế độ | Bạn làm gì | Nó làm gì | Ví dụ |
|---|---|---|---|
| **Autocomplete** | Gõ code bình thường | Gợi ý dòng tiếp theo / next edit, `Tab` nhận | Gõ `def fetch_user(` → hiện gợi ý thân hàm |
| **Chat (Ask)** | Hỏi trong Chat view | Trả lời bằng chữ, không sửa file | "Giải thích hàm này cho tôi" |
| **Edit** | Chọn vài file + ra lệnh | Sửa đúng các file bạn chọn | "Thêm null check cho 3 chỗ này" |
| **Agent** | Giao task mở | Tự tìm file, sửa, chạy test, lặp tới khi xong | "Thêm rate-limit cho POST /login" |
| **Copilot in the cloud** | Assign issue trên GitHub | Code trên hạ tầng managed của GitHub, mở PR draft | Assign issue #123 → có PR chờ bạn review |

> **Chú thích:** Ask/Edit/Agent là mode trong Chat view của **Local harness**; **Copilot harness** có built-in agents **Ask / Plan / Agent** — xem [`/plan`](./commands/copilot/code-actions/plan/README.md). Bảng mode nào đi với harness nào: bài 10.

**Copilot CLI** (binary `copilot`) là agent hoàn chỉnh chạy trong terminal — đổi model, tích hợp repo/issue/PR; đừng nhầm với `gh copilot suggest/explain` (extension cộng đồng cho GitHub CLI, chỉ gợi ý lệnh shell). Chi tiết: [bài 02](./02-cac-be-mat-vscode-ide-web-cli.md) · [bài 12](./12-copilot-sdk-ci-cd-automation.md).

> 📄 **Ví dụ copy-paste:** [`./examples/00-tong-quan-copilot/bon-ho-tool-copilot.md`](./examples/00-tong-quan-copilot/bon-ho-tool-copilot.md) — bảng "4 họ tool" ai làm việc gì · [`./examples/00-tong-quan-copilot/jetbrains-visual-studio-neovim.sh`](./examples/00-tong-quan-copilot/jetbrains-visual-studio-neovim.sh) — Copilot trên IDE khác.

**Chọn chế độ nào — cây hỏi 10 giây:**

```text
Go code quen tay?                    -> Autocomplete
Chua hieu code, chi hoi?             -> Ask
Biet ro file nao can sua?            -> Edit
Task mo, nhieu file, can test?       -> Agent (Session Target = Copilot)
Muon chay qua dem, ra PR?            -> Copilot in the cloud
Dang o terminal?                     -> Copilot CLI (binary `copilot`)
```

Prompt tệ = kết quả tệ: "TypeError này nghĩa là gì?" (Ask, không context) khác hẳn "Trong apps/api, POST /orders crash khi thiếu customerId. Tìm root cause, fix, thêm regression test, chạy `npm test -- --filter api`, đừng sửa ngoài phạm vi." — câu sau có **nơi nào**, **làm gì**, **check bằng gì**, **ranh giới**.

> **Vì sao quan trọng?** Đa số thất vọng với Copilot đến từ **chọn sai chế độ**, không phải model dở. Giao task mở cho Ask → chỉ nhận chữ, tưởng "Copilot không sửa được file"; dùng Agent cho việc 1 dòng → nó đọc 20 file, đốt credits vô ích. Như thuê cả đội thợ để đóng một cái đinh.
> **Nếu làm sai?** Chọn lầm chế độ thì prompt hay mấy cũng bó tay — hỏi trước: "tôi phải làm bao nhiêu?" Câu trả lời càng ngắn, càng nên dùng chế độ dưới thấp của bảng.
> **Tóm gọn 1 câu:** Chọn chế độ theo kích thước việc — gõ, hỏi, sửa vài file, giao cả task, hay chạy cloud. · 📄 [VS Code Docs: AI in VS Code — Overview](https://code.visualstudio.com/docs/agents/overview)

## 2. Copilot vs Claude Code — khác nhau ở đâu

Bài 00 là **chủ sở hữu** bảng so sánh này — các bài khác dẫn về đây. Nếu quen Claude Code, khái niệm chuyển sang Copilot gần như 1-1, chỉ khác *tên file* và *nơi chạy*.

| Việc | GitHub Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Chạy ở đâu | VS Code · JetBrains · github.com · CLI · Copilot app | CLI trong terminal (+ IDE extension) | Copilot phủ nhiều bề mặt hơn |
| Autocomplete | Có — **không trừ AI credits** trên plan trả phí | Không phải trọng tâm | Điểm riêng của Copilot khi gõ từng dòng |
| Chọn model | Đổi ngay trong picker, nhiều nhà cung cấp | Gắn với model Anthropic | Chọn model Claude *trong* Copilot picker **không** phải là đổi sang Claude harness |
| Luật trong repo | `.github/copilot-instructions.md` + `AGENTS.md` | `CLAUDE.md` + `.claude/` | Cùng tư tưởng: file trong repo là "luật" |
| Việc lặp lại | Agent Skills `SKILL.md` (chuẩn mở) | Skills trong `.claude/skills` | Cùng chuẩn, khác thư mục |
| Prompt dựng sẵn | `*.prompt.md` — **chỉ chạy ở Local harness** | `.claude/commands/` | Hướng mới: port sang skill (bài 05) |
| Tool ngoài | MCP (`.mcp.json`) + [Copilot connectors](./commands/copilot/system-knowledge/connector/README.md) | MCP | Cùng chuẩn giao thức |
| Kiểm chứng | Bạn là người chạy test | Bạn là người chạy test | **Không agent nào tự chịu trách nhiệm đúng/sai** |

> **Vì sao quan trọng?** Bảng này đổi cho bạn "từ điển" miễn phí: mỗi khái niệm đã học ở Claude Code đều có một ô tương ứng — không phải học lại từ đầu, chỉ phải nhớ *đường dẫn và nơi chạy khác nhau*.
> **Nếu nhầm thì sao?** Nghĩ "Copilot = autocomplete" (kiểu 2023) là bỏ nửa sức mạnh công cụ. Ngược lại, tưởng "Copilot giống hệt Claude Code" thì sẽ lạc khi thấy Session Target, Customizations editor và các surface web/cloud — khác nhau ở *nơi chạy*, không ở khái niệm.
> **Tóm gọn 1 câu:** Copilot hơn ở autocomplete không trừ credits + nhiều bề mặt + picker model đa nhà cung cấp; Claude Code mạnh ở agentic mặc định + terminal-first. 📄 Tạo đủ 3 loại file để thấy khác nhau: [`./examples/00-tong-quan-copilot/loai-file-phan-biet-va-at.sh`](./examples/00-tong-quan-copilot/loai-file-phan-biet-va-at.sh) · port `*.prompt.md`/`CLAUDE.md` sang `.github/`: [`./examples/00-tong-quan-copilot/port-prompt-file-cu-sang-skill.sh`](./examples/00-tong-quan-copilot/port-prompt-file-cu-sang-skill.sh) · 📄 [VS Code Docs: Choose an Agent Harness](https://code.visualstudio.com/docs/agents/run/agent-harnesses)

## 3. Vòng lặp agent — và harness thật sự chạy nó

```text
BƯỚC 1 — NGHĨ:     model tự hỏi "cần đọc file nào, chạy lệnh gì để xác nhận?"
BƯỚC 2 — LÀM:      model yêu cầu tool: read(auth.ts) + search("customerId") + terminal(npm test)
BƯỚC 3 — THẤY:     harness thực thi tool, trả kết quả về model: nội dung file / stdout / exit code
BƯỚC 4 — KIỂM TRA: chưa xong -> quay lại BƯỚC 1. Xong -> báo cáo + diff.
```

**Tên gọi chính xác của "đội thợ" ở bước 3** là **agent harness** — docs định nghĩa là tầng "coordinates the language model, context, and tools": **Agent Host chạy Copilot harness** (qua Copilot SDK — runtime chung cho VS Code, Copilot CLI, Copilot app); **extension host chạy Local harness**. Model không bao giờ tự chạm đĩa: model = kiến trúc sư vẽ bản vẽ, harness = đội thợ thi công.

Picker chọn "động cơ" là **Session Target** (docs gọi là *Choose an agent harness*) — 5 lựa chọn hay bị đọc sai nhất:

| Session Target | Bản chất thật |
|---|---|
| **Local** | **Local harness** (legacy) — chạy trong extension host, đóng cửa sổ editor là agent dừng, không có trong Agents window |
| **Copilot** | **Copilot harness** — chạy trong Agent Host, session chạy nền, tiếp nối giữa các surface |
| **Claude** / **Codex** | **provider harness** thật (Anthropic / OpenAI); org bật enterprise-managed settings có thể chặn |
| **Cloud** | **KHÔNG phải harness** — là *execution target* chạy **Copilot harness** trên hạ tầng managed của GitHub |

Docs VS Code khuyến nghị bắt đầu (hoặc chuyển sang) **Copilot harness** — xem [Move from Local to Copilot](https://code.visualstudio.com/docs/agents/run/move-to-copilot). Cả khoá này lấy Copilot harness làm mặc định; Local chỉ xuất hiện để so sánh. 📄 Bài tập quan sát picker 2 trạng thái: [`./examples/00-tong-quan-copilot/session-target-picker.md`](./examples/00-tong-quan-copilot/session-target-picker.md).

**Khi nào agent làm hỏng?**

| Dấu hiệu trên màn hình | Vì sao | Cách xử lý |
|---|---|---|
| Đọc lung tung, sửa sai chỗ | không biết file nào quan trọng | instructions rõ (bài 03) + gắn context bằng `#`-mentions / Add Context |
| Báo "xong" nhưng test fail | model chỉ *đọc* kết quả, không tự biết đúng/sai | bắt agent chạy lệnh verify *mỗi task* |
| Càng sửa càng nát sau nhiều turn | context đầy → "quên đầu bài" | chat mới `Ctrl+N` hoặc `/compact`, chia task nhỏ hơn |

> **Vì sao quan trọng?** Vòng lặp này giải thích cùng lúc: policy chặn lệnh nằm ở **harness** chứ không ở model ([`/sandbox policy`](./commands/copilot/model-agent/sandbox-policy/README.md)), chat dài thì agent quên đầu bài, và vì sao phải có lệnh verify.
> **Nếu làm sai?** Hai nhầm kinh điển: "model chạy trên máy tôi nên Local là offline" — docs FAQ ghi rõ *the Local harness is not Copilot CLI*, model vẫn chạy remote; và "chọn Cloud là chọn một động cơ khác" — Cloud vẫn chạy Copilot harness, chỉ đổi *nơi thợ đứng làm việc*.
> **Tóm gọn 1 câu:** Agent = vòng lặp "nghĩ → làm → thấy" do harness chạy hộ; agent quay nhiều turn vô vọng thì dừng, mở chat mới, chia nhỏ task. · 📄 [VS Code Docs: Agent loop](https://code.visualstudio.com/docs/agents/concepts/agents#agent-loop)

## 4. Bốn họ tool Copilot

Khi agent "nghĩ", nó có 4 họ công cụ trong tay — biết trước để không giật mình khi nó tự chạy lệnh, và biết tool nào cần soi kỹ. Bảng kiểm + mẫu phiên làm việc 4 họ tool: [`./examples/00-tong-quan-copilot/bon-ho-tool-copilot.md`](./examples/00-tong-quan-copilot/bon-ho-tool-copilot.md).

- **Nhóm 1 — Đọc & tìm (nhanh, rẻ):** `read` / `#file`, `search`, `list`. Tiết kiệm: luôn `search` trước rồi `read` sau; file quá dài → bảo agent đọc từng phần. Như mở tủ lạnh: ngó trước, lấy đúng ngăn.
- **Nhóm 2 — Sửa & chạy (dao sắc, cần review):** `edit` (hiện diff — duyệt từng hunk trước khi Accept), `create` (kiểm tra path), `terminal` (có confirm trước lệnh nguy hiểm).
- **Nhóm 3 — Mở rộng context:** gắn file/editor/URL bằng `#`-mentions hoặc nút **Add Context** (dán link docs ngoài repo vào phiên). ⚠️ **Chat participants** dạng `@...` đã **deprecated và không chạy trong Copilot harness** — docs bảo thay bằng agent + context/tools, đừng học theo bản cũ.
- **Nhóm 4 — MCP (tool ngoài, động):** MCP server là chương trình ngoài repo phơi ra tools để agent gọi — ví dụ `mcp__github__create_pr` mở PR thật. Quy tắc thực hành: giữ **3–6 servers**, càng nhiều tool model càng dễ chọn nhầm. Chi tiết: [bài 08](./08-mcp-ket-noi-cong-cu-ngoai.md).

> **Vì sao quan trọng?** Nhóm 1 vô hại; nhóm 2 thay đổi code của bạn; nhóm 4 chạy code của *người khác* — rủi ro tăng dần từ trái sang phải, mức độ rà soát cũng phải tăng vậy.
> **Nếu làm sai?** Cài 15 MCP servers "cho đủ" → model chọn nhầm tool, mỗi lệnh ngoài thêm một bề mặt tấn công.
> **Tóm gọn 1 câu:** Bốn họ tool — đọc, sửa/chạy, gắn context, MCP — trong đó nhóm sửa/chạy và MCP cần bạn duyệt kỹ nhất. · 📄 [VS Code Docs: Types of tools](https://code.visualstudio.com/docs/agents/concepts/tools#types-of-tools)

## 5. AI credits — tiền rơi vào chỗ nào

> **AI credits là gì?** Đơn vị tính chi phí Copilot theo **usage-based billing** — **1 credit = $0,01**, chi phí = **giá mỗi token của model × số token** (bảng per-million-token trong docs), không đóng gói trọn gói. Tưởng như nước sinh hoạt: dùng bao nhiêu trả bấy nhiêu. Nguồn: [Models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing). Bốn điều cần biết:

1. Model mạnh đắt hơn model rẻ — cùng một việc, đổi model là đổi hoá đơn.
2. **Code completions + next edit suggestions KHÔNG trừ AI credits** — unlimited cho mọi plan trả phí (docs GitHub); cứ autocomplete thoải mái.
3. Mỗi turn agent = 1+ lượt gọi model — task càng dài càng đắt.
4. Instructions nạp lại **mỗi turn** — chỗ đốt tiền thầm lặng nhất.

Giá từng plan (Free / Pro / Pro+ / Max + Business / Enterprise) thuộc **bài 14 §4** (bài 01 chỉ liệt kê plan để chọn) — bài này không chép lại vì giá đổi theo thời gian; chuẩn cuối là dashboard `github.com/settings/copilot`.

```text
Uoc luong vi sao instructions phinh ton tien (du thuc hanh, khong phai con so docs):
- instructions 150 dong ~ 2.500 tokens, task 10 turns -> 25.000 tokens chi de "nhac lai noi quy"
- neu instructions 600 dong (~10.000 tokens): 100.000 tokens/task, lech 75.000
- 20 tasks/tuan ~ 1,5 trieu tokens qua cua so -> 1 gio don instructions (bai 03) hon 1 tuan toi uu prompt
```

> **Vì sao quan trọng?** Mọi quyết định — chọn model, độ dài chat, độ dài instructions — đều là quyết định chi tiền; không hiểu credits thì không biết đánh đổi cái gì lấy cái gì.
> **Nếu làm sai?** Sợ "đốt credits" mà tắt autocomplete thì phí (completions không trừ credits); ngược lại coi instructions dài là an toàn thì trả tiền "nhắc lại nội quy" mỗi turn.
> **Tóm gọn 1 câu:** Credits tính theo token nạp mỗi turn — instructions gọn, chat mới mỗi task, model hợp việc là 3 van tiền lớn nhất.

## 6. Bản đồ tùy biến: 7 thứ hay bị nhầm

Cái gì để đâu — đọc để khỏi nhét sai chỗ rồi trả tiền cho thứ agent không cần.

| Thứ | Là gì (nôm na) | Ví dụ | Dùng khi nào |
|---|---|---|---|
| **`copilot-instructions.md`** / `AGENTS.md` | Giấy dán đầu tủ lạnh — đọc *mọi* lần vào bếp | "Dùng pnpm. Test: `pnpm test --filter api`." | Quy ước mọi chat phải nhớ (bài 03) |
| **`*.instructions.md`** | Giấy dán riêng từng phòng | `applyTo: apps/api/**` | Quy tắc chỉ đúng 1 thư mục (bài 03) |
| **Agent Skills** | Công thức nấu ăn in sẵn, lôi ra khi cần | `/deploy` hoặc nói "deploy" → skill tự load | Việc lặp lại (bài 05) |
| **Custom agents** | Thợ chuyên: thợ điện chỉ sửa điện | Agent `reviewer` chỉ đọc + comment, cấm sửa | Task chuyên biệt, hẹp (bài 06) |
| **MCP servers** | Ki-ốt dịch vụ ngoài (DB, Slack, GitHub) | `mcp__github__create_pr` mở PR thật | Cần dữ liệu ngoài repo (bài 08) |
| **Agent Plugins** | Gói skill + MCP + hooks để share giữa repos | Marketplace là Git repo cài bằng `/plugin` | Chỉ **Copilot harness**; khác VS Code extensions (bài 17) |
| **Prompt files** | Bản cũ của "công thức nấu ăn" | `.github/prompts/*.prompt.md` | **Chỉ còn chạy ở Local harness** — việc mới dùng skill |

> **Vì sao quan trọng?** Nhét sai chỗ là trả cả tiền lẫn độ chính xác: thứ luôn cần thì phải luôn nạp (instructions), thứ thỉnh thoảng cần thì chỉ nạp khi gọi (skill) — nạp nhầm cái "thỉnh thoảng" thành "luôn luôn" là nhân token mỗi turn.
> **Nếu nhầm thì sao?** Nhét checklist deploy 15 bước vào `copilot-instructions.md` → nạp lại *mỗi turn*, tốn credits + loãng trọng tâm. Cái gì "chỉ đúng lúc cần" thì để skill, đừng để trong instructions.
> **Tóm gọn 1 câu:** Mỗi loại tùy biến có một "nhà" riêng — dữ kiện để instructions, việc lặp để skill, gói chia sẻ để plugin.

> 📄 **File mẫu từng loại:** [`templates/.github/copilot-instructions.md`](../templates/.github/copilot-instructions.md) · [`templates/.github/instructions/`](../templates/.github/instructions/) · [`templates/.github/skills/review-pr/SKILL.md`](../templates/.github/skills/review-pr/SKILL.md) · [`templates/.github/agents/`](../templates/.github/agents/) · [`templates/.mcp.json`](../templates/.mcp.json) — copy bằng [`templates/examples/01-cach-copy-vao-project-3-buoc.sh`](../templates/examples/01-cach-copy-vao-project-3-buoc.sh). · 📄 [VS Code Docs: Customization building blocks](https://code.visualstudio.com/docs/agents/concepts/customization#customization-building-blocks)

## 7. Bắt đầu ở đâu?

Toàn bộ thao tác cài đặt, login, verify và **walkthrough 5 bước cho session đầu** (mở Chat trong repo thật → kiểm tra agent đọc đúng repo → viết instructions tối thiểu → giao task nhỏ có lệnh check → đóng session sạch) thuộc **bài 01 §6**: [01 — Cài đặt & xác thực](./01-cai-dat-va-xac-thuc.md). Bài này dừng ở bản đồ; tay nghề bắt đầu từ bài 01. · 📄 [VS Code Docs: Find a Guide](https://code.visualstudio.com/docs/agents/guides/overview)

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| (Ask mode) "Sửa bug login giúp tôi" | chỉ trả lời chữ, không đụng file | (Agent mode, có scope) "Trong src/auth, fix login email có dấu bị 500, chạy `npm test -- auth`, dán output." |
| Tin lời "Xong rồi nhé!" rồi đi deploy | deploy code hỏng | bắt agent chạy test thật: "Chạy `npm test -- auth` rồi dán output cho tôi" |
| `copilot-instructions.md` 600 dòng gồm cả checklist deploy | nạp lại mỗi turn → tốn credits, loãng trọng tâm | instructions < 200 dòng; checklist tách ra skill (bài 05) |
| "Chọn Session Target Local để chạy offline, khỏi tốn tiền cloud" | vẫn gọi model remote, vẫn trừ credits như nhau | Local là **harness** (nơi thợ đứng), không phải nơi tính model chạy; model luôn chạy remote trên mọi target |
| "Cài MCP server vào là chạy mãi" | server rớt, sai key, agent gọi nhầm tool | kiểm tra MCP trong Customizations editor trước khi giao việc (bài 08) |

**Bài học:** mọi hiểu nhầm ở bảng này có chung gốc — tin lời nói thay vì verify, và nhét mọi thứ vào một chỗ. · 📄 [VS Code Docs: Chat features aren't working](https://code.visualstudio.com/docs/agents/agent-troubleshooting/faq#chat-features-arent-working-for-me)

## Best practices

- **Giữ instructions < 200 dòng, việc lặp tách sang skill.** *Vì sao:* instructions được nạp lại mỗi turn — phình gấp 4 là tiền gấp 4 (mục 5).
- **Task mới = chat mới (`Ctrl+N`); chat dài thì `/compact`.** *Vì sao:* context đầy khiến agent "quên đầu bài", sửa càng lâu càng nát.
- **Model rẻ cho việc dễ, model mạnh cho refactor khó.** *Vì sao:* chi phí là giá-token × số-token; model mạnh đắt hơn trên cùng một việc.
- **Giữ 3–6 MCP servers.** *Vì sao:* càng nhiều tool, model càng dễ chọn nhầm và mỗi tool là một bề mặt tấn công.
- **Mọi task code phải có lệnh verify chạy thật trong prompt.** *Vì sao:* model chỉ đọc kết quả chứ không tự biết đúng/sai — lời "xong" không có giá trị bằng log. · 📄 [VS Code Docs: Pick the right tool for the task](https://code.visualstudio.com/docs/agents/best-practices#pick-the-right-tool-for-the-task)

## Bài tập

1. **(15 phút) Trace một vòng lặp thật:** giao task nhỏ ở Agent mode (Session Target = Copilot), xong hỏi "liệt kê từng turn: bạn nghĩ gì, gọi tool gì, thấy kết quả gì" — đối chiếu sơ đồ mục 3.
2. **(15 phút) Đo tiền đã đốt:** mở `github.com/settings/copilot`, ghi AI credits trước/sau một task dài. Model nào tốn nhất? Đề xuất 1 thay đổi cụ thể.
3. **(10 phút) Đọc đúng Session Target:** mở picker Session Target trong repo thật, liệt kê target nào *hiện ra* với bạn; giải thích vì sao một số target vắng mặt (điều kiện harness — bài 02).
4. **(30 phút) Session đầu chuẩn:** làm đủ walkthrough bài 01 §6 trên một repo thật — 3 điều bạn *hiểu sai* trước khi đọc bài này là gì?

## Link qua

- Cài đặt, login, walkthrough 5 bước → [bài 01](./01-cai-dat-va-xac-thuc.md). · Chọn bề mặt (editor/CLI/web) → [bài 02](./02-cac-be-mat-vscode-ide-web-cli.md).
- Instructions gọn để tiết kiệm credits → [bài 03](./03-instructions-memory-rules.md). · Tra slash command & phím tắt → [bài 04](./04-chat-commands-toan-tap.md). · Đóng gói việc lặp thành skill → [bài 05](./05-agent-skills-reusable-workflows.md).
- Persona chuyên biệt → [bài 06](./06-custom-agents-parallel.md). · MCP → [bài 08](./08-mcp-ket-noi-cong-cu-ngoai.md). · Modes & permission levels → [bài 10](./10-modes-permissions-availability.md). · Cloud agent session → [bài 12](./12-copilot-sdk-ci-cd-automation.md). · Chọn model → [bài 14](./14-models-chon-model-dung.md).
- Gói plugin chia sẻ → [bài 17](./17-agent-customizations-hub.md). · Tra nhanh: [session-target](./commands/copilot/model-agent/session-target/README.md) · [agent-mode](./commands/copilot/model-agent/agent-mode/README.md) · [ai-credits](./commands/copilot/model-agent/ai-credits/README.md) · [giao việc cho cloud agent](./commands/cloud/model-agent/coding-agent-assign/README.md).

## Reference

- VS Code — [Understand agent harnesses](https://code.visualstudio.com/docs/agents/concepts/agent-harnesses) (định nghĩa harness; Agent Host chạy Copilot harness, extension host chạy Local harness; bảng Session Target) · [Choose an agent harness](https://code.visualstudio.com/docs/agents/run/agent-harnesses) · [Move from Local to Copilot](https://code.visualstudio.com/docs/agents/run/move-to-copilot) (khuyến nghị bắt đầu với Copilot harness) · [AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) (phím tắt, slash commands) · [Cloud sandbox sessions](https://code.visualstudio.com/docs/agents/run/cloud-sandbox-sessions) (Cloud là execution target)
- GitHub — [Models and pricing (AI credits)](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) (1 credit = $0,01, billing per-token, completions không trừ credits) · [Copilot docs](https://docs.github.com/en/copilot)

**Chốt:** Copilot là nhiều "động cơ" chạy chung một tài khoản và một loại tiền là AI credits — chọn đúng chế độ theo cỡ việc, hiểu harness đang cầm lái sau mỗi lệnh, giữ context gọn, và luôn bắt agent chạy lệnh verify; bốn điều đó là bản đồ còn lại cho 17 bài sau.
