# Tips 08 — Tiết Kiệm AI Credits: Dùng Copilot Rẻ Mà Vẫn Mạnh

> **Dành cho:** người thấy credits tụt nhanh mà không rõ tiền đi đâu.
> **Vấn đề:** việc gì cũng dùng Agent mode + model mạnh nhất, hết credits giữa tháng.
> **Đọc xong:** route đúng việc sang đúng chế độ/model, prune MCP, đóng gói knowledge base — giảm 30–50% credits mà chất lượng không tụt.
> **Thời gian:** ~20 phút đọc + ~50 phút làm bài tập.

> **Lưu ý billing 2026:** từ **01/06/2026** Copilot chuyển từ "premium requests" (legacy) sang **usage-based billing theo AI Credits**. 1 AI credit = **$0.01**. Tên gọi "premium requests" không còn được dùng.

## 1. Cách tính: AI Credits là gì?

**Bảng gói hiện tại (từ 01/06/2026):**

| Gói | Giá/tháng | Credits gồm sẵn |
|---|---|---|
| Copilot Free | $0 | Giới hạn thấp (credits nhỏ) |
| Copilot Pro | $10 | 1.500 AI credits (base 1.000 + flex 500) |
| Copilot Pro+ | $39 | 7.000 AI credits (base 3.900 + flex 3.100) |
| Copilot Max | $100 | 20.000 AI credits (base 10.000 + flex 10.000) |
| Copilot Business | $19/user | 1.900 AI credits/seat |
| Copilot Enterprise | $39/user | 3.900 AI credits/seat (pooled) |

Credits dùng hết có thể mua thêm; mỗi lượt gọi model trừ theo **số tokens × hệ số của model** (model nhẹ rẻ hơn flagship nhiều). Xem usage: GitHub → Settings → Copilot → Usage; trong Copilot CLI dùng `/limits` để xem/đổi giới hạn credits của phiên.

> Bài cũ nào còn dạy "tiết kiệm premium requests" là legacy — nguyên tắc tiết kiệm giữ nguyên, chỉ đổi đơn vị đo sang AI Credits.

## 2. Vì sao tốn credits?

Ba cách đốt credits nhanh nhất:

- Mọi câu hỏi đều dùng model mạnh nhất + Agent mode, kể cả hỏi vặt.
- 1 chat nuôi 100 turns, mỗi turn gánh rác cũ → mỗi request đắt dần.
- Bật 12 MCP servers/extensions, mỗi request gánh tool defs không dùng.

Thang tốn (rẻ → đắt):

```text
[Rẻ] completions (gợi ý inline, Tab) → chat Ask → chat Edit → Agent → Coding Agent (cloud + CI)
```

Công thức tốn:

```text
Tổng = số turns × (prompt tokens + tools × overhead) × hệ số model
```

Giảm 1 trong 3 là rẻ: **giảm turns** (prompt tốt + plan-first, ít retry); **giảm tokens/turn** (chat gọn + ít attachments + ít MCP); **giảm hệ số model** (việc dễ dùng model nhẹ). Chat gọn xem [Tips 01](./01-context-hygiene.md), prompt tốt xem [Tips 02](./02-prompt-engineering.md).

> Rule: **việc rẻ thì dùng cách rẻ. Credits model mạnh để dành cho plan + implement khó.**

## 3. Model routing: việc nào model nào?

| Việc | Ví dụ | Model | Mode | Vì sao |
|---|---|---|---|---|
| Gợi ý inline, boilerplate | Gõ `function sum(` + Tab | Nhẹ / auto | Completions | Rẻ, nhanh, đủ đúng |
| Giải thích hàm, hỏi docs | `retryWithBackoff` làm gì? | Nhẹ | Ask | Không cần reasoning nặng |
| Fix 1 hàm rõ ràng | Fix `normalizeEmail` crash dấu | Trung bình | Edit | Đủ sức, ít tốn |
| Feature multi-files, refactor | Refactor auth 800 dòng 5 files | Mạnh | Agent + plan | Đáng tiền, tránh retry |
| Review khó, kiến trúc | Review PR payments | Mạnh | Ask/Reviewer fresh | Cần reasoning tốt nhất |
| Việc nền độc lập 2 giờ | Issue rate-limit | — | Coding Agent | Đắt nhưng bạn làm việc khác |

**Ví dụ 1 — Đặt default nhẹ (copy-paste setup):**

```text
VS Code → Settings → Copilot:
- Default chat model: nhẹ/auto (dùng hằng ngày).
- Chỉ chuyển sang mạnh khi: plan feature, refactor, review khó.
- Completions: luôn bật, Tab để nhận, Esc để bỏ.
# Kỳ vọng: 80% chat hằng ngày chạy model nhẹ, chỉ thay khi thật sự cần.
```

**Ví dụ 2 — Khi nào KHÔNG tiếc credits:**

```text
ĐÁNG tiền:
- 1 turn plan mạnh tránh 10 turns sửa sai.
- 1 review mạnh bắt được HIGH bug trước prod.
- Research repo lạ bằng model mạnh 1 lần rồi ghi file.

KHÔNG đáng:
- Hỏi vặt "hàm này là gì" bằng Agent mạnh.
- Retry lần 5 cho prompt ẩu (sửa prompt thay vì đốt tiếp).
- @workspace cả repo cho câu hỏi 1 file.
```

## 4. Completions vs Chat vs Agent

| Tiêu chí | Completions (Tab) | Chat (Ask/Edit) | Agent |
|---|---|---|---|
| Tốn credits | ~0 (rẻ nhất) | Thấp (1 turn) | Cao (turn + tool calls + retry) |
| Sửa code | Không — chỉ chèn gợi ý | Edit 1 chỗ | Đa file + chạy lệnh |
| Phạm vi | 1 dòng đang gõ | 1 file/đoạn bôi đen | Nhiều file + terminal |
| Khi nào dùng | Boilerplate, import, test lặp | Hỏi/lý giải, fix 1 chỗ | Task >2 steps, multi-files, cần test |
| Tránh khi | Cần reasoning/đa file | Multi-files phức tạp | Hỏi vặt, task <15 phút Edit xong |

**Completions — Tab là vua:**

```text
Thay vì chat: "viết hàm cộng 2 số" (1 request)
Hãy gõ: `function sum(` → Tab → xong (gần như 0 credits).

Thay vì chat: "viết 10 test cases CRUD" (đắt)
Hãy gõ 1 case mẫu → Tab Tab Tab → sửa số liệu.
```

**Agent — gate trước khi bật (checklist):**

```text
- [ ] Có plan.md duyệt chưa? Chưa → Ask plan trước (rẻ hơn).
- [ ] Scope ≤5 files? Chưa → thu hẹp.
- [ ] Có verify + NEVER? Chưa → thêm vào prompt.
- [ ] Task <15 phút Edit xong? → đừng bật Agent.
```

Ba chế độ chênh nhau cả chục lần về chi phí — chọn đúng chế độ tiết kiệm nhiều hơn mọi mẹo tối ưu prompt.

## 5. Prune MCP/extensions + chat gọn

**Prune checklist (mỗi tháng 1 lần):**

```text
1. Extensions → Copilot/MCP related: tắt cái 2 tuần không dùng.
2. MCP servers: giữ ≤6, tắt server không nhớ tác dụng.
3. Thiếu thì bật lại, đừng bật sẵn "cho chắc".
```

**3 thói quen rẻ:**

```text
1. 1 task 1 chat, xong → New Chat (đừng nuôi 100 turns).
2. Ưu tiên #file/#selection, hạn chế @workspace cả repo.
3. Log dài → paste vào file, chat chính chỉ nhận summary 5 bullet.
```

**Đo và so:** ghi số chats, turns/chat, số @workspace, số retries vì prompt ẩu tuần này; áp routing + prune tuần sau; so 2 cột trước/sau.

## 6. Đóng gói tri thức: trả 1 lần, dùng mãi

Paste spec 200 dòng vào 20 chats = trả 20 lần. Đưa vào file dùng chung = trả 1 lần:

- **Knowledge base** (Repo → Settings → Copilot → Knowledge bases; nguồn docs/, wiki, ADRs). Hỏi: `@payments-docs Chính sách refund 30 ngày? Kèm link nguồn, 3 bullet.` → không paste spec, không quét repo.
- **Instructions** thay paste NEVER mỗi chat — mọi chat tự áp luật từ `.github/copilot-instructions.md`.
- **Skills** thay gõ lại prompt (chuẩn 2026): `.github/skills/team-bug/SKILL.md` — nói "fix bug" là tự load; prompt files `.prompt.md` legacy chỉ chạy Local. Xem [Tips 07](./07-thiet-ke-prompts-skills.md).

Cẩn thận: đóng gói sai chỗ (nhét cả checklist dài vào instructions) thì nạp lại mỗi turn — càng tốn hơn.

## 7. Walkthrough: audit usage trong 50 phút

| Phút | Việc | Làm gì |
|---|---|---|
| 0–5 | Xem usage | Settings → Copilot → Usage: ngày nào tốn nhất? Model nào? Agent vs chat? |
| 5–15 | Phân loại | Ghi 10 turns gần nhất: mấy hỏi vặt bằng Agent? mấy retry vì prompt ẩu? mấy @workspace rộng? |
| 15–25 | Routing | Đặt default model nhẹ, completions ON, mạnh chỉ cho plan/review/refactor. Bảng routing dán wiki |
| 25–35 | Prune | Tắt extensions/MCP thừa, bật tool approval, thu gọn instructions <200 dòng |
| 35–45 | Đóng gói | Lưu 2 skills/prompts dùng nhiều nhất, tạo knowledge base cho docs hay paste |
| 45–50 | Đo lại | Tuần sau so credits/tuần + số retry + chất lượng (test xanh? review PASS?) |

## 8. Bảng tra nhanh: tốn bao nhiêu?

| Cách làm | Tốn tương đối | Cách rẻ hơn |
|---|---|---|
| Completions Tab | ★☆☆☆☆ | Luôn ưu tiên trước |
| Chat Ask nhẹ | ★★☆☆☆ | Dùng #selection, không @workspace |
| Chat Edit | ★★☆☆☆ | Bôi đen hẹp, không Agent |
| Chat Agent | ★★★★☆ | Plan duyệt + scope hẹp + giới hạn 3 lần đỏ |
| Coding Agent cloud | ★★★★★ | Chỉ khi spec rõ + done checklist |
| @workspace cả repo | +★★ | 1 lần rồi ghi file, sau đó đọc file |
| MCP 12 servers | +★★ | Prune ≤6, tắt auto-approve write |
| Retry prompt ẩu ×5 | ×5 | Sửa prompt (scope+verify+NEVER) rồi mới retry |

> Quy tắc ngón tay: **Tab trước, Ask/Edit sau, Agent khi đáng, Coding Agent khi rảnh tay làm việc khác.**

## 9. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Mọi việc đều Agent mạnh | Hết credits giữa tháng | Routing mục 3, default nhẹ |
| Nuôi chat 100 turns | Mỗi request đắt dần | New chat mỗi task (Tips 01) |
| @workspace mọi câu | Tốn + chậm + lạc | #file/#selection, @workspace chỉ explore |
| Prompt ẩu → retry 5 lần | Đốt 5× cho 1 việc | Sửa prompt rồi retry, max 3 lần đỏ thì dừng |
| 12 MCP/extensions | Overhead mọi turn | Prune ≤6, audit monthly |
| Paste spec 20 lần | Trả 20 lần cho 1 nội dung | Knowledge base + instructions |
| Giao Coding Agent việc 15 phút | Đắt + chờ lâu | Edit local nhanh hơn |
| Tắt completions | Mọi việc đều thành chat | Bật completions, Tab trước khi chat |
| Không đo usage | Không biết tốn đâu | Xem usage weekly, audit 50 phút mục 7 |

## 10. So sánh với Claude Code

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Cơ chế tính tiền | AI Credits (1 credit = 0,01 USD), trừ theo model × token | Gói subscription (Pro/Max) theo cửa sổ usage | Copilot trả theo mức dùng, Claude theo hạn mức gói |
| Completions (Tab) | Có, gần như miễn phí credits | Không phải trọng tâm | Copilot có "vua" gõ code từng dòng |
| Chọn model | Đổi ngay trong Chat: GPT / Claude / Gemini | `/model` trong nhóm model Anthropic | Copilot cho chọn nhiều nhà cung cấp hơn |
| Giữ context gọn | New Chat + `#file`/`#selection` | `/clear` + `/compact` | Cùng mục tiêu: đừng nuôi phiên quá dài |
| Đóng gói tri thức | Knowledge base + copilot-instructions.md | `CLAUDE.md` + file trong `.claude/` | Viết 1 lần, tái dùng nhiều lần |
| Prune công cụ ngoài | MCP servers (giữ ≤6) | MCP servers trong `.mcp.json` | Cả hai cần prune để giảm overhead |

> Nguyên tắc tối ưu giống hệt nhau — chỉ khác đơn vị đo tiền. Copilot đo bằng AI Credits từng lượt nên "thấy" được tiền đi đâu; Claude Code đo bằng hạn mức gói nên càng phải kiểm soát bằng thói quen.

## 11. Bài tập cuối bài

**Bài 1 (10 phút):** Liệt kê 10 lần dùng Copilot gần nhất, gắn mỗi lần 1 ô (completions/Ask/Edit/Agent/Coding Agent), đánh dấu mấy lần dùng đắt hơn cần → viết lại cách rẻ hơn.

**Bài 2 (20 phút):** Liệt kê MCP + extensions đang bật, tắt cái 2 tuần không dùng. Rút gọn instructions <200 dòng, đặt default model nhẹ.

**Bài 3 (15 phút):** Lấy prompt dài bạn gõ >2 lần/tuần, lưu thành skill/prompt file. Tạo 1 knowledge base cho docs hay paste nhất. Tuần sau so credits: giảm? retry giảm? chất lượng giữ?

> Đạt: giảm 30–50% credits/tuần mà test xanh + review PASS không giảm.

## Tham khảo chéo

- [Tips 01](./01-context-hygiene.md) — chat gọn rẻ hơn nhiều lần
- [Tips 02](./02-prompt-engineering.md) — prompt tốt ít retry
- [Tips 03](./03-plan-first-workflow.md) — 1 turn plan tránh 10 turns sai
- [Tips 06](./06-policies-guardrails-recipes.md) — prune MCP + approval
- [Tips 07](./07-thiet-ke-prompts-skills.md) — knowledge base + prompt files
- [00 — Tổng quan: AI Credits](../01-huong-dan-su-dung/00-tong-quan-copilot.md) — bảng giá + cách tính
- [08 — MCP](../01-huong-dan-su-dung/08-mcp-ket-noi-cong-cu-ngoai.md) — prune ở đâu, giữ mấy servers

> **Chốt Tips 08:** credits không mất vì bạn dùng Copilot nhiều, mà vì bạn dùng *sai cỡ việc*. Giữ đúng thứ tự Tab → Ask/Edit → Agent → Coding Agent, và đóng gói những gì lặp lại — tiết kiệm gần một nửa mà chất lượng đầu ra không đổi.
