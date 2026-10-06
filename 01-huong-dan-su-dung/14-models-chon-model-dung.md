# 14 — Models: Chọn Model Đúng (GPT-5.x / Claude / Gemini / o-series Trên Copilot)

> Bài 14 series 01. Đọc xong bạn chọn đúng model cho từng task trong model picker,
> hiểu premium requests multiplier, cấu hình BYOK/policy cho enterprise, và không
> còn trả model đắt cho việc model rẻ làm được. Thời gian: ~40 phút.

## Mục lục

1. [Vì sao chọn model? (why)](#1-vì-sao-chọn-model-why)
2. [Bản đồ models trên Copilot 2026](#2-bản-đồ-models-trên-copilot-2026)
3. [Model picker: đổi ở đâu, ảnh hưởng gì](#3-model-picker-đổi-ở-đâu-ảnh-hưởng-gì)
4. [Premium requests multiplier (tiền thật)](#4-premium-requests-multiplier-tiền-thật)
5. [BYOK + enterprise policy: gate model cho team](#5-byok--enterprise-policy-gate-model-cho-team)
6. [Khi nào dùng model nào (bảng dán tường)](#6-khi-nào-dùng-model-nào-bảng-dán-tường)
7. [Route theo phase + agent routing](#7-route-theo-phase--agent-routing)
8. [Walkthrough end-to-end (20 phút)](#8-walkthrough-end-to-end-20-phút)
9. [Pitfalls + fix](#9-pitfalls--fix)
10. [Bài tập](#10-bài-tập)
11. [Link chéo](#11-link-chéo)

---

## 0. Giải ngố thuật ngữ (1 câu + analogie + verify)

| Thuật ngữ | Hiểu nôm na (1 câu) | Analogie | Ví dụ kỹ thuật thật | Verify |
|---|---|---|---|---|
| **Model picker** | Nút chọn "bộ não" cho từng chat (rẻ/đắt khác nhau). | Như chọn xe: xe đạp (mini) đi chợ, xe tải (flagship) chở nhà. | Chat view → dropdown góc dưới → `GPT-5.x / Claude Sonnet / Gemini Pro / mini`. | Đổi model → chat mới hiện tên model mới trên header. |
| **Premium request multiplier** | Hệ số nhân tiền: model đắt tốn gấp nhiều lần model rẻ. | Như giá điện giờ cao điểm ×3 — bật điều hòa flagship là hóa đơn bốc. | Mini ×0–0.5, Mid ×1, Flagship ×2–3, Reasoning ×3–5 (khung, tra billing exact). | Billing → Copilot usage xem % đã dùng + tốc độ hết tháng. |
| **Flagship (GPT-5.x / Opus-tier)** | Bộ não mạnh nhất, hợp việc khó mơ hồ. | Như giáo sư: hỏi khó mới cần, hỏi đường thì phí. | Thiết kế migrate auth 5 files, debug stuck 1h. | Task khó: flagship 1 lần đúng; mini thử 3 lần vẫn sai. |
| **Reasoning (o-series)** | Bộ não nghĩ lâu, hợp toán/logic/race khó. | Như ngồi thiền 30 phút để giải toán khó — đừng nhờ mua rau. | Tối ưu query, race condition, thuật toán. | Latency cao rõ (chờ lâu) nhưng chain-of-thought dài. |
| **BYOK / Model gating** | Công ty tự mang chìa khóa + khóa tủ: ai được dùng model nào. | Như bố giữ két: con nhỏ chỉ lấy ngăn mini, anh lớn mới mở ngăn flagship. | Interns chỉ mini+mid, seniors mới flagship (Org Settings → Policies). | Mở picker → model bị cấm phải không hiện. |

---

## 1. Vì sao chọn model? (why)

Model mạnh nhất không phải lúc nào cũng là model đúng. Mỗi task có 3 chiều cần
cân: **chất lượng suy luận — tốc độ — chi phí (premium requests)**. Dùng sai chiều
là mất quota hoặc mất thời gian:

- Dùng model reasoning đắt sửa typo → tốn gấp 5–10 lần mà kết quả y hệt model rẻ.
- Dùng model mini thiết kế kiến trúc → thiếu depth, refactor 3 lần vẫn sai, tổng
  quota cao hơn 1 lần model mạnh đúng ngay.
- Không hiểu multiplier → shock khi quota tháng hết sau 1 tuần agent mode (mục 4).

Nguyên tắc vàng:

```text
Task khó, mơ hồ, hậu quả lớn → model mạnh (GPT-5.x / Claude Sonnet-Opus / Gemini Pro).
Task rõ ràng, lặp lại, khối lượng lớn → model rẻ + nhanh (mini/flash/haiku-tier).
Không bao giờ default model đắt nhất — chỉ gọi đích danh khi cần reasoning sâu.
```

### 1.1. Sơ đồ route model 30 giây (mermaid)

```mermaid
flowchart TD
    A[Task mới] --> B{Khó + mơ hồ + hậu quả lớn?}
    B -->|Cả 3 Có| C[Flagship GPT-5.x / Opus]
    B -->|Không| D{Cần context khổng lồ?}
    D -->|Có, monorepo| E[Gemini Pro long-context]
    D -->|Không| F{Cần văn tinh tế / review wording?}
    F -->|Có| G[Claude Sonnet-tier]
    F -->|Không| H{Toán/logic/race khó?}
    H -->|Có| I[o-series reasoning]
    H -->|Không| J[Mini/Flash-tier rẻ]
    C --> K{Stuck >30p?}
    J --> K
    K -->|Vẫn stuck| L[Leo 1 nấc: mini→mid→flagship→reasoning]
    K -->|Xong| M[Ghi log: task X tier nào đủ]
```

Giải thích từng bước:

1. **A → B:** Checklist 3✓ mục 2.2 (nhiều steps + đã thử rẻ mà fail + sai là đau) — đủ 3 mới flagship.
2. **B → C:** Flagship cho thiết kế/refactor multi-file, migration prod, debug stuck.
3. **D → E:** Monorepo hỏi rộng ("tóm tắt cả package") → Gemini long-context thay vì nhét 20 files vào flagship.
4. **F → G:** Docs, PR description, review wording bị GPT chê "quá máy" → đổi Claude.
5. **H → I:** Thuật toán/query/race cần thinking dài → o-series, chấp nhận chờ lâu.
6. **Mặc định J:** Autocomplete, rename, CRUD, test, explore 5 hướng song song → mini rẻ nhất.
7. **K → L:** Stuck thì leo thang, không nhảy cóc mini→reasoning (đốt quota).
8. **M:** Ghi 1 dòng team wiki để lần sau route đúng ngay.

> ✅ **Kỳ vọng thấy gì:** đổi model ở picker → header chat hiện tên mới. Billing usage sau 1 tuần cho thấy flagship <30% requests (nếu >50% là routing hỏng).

- Quản lý: model picker đổi mỗi chat; org policy gate models cho team (mục 5);
  cost thực tế: usage dashboard (bài 13) sau mỗi tuần.

---

## 2. Bản đồ models trên Copilot 2026

> Danh sách model đổi theo quý — tra model picker thực tế, đừng học thuộc lòng.
> Bảng dưới là khung phân loại để bạn route đúng, không phải catalog bất biến.

### 2.1. Bảng tổng (vai trò, không phải giá tuyệt đối)

| Nhóm | Hiểu nôm na | Ví dụ trên picker | Ví dụ task nên dùng | Vai trò |
|---|---|---|---|---|
| **GPT-5.x (flagship)** | Giáo sư toàn diện — khó gì cũng nghĩ được. | GPT-5.x, GPT-5.x-codex | Plan migrate auth 5 files; debug stuck 1h. | Suy luận sâu, agent multi-step, refactor lớn |
| **o-series (reasoning)** | Nhà toán học trầm ngâm — chậm mà sâu. | o1/o3/o4-tier | Tối ưu query N+1, race condition retry. | Toán/logic khó, debug stuck, cần chain-of-thought dài |
| **Claude trên Copilot** | Nhà văn tinh tế — viết hay, review khéo. | Claude Sonnet/Opus-tier | Viết docs, PR description, review wording giữ style. | Viết + giải thích code dài, docs, review tinh tế |
| **Gemini trên Copilot** | Thủ thư nhớ cả thư viện — context khổng lồ. | Gemini Pro/Flash-tier | Tóm tắt cả `apps/api`, hỏi xuyên monorepo. | Context rất dài, retrieve monorepo, task đa ngữ |
| **Mini/Flash-tier (rẻ)** | Xe ôm nhanh rẻ — việc nhỏ gọi ngay. | GPT-mini, Flash, Haiku-tier | Autocomplete, rename, CRUD, 5 chats explore song song. | Việc hàng ngày: complete, test, CRUD, explore |

### 2.2. GPT-5.x — flagship mặc định khi cần depth

```text
GPT-5.x: mạnh toàn diện, hợp agent mode multi-step (plan → edit → test → fix).
Dùng cho: thiết kế, refactor multi-file, debug khó, review quan trọng.
Giá quota: multiplier cao (mục 4) — đừng dùng sửa typo.
```

Khi nào gọi flagship (checklist):

```text
✓ Task kéo dài nhiều steps, cần coherence xuyên suốt?
✓ Đã thử model rẻ mà stuck / quality chưa đạt?
✓ Hậu quả sai cao (migration prod, security-critical)?
→ Cả 3 ✓ thì flagship. Thiếu 1 thì thử tier giữa trước đã.
```

### 2.3. o-series — reasoning, chậm mà sâu

```text
o-series: thinking dài, latency cao, hợp bài toán logic/toán/constraints khó
(thuật toán, query tối ưu, debug race condition). KHÔNG hợp: chat nhanh, sửa
lặt vặt (chờ lâu, tốn quota), task cần đọc context khổng lồ.
```

### 2.4. Claude / Gemini trên Copilot — khi nào đổi nhà

```text
Claude-tier: mạnh viết lách + giải thích (docs, PR description, review comments
tinh tế, refactor giữ style). Đổi sang khi GPT trả lời cộc/quá "máy".

Gemini-tier: context window rất dài → monorepo khổng lồ, "tóm tắt cả package",
task cross-file rộng. Đổi sang khi model khác kêu thiếu context.
```

### 2.5. Mini/Flash-tier — việc nhỏ + fan-out

```text
Mini/Flash: rẻ nhất, nhanh nhất. Việc nhỏ (autocomplete, rename, grep/explore,
tóm tắt, classify) + fan-out: 5 prompt explore song song rẻ hơn 1 flagship mà
cover rộng hơn. Lưu ý: context + reasoning yếu hơn — đừng giao kiến trúc.
```

---

## 3. Model picker: đổi ở đâu, ảnh hưởng gì

```bash
# Đổi model (3 chỗ):
# 1. Chat view → model picker (dropdown góc dưới) → chọn mỗi chat mới.
# 2. Inline completions: model riêng (settings: github.copilot.completions model).
# 3. Agent coding (github.com assign issue): model chọn lúc tạo job.
```

```text
# Quy tắc đổi model (giữ 3 điều):
# 1. Đổi theo PHASE, không đổi giữa chừng 1 phase (đỡ mất context/cache).
#    plan (mạnh) → implement (rẻ) → stuck thì leo lên (mục 7).
# 2. Mỗi chat mới = cơ hội chọn lại (đừng để flagship dính từ chat cũ sang typo mới).
# 3. Sau 1 tuần: dashboard model nào ngốn % (bài 13) → adjust default team.
```

```jsonc
// .vscode/settings.json — default gợi ý cho team (commit, copy-paste khung):
{
  // Model completions rẻ cho inline (tiết kiệm quota):
  // "github.copilot.chat.model": "gpt-mini-tier", // tên exact tra picker thực tế
  // "github.copilot.completions.model": "gpt-mini-tier"
}
```

> Tên model exact đổi theo quý — mở picker copy tên thật, đừng gõ từ trí nhớ
> rồi kêu "model not found".

---

## 4. Premium requests multiplier (tiền thật)

### 4.1. Vì sao quota hết nhanh hơn bạn nghĩ

```text
Copilot tính quota theo "premium requests": mỗi request × multiplier của model.
Model flagship/reasoning multiplier cao gấp nhiều lần mini-tier.
Agentic = mỗi step 1 request → agent 50 steps × flagship = quota bốc hơi.
Không hiểu multiplier → hết quota tuần 1, 3 tuần còn lại dùng model base.
```

### 4.2. Bảng multiplier minh họa (khung — tra docs hiện hành)

| Tier | Hiểu nôm na | Ví dụ model | Multiplier minh họa | Ví dụ task nên dùng | Nghĩa thực tế |
|---|---|---|---|---|---|
| Mini/Flash-tier | Trà đá — uống tẹt không xót. | GPT-mini, Flash, Haiku | ×0 – ×0.5 | Sửa typo, rename, explore 5 hướng. | Hỏi tẹt ga, tốn ít |
| Mid-tier (Sonnet/Pro/GPT-4o-class) | Cơm văn phòng — ngày nào cũng ăn. | Sonnet, GPT-4o-class, Pro | ×1 | Implement theo plan, CRUD, test. | Chuẩn 1 request = 1 |
| Flagship (GPT-5.x / Opus-tier) | Nhà hàng — ngon mà đắt, tuần 1 lần. | GPT-5.x, Opus-tier | ×2 – ×3+ | Plan kiến trúc, refactor 5 files. | Mỗi câu đắt gấp 2–3 lần |
| Reasoning (o-series deep) | Tiệc cưới — chỉ khi đại sự. | o-series deep | ×3 – ×5+ | Race condition, thuật toán khó. | Suy luận dài, đắt nhất |

> Số trên là KHUNG minh họa để hiểu cơ chế — tra docs/billing page số exact quý
> hiện tại. Cơ chế (đắt theo tier + agentic nhân steps) thì không đổi.

### 4.3. Giữ quota sống hết tháng (thực hành)

```text
1. Default chat = tier giữa/rẻ. Flagship chỉ đích danh khi checklist mục 2.2 đủ 3 ✓.
2. Agent mode + flagship là combo đốt quota nhanh nhất → agent thì tier giữa trước,
   stuck mới leo (mục 7).
3. Explore fan-out bằng mini (5 prompt rẻ) thay vì nhét 20 files vào flagship chat.
4. Cuối tuần: dashboard premium requests by model (bài 13) → model nào > 50% thì gate.
```

```bash
# Kiểm tra quota còn bao nhiêu (đừng đoán — xem thật):
# VS Code → Copilot status bar / github.com → Settings → Billing → Copilot usage
# → ghi: đã dùng ?% premium requests, ngày ?/30. Tốc độ này có sống hết tháng không?
```

---

## 5. BYOK + enterprise policy: gate model cho team

- **BYOK (Bring Your Own Key) là gì?** Enterprise dùng Azure/OpenAI key riêng cho
  Copilot thay vì GitHub-hosted models — data residency + billing riêng + model
  allowlist công ty. Hỏi admin bạn có BYOK không trước khi assume data đi đâu.
- **Model gating (policy)**: admin cấm/bật models theo team (interns chỉ mini+mid,
  seniors mới flagship; team payments cấm model X...).

```text
# Checklist admin gate model (github.com → Org/Ent Settings → Copilot → Policies):
[ ] Model allowlist: team nào × models nào (đừng all-access ngày đầu)
[ ] Flagship: bật cho seniors/leads, tắt cho interns/bot accounts
[ ] Reasoning tier: tắt default, mở theo request (đắt + chậm, ít người cần)
[ ] Review hàng tháng: dashboard by-model (bài 13) → siết/nới 1 model
[ ] BYOK (nếu có): key rotation lịch + endpoint region đúng compliance
```

```bash
# Verify policy có hiệu lực (máy dev, làm 1 lần):
# 1. Mở model picker → model bị cấm phải KHÔNG hiện (hiện là policy hỏng).
# 2. Hỏi admin: "team tôi được models nào?" → đối chiếu picker (lệch thì báo).
```

```text
# Template đề xuất model cho team mới (paste vào team wiki):
# Default: mid-tier · Agent: mid-tier · Flagship: khi checklist 3✓ (mục 2.2)
# Mini: autocomplete + explore · Reasoning: debug stuck > 1h mới mở
# Review quota mỗi thứ 2 (15 phút, bài 13 mục 7.3).
```

---

## 6. Khi nào dùng model nào (bảng dán tường)

| Task | Hiểu nôm na | Ví dụ cụ thể | Model | Vì sao |
|---|---|---|---|---|
| Thiết kế kiến trúc, plan multi-file | Vẽ bản đồ trước khi xây nhà. | Plan migrate `auth.ts` 900 dòng → 3 modules. | Flagship (GPT-5.x / Opus-tier) | Quyết định đắt nhất → model mạnh |
| Debug stuck > 30 phút | Kẹt 1 chỗ 30 phút không ra. | `normalizeEmail` crash email có dấu, thử 3 cách fail. | Flagship → reasoning nếu vẫn stuck | Cần depth, không cần tốc độ |
| Implement theo plan đã duyệt | Bản đồ có rồi, chỉ việc xây. | Implement step 1–3 của `plan.md` refund. | Mid-tier | Rõ ràng → vừa đủ + tiết kiệm |
| Viết test, docs, CRUD | Việc tay chân lặp lại. | Viết 10 test CRUD `payments`. | Mini/Mid-tier | Cơ học, khối lượng lớn |
| Explore codebase, grep, tóm tắt | Đi trinh sát 5 hướng cùng lúc. | 5 chats mini mỗi chat 1 module `auth/db/api`. | Mini/Flash-tier | Rộng + nhanh + rẻ |
| Format, rename, classify | Dọn nhà, đổi tên nhãn. | Rename `userId` → `user_id` 20 files. | Mini-tier | Flagship làm cũng vậy mà đắt nhiều lần |
| Context khổng lồ (monorepo) | Đọc cả thư viện 1 lần. | Tóm tắt cả `apps/api` 500 files. | Gemini-tier (long context) | Cửa sổ context rộng nhất |
| Giải thích tinh tế, review wording | Viết thư xin việc, cần văn hay. | PR description refund + review comments. | Claude-tier | Văn + style tốt hơn |
| Thuật toán/logic khó | Giải toán Olympic. | Tối ưu query N+1, retry backoff. | o-series reasoning | Thinking dài, đừng vội |
| Demo live cần nhanh | Diễn sân khấu, không được ấp úng. | Demo sprint review 5 phút. | Mid-tier nhanh | Reasoning chậm làm demo chết |

> ✅ **Kỳ vọng thấy gì:** sau 1 tuần chạy bảng này, billing cho thấy mini/mid chiếm >70% requests, flagship <30% — quota sống hết tháng.

### Hiểu nhầm thường gặp (file 14)

- **Hiểu nhầm:** "Model mạnh nhất là tốt nhất cho mọi task." → **Thật ra:** flagship sửa typo cũng ra chữ y hệt mini mà tốn ×3. Verify: cùng task typo chạy mini vs flagship, so output + thời gian.
- **Hiểu nhầm:** "Tên model học thuộc 1 lần dùng mãi." → **Thật ra:** tên đổi theo quý. Luôn copy exact từ picker, đừng gõ từ trí nhớ.
- **Hiểu nhầm:** "Agent + flagship từ đầu cho chắc." → **Thật ra:** đây là combo đốt quota nhanh nhất (50 steps × ×3). Agent mid trước, stuck mới leo.

---

## 7. Route theo phase + agent routing

### 7.1. Nguyên tắc route (3 câu)

```text
1. Plan đắt, execute rẻ: flagship plan + mid/mini implement là default task > 3 files.
2. Fan-out rẻ, main đắt: explore đẩy mini, chat chính giữ mid/flagship.
3. Stuck thì leo thang: mini 2 lần → mid → flagship → reasoning. Ghi lý do để lần
   sau route đúng ngay.
```

### 7.2. Kịch bản route mẫu (copy-paste)

```text
# Kịch bản A — feature multi-file (default team):
# Chat 1 (flagship): "plan migrate auth sang session, steps + risks, KHÔNG code"
# Chat 2 mới (mid-tier): "implement step 1–3 của plan trên" (+ paste plan vào)
# Stuck > 30p → chat 3 (flagship/reasoning): "đang stuck ở X, log Y, gợi ý?"

# Kịch bản B — explore rẻ:
# 5 chat mini song song, mỗi chat 1 hướng (auth, db, api, tests, docs) →
# gom vào chat chính (mid) quyết định. Đừng nhét 20 files vào 1 flagship chat.

# Kịch bản C — review quan trọng:
# Claude-tier review wording + flagship review logic (2 pass, 2 điểm mạnh khác nhau)
```

---

## 8. Walkthrough end-to-end (20 phút)

**Phút 0–5 (baseline quota):**

```bash
# Mở billing usage → ghi % premium requests đã dùng + ngày hiện tại.
# Mở model picker → liệt kê models team bạn có (chụp màn hình cho team wiki).
```

**Phút 5–12 (cùng task, 3 tiers):**

```text
# Lấy 1 task nhỏ thật. Chạy 3 chats mới: mini → mid → flagship.
# Ghi quality + thời gian + (ước tính) requests mỗi tier.
# Kết luận: tier nào là "đủ"? (kỳ vọng: mini/mid đủ cho task rõ)
```

**Phút 12–17 (route theo phase):**

```text
# Lấy 1 task 3+ files: chat flagship plan (không code) → chat mới mid implement.
# So với lần trước làm full-flagship: quality tương đương? quota nhẹ hơn?
```

**Phút 17–20 (gate check):**

```bash
# Picker còn model nào team không nên có? → note đề xuất admin (mục 5).
# Ghi 1 dòng team log: "task X: mini đủ / mid đủ / cần flagship vì Y".
```

---

## 9. Pitfalls + fix

| Pitfall | Vì sao | Fix |
|---|---|---|
| Default flagship mọi chat | Quota nổ tuần 1, 3 tuần sau hẻo | Default mid/mini, flagship đích danh khi đủ 3✓ |
| Ở lì flagship cả task dài | Phần cơ học trả giá flagship | Chia phase: plan đắt + execute rẻ (mục 7) |
| Mini cho task kiến trúc | Thiếu depth, refactor 3 lần | Plan flagship trước, execute mới rẻ |
| Reasoning cho chat nhanh | Chờ lâu, tốn quota, cáu | Reasoning chỉ debug/logic khó, chat thường dùng mid |
| Gõ tên model từ trí nhớ | `model not found` (tên đổi theo quý) | Copy tên exact từ picker hiện tại |
| Agent + flagship từ đầu | Combo đốt quota nhanh nhất | Agent mid trước, stuck mới leo flagship |
| Nhìn tên model mà quên multiplier | Shock bill (agentic × steps × multiplier) | Xem usage dashboard hàng tuần (bài 13) |
| Policy gate nhưng không verify | Model cấm vẫn hiện, team dùng lậu | Check picker + hỏi admin đối chiếu (mục 5) |
| Không review quota hàng tuần | Ngốn cả tháng mới biết | Block 15 phút thứ 2 (bài 13 mục 7.3) |

---

## 10. Bài tập

**Bài 1 (15 phút — 3 tiers, 1 task):**

1. Cùng 1 task nhỏ, chạy 3 chats (mini → mid → flagship). Ghi quality + thời gian.
2. Tier nào là "đủ"? Viết 1 câu lý do vào team wiki.

**Bài 2 (15 phút — plan đắt/execute rẻ):**

1. Task 3+ files: chat flagship plan (không code) → chat mới mid implement.
2. So quality + cảm nhận quota với lần làm full-flagship trước đây.

**Bài 3 (15 phút — reasoning + long-context):**

1. Lấy 1 bug logic khó: thử mid 15 phút → stuck thì reasoning, ghi khác biệt.
2. Lấy 1 task monorepo rộng: thử Gemini-tier retrieve, so với mid (đủ context không?).

**Bài 4 (10 phút — quota audit):**

1. Mở billing usage: % đã dùng, tốc độ này sống hết tháng không?
2. Liệt kê models picker vs policy team (mục 5) — lệch chỗ nào thì báo admin.

> Đạt: nói được "task này tier nào đủ + vì sao" cho 5 task mẫu, quota sống hết
> tháng, team có default model bằng văn bản.

---

## 11. Link chéo

- **Bài 04 — Chat commands toàn tập**: model picker đổi ở đâu, công thức 5 lệnh đầu.
- **Bài 06 — Custom agents & Agent mode**: agent nào × model nào, fan-out mini rẻ.
- **Bài 07 — Policies/guardrails**: gate models + content exclusion cho org.
- **Bài 10 — Modes/Permissions**: Ask/Edit/Agent + approval trước khi agent đốt quota.
- **Bài 12 — Copilot SDK/CI**: pin model trong pipeline để CI không đổi behavior.
- **Bài 13 — Indexing & Telemetry**: dashboard by-model/by-user, vòng lặp 15 phút/tuần.
- **Bài 15 — Security 5 tầng**: model policy là tầng 5, exclusion là tầng 1.
- **Bài 16 — Extensions/MCP validate**: tools ngoài có tuân thủ model policy không?
