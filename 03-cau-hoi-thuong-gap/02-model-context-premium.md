# FAQ 02 — Model, Context & Chi Phí AI Credits

> **Vấn đề:** "model picker chọn gì, AI Credits tính tiền thế nào, tràn context xử ra sao, BYOK được không" — dùng model mạnh cho việc lặt vặt là cách đốt Credits nhanh nhất; để context phình to thì agent quên đầu bài rồi lặp vòng.

## Bảng tổng hợp: chọn model nhanh

| Việc | Model nên chọn | Vì sao |
|---|---|---|
| Gõ code hàng ngày, completion | Model mặc định | Latency thấp, không tốn AI Credits |
| Chat hỏi đáp, refactor vừa | Model cân bằng (GPT / Claude Sonnet) | Đủ thông minh, chi phí vừa |
| Debug khó, kiến trúc, multi-file | Model mạnh nhất (Claude Opus / GPT-5-class) | Chi phí cao nhưng đáng |
| Tiết kiệm cuối chu kỳ | Về model mặc định, tắt Agent mode | Giữ AI Credits cho việc khó |

---

## 1. Model picker ở đâu, đổi model thế nào?

**Trả lời 1 câu:** Model picker nằm ở Completions (setting), Chat sidebar (dropdown) và Agent/Edit mode — đổi model chat không ảnh hưởng completions lẫn ngược lại.

- **Completions:** setting `github.copilot.completions.model` — thường không cần đổi.
- **Chat sidebar / Agent mode:** dropdown trên khung chat, chọn theo conversation.

```bash
# VS Code settings.json: ghim model completions (nếu muốn)
# { "github.copilot.completions.model": "<model-id>" }
# Chat model: đổi bằng dropdown trong Chat view (không có lệnh CLI)
```

> **Nếu picker thiếu model:** check org policy allowlist (admin ẩn), reload IDE, hỏi admin mở thêm.

## 2. AI Credits tính tiền thế nào?

**Trả lời 1 câu:** Từ 01/06/2026 mọi lượt tính bằng **AI Credits (1 credit = $0.01)**: chi phí = giá mỗi token của model × số token — model đắt tốn nhiều Credits hơn, còn completions thì không tốn gì.

- **Cách cũ (trước 06/2026):** quota "premium requests"/tháng + multiplier ×3/×5/×10 theo request — **LEGACY**, chỉ còn thấy trong tài liệu cũ.
- **Cách mới:** không còn multiplier theo request; model đắt có giá token cao → cùng 1 prompt tốn nhiều credits hơn.
- **Code completions KHÔNG trừ Credits** — không giới hạn trên plan trả phí.
- Plan trả phí dùng **auto model selection được giảm 10%**.
- Hết credits base + flex → tính vào **additional usage budget** (spend cap cấu hình được).

| Cách dùng | Tốn AI Credits? | Mức độ |
|---|---|---|
| Completions (gợi ý xám) | Không | 0 |
| Chat 1 câu | Có (theo token) | Thấp |
| Edit mode | Có (chat + apply) | Trung bình |
| Agent mode | Có (nhiều tool-call) | Cao nhất |

Thứ tự tốn Credits tăng dần → **gõ tay được thì đừng chat; chat được thì đừng agent.**

```bash
# Theo dõi usage trên web (không có CLI):
# https://github.com/settings/copilot -> "AI Credits usage"
# Kinh nghiệm: đầu tháng check 1 lần, giữa tháng check 1 lần
```

**Ví dụ cụ thể:** Pro 1.500 credits/tháng (1.000 base + 500 flex). Dùng model đắt cho mọi chat linh tinh → cạn nhanh; model rẻ cho việc dễ + model mạnh cho việc khó → đủ cả tháng.

> **Khi chat báo "AI Credits limit reached":** xem usage page, đối chiếu model đắt nào dùng nhiều, có agent chạy vòng lặp không, instructions dài có bị nạp mỗi turn không.

## 3. Context window là gì, Copilot nhét gì vào context?

**Trả lời 1 câu:** Context là toàn bộ code + instructions + kết quả tool mà Copilot đọc mỗi lần gợi ý; tràn context thì gợi ý tệ, chat quên đầu bài, agent lặp vòng.

Gồm: file đang mở (vùng quanh con trỏ), file liên quan (imports, file mở gần đây), `#file` / `#selection` bạn attach, `copilot-instructions.md` + instructions khớp `applyTo`, và (Agent mode) kết quả tool calls.

```bash
# Trong Chat: gắn file cụ thể thay vì để Copilot tự đoán
# #file:src/auth/login.ts giải thích hàm này làm gì
# #selection refactor đoạn này sang async/await
# Kiểm tra instructions nào đang ăn: Chat -> "..." -> referenced files
```

> **Trả lời lạc đề:** 80% là context nhiễu, không phải model dốt.

## 4. Tràn context thì làm gì?

**Trả lời 1 câu:** Mở chat mới là cách rẻ nhất, rồi thu hẹp scope bằng `#file`, tóm tắt tay bối cảnh và chia task lớn thành task nhỏ.

1. **Mở chat mới** (`Ctrl+Shift+P → "Chat: New Chat"`).
2. **Thu hẹp scope:** `#file` cụ thể thay vì cả folder.
3. **Tóm tắt tay:** copy kết luận sang chat mới ("tiếp tục từ: ...").
4. **Chia task:** 1 task lớn → 3 task nhỏ (xem [bài 07](07-custom-agents-coding-agent-workflows.md)).

**Ví dụ:** agent refactor 20 file chạy 30 phút chưa xong → dừng, chia 3 đợt (models → api → tests), mỗi đợt 1 chat mới. Ngay khi agent lặp lần 3 cùng 1 lỗi — đừng để nó đốt Credits vô ích.

## 5. BYOK (Bring Your Own Key) có được không?

**Trả lời 1 câu:** Copilot mặc định **KHÔNG BYOK** cho completions/chat — model đi qua hạ tầng GitHub; chỉ **Enterprise + Azure OpenAI** route được qua Azure tenant của bạn (admin cấu hình).

Cần gọi model ngoài cho workflow riêng → dùng **Copilot CLI / SDK** (xem [bài 10](10-ci-sdk-review-web.md)). Compliance hỏi "data đi đâu" → xem [bài 09](09-bao-mat-quyen-rieng-tu.md).

## 6. Nên dùng model nào cho việc nào?

**Trả lời 1 câu:** Việc dễ dùng model nhẹ, việc khó dùng model mạnh, agent tự chạy lâu thì phải kèm instructions chặt.

- Completion gõ tay: model mặc định — latency quan trọng hơn thông minh, không tốn Credits.
- Giải thích code, viết test đơn: model tầm trung.
- Refactor multi-file, debug race condition, thiết kế: model mạnh nhất.
- Agent tự chạy lâu: model mạnh + instructions chặt (không thì nó chạy loạn bằng model đắt).

```bash
# Mẫu chat mở đầu để ép scope trước khi nâng model:
# "Đọc #file:src/auth/login.ts và #file:src/auth/session.ts,
#  liệt kê 3 chỗ có thể gây race condition. Chưa cần sửa."
```

## 7. Sao cùng 1 prompt mà hôm nay dở hơn hôm qua?

**Trả lời 1 câu:** Check theo thứ tự model → context → instructions → hạn mức — 4 thứ này đổi được, đừng kết luận model "dốt đột xuất".

1. **Model sau lưng bị đổi** (GitHub âm thầm update default) → check model picker.
2. **Context khác** (mở file khác, instructions khác) → check referenced files.
3. **Instructions mới thêm** làm nhiễu → thử tắt instructions custom.
4. **Hết Credits → rớt model yếu** → check usage page.

**Ví dụ:** team thêm `frontend-react.instructions.md` với `applyTo: **` → mọi chat backend cũng bị nhồi React context → chất lượng tụt. Fix: sửa `applyTo` cho hẹp (xem [bài 06](06-prompts-agents-instructions.md)).

## 8. Có khóa model cố định cho cả team được không?

**Trả lời 1 câu:** Được ở 2 mức — org policy allowlist (admin, ép buộc) và `copilot-instructions.md` (team, chỉ là khuyến nghị).

| Mức | Ai set | Ép buộc? |
|---|---|---|
| Org policy (allowlist) | Admin Business/Enterprise | Có |
| `copilot-instructions.md` | Team, commit vào repo | Không (khuyến nghị) |

```markdown
<!-- Đoạn mẫu trong .github/copilot-instructions.md -->
## Model guidance (khuyến nghị, không ép buộc)
- Chat hằng ngày: model mặc định.
- Review PR / refactor auth: model mạnh nhất hiện có.
```

> **Khi bill team tăng đột biến:** admin allowlist chỉ 2 model (1 rẻ + 1 mạnh) + training 10 phút về chọn model.

## 9. Hết AI Credits giữa tháng thì chữa cháy sao?

**Trả lời 1 câu:** Thứ tự: chuyển về model rẻ + tắt Agent → dùng completions và IDE refactor (0 Credits) → xin admin thêm budget / chuyển plan → chờ chu kỳ mới.

```bash
# Check ngày reset: https://github.com/settings/copilot -> Billing cycle ends
# Credits còn lại / số ngày còn lại = ngân sách/ngày
```

**Ví dụ:** còn 100 Credits mà 10 ngày nữa mới reset → 10/ngày: chỉ bật model mạnh cho task blocker, còn lại model nhẹ. Đừng đợi cạn mới tiết kiệm — nhận cảnh báo 80% là bắt đầu.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Check model đang chọn trong picker (đúng ý chưa).
2. Mở chat mới + attach `#file` gọn (loại trừ context nhiễu).
3. Tắt instructions custom tạm để test.
4. Check hạn mức: `github.com/settings/copilot` → "AI Credits usage".
5. Vẫn tệ → đổi model mạnh hơn 1 nấc, hoặc chia nhỏ prompt.

Tham khảo chéo: [bài 01](01-tai-khoan-pricing-cai-dat.md) (cài đặt + seat) · [bài 06](06-prompts-agents-instructions.md) (instructions) · [bài 07](07-custom-agents-coding-agent-workflows.md) (agent tốn Credits) · [bài 09](09-bao-mat-quyen-rieng-tu.md) (bảo mật data).
