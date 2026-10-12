# FAQ 02 — Model, Context & Premium

> **Dành cho:** dev đã dùng Copilot Chat/Agent và muốn kiểm soát chi phí, chọn đúng model, giữ context gọn.
> **Vấn đề:** "model picker chọn gì, chi phí AI Credits tính ra sao, context window bao nhiêu, BYOK được không" — mỗi câu trả lời theo khuôn cố định.
> **Đọc xong:** biết chọn model nào cho việc nào, khi nào tốn Credits, giữ context sao cho không bị cắt. **Thời gian:** ~12 phút đọc.

10 câu dưới đây trả lời một mạch câu hỏi quen thuộc: **"model picker chọn gì, AI Credits tính tiền thế nào, context window bao nhiêu, BYOK được không"**. Mỗi câu gồm giải thích + lệnh copy-paste + ví dụ + lúc nào nên áp dụng.

> **Nếu làm sai thì sao?** Dùng model mạnh cho việc lặt vặt là cách đốt Credits nhanh nhất; để context phình to thì agent quên đầu bài rồi lặp vòng; còn nhầm "quota theo request" (kiểu cũ) với "tính theo token" (từ 06/2026) sẽ khiến bạn ước lượng chi phí sai hẳn.

## Mục tiêu bài học

- Biết đổi model ở đâu (completions / chat / agent) và đổi chỗ này không ảnh hưởng chỗ kia.
- Hiểu cách tính tiền mới từ 01/06/2026 (AI Credits theo token) và vì sao "multiplier" cũ không còn đúng.
- Nhận ra dấu hiệu tràn context và xử đúng thứ tự trước khi tốn thêm Credits.
- Chọn được model theo độ khó việc và biết khi nào được phép "khóa" model cho cả team.

## Sơ đồ tư duy nhanh (đọc 30 giây)

Từ một task, bạn quyết định model nào, rồi xử lý ra sao khi context sắp tràn — đi theo 3 nhánh của sơ đồ.

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

Việc cụ thể của bạn nên đi với model nào, và vì sao — tra nhanh trước khi mở chat.

| Việc | Model nên chọn | Vì sao |
|---|---|---|
| Gõ code hàng ngày, completion | Model mặc định (nhanh, rẻ) | Latency thấp, không tốn AI Credits |
| Chat hỏi đáp, refactor vừa | Model cân bằng (VD GPT / Claude Sonnet) | Đủ thông minh, chi phí vừa |
| Debug khó, kiến trúc, multi-file | Model mạnh nhất (VD Claude Opus / GPT-5-class) | Chi phí cao nhưng đáng |
| Review bảo mật / logic nặng | Model mạnh + custom agent security-reviewer | Kết hợp model + instructions |
| Tiết kiệm Credits cuối chu kỳ | Về model mặc định, tắt Agent mode | Giữ AI Credits cho việc khó |

---

## 1. Model picker ở đâu, đổi model thế nào?

> **Hỏi ngắn gọn:** _Model picker ở đâu, đổi model thế nào?_

**Trả lời 1 câu:** Model picker nằm ở Completions (setting), Chat sidebar (dropdown) và Agent/Edit mode, và đổi model chat không ảnh hưởng completions lẫn ngược lại.

**Giải thích chi tiết + ví dụ:** Model picker nằm ở 3 chỗ:

- **Completions (gõ code):** theo setting `github.copilot.completions.model` hoặc model mặc định của extension — thường không cần đổi.
- **Chat sidebar:** dropdown trên cùng khung chat → chọn model cho conversation đó.
- **Agent/Edit mode:** model chọn trong chat + `copilot-instructions.md` có thể gợi ý model phù hợp (nhưng không ép được).

Đổi model chat không ảnh hưởng completions và ngược lại.

| Vị trí | Đổi model ở đâu | Ảnh hưởng tới | Khi nào dùng |
|---|---|---|---|
| Completions (gõ code) | Setting `github.copilot.completions.model` | Chỉ gợi ý xám | Ghim model completions cố định |
| Chat sidebar | Dropdown trên khung chat | Chỉ conversation đó | Chọn model theo độ khó câu hỏi |
| Agent/Edit mode | Model trong chat + `copilot-instructions.md` | Phiên agent/edit | Gợi ý model phù hợp (không ép được) |

### Làm thế nào (steps copy-paste)

Ghim model completions nếu muốn cố định, còn model chat thì đổi bằng dropdown:

```bash
# VS Code settings.json: ghim model completions (nếu muốn)
# Mở Command Palette -> "Preferences: Open User Settings (JSON)" rồi thêm:
# { "github.copilot.completions.model": "<model-id>" }
# Verify: reload IDE, gõ code -> suggestions vẫn chạy với model bạn ghim
# Chat model: đổi bằng dropdown trong Chat view (không có lệnh CLI)
```

**Ví dụ cụ thể:** chat đang dùng model mạnh để hỏi cú pháp đơn giản → tốn Credits vô ích. Đổi dropdown về model nhẹ cho câu dễ, dành model mạnh cho refactor.

> **Khi nào áp dụng:** mỗi khi mở chat mới — chọn model theo độ khó việc, đừng để mặc định mãi.

> **Nếu vẫn lỗi thì...** (picker thiếu model bạn muốn): (1) kiểm tra org policy allowlist — model bị admin ẩn thì picker sẽ không hiện, (2) xác nhận plan hiện tại có bao gồm model đó, (3) reload IDE cho picker refresh, (4) hỏi admin mở thêm model — xem "Vẫn lỗi thì sao?" cuối file.
---

## 2. Premium multiplier là gì, model nào tốn bao nhiêu?

> **Hỏi ngắn gọn:** _Premium multiplier là gì, model nào tốn bao nhiêu?_

**Trả lời 1 câu:** Từ 01/06/2026 không còn gói "AI Credits" cố định mỗi tháng — mọi lượt tính bằng AI Credits (1 credit = $0.01), model đắt tốn nhiều Credits hơn còn completions thì không tốn gì.

**Giải thích chi tiết + ví dụ:** Đây là chỗ hay nhầm nhất sau khi GitHub đổi cách tính tiền:

- **Cách cũ (trước 06/2026):** mỗi plan có quota **AI Credits/tháng**. Model thường (multiplier ×1) tốn 1 request; model mạnh (×3, ×5, ×10...) tốn nhiều hơn mỗi lần gọi. Hết quota → chờ reset, trả thêm, hoặc rớt về model thường.
- **Cách mới (usage-based billing từ 01/06/2026):** không còn multiplier theo request. **1 AI credit = $0.01 USD**; chi phí mỗi lượt = giá mỗi token của model × số token, quy đổi ra credits.
- Model đắt hơn (VD Claude Opus 5, GPT-5.5) có giá token cao model rẻ hơn (VD MAI-Code-1.1-Flash, GPT-5.6 Luna) → cùng 1 prompt tốn nhiều Credits hơn — "multiplier" cũ nay hiện qua giá token.
- **Code completions + next edit suggestions KHÔNG trừ Credits** — không giới hạn trên plan trả phí.
- Plan trả phí dùng **auto model selection được giảm 10%**.
- Hết credits base + flex → dùng tiếp tính vào **additional usage budget** (spend cap cấu hình được).

| Tiêu chí | Cách cũ (trước 06/2026) | Cách mới (usage-based từ 01/06/2026) |
|---|---|---|
| Đơn vị tính | Quota AI Credits/tháng + multiplier theo request | 1 AI credit = $0.01; giá token × số token |
| Model mạnh | Multiplier ×3, ×5, ×10... theo request | Giá token cao hơn → tốn nhiều credits hơn |
| Hết quota | Chờ reset / trả thêm / rớt model thường | Tính vào additional usage budget (spend cap) |
| Auto model selection | — | Giảm 10% |
| Khi nào dùng | Tham chiếu tài liệu cũ | Cách tính áp dụng từ 06/2026 |

Quy tắc thực tế: **gõ code (completions) = 0 Credits, chat 1 câu tốn theo tokens, agent mode nhiều lượt tool-call → tốn nhất.**

### Làm thế nào (steps copy-paste)

Theo dõi usage trên web vì không có lệnh CLI, và tập thói quen check đều:

```bash
# Không có CLI xem hạn mức; check web:
# https://github.com/settings/copilot -> "AI Credits usage"
# Verify: bạn thấy cột usage + số credits còn lại trong chu kỳ hiện tại
# Kinh nghiệm: đầu tháng check 1 lần, giữa tháng check 1 lần
```

**Ví dụ cụ thể:** Pro cho 1.500 Credits/tháng (1.000 base + 500 flex). Dùng model đắt cho mọi chat linh tinh → tốn nhanh. Dùng model rẻ cho việc dễ + model mạnh cho việc khó → đủ cả tháng.

> **Khi nào áp dụng:** khi chat báo "AI Credits limit reached" — xem lại mình đã đốt Credits vào việc gì.

> **Nếu vẫn lỗi thì...** (usage nhảy bất thường, không hiểu tiền đi đâu): (1) đối chiếu model đắt nào đang được dùng nhiều, (2) xem có chat/agent nào chạy vòng lặp không, (3) rà lại instructions dài bị nạp mỗi turn, (4) lập bảng phân bổ model rẻ/mạnh cho tuần tới — xem "Vẫn lỗi thì sao?" cuối file.
---

## 3. Context window là gì, Copilot nhét gì vào context?

> **Hỏi ngắn gọn:** _Context window là gì, Copilot nhét gì vào context?_

**Trả lời 1 câu:** Context là toàn bộ code + instructions + kết quả tool mà Copilot đọc mỗi lần gợi ý, tràn context thì gợi ý tệ và agent quên đầu bài.

**Giải thích chi tiết + ví dụ:** Context = lượng code + instructions Copilot đọc mỗi lần gợi ý. Gồm: file đang mở (vùng quanh con trỏ), file liên quan (imports, file mở gần đây), `#file` / `#selection` bạn attach trong chat, `copilot-instructions.md` + instructions khớp `applyTo`, và (Agent mode) kết quả tool calls.

Tràn context → gợi ý tệ, chat quên đầu bài, agent lặp vòng.

### Làm thế nào (steps copy-paste)

Chủ động gắn đúng file thay vì để Copilot tự đoán, và kiểm tra nó đang đọc gì:

```bash
# Trong Chat: gắn file cụ thể thay vì để Copilot tự đoán
# #file:src/auth/login.ts giải thích hàm này làm gì
# #selection refactor đoạn này sang async/await
# Verify: copilot trả lời đúng nội dung file đã attach, không lan man

# Kiểm tra instructions nào đang ăn vào context:
# VS Code -> Copilot Chat -> "..." -> xem referenced files
# Verify: danh sách file khớp đúng context bạn mước hiện tại
```

**Ví dụ cụ thể:** hỏi về hàm `login` mà Copilot trả lời lan man → chat mới + `#file:src/auth/login.ts` → câu trả lời gọn, đúng file.

> **Khi nào áp dụng:** mỗi khi câu trả lời "lạc đề" — 80% là context nhiễu, không phải model dốt.

> **Nếu vẫn lỗi thì...** (attach file rồi mà vẫn lan man): (1) mở "referenced files" xem có đúng file bạn tưởng không, (2) gỡ bớt instructions `applyTo: **` đang nhồi context sai, (3) thử `#selection` cho đúng đoạn thay vì cả file, (4) mở chat mới hoàn toàn — xem "Vẫn lỗi thì sao?" cuối file.
---

## 4. Tràn context thì làm gì (chat dài, agent lặp)?

> **Hỏi ngắn gọn:** _Tràn context thì làm gì (chat dài, agent lặp)?_

**Trả lời 1 câu:** Mở chat mới là cách rẻ nhất, rồi thu hẹp scope bằng `#file`, tóm tắt tay bối cảnh và chia task lớn thành task nhỏ.

**Giải thích chi tiết + ví dụ:** Dấu hiệu: chat trả lời ngày càng tệ, agent chạy vòng lặp không xong, báo `context limit`. Cách xử lý theo thứ tự:

1. **Mở chat mới** (`Ctrl+Shift+P → "New Chat"`) — rẻ nhất, hiệu quả nhất.
2. **Thu hẹp scope:** `#file` cụ thể thay vì cả folder.
3. **Tóm tắt tay:** copy kết luận sang chat mới ("tiếp tục từ: ...").
4. **Chia task:** agent 1 task lớn → 3 task nhỏ (xem [bài 07](07-custom-agents-coding-agent-workflows.md)).

### Làm thế nào (steps copy-paste)

Dọn context theo 3 thao tác trong IDE — không có lệnh CLI cho việc này:

```bash
# Không có lệnh CLI; thao tác trong IDE:
# 1. Ctrl+Shift+P -> "Chat: New Chat"
# 2. Gõ tóm tắt bối cảnh 5 dòng vào chat mới
# 3. Attach lại đúng 1-2 file cần thiết bằng #file
# Verify: chat mới trả lời đúng trọng tâm + agent không lặp vòng nữa
```

**Ví dụ cụ thể:** agent refactor 20 file chạy 30 phút chưa xong → dừng, chia 3 đợt (models → api → tests), mỗi đợt 1 chat mới.

> **Khi nào áp dụng:** ngay khi thấy agent lặp lần 3 cùng 1 lỗi — đừng để nó đốt Credits vô ích.

> **Nếu vẫn lỗi thì...** (chat mới rồi vẫn lặp): (1) kiểm tra task có thật sự chia được nhỏ hơn không, (2) thêm gate review giữa các phase, (3) giảm số file attach mỗi phase, (4) dừng agent (Cancel) rồi đọc log vòng cuối để tìm điểm mắc — xem "Vẫn lỗi thì sao?" cuối file.
---

## 5. BYOK (Bring Your Own Key) là gì, Copilot có hỗ trợ không?

> **Hỏi ngắn gọn:** _BYOK (Bring Your Own Key) là gì, Copilot có hỗ trợ không?_

**Trả lời 1 câu:** BYOK là dùng API key/endpoint model của riêng bạn, nhưng Copilot mặc định KHÔNG BYOK cho completions/chat — chỉ Enterprise mới route được qua Azure OpenAI.

**Giải thích chi tiết + ví dụ:** BYOK = dùng API key / endpoint model của riêng bạn (Azure OpenAI, Anthropic trực tiếp...) thay vì model GitHub cấp. **Copilot mặc định KHÔNG BYOK** cho completions/chat — model đi qua hạ tầng GitHub.

Ngoại lệ: **Enterprise + Azure OpenAI** có integration cho phép route qua Azure tenant của bạn (admin cấu hình, data boundary giữ trong Azure). Hoặc dùng **Copilot CLI / SDK** gọi model ngoài trong workflow riêng (xem [bài 10](10-ci-sdk-review-web.md)).

### Làm thế nào (steps copy-paste)

Việc cấu hình này thuộc về admin, dev thường không phải làm gì:

```bash
# Kiểm tra org có bật Azure OpenAI integration không (admin, web UI):
# Org Settings -> Copilot -> Policies -> Models
# Verify: mục Models có dòng "Azure OpenAI" đã cấu hình tenant
# Dev thường: không cần làm gì — BYOK là việc của admin
```

**Ví dụ cụ thể:** bank yêu cầu data không ra khỏi Azure region → admin bật Enterprise + Azure OpenAI routing, dev dùng Copilot như bình thường.

> **Khi nào áp dụng:** khi compliance hỏi "data đi đâu" — trả lời bằng cấu hình org, xem [bài 09](09-bao-mat-quyen-rieng-tu.md).

> **Nếu vẫn lỗi thì...** (compliance muốn BYOK mà không thấy cấu hình): (1) xác nhận org đang ở plan Enterprise, vì tính năng này không có ở gói thấp hơn, (2) nhờ admin kiểm tra mục Models trong Policies, (3) nếu chỉ cần gọi model ngoài cho workflow riêng thì cân nhắc Copilot CLI/SDK, (4) ghi lại yêu cầu data-boundary bằng văn bản với admin — xem "Vẫn lỗi thì sao?" cuối file.
---

## 6. Nên dùng model nào cho việc nào (khuyến nghị thực tế)?

> **Hỏi ngắn gọn:** _Nên dùng model nào cho việc nào (khuyến nghị thực tế)?_

**Trả lời 1 câu:** Việc dễ dùng model nhẹ, việc khó dùng model mạnh, và agent tự chạy lâu thì phải kèm instructions chặt.

**Giải thích chi tiết + ví dụ:** Nguyên tắc **"việc dễ model nhẹ, việc khó model mạnh"**:

- **Completion gõ tay:** model mặc định — latency quan trọng hơn thông minh, lại không tốn Credits.
- **Giải thích code, viết test đơn:** model tầm trung.
- **Refactor multi-file, debug race condition, thiết kế:** model mạnh nhất.
- **Agent tự chạy lâu:** model mạnh + instructions chặt (không thì nó chạy loạn bằng model đắt).

### Làm thế nào (steps copy-paste)

Ép scope trước bằng một prompt khảo sát, rồi mới nâng model:

```bash
# Mẫu chat mở đầu để ép scope trước khi chọn model mạnh:
# "Đọc #file:src/auth/login.ts và #file:src/auth/session.ts,
#  liệt kê 3 chỗ có thể gây race condition. Chưa cần sửa."
# Verify: model trả lời đúng 3 điểm, không đi sửa code — đủ scope rồi mới nâng model
```

**Ví dụ cụ thể:** cần refactor auth (khó) → chat mới + model mạnh + attach 2 file. Hỏi cú pháp `map` (dễ) → model nhẹ.

> **Khi nào áp dụng:** trước mỗi task >15 phút — dành 10 giây chọn model đúng, tiết kiệm hàng chục lượt tốn Credits.

> **Nếu vẫn lỗi thì...** (model mạnh vẫn trả lời hời hợt): (1) kiểm tra scope đã đủ hẹp chưa trước khi đổ lỗi cho model, (2) đính kèm file/đoạn cụ thể thay vì mô tả chung, (3) chia task khó thành các bước nhỏ, (4) chỉ khi vẫn kém mới đổi sang model mạnh hơn một nấc — xem "Vẫn lỗi thì sao?" cuối file.
---

## 7. Completions vs Chat vs Agent tốn quota khác nhau ra sao?

> **Hỏi ngắn gọn:** _Completions vs Chat vs Agent tốn quota khác nhau ra sao?_

**Trả lời 1 câu:** Completions không trừ Credits, chat 1 câu tốn theo tokens, còn agent mode tốn nhất vì nhiều lượt tool-call.

**Giải thích chi tiết + ví dụ:** Thứ tự tốn Credits tăng dần:

1. **Completions (gợi ý xám):** **không trừ AI Credits**, không giới hạn trên plan trả phí.
2. **Chat 1 câu:** tốn Credits theo giá token của model + số token trong lượt đó.
3. **Edit mode:** chat + apply → tốn hơn chat thường 1 chút.
4. **Agent mode:** nhiều vòng tool-call → tốn gấp nhiều lần 1 chat.

Vì vậy: gõ tay được thì đừng chat; chat được thì đừng agent.

| Cách dùng | Tốn AI Credits? | Mức độ | Khi nào dùng |
|---|---|---|---|
| Completions (gợi ý xám) | Không | 0 | Gõ code hàng ngày |
| Chat 1 câu | Có (theo token) | Thấp | Hỏi/giải thích, việc nhỏ |
| Edit mode | Có (chat + apply) | Trung bình | Sửa file cụ thể trong scope |
| Agent mode | Có (nhiều tool-call) | Cao nhất | Task multi-file, refactor |

### Làm thế nào (steps copy-paste)

Tập thứ tự "gõ trước, hỏi sau, agent cuối" và tự kiểm chứng bằng usage cuối tuần:

```bash
# Thói quen tiết kiệm Credits:
# 1. Gõ -> Tab (completions, không tốn Credits)
# 2. Không ra -> hỏi chat 1 câu gọn (tốn ít)
# 3. Việc multi-file -> mới bật Agent mode (tốn nhất)
# Verify: cuối tuần check usage, agent call chiếm <50% tổng chi
```

**Ví dụ cụ thể:** đổi tên biến 10 chỗ → dùng IDE rename (0 Credits) thay vì nhờ agent (nhiều lượt tốn Credits).

> **Khi nào áp dụng:** cuối chu kỳ khi Credits đỏ — chuyển 80% việc về completions + chat nhẹ.

> **Nếu vẫn lỗi thì...** (thấy agent tốn quá mức): (1) ước tính xem task có thật sự cần agent không, (2) giới hạn scope để ít tool-call, (3) thêm lệnh verify để agent không lặp, (4) tắt agent và làm bằng tay nếu task vốn dễ — xem "Vẫn lỗi thì sao?" cuối file.
---

## 8. Sao cùng 1 prompt mà hôm nay dở hơn hôm qua?

> **Hỏi ngắn gọn:** _Sao cùng 1 prompt mà hôm nay dở hơn hôm qua?_

**Trả lời 1 câu:** Check theo thứ tự model → context → instructions → hạn mức, vì 4 thứ này đổi được chứ không chỉ do model "dốt đột xuất".

**Giải thích chi tiết + ví dụ:** 4 nguyên nhân phổ biến (theo thứ tự kiểm tra):

1. **Model sau lưng bị đổi** (GitHub âm thầm update default model) → check model picker.
2. **Context khác** (mở file khác, instructions khác) → check referenced files.
3. **Instructions mới thêm** làm nhiễu → thử tắt instructions custom.
4. **Hết Credits → rớt model yếu** → check usage page.

### Làm thế nào (steps copy-paste)

Chạy checklist loại trừ dần — bước nào đổi chất lượng thì đó là nguyên nhân:

```bash
# Checklist khi chất lượng tụt:
# 1. Chat mới + cùng prompt + cùng model -> còn dở không?
# 2. Tắt .github/instructions custom tạm -> khá hơn không?
# 3. https://github.com/settings/copilot -> Credits còn không?
# Verify: bước nào làm thay đổi chất lượng -> đó là root cause
```

**Ví dụ cụ thể:** team thêm `frontend-react.instructions.md` với `applyTo: **` → mọi chat backend cũng bị nhồi React context → chất lượng tụt. Fix: sửa `applyTo` cho hẹp (xem [bài 06](06-prompts-agents-instructions.md)).

> **Khi nào áp dụng:** khi "hôm qua còn ngon" — đừng đổi model vội, check context trước.

> **Nếu vẫn lỗi thì...** (đã loại hết 4 nguyên nhân mà vẫn tệ): (1) ghi lại đúng prompt + model đang dùng để có mốc so sánh, (2) thử trên một repo nhỏ tối giản, (3) so sánh với ngày khác xem có trùng lúc hết quota không, (4) đổi model mạnh hơn một nấc rồi chạy lại — xem "Vẫn lỗi thì sao?" cuối file.
---

## 9. Có khóa model cố định cho cả team được không?

> **Hỏi ngắn gọn:** _Có khóa model cố định cho cả team được không?_

**Trả lời 1 câu:** Được — admin khóa bằng org allowlist (ép buộc) và team ghi khuyến nghị vào `copilot-instructions.md` (không ép được).

**Giải thích chi tiết + ví dụ:** Được, ở 2 mức:

- **Org policy (admin):** allowlist model nào được dùng → mọi member chỉ thấy model đó (Business/Enterprise).
- **Repo convention:** ghi vào `copilot-instructions.md` ("dùng model X cho review") — chỉ là khuyến nghị, không ép được.

| Mức | Ai set | Ép buộc? | Khi nào dùng |
|---|---|---|---|
| Org policy (admin) | Admin Business/Enterprise | Có (allowlist) | Muốn khóa model cứng cho cả team |
| Repo convention (`copilot-instructions.md`) | Team, commit vào repo | Không (khuyến nghị) | Hướng dẫn mềm theo task |

### Làm thế nào (steps copy-paste)

Ghi khuyến nghị mềm bằng markdown trong file instructions của repo:

```markdown
<!-- Đoạn mẫu trong .github/copilot-instructions.md -->
## Model guidance (khuyến nghị, không ép buộc)
- Chat hằng ngày: model mặc định.
- Review PR / refactor auth: model mạnh nhất hiện có.
```

**Ví dụ cụ thể:** team muốn tiết kiệm Credits → admin allowlist chỉ 2 model (1 rẻ + 1 mạnh), dev tự chọn theo việc.

> **Khi nào áp dụng:** khi bill Credits của team tăng đột biến — khóa allowlist + training 10 phút về chọn model.

> **Nếu vẫn lỗi thì...** (dev vẫn dùng model ngoài mong muốn): (1) nhớ rằng ghi trong instructions chỉ là khuyến nghị, không ràng buộc, (2) muốn ép thật thì phải dùng org allowlist, (3) kiểm tra allowlist chỉ còn đúng model mong muốn, (4) training lại cách chọn model thay vì siết thêm — xem "Vẫn lỗi thì sao?" cuối file.
---

## 10. Dùng Copilot hết quota giữa tháng thì chữa cháy sao?

> **Hỏi ngắn gọn:** _Dùng Copilot hết quota giữa tháng thì chữa cháy sao?_

**Trả lời 1 câu:** Thứ tự chữa cháy là chuyển về model rẻ + tắt Agent, dùng completions và IDE refactor, rồi mới xin admin thêm Credits hoặc chuyển plan.

**Giải thích chi tiết + ví dụ:** Thứ tự chữa cháy:

1. Chuyển chat về model rẻ, tắt Agent mode.
2. Dùng completions + IDE refactor (không tốn Credits) thay vì chat.
3. Xin admin mua thêm Credits / chuyển sang plan cao hơn (nếu đáng).
4. Task gấp + model mạnh cần thiết → dùng web `github.com/copilot` (chung hạn mức nhưng đôi khi còn slot) hoặc chờ chu kỳ mới.

### Làm thế nào (steps copy-paste)

Tính ngân sách/ngày để biết còn "tiêu" được bao nhiêu cho từng việc:

```bash
# Check ngày reset hạn mức (web UI):
# https://github.com/settings/copilot -> Billing cycle ends ...
# Tính toán: Credits còn lại / số ngày còn lại = ngân sách/ngày
# Verify: số ngân sách/ngày đủ cho việc khó hôm nay thì yên tâm
```

**Ví dụ cụ thể:** còn 100 Credits mà 10 ngày nữa mới reset → 10/ngày: chỉ bật model mạnh cho task blocker, còn lại model nhẹ.

> **Khi nào áp dụng:** ngay khi nhận cảnh báo Credits 80% — đừng đợi cạn mới tiết kiệm.

> **Nếu vẫn lỗi thì...** (cạn hẳn mà vẫn còn việc gấp): (1) dùng completions + IDE refactor cho việc không cần AI, (2) gom các câu hỏi vào 1 chat thay vì nhiều chat, (3) nhờ admin nâng budget nếu có spend cap, (4) chờ chu kỳ mới hoặc chuyển plan cao hơn — xem "Vẫn lỗi thì sao?" cuối file.
---

## So sánh với Claude Code

Phần "chọn model theo việc" và "giữ context sạch" là tư tưởng chung, nhưng cách thực hiện khác nhau tùy nhà cung cấp:

| Việc | GitHub Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Chọn model | Đổi ngay trong Chat: GPT / Claude / Gemini | Gắn với model Anthropic (Claude), ít lựa chọn nhà hơn | Copilot cho "đổi não"; Claude Code nhất quán 1 nhà |
| BYOK / key riêng | Mặc định không (trừ Enterprise + Azure OpenAI) | Dùng subscription Anthropic hoặc API key của bạn | Định vị khác nhau: Copilot đi qua hạ tầng GitHub |
| Xử tràn context | Mở Chat mới + `#file` gọn | Nén/chia nhỏ phiên | Cùng tư tưởng: đừng để context phình |
| Kiểm soát chi phí | AI Credits × giá token, completions miễn phí | Tính theo usage subscription/API | Đơn vị khác nhau, không so số trực tiếp |
| Autocomplete | Có (không tốn AI Credits) | Không phải trọng tâm | Copilot mạnh ở gõ code từng dòng |

> **Đọc bảng này thế nào:** nếu bạn quen Claude Code, hãy chuyển nguyên tắc "việc dễ model nhẹ, việc khó model mạnh" và "chat mới khi tràn context" sang Copilot — chúng gần như 1-1. Cái khác là **đơn vị tiền**: credits của Copilot và usage Anthropic không quy đổi cho nhau, nên đừng ước lượng chi phí bằng cách nhân chia giữa hai bên.

## Best practices (kèm "vì sao")

- **Việc dễ model nhẹ, việc khó model mạnh.** *Vì sao?* Giá token chênh nhau nhiều lần; hỏi cú pháp không cần flagship.
- **Gõ tay trước, chat sau, agent cuối.** *Vì sao?* Completions không tốn Credits, còn agent là mục tốn nhất.
- **Trả lời lạc đề → chat mới + `#file` gọn.** *Vì sao?* Phần lớn ca "model dốt đột xuất" thật ra là context nhiễu.
- **Attach đúng file thay vì cả folder.** *Vì sao?* Ít token hơn, ít bị phân tán hơn.
- **Check usage đầu và giữa chu kỳ.** *Vì sao?* Biết sớm để phân bổ model, tránh cạn vào lúc cần việc khó.
- **Chỉ nâng model mạnh khi task >15 phút.** *Vì sao?* 10 giây chọn model tiết kiệm hàng chục lượt tốn Credits.
- **Giữ `applyTo` của instructions thật hẹp.** *Vì sao?* Instructions rộng nhồi context sai vào mọi chat và làm chất lượng tụt.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

Chất lượng hoặc chi phí vẫn lệch sau khi đã thử mọi cách — chạy 5 bước check này theo thứ tự.

1. Check model đang chọn trong picker (có đúng ý mình không).
2. Mở chat mới + attach `#file` gọn (loại trừ context nhiễu).
3. Tắt instructions custom tạm để test.
4. Check hạn mức Credits: `github.com/settings/copilot`.
5. Vẫn tệ → đổi model mạnh hơn 1 nấc, hoặc hỏi lại với prompt chia nhỏ.

```bash
# Xác nhận nhanh model + hạn mức trước khi kết luận:
gh api user --jq .login            # đúng account chưa
# Mở https://github.com/settings/copilot -> xem "AI Credits usage"
# Verify: biết chắc model đang dùng + còn bao nhiêu Credits trong chu kỳ
```

---

## Tham khảo chéo

Muốn đào sâu tiếp thì rẽ theo hướng bạn đang vướng.

- Cài đặt + seat: [bài 01](01-tai-khoan-pricing-cai-dat.md). Instructions nhiễu context: [bài 06](06-prompts-agents-instructions.md).
- Agent tốn Credits: [bài 07](07-custom-agents-coding-agent-workflows.md). Bảo mật data khi dùng model: [bài 09](09-bao-mat-quyen-rieng-tu.md).
- Templates: [../templates/README.md](../templates/README.md).

> **Chốt bài:** Đừng hỏi "model nào mạnh nhất" mà hỏi "việc này đáng dùng model nào". Chọn đúng model theo độ khó, giữ context gọn bằng `#file`, và mở chat mới khi thấy lặp — ba thói quen đó xử lý gần hết cả "tốn tiền" lẫn "trả lời dở".
