# FAQ 02 — Model, Context & Premium

> Nhóm Model & Context · 10 câu hỏi deep-dive · Đọc xong biết chọn model nào, khi nào tốn premium, giữ context sao cho gọn

File này trả lời mọi câu hỏi "model picker chọn gì, premium multiplier là gì, context window bao nhiêu, BYOK được không". Mỗi câu có giải thích + lệnh copy-paste + ví dụ + khi nào áp dụng.

---

## Sơ đồ tư duy nhanh (đọc 30 giây)

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

| Việc | Model nên chọn | Vì sao |
|---|---|---|
| Gõ code hàng ngày, completion | Model mặc định (nhanh, rẻ) | Latency thấp, không tốn premium |
| Chat hỏi đáp, refactor vừa | Model cân bằng (VD GPT / Claude Sonnet) | Đủ thông minh, multiplier vừa |
| Debug khó, kiến trúc, multi-file | Model mạnh nhất (VD Claude Opus / GPT-5-class) | Multiplier cao nhưng đáng |
| Review bảo mật / logic nặng | Model mạnh + custom agent security-reviewer | Kết hợp model + instructions |
| Tiết kiệm quota cuối tháng | Về model mặc định, tắt Agent mode | Giữ premium requests cho việc khó |

---

## 1. Model picker ở đâu, đổi model thế nào?

> **Hỏi ngắn gọn:** _Model picker ở đâu, đổi model thế nào?_

**Trả lời 1 câu:** 

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

**Ví dụ cụ thể:** chat đang dùng model mạnh để hỏi cú pháp đơn giản → phí premium. Đổi dropdown về model nhẹ cho câu dễ, dành model mạnh cho refactor.

> **Khi nào áp dụng:** mỗi khi mở chat mới — chọn model theo độ khó việc, đừng để mặc định mãi.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 2. Premium multiplier là gì, model nào tốn bao nhiêu?

> **Hỏi ngắn gọn:** _Premium multiplier là gì, model nào tốn bao nhiêu?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** Mỗi plan có quota **premium requests/tháng**. Model thường (multiplier ×1) tốn 1 request; model mạnh (×3, ×5, ×10...) tốn nhiều hơn mỗi lần gọi. Hết quota → hoặc chờ reset, hoặc trả thêm, hoặc rớt về model thường.

Quy tắc: **completion hàng ngày ×1, chat vừa ×1–3, agent/model mạnh ×5+.** Agent mode gọi nhiều lượt → nhân lên nhanh.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Không có CLI xem quota; check web:
# https://github.com/settings/copilot -> "Premium requests usage"
# Kinh nghiệm: đầu tháng check 1 lần, giữa tháng check 1 lần
```

**Ví dụ cụ thể:** Pro cho 1.500 premium/tháng. Dùng model ×5 cho mọi chat linh tinh → 300 câu là hết. Dùng model ×1 cho việc dễ + ×5 cho việc khó → đủ cả tháng.

> **Khi nào áp dụng:** khi chat báo "premium quota exhausted" — xem lại mình đã đốt multiplier cao vào việc gì.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 3. Context window là gì, Copilot nhét gì vào context?

> **Hỏi ngắn gọn:** _Context window là gì, Copilot nhét gì vào context?_

**Trả lời 1 câu:** 

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

> **Hỏi ngắn gọn:** _Tràn context thì làm gì (chat dài, agent lặp)?_

**Trả lời 1 câu:** 

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

> **Khi nào áp dụng:** ngay khi thấy agent lặp lần 3 cùng 1 lỗi — đừng để nó đốt premium vô ích.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 5. BYOK (Bring Your Own Key) là gì, Copilot có hỗ trợ không?

> **Hỏi ngắn gọn:** _BYOK (Bring Your Own Key) là gì, Copilot có hỗ trợ không?_

**Trả lời 1 câu:** 

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

> **Hỏi ngắn gọn:** _Nên dùng model nào cho việc nào (khuyến nghị thực tế)?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** Nguyên tắc **"việc dễ model nhẹ, việc khó model mạnh"**:

- **Completion gõ tay:** model mặc định — latency quan trọng hơn thông minh.
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

> **Khi nào áp dụng:** trước mỗi task >15 phút — dành 10 giây chọn model đúng, tiết kiệm hàng chục premium requests.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 7. Completions vs Chat vs Agent tốn quota khác nhau ra sao?

> **Hỏi ngắn gọn:** _Completions vs Chat vs Agent tốn quota khác nhau ra sao?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** Thứ tự tốn quota tăng dần:

1. **Completions (gợi ý xám):** rẻ nhất, thường nằm trong quota base.
2. **Chat 1 câu:** tốn theo multiplier model chat.
3. **Edit mode:** chat + apply → tốn hơn chat thường 1 chút.
4. **Agent mode:** nhiều vòng tool-call → tốn gấp nhiều lần 1 chat.

Vì vậy: gõ tay được thì đừng chat; chat được thì đừng agent.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Thói quen tiết kiệm quota:
# 1. Gõ -> Tab (completions, rẻ nhất)
# 2. Không ra -> hỏi chat 1 câu gọn (tầm trung)
# 3. Việc multi-file -> mới bật Agent mode (đắt nhất)
```

**Ví dụ cụ thể:** đổi tên biến 10 chỗ → dùng IDE rename (0 quota) thay vì nhờ agent (tốn 5+ requests).

> **Khi nào áp dụng:** cuối tháng khi quota đỏ — chuyển 80% việc về completions + chat nhẹ.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 8. Sao cùng 1 prompt mà hôm nay dở hơn hôm qua?

> **Hỏi ngắn gọn:** _Sao cùng 1 prompt mà hôm nay dở hơn hôm qua?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** 4 nguyên nhân phổ biến (theo thứ tự kiểm tra):

1. **Model sau lưng bị đổi** (GitHub âm thầm update default model) → check model picker.
2. **Context khác** (mở file khác, instructions khác) → check referenced files.
3. **Instructions mới thêm** làm nhiễu → thử tắt instructions custom.
4. **Quota hết → rớt model yếu** → check usage page.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Checklist khi chất lượng tụt:
# 1. Chat mới + cùng prompt + cùng model -> còn dở không?
# 2. Tắt .github/instructions custom tạm -> khá hơn không?
# 3. https://github.com/settings/copilot -> quota còn không?
```

**Ví dụ cụ thể:** team thêm `frontend-react.instructions.md` với `applyTo: **` → mọi chat backend cũng bị nhồi React context → chất lượng tụt. Fix: sửa `applyTo` cho hẹp (xem [bài 06](06-prompts-agents-instructions.md)).

> **Khi nào áp dụng:** khi "hôm qua còn ngon" — đừng đổi model vội, check context trước.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 9. Có khóa model cố định cho cả team được không?

> **Hỏi ngắn gọn:** _Có khóa model cố định cho cả team được không?_

**Trả lời 1 câu:** 

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

**Ví dụ cụ thể:** team muốn tiết kiệm quota → admin allowlist chỉ 2 model (1 nhẹ + 1 mạnh), dev tự chọn theo việc.

> **Khi nào áp dụng:** khi bill premium của team tăng đột biến — khóa allowlist + training 10 phút về chọn model.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 10. Dùng Copilot hết quota giữa tháng thì chữa cháy sao?

> **Hỏi ngắn gọn:** _Dùng Copilot hết quota giữa tháng thì chữa cháy sao?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** Thứ tự chữa cháy:

1. Chuyển chat về model ×1, tắt Agent mode.
2. Dùng completions + IDE refactor thay vì chat.
3. Xin admin mua thêm premium / chuyển sang Pro (nếu đáng).
4. Task gấp + model mạnh cần thiết → dùng web `github.com/copilot` (chung quota nhưng đôi khi còn slot) hoặc chờ reset.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Check ngày reset quota (web UI):
# https://github.com/settings/copilot -> Billing cycle ends ...
# Tính toán: quota còn lại / số ngày còn lại = ngân sách/ngày
```

**Ví dụ cụ thể:** còn 100 premium mà 10 ngày nữa mới reset → 10/ngày: chỉ bật model mạnh cho task blocker, còn lại model nhẹ.

> **Khi nào áp dụng:** ngay khi nhận cảnh báo quota 80% — đừng đợi cạn mới tiết kiệm.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Check model đang chọn trong picker (có đúng ý mình không).
2. Mở chat mới + attach `#file` gọn (loại trừ context nhiễu).
3. Tắt instructions custom tạm để test.
4. Check quota: `github.com/settings/copilot`.
5. Vẫn tệ → đổi model mạnh hơn 1 nấc, hoặc hỏi lại với prompt chia nhỏ.

---

## Tham khảo chéo

- Cài đặt + seat: [bài 01](01-tai-khoan-pricing-cai-dat.md). Instructions nhiễu context: [bài 06](06-prompts-agents-instructions.md).
- Agent tốn quota: [bài 07](07-custom-agents-coding-agent-workflows.md). Bảo mật data khi dùng model: [bài 09](09-bao-mat-quyen-rieng-tu.md).
- Templates: [../templates/README.md](../templates/README.md).

> Mẹo 1 dòng: _việc dễ model nhẹ, việc khó model mạnh, và chat mới + #file gọn giải quyết 80% ca "model dốt đột xuất"._
