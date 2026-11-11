# 03 — Instructions, Memory & Rules: Bộ Luật Của Repo

> **Dành cho:** dev đã dùng Copilot Chat nhưng repo chưa có file luật chuẩn — mọi quy ước vẫn phải nhắc lại bằng prompt.
> **Vấn đề:** agent đoán sai lệnh test, viết sai style, đụng vào file generated — và khi bạn tự viết luật thì không biết luật nào thật sự được nạp.
> **Đọc xong:** viết được `.github/copilot-instructions.md` <200 dòng lệnh đã verify, tách rules theo `applyTo`, dùng được `AGENTS.md`, hiểu cách Personal/Repo/Org nạp chung và Copilot Memory là gì. **Thời gian:** ~30 phút.

## Mục tiêu bài học

Mục này cho bạn biết sau 30 phút sẽ mang được gì về — như danh sách đồ cần mua trước khi vào chợ.

- Viết được `copilot-instructions.md` **<200 dòng**: chỉ chứa lệnh đã chạy tay PASS + rule kiểm chứng được.
- Phân biệt **3 loại file**: `copilot-instructions.md` / `*.instructions.md` (`applyTo`) / `AGENTS.md` — và hai đường dẫn cá nhân `~/.copilot/copilot-instructions.md`, `~/.copilot/instructions/`.
- Hiểu **cơ chế nạp**: Personal, Repo, Org **đều được đưa vào context** — không có luật "file cao nhất thắng"; thứ tự chỉ phân xử khi mâu thuẫn, và mỗi harness một quy tắc kết hợp.
- **Verify** được file có thật sự nạp (`Chat: Open Customizations`, References, chat mới) và phân biệt instructions với **Copilot Memory**.

> **Tóm gọn 1 câu:** Xong bài này bạn có file luật ngắn, đúng lệnh, và cách *chứng minh* agent đang đọc nó thay vì đoán.

---

## 1. Vì sao instructions là file đáng viết nhất?

Instructions là nơi bạn dạy Copilot về repo của mình — viết một lần, mọi task sau đều được lợi.

- **Định nghĩa 1 câu:** file markdown do bạn viết, được nạp vào context ở đầu mỗi chat.
- **Nôm na:** tờ dặn dò dán trên tủ lạnh cho người vào nhà: "chó ăn 2 bữa, đừng mở cửa sau".
- **Ví dụ:** dòng `Test focused: pnpm vitest run apps/api` giúp agent không chạy nhầm `pnpm test` full 20 phút.

```text
Cơ chế: instructions được đưa vào đầu system prompt.
Mỗi turn, agent nạp lại toàn bộ context: instructions + history + tool results.
=> 1 dòng thừa trong instructions = trả AI credits N lần (N = số turns).
```

Hai giới hạn docs VS Code ghi rõ: instructions **không đảm bảo model tuân** (không thay được test, review, security control) và **không áp dụng cho inline suggestions** khi bạn gõ code.

> **Vì sao quan trọng?** Luật đúng thì mọi task sau tự đúng không phải nhắc lại; luật sai thì mọi task sau sai theo — cả hai trường hợp bạn đều trả tiền ở mỗi turn.
> **Nếu làm sai?** Không có instructions: agent tự đoán lệnh test + style (và đoán sai). Nhét 500 dòng wiki: trả credits cho rác mỗi turn, luật thật chìm mất.
> **Tóm gọn 1 câu:** File rẻ nhất và lãi nhất bạn từng viết — một lần dọn, mọi task sau đỡ phải giải thích lại.

## 2. Ba loại file — và một mẫu tối thiểu

| Loại file | Đặt ở đâu | Nôm na | Khi nào dùng |
|---|---|---|---|
| **`copilot-instructions.md`** | `.github/` — 1 file duy nhất, commit | nội quy cả nhà, đọc mọi chat | quy ước mọi task cần (<200 dòng) |
| **`*.instructions.md`** | `.github/instructions/` (được tạo thư mục con) | nội quy từng phòng, vào phòng mới đọc | rule chỉ đúng cho path khớp `applyTo` (mỗi file <50 dòng) |
| **`AGENTS.md`** | root **hoặc bất kỳ đâu** trong repo | chuẩn chung, đội thợ nào cũng hiểu | 1 file cho Copilot + Claude Code + Codex (mục 5) |

Docs VS Code khuyên bắt đầu từ **một quy ước mà agent hay bỏ quên nhất**; file project-wide không cần frontmatter:

```markdown
# Project: Acme API
## Commands (VERIFIED 2026-11)
- Dev: `npm run dev` (can `.env` tu 1Password "Acme dev")
- Test focused: `npm test -- --filter api --testPathPattern=orders`
## Rules
- Route KHONG query DB truc tiep; goi qua `src/services/`.
- ALWAYS chay focused test sau khi sua; NEVER commit truc tiep main.
```

Bản hoàn chỉnh cho hai loại project phổ biến (lệnh đã verify — thay project của bạn vào): 📄 [`./examples/03-instructions-memory-rules/mau-instructions-backend.md`](./examples/03-instructions-memory-rules/mau-instructions-backend.md) (Node + Express, kèm biến thể Python) · 📄 [`./examples/03-instructions-memory-rules/mau-instructions-frontend.md`](./examples/03-instructions-memory-rules/mau-instructions-frontend.md) (Next.js + Prisma) · 📄 tạo đủ 3 loại file trong 1 phút: [`./examples/00-tong-quan-copilot/loai-file-phan-biet-va-at.sh`](./examples/00-tong-quan-copilot/loai-file-phan-biet-va-at.sh)

> **Tóm gọn 1 câu:** Luật chung để `copilot-instructions.md`, luật theo thư mục để `*.instructions.md`, luật đa-tool để `AGENTS.md`.

## 3. Personal, Repo, Org — nạp thế nào, ai phân xử

| Tầng | Nằm ở đâu | Ai quản lý |
|---|---|---|
| **Personal** | `~/.copilot/copilot-instructions.md` (chung) + `~/.copilot/instructions/**/*.instructions.md` (module) — 📄 tạo đủ 3 loại file 1 phút: [`./examples/00-tong-quan-copilot/loai-file-phan-biet-va-at.sh`](./examples/00-tong-quan-copilot/loai-file-phan-biet-va-at.sh) | chính bạn, mọi repo trên máy |
| **Repository** | `.github/copilot-instructions.md`, `.github/instructions/`, `AGENTS.md` | team, qua git |
| **Organization** | **settings UI trên GitHub** (Business/Enterprise) — không có file org trong repo | org owner/admin |

Khác với luật cũ "file cao nhất thắng" hay dạy trước đây:

- GitHub: *"all sets of relevant instructions are provided to Copilot"* — **cả ba tầng đều vào context**, không tầng nào "lấn phe" tầng nào.
- Thứ tự **Personal > Repository > Org chỉ phân xử khi mâu thuẫn**; *"combination rules differ by harness"* — **không có universal precedence**. Khi Personal xung đột Repo: **xoá/thu hẹp bên mâu thuẫn**, đừng viết rule "bù đắp". Harness quyết định đọc file nào — chọn đúng harness ở Session Target (bài 02) rồi mới tạo file.

Verify file đã nạp (docs VS Code, đúng thứ tự): **1) `Chat: Open Customizations` → tab Instructions** phải liệt kê file (kiểm *discovery*) → **2) chat mới** xin một việc nhỏ, không nhắc lại rule trong prompt → **3) giãn phần References**: thấy `.github/copilot-instructions.md` = đã được *đưa vào*. Vẫn làm sai = rule mơ hồ/mâu thuẫn, không phải "chưa nạp".

> **Tóm gọn 1 câu:** Đừng tin "rule đã có" chỉ vì bạn đã viết ra — tin danh sách trong Customizations editor và References của câu trả lời.

## 4. Rules theo đường dẫn: `applyTo` và `excludeAgent`

File `NAME.instructions.md` chỉ nạp khi file agent đang chạm khớp glob trong `applyTo` — và chạy **song song** với repo-wide: docs GitHub, khi cả hai cùng áp thì *"the instructions from both files are used"*. Nôm na: biển báo phòng thí nghiệm, ai vào phòng đó mới cần đọc.

```markdown
---
applyTo: "src/**/*.py"
excludeAgent: "code-review"   # tuy chon: rule cho moi agent TRU code review
---
# Python rules
- Reuse fixtures tu `tests/conftest.py`; test toi da: `python -m pytest <file>`.
```

- Nhiều pattern ngăn bằng dấu phẩy (`applyTo: "**/*.ts,**/*.tsx"`); path tính **từ gốc repo**, không tính từ `.github/instructions`. `src/*.py` khớp `src/foo.py` nhưng **không** khớp `src/foo/bar.py` — dùng `src/**/*.py` để khớp đệ quy.

| Pattern | Phủ | Rule hợp |
|---|---|---|
| `apps/api/**` | một subtree backend | DB/validation, "route không query DB trực tiếp" |
| `apps/web/src/app/**` | routes frontend | server/client component, không import thẳng DB |
| `tests/**/*.test.ts` | chỉ test | fixtures, không mock quá tay |
| `db/migrations/**` | migrations | forward-only, không sửa migration đã merge |
| `*.md` | docs | giọng văn, heading style |

Ba sự thật docs GitHub: (1) trên **GitHub.com**, path-specific hiện **chỉ hỗ trợ Copilot cloud agent + Copilot code review** (trong editor VS Code thì cả Copilot lẫn Local harness đọc `.github/instructions/` bình thường); (2) khi review PR, **code review đọc instructions từ head branch**, không phải base — thử sửa chính file luật ngay trong PR đang làm được; (3) `excludeAgent` là field chính thức, nhận `"code-review"` hoặc `"cloud-agent"`, **bỏ trống = cả hai đều đọc**.

Giới hạn thực hành: ≤8 file, mỗi file <50 dòng. Verify: sửa file trong subtree rồi hỏi "rules nào đang áp cho folder này?" → phải kể đúng nội dung; sửa file ngoài subtree mà rule vẫn đọc = glob quá rộng.

> **Tóm gọn 1 câu:** Glob hẹp nhất có thể — rule chỉ nạp đúng lúc cần thì vừa đỡ tốn credits vừa đỡ áp sai chỗ. Bản hoàn chỉnh để copy (kèm 2 bước verify): 📄 [`./examples/03-instructions-memory-rules/mau-python-rules.instructions.md`](./examples/03-instructions-memory-rules/mau-python-rules.instructions.md).

## 5. `AGENTS.md` — viết một lần, nhiều agent đọc

`AGENTS.md` là chuẩn mở ([agents.md](https://agents.md/)) mà Copilot, Claude Code, Codex, Gemini cùng đọc. Thứ **chung** (lệnh build/test, architecture, style) để đây; thứ **riêng Copilot** để `copilot-instructions.md` — đừng copy nguyên văn qua lại, trùng lặp là trả tiền hai lần mỗi turn.

- **Đặt bất kỳ đâu trong repo**, không chỉ root: docs GitHub — file `AGENTS.md` **gần nhất trong cây thư mục có ưu tiên**; docs VS Code bổ sung — Copilot harness tìm dọc đường dẫn tới file đang làm việc và **kết hợp** các phần áp dụng.
- Ở **root**, `CLAUDE.md` **hoặc** `GEMINI.md` là **thay thế hợp lệ** cho `AGENTS.md` (docs GitHub) — repo đã có thì dùng tiếp, đừng tạo bản sao cạnh tranh.
- `AGENTS.md` hướng dẫn agent đang tồn tại, **không định nghĩa custom agent** (cái đó là `.github/agents/` — bài 06).

Mỗi lần đổi toolchain: `diff <(sort AGENTS.md) <(sort .github/copilot-instructions.md) | head -30` — trùng >50% thì gộp về một nơi (script đầy đủ: 📄 [`./examples/03-instructions-memory-rules/agents-md-portability-viet-1-lan-chay.sh`](./examples/03-instructions-memory-rules/agents-md-portability-viet-1-lan-chay.sh)).

> **Tóm gọn 1 câu:** Thứ chung để `AGENTS.md`, thứ riêng để file riêng từng tool — mỗi sự thật chỉ viết một nơi.

## 6. Front-load & chống phình

Model đọc instructions từ trên xuống và chú ý phần đầu hơn phần cuối — hãy tưởng tượng người đọc chỉ nhớ 5 dòng đầu. Thứ tự xếp: **1) lệnh đã verify** (agent cần chạy đúng lệnh trước khi nghĩ chuyện khác) → **2) NEVER list** (ranh giới cứng) → **3) ALWAYS list** (cửa verify) → **4) architecture + style**.

| Dấu hiệu file phình | Chuyển đi đâu |
|---|---|
| Checklist deploy 40 dòng | skill `.github/skills/<ten>/SKILL.md` (bài 05) |
| Rule chỉ đúng một subtree | `.github/instructions/…` + `applyTo` (mục 4) |
| Persona review chỉ-đọc-không-sửa | custom agent `.github/agents/` (bài 06) |
| Schema/format dài (endpoints, error codes) | file `docs/` + 1 dòng link — link **không đảm bảo** nội dung tới được model, agent mở khi cần |
| Quy ước chung nhiều repo trong org | organization instructions qua settings UI (mục 3) |

> **Tóm gọn 1 câu:** Instructions chỉ giữ phần dùng mỗi ngày; phần nặng đẩy sang skill, docs, agent.

## 7. Copilot Memory — phần bạn không phải viết vào file nữa

Instructions là **luật bạn chủ động viết và review**; **Copilot Memory** là bộ nhớ **cloud-backed**: docs 11/2026 ghi nó khả dụng trên mọi plan Copilot trả phí và được dùng bởi nhiều surface — GitHub Copilot app, CLI, code review, **cloud agent**, Mobile, Slack, Teams (docs VS Code ghi bật mặc định cho session Copilot) — nên không còn là tính thử nghiệm phải tự bật. Agent tự học **repository facts** và **user preferences**, nhớ xuyên session, khỏi paste vào instructions. Docs GitHub chốt vai: muốn rule áp **nhất quán** thì phải là instructions, không trông chờ memory.

- **Bật/tắt:** plan cá nhân (Pro/Pro+/Max) mặc định cho user preferences; Business/Enterprise **tắt cho tới khi org/enterprise bật policy** (`github.com/settings/copilot/features`). VS Code có setting cục bộ `chat.copilot.memory.enabled`; CLI interactive mặc định bật, session programmatic phải truyền `--enable-memory`, kiểm bằng `/memory show`. Repo cần write access mới sinh repository facts.
- **Xem lại / xoá:** user preferences ở settings cá nhân (`github.com/settings/copilot/memory`), repository facts ở repo **Settings → Copilot → Memory** (cần write access). Nói "quên cái này đi" chỉ khiến Copilot **downvote** — xoá vĩnh viễn vẫn phải làm trên GitHub. Memory file của **Local harness** là hệ tách biệt (lệnh `Chat: Show Memory Files` thuộc Local, **không tự convert** sang cloud).
- **Hai chi phí phải biết:** memory nạp vào context **tính vào token → AI credits**; fact để đó mà không dùng sẽ **hết hạn** (docs GitHub: mặc định 90 ngày, org/enterprise chỉnh 7–180; docs VS Code ghi 28 ngày — xem `plan-update/07`). Fork **không** copy memory, fact không gộp toàn org.
- **Bản experimental cho team thích file hơn cloud:** `chat.copilot.memory.local.enabled` lưu repository facts vào `.github/copilot-memories.jsonl` trong working tree — **không** có user scope, **không** bị policy GitHub che chở, và **dễ bị commit kèm secret** → review file này như review instructions.

> **Vì sao quan trọng?** Memory tiết kiệm đúng phần tốn kém nhất của instructions: sự thật về repo và về bạn, nạp tự động, không chiếm dòng nào trong file luật. **Nếu làm sai?** Quên kiểm memory: agent "nhớ" quy ước lỗi thời và làm theo, trong khi file luật của bạn nói ngược lại — triệu chứng trông hệt "instructions không ăn". Đừng để secret vào memory cũng như vào instructions: cả hai đều là chỗ người khác đọc được.

## 8. Hiểu nhầm thường gặp

| Hiểu nhầm | Sự thật |
|---|---|
| "3 loại file là một, viết vào đâu cũng được" | 3 phạm vi khác nhau: cả nhà / từng phòng / cả khu phố đa-tool |
| "File tầng cao nhất thắng, lấn các file khác" | Mọi set instructions liên quan **đều vào context**; Personal > Repo > Org chỉ phân xử khi mâu thuẫn; mỗi harness một quy tắc kết hợp |
| "`applyTo: **` cho chắc ăn" | Glob rộng = nạp mọi lúc = tốn credits + áp sai chỗ. Chọn glob hẹp nhất |
| "Copy nguyên `AGENTS.md` sang instructions" | Trùng lặp = trả tiền 2 lần mỗi turn. Chung → AGENTS, riêng → instructions |
| "Ghi lệnh đoán, agent tự sửa khi fail" | Lệnh sai làm cháy credits + loạn context. Mọi lệnh phải PASS tay + ngày VERIFIED |
| "Viết 1 lần là xong mãi mãi" | Toolchain đổi là instructions thành rác — verify lại, ghi ngày mới |
| "Rules chung chung ('viết code sạch')" | Không kiểm chứng được. Viết lại dạng check được: "file >300 dòng thì tách" |
| "Để secret trong instructions" | File này commit vào git — chỉ ghi "lấy từ 1Password `<tên>`", không paste giá trị |

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| Sửa rule rồi test ngay trong chat đang mở | model vẫn làm theo rule cũ → kết luận oan "instructions vô dụng" | mở **chat mới**, kiểm phần **References** |
| Đi tìm một folder trong `~/.copilot/` để đặt "luật org" | docs không có đường dẫn kiểu đó | org instructions quản qua **settings UI trên GitHub**, không phải file |
| Chép lệnh test từ README cũ, agent chạy fail 3 lần | cháy credits, context loạn | chạy tay từng lệnh, chỉ ghi lệnh PASS + ngày VERIFIED |
| `copilot-instructions.md` 500 dòng, copy cả wiki framework | trả tiền cho rác mỗi turn, luật thật chìm | <200 dòng; phần dài đẩy sang `docs/` hoặc skill (bài 05) |

**Bài học:** mọi ca "rule không ăn" giải bằng 3 câu hỏi theo thứ tự: file có được *discovery* không (Customizations editor) → có được *đưa vào* không (References) → có *được tuân* không (rule mơ hồ hay mâu thuẫn).

## Best practices

- **Một sự thật, một nơi ở.** *Vì sao:* hai bản sao sẽ lệch nhau, và không có universal precedence để biết bên nào thắng.
- **Lệnh luôn kèm ngày VERIFIED.** *Vì sao:* instructions cũ hơn toolchain là loại rác đắt nhất — bạn trả credits cho nó mỗi turn.
- **Luật cá nhân để `~/.copilot/`, luật team commit vào repo.** *Vì sao:* chuẩn chỉ mình bạn thấy sẽ chết ngay khi bạn nghỉ phép.
- **Sửa rule là verify lại bằng chat mới + References.** *Vì sao:* chat cũ ôm context cũ — không có cách nào chắc rule được nạp lại.

## Bài tập

1. **(20 phút) Viết từ 0:** mở Customizations editor → tạo `.github/copilot-instructions.md`: thu thập sự thật từ README + package.json, **chạy tay từng lệnh** chỉ giữ lệnh PASS, xếp theo thứ tự mục 6, verify 3 bước mục 3 — 📄 file mẫu: [`templates/.github/copilot-instructions.md`](../templates/.github/copilot-instructions.md) · verify bằng lệnh: [`./examples/01-cai-dat-va-xac-thuc/verify-tong-va-bang-loi.sh`](./examples/01-cai-dat-va-xac-thuc/verify-tong-va-bang-loi.sh).
2. **(15 phút) Tách `applyTo`:** đưa 2 rules chỉ đúng một subtree vào `.github/instructions/` với glob hẹp; test sửa file trong/ngoài subtree; thêm `excludeAgent: "code-review"` vào một file rồi giải thích sự khác biệt.
3. **(10 phút) Dedupe `AGENTS.md`:** chạy `diff` mục 5, gom trùng lặp về một nơi, đo lại `wc -l` cả hai file.
4. **(10 phút) Kiểm memory:** chạy **`Chat: Show Memory Files`**, mở settings Copilot Memory trên GitHub; xoá fact nào đã lỗi thời rồi test lại bằng chat mới.

## Link qua

- Luật thành quy trình nhiều bước → **bài 05** (Agent Skills) · persona đọc instructions → **bài 06** (custom agents) · mọi loại customization trong **Agent Customizations editor** + migrate memory → **bài 17**.
- Tra lệnh: `/instructions` — xem luật đang nạp ([commands/copilot/system-knowledge/instructions/README.md](commands/copilot/system-knowledge/instructions/README.md)) · prompt files kiểu cũ, chỉ chạy ở Local ([commands/local/system-knowledge/prompt-file/README.md](commands/local/system-knowledge/prompt-file/README.md)) · rule cứ không nạp, debug sâu → [commands/copilot/chat-session/troubleshoot/README.md](commands/copilot/chat-session/troubleshoot/README.md).
- Từ Claude Code sang? `CLAUDE.md` ở root là thay thế hợp lệ (mục 5) — bảng so sánh Copilot × Claude Code + token economics: **bài 00** là chủ sở hữu.

## Reference

- VS Code — [Use custom instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions) (nạp + verify, "don't rely on a universal precedence order") · [Custom instructions reference](https://code.visualstudio.com/docs/agents/reference/custom-instructions-reference) (đường dẫn `~/.copilot/`, cách mỗi harness tìm `AGENTS.md`) · [Memory](https://code.visualstudio.com/docs/agents/run/memory) (`Chat: Show Memory Files`)
- GitHub — [Adding repository custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions) (glob `applyTo`, `excludeAgent`, head branch, nearest `AGENTS.md`) · [Adding personal instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-personal-instructions) · [Custom instructions support](https://docs.github.com/en/copilot/reference/custom-instructions-support) (ma trận surface) · [Managing Copilot Memory](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/copilot-memory/manage-for-yourself) và [Copilot Memory](https://docs.github.com/en/copilot/concepts/prompting-and-context/copilot-memory) (mặc định, danh sách surface dùng được memory)
- Chuẩn mở & mẫu: [agents.md](https://agents.md/) · [Customization library — instructions](https://docs.github.com/en/copilot/tutorials/customization-library/custom-instructions)

**Chốt:** instructions không phải wiki — nó là luật: ngắn, kiểm chứng được, lệnh đã chạy tay, và **luật nào cũng phải chứng minh được là agent đang đọc** bằng Customizations editor + References; phần còn lại giao cho skill, agent và memory.
