# FAQ 02 — Model, Context & Premium

> **Dành cho:** dev đã dùng Copilot Chat/Agent và muốn kiểm soát chi phí, chọn đúng model, giữ context gọn.
> **Vấn đề:** "model picker chọn gì, chi phí AI Credits tính ra sao, context window bao nhiêu, BYOK được không" — mỗi câu trả lời theo khuôn cố định.
> **Đọc xong:** biết chọn model nào cho việc nào, khi nào tốn Credits, giữ context sao cho không bị cắt. **Thời gian:** ~12 phút đọc.

File này trả lời mọi câu hỏi "model picker chọn gì, AI Credits tính tiền thế nào, context window bao nhiêu, BYOK được không". Mỗi câu có giải thích + lệnh copy-paste + ví dụ + khi nào áp dụng.

---

## Sơ đồ tư duy nhanh (đọc 30 giây)

Section này trả lời: từ 1 task, bạn quyết định model nào và làm sao khi context sắp tràn — theo 3 nhánh của sơ đồ.

```mermaid
flowchart TD
    A[Task toi] --> B{Kho?}
    B -->|Nhe: explain/doc| C[Model re - tiet kiem]
    B -->|Kho: agent/kien truc| D[Model manh]
    C --> E[Gan scope gon]
    D --> E
    E --> F{Tran context?}
    F -->|Yes| G[/clear - /new - chia nho]
    F -->|No| H[Verify + test]
```

## Bảng tổng hợp: chọn model nhanh

Section này trả lời: việc cụ thể của bạn nên đi với model nào, và vì sao — tra nhanh trước khi mở chat.

| Việc | Model nên chọn | Vì sao |
|---|---|---|
| Gõ code hàng ngày, completion | Model mặc định (nhanh, rẻ) | Latency thấp, không tốn AI Credits |
| Chat hỏi đáp, refactor vừa | Model cân bằng (VD GPT / Claude Sonnet) | Đủ thông minh, chi phí vừa |
| Debug khó, kiến trúc, multi-file | Model mạnh nhất (VD Claude Opus / GPT-5-class) | Chi phí cao nhưng đáng |
| Review bảo mật / logic nặng | Model mạnh + custom agent security-reviewer | Kết hợp model + instructions |
| Tiết kiệm Credits cuối chu kỳ | Về model mặc định, tắt Agent mode | Giữ AI Credits cho việc khó |

---

## 1. Model picker ở đâu, đổi model thế nào?

Section này trả lời: model đổi ở 3 chỗ nào trong IDE, và đổi chỗ này có ảnh hưởng chỗ kia không.

> **Hỏi ngắn gọn:** _Model picker ở đâu, đổi model thế nào?_

**Trả lời 1 câu:** Model picker nằm ở Completions (setting), Chat sidebar (dropdown) và Agent/Edit mode, và đổi model chat không ảnh hưởng completions lẫn ngược lại.

**Giải thích chi tiết + ví dụ:** Model picker nằm ở 3 chỗ:

- **Completions (gõ code):** theo setting `github.copilot.completions.model` hoặc model mặc định của extension — thường không cần đổi.
- **Chat sidebar:** dropdown trên cùng khung chat → chọn model cho conversation đó.
- **Agent/Edit mode:** model chọn trong chat + `muse-instructions.md` có thể gợi ý model phù hợp (nhưng không ép được).

Đổi model chat không ảnh hưởng completions và ngược lại.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# VS Code settings.json: ghim model completions (nếu muốn)
# Mở Command Palette -> "Preferences: Open User Settings (JSON)" rồi thêm:
# { "github.copilot.completions.model": "<model-id>" }
# Chat model: đổi bằng dropdown trong Chat view (không có lệnh CLI)
```

**Ví dụ cụ thể:** chat đang dùng model mạnh để hỏi cú pháp đơn giản → tốn Credits vô ích. Đổi dropdown về model nhẹ cho câu dễ, dành model mạnh cho refactor.

> **Khi nào áp dụng:** mỗi khi mở chat mới — chọn model theo độ khó việc, đừng để mặc định mãi.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 2. Premium multiplier là gì, model nào tốn bao nhiêu?

Section này trả lời: vì sao model mạnh tốn tiền hơn model rẻ, và từ 2026 tiền tính theo đơn vị gì.

> **Hỏi ngắn gọn:** _Premium multiplier là gì, model nào tốn bao nhiêu?_

**Trả lời 1 câu:** Từ 01/06/2026 không còn gói "AI Credits" cố định mỗi tháng — mọi lượt tính bằng AI Credits (1 credit = $0.01), model đắt tốn nhiều Credits hơn còn completions thì không tốn gì.

**Giải thích chi tiết + ví dụ:** Đây là chỗ hay nhầm nhất sau khi GitHub đổi cách tính tiền:

- **Cách cũ (trước 06/2026):** mỗi plan có quota **AI Credits/tháng**. Model thường (multiplier ×1) tốn 1 request; model mạnh (×3, ×5, ×10...) tốn nhiều hơn mỗi lần gọi. Hết quota → chờ reset, trả thêm, hoặc rớt về model thường.
- **Cách mới (usage-based billing từ 01/06/2026):** không còn multiplier theo request. **1 AI credit = $0.01 USD**; chi phí mỗi lượt = giá mỗi token của model × số token, quy đổi ra credits.
- Model đắt hơn (VD Claude Opus 5, GPT-5.5) có giá token cao model rẻ hơn (VD MAI-Code-1.1-Flash, GPT-5.6 Luna) → cùng 1 prompt tốn nhiều Credits hơn — "multiplier" cũ nay hiện qua giá token.
- **Code completions + next edit suggestions KHÔNG trừ Credits** — không giới hạn trên plan trả phí.
- Plan trả phí dùng **auto model selection được giảm 10%**.
- Hết credits base + flex → dùng tiếp tính vào **additional usage budget** (spend cap cấu hình được).

Quy tắc thực tế: **gõ code (completions) = 0 Credits, chat 1 câu tốn theo tokens, agent mode nhiều lượt tool-call → tốn nhất.**

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Không có CLI xem hạn mức; check web:
# https://github.com/settings/copilot -> "AI Credits usage"
# Kinh nghiệm: đầu tháng check 1 lần, giữa tháng check 1 lần
```

**Ví dụ cụ thể:** Pro cho 1.500 Credits/tháng (1.000 base + 500 flex). Dùng model đắt cho mọi chat linh tinh → tốn nhanh. Dùng model rẻ cho việc dễ + model mạnh cho việc khó → đủ cả tháng.

> **Khi nào áp dụng:** khi chat báo "AI Credits limit reached" — xem lại mình đã đốt Credits vào việc gì.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 3. Context window là gì, Copilot nhét gì vào context?

Section này trả lời: context gồm những thứ gì, và khi nào nó đầy thì hậu quả ra sao.

> **Hỏi ngắn gọn:** _Context window là gì, Copilot nhét gì vào context?_

**Trả lời 1 câu:** Context là toàn bộ code + instructions + kết quả tool mà Copilot đọc mỗi lần gợi ý, tràn context thì gợi ý tệ và agent quên đầu bài.

**Giải thích chi tiết + ví dụ:** Context = lượng code + instructions Copilot đọc mỗi lần gợi ý. Gồm: file đang mở (vùng quanh con trỏ), file liên quan (imports, file mở gần đây), `#file` / `#selection` bạn attach trong chat, `muse-instructions.md` + instructions khớp `applyTo`, và (Agent mode) kết quả tool calls.

Tràn context → gợi ý tệ, chat quên đầu bài, agent lặp vòng.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Trong Chat: gắn file cụ thể thay vì để Copilot tự đoán
# #file:src/auth/login.ts giải thích hàm này làm gì
# #selection refactor đoạn này sang async/await

# Kiểm tra instructions nào đang ăn vào context:
# VS Code -> Copilot Chat -> "..." -> xem referenced files
```

**Ví dụ cụ thể:** hỏi về hàm `login` mà Copilot trả lời lan man → chat mới + `#file:src/auth/login.ts` → câu trả lời gọn, đúng file.

> **Khi nào áp dụng:** mỗi khi câu trả lời "lạc đề" — 80% là context nhiễu, không phải model dốt.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 4. Tràn context thì làm gì (chat dài, agent lặp)?

Section này trả lời: chat dài hoặc agent lặp vòng thì xử lý theo thứ tự nào cho hết tràn context.

> **Hỏi ngắn gọn:** _Tràn context thì làm gì (chat dài, agent lặp)?_

**Trả lời 1 câu:** Mở chat mới là cách rẻ nhất, rồi thu hẹp scope bằng `#file`, tóm tắt tay bối cảnh và chia task lớn thành task nhỏ.

**Giải thích chi tiết + ví dụ:** Dấu hiệu: chat trả lời ngày càng tệ, agent chạy vòng lặp không xong, báo `context limit`. Cách xử lý theo thứ tự:

1. **Mở chat mới** (`Ctrl+Shift+P → "New Chat"`) — rẻ nhất, hiệu quả nhất.
2. **Thu hẹp scope:** `#file` cụ thể thay vì cả folder.
3. **Tóm tắt tay:** copy kết luận sang chat mới ("tiếp tục từ: ...").
4. **Chia task:** agent 1 task lớn → 3 task nhỏ (xem [bài 07](07-custom-agents-coding-agent-workflows.md)).

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Không có lệnh CLI; thao tác trong IDE:
# 1. Ctrl+Shift+P -> "Chat: New Chat"
# 2. Gõ tóm tắt bối cảnh 5 dòng vào chat mới
# 3. Attach lại đúng 1-2 file cần thiết bằng #file
```

**Ví dụ cụ thể:** agent refactor 20 file chạy 30 phút chưa xong → dừng, chia 3 đợt (models → api → tests), mỗi đợt 1 chat mới.

> **Khi nào áp dụng:** ngay khi thấy agent lặp lần 3 cùng 1 lỗi — đừng để nó đốt Credits vô ích.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 5. BYOK (Bring Your Own Key) là gì, Copilot có hỗ trợ không?

Section này trả lời: có dùng API key/endpoint của riêng mình không, và ai là người cấu hình.

> **Hỏi ngắn gọn:** _BYOK (Bring Your Own Key) là gì, Copilot có hỗ trợ không?_

**Trả lời 1 câu:** BYOK là dùng API key/endpoint model của riêng bạn, nhưng Copilot mặc định KHÔNG BYOK cho completions/chat — chỉ Enterprise mới route được qua Azure OpenAI.

**Giải thích chi tiết + ví dụ:** BYOK = dùng API key / endpoint model của riêng bạn (Azure OpenAI, Anthropic trực tiếp...) thay vì model GitHub cấp. **Copilot mặc định KHÔNG BYOK** cho completions/chat — model đi qua hạ tầng GitHub.

Ngoại lệ: **Enterprise + Azure OpenAI** có integration cho phép route qua Azure tenant của bạn (admin cấu hình, data boundary giữ trong Azure). Hoặc dùng **Copilot CLI / SDK** gọi model ngoài trong workflow riêng (xem [bài 10](10-ci-sdk-review-web.md)).

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Kiểm tra org có bật Azure OpenAI integration không (admin, web UI):
# Org Settings -> Copilot -> Policies -> Models
# Dev thường: không cần làm gì — BYOK là việc của admin
```

**Ví dụ cụ thể:** bank yêu cầu data không ra khỏi Azure region → admin bật Enterprise + Azure OpenAI routing, dev dùng Copilot như bình thường.

> **Khi nào áp dụng:** khi compliance hỏi "data đi đâu" — trả lời bằng cấu hình org, xem [bài 09](09-bao-mat-quyen-rieng-tu.md).

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 6. Nên dùng model nào cho việc nào (khuyến nghị thực tế)?

Section này trả lời: quy tắc chọn model theo độ khó việc, kèm cách ép scope trước khi gọi model mạnh.

> **Hỏi ngắn gọn:** _Nên dùng model nào cho việc nào (khuyến nghị thực tế)?_

**Trả lời 1 câu:** Việc dễ dùng model nhẹ, việc khó dùng model mạnh, và agent tự chạy lâu thì phải kèm instructions chặt.

**Giải thích chi tiết + ví dụ:** Nguyên tắc **"việc dễ model nhẹ, việc khó model mạnh"**:

- **Completion gõ tay:** model mặc định — latency quan trọng hơn thông minh, lại không tốn Credits.
- **Giải thích code, viết test đơn:** model tầm trung.
- **Refactor multi-file, debug race condition, thiết kế:** model mạnh nhất.
- **Agent tự chạy lâu:** model mạnh + instructions chặt (không thì nó chạy loạn bằng model đắt).

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Mẫu chat mở đầu để ép scope trước khi chọn model mạnh:
# "Đọc #file:src/auth/login.ts và #file:src/auth/session.ts,
#  liệt kê 3 chỗ có thể gây race condition. Chưa cần sửa."
```

**Ví dụ cụ thể:** cần refactor auth (khó) → chat mới + model mạnh + attach 2 file. Hỏi cú pháp `map` (dễ) → model nhẹ.

> **Khi nào áp dụng:** trước mỗi task >15 phút — dành 10 giây chọn model đúng, tiết kiệm hàng chục lượt tốn Credits.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 7. Completions vs Chat vs Agent tốn quota khác nhau ra sao?

Section này trả lời: 3 cách dùng Copilot tốn Credits theo thứ tự nào, để bạn chọn cách rẻ nhất.

> **Hỏi ngắn gọn:** _Completions vs Chat vs Agent tốn quota khác nhau ra sao?_

**Trả lời 1 câu:** Completions không trừ Credits, chat 1 câu tốn theo tokens, còn agent mode tốn nhất vì nhiều lượt tool-call.

**Giải thích chi tiết + ví dụ:** Thứ tự tốn Credits tăng dần:

1. **Completions (gợi ý xám):** **không trừ AI Credits**, không giới hạn trên plan trả phí.
2. **Chat 1 câu:** tốn Credits theo giá token của model + số token trong lượt đó.
3. **Edit mode:** chat + apply → tốn hơn chat thường 1 chút.
4. **Agent mode:** nhiều vòng tool-call → tốn gấp nhiều lần 1 chat.

Vì vậy: gõ tay được thì đừng chat; chat được thì đừng agent.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Thói quen tiết kiệm Credits:
# 1. Gõ -> Tab (completions, không tốn Credits)
# 2. Không ra -> hỏi chat 1 câu gọn (tốn ít)
# 3. Việc multi-file -> mới bật Agent mode (tốn nhất)
```

**Ví dụ cụ thể:** đổi tên biến 10 chỗ → dùng IDE rename (0 Credits) thay vì nhờ agent (nhiều lượt tốn Credits).

> **Khi nào áp dụng:** cuối chu kỳ khi Credits đỏ — chuyển 80% việc về completions + chat nhẹ.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 8. Sao cùng 1 prompt mà hôm nay dở hơn hôm qua?

Section này trả lời: 4 nguyên nhân khiến chất lượng trả lời tụt, và check theo thứ tự nào.

> **Hỏi ngắn gọn:** _Sao cùng 1 prompt mà hôm nay dở hơn hôm qua?_

**Trả lời 1 câu:** Check theo thứ tự model → context → instructions → hạn mức, vì 4 thứ này đổi được chứ không chỉ do model "dốt đột xuất".

**Giải thích chi tiết + ví dụ:** 4 nguyên nhân phổ biến (theo thứ tự kiểm tra):

1. **Model sau lưng bị đổi** (GitHub âm thầm update default model) → check model picker.
2. **Context khác** (mở file khác, instructions khác) → check referenced files.
3. **Instructions mới thêm** làm nhiễu → thử tắt instructions custom.
4. **Hết Credits → rớt model yếu** → check usage page.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Checklist khi chất lượng tụt:
# 1. Chat mới + cùng prompt + cùng model -> còn dở không?
# 2. Tắt .github/instructions custom tạm -> khá hơn không?
# 3. https://github.com/settings/copilot -> Credits còn không?
```

**Ví dụ cụ thể:** team thêm `frontend-react.instructions.md` với `applyTo: **` → mọi chat backend cũng bị nhồi React context → chất lượng tụt. Fix: sửa `applyTo` cho hẹp (xem [bài 06](06-prompts-agents-instructions.md)).

> **Khi nào áp dụng:** khi "hôm qua còn ngon" — đừng đổi model vội, check context trước.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 9. Có khóa model cố định cho cả team được không?

Section này trả lời: khóa model cho cả team được ở 2 mức nào, mức nào ép buộc mức nào chỉ khuyến nghị.

> **Hỏi ngắn gọn:** _Có khóa model cố định cho cả team được không?_

**Trả lời 1 câu:** Được — admin khóa bằng org allowlist (ép buộc) và team ghi khuyến nghị vào `muse-instructions.md` (không ép được).

**Giải thích chi tiết + ví dụ:** Được, ở 2 mức:

- **Org policy (admin):** allowlist model nào được dùng → mọi member chỉ thấy model đó (Business/Enterprise).
- **Repo convention:** ghi vào `muse-instructions.md` ("dùng model X cho review") — chỉ là khuyến nghị, không ép được.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```markdown
<!-- Đoạn mẫu trong .github/muse-instructions.md -->
## Model guidance (khuyến nghị, không ép buộc)
- Chat hằng ngày: model mặc định.
- Review PR / refactor auth: model mạnh nhất hiện có.
```

**Ví dụ cụ thể:** team muốn tiết kiệm Credits → admin allowlist chỉ 2 model (1 rẻ + 1 mạnh), dev tự chọn theo việc.

> **Khi nào áp dụng:** khi bill Credits của team tăng đột biến — khóa allowlist + training 10 phút về chọn model.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 10. Dùng Copilot hết quota giữa tháng thì chữa cháy sao?

Section này trả lời: hết Credits giữa chu kỳ thì xử lý theo thứ tự nào để vẫn làm được việc gấp.

> **Hỏi ngắn gọn:** _Dùng Copilot hết quota giữa tháng thì chữa cháy sao?_

**Trả lời 1 câu:** Thứ tự chữa cháy là chuyển về model rẻ + tắt Agent, dùng completions và IDE refactor, rồi mới xin admin thêm Credits hoặc chuyển plan.

**Giải thích chi tiết + ví dụ:** Thứ tự chữa cháy:

1. Chuyển chat về model rẻ, tắt Agent mode.
2. Dùng completions + IDE refactor (không tốn Credits) thay vì chat.
3. Xin admin mua thêm Credits / chuyển sang plan cao hơn (nếu đáng).
4. Task gấp + model mạnh cần thiết → dùng web `github.com/copilot` (chung hạn mức nhưng đôi khi còn slot) hoặc chờ chu kỳ mới.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Check ngày reset hạn mức (web UI):
# https://github.com/settings/copilot -> Billing cycle ends ...
# Tính toán: Credits còn lại / số ngày còn lại = ngân sách/ngày
```

**Ví dụ cụ thể:** còn 100 Credits mà 10 ngày nữa mới reset → 10/ngày: chỉ bật model mạnh cho task blocker, còn lại model nhẹ.

> **Khi nào áp dụng:** ngay khi nhận cảnh báo Credits 80% — đừng đợi cạn mới tiết kiệm.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

Section này trả lời: chất lượng hoặc chi phí vẫn lệch sau khi đã thử mọi cách — chạy 5 bước check này.

1. Check model đang chọn trong picker (có đúng ý mình không).
2. Mở chat mới + attach `#file` gọn (loại trừ context nhiễu).
3. Tắt instructions custom tạm để test.
4. Check hạn mức Credits: `github.com/settings/copilot`.
5. Vẫn tệ → đổi model mạnh hơn 1 nấc, hoặc hỏi lại với prompt chia nhỏ.

---

## Tham khảo chéo

Section này trả lời: đào sâu tiếp theo hướng nào — cài đặt, instructions, agent hay bảo mật.

- Cài đặt + seat: [bài 01](01-tai-khoan-pricing-cai-dat.md). Instructions nhiễu context: [bài 06](06-prompts-agents-instructions.md).
- Agent tốn Credits: [bài 07](07-custom-agents-coding-agent-workflows.md). Bảo mật data khi dùng model: [bài 09](09-bao-mat-quyen-rieng-tu.md).
- Templates: [../templates/README.md](../templates/README.md).

> Mẹo 1 dòng: _việc dễ model nhẹ, việc khó model mạnh, và chat mới + #file gọn giải quyết 80% ca "model dốt đột xuất"._
