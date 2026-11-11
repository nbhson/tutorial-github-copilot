# FAQ 02 — Model, Context & Chi Phí AI Credits

> **Vấn đề:** "model picker chọn gì, AI Credits tính tiền thế nào, tràn context xử ra sao, BYOK được không" — dùng model mạnh cho việc lặt vặt là cách đốt Credits nhanh nhất; để context phình to thì agent quên đầu bài rồi lặp vòng.

## Bảng tổng hợp: chọn model nhanh

| Việc | Model nên chọn | Vì sao |
|---|---|---|
| Gõ code hàng ngày, completion | Model mặc định | Latency thấp, không tốn AI Credits |
| Chat hỏi đáp, refactor vừa | Model cân bằng (GPT / Claude Sonnet) | Đủ thông minh, chi phí vừa |
| Debug khó, kiến trúc, multi-file | Model mạnh nhất (Claude Opus / GPT-5-class) | Chi phí cao nhưng đáng |
| Tiết kiệm cuối chu kỳ | Về model mặc định, tắt Agent mode | Giữ AI Credits cho việc khó |

> **Cách đọc bảng này:** cột **Việc** là loại việc bạn đang định làm, cột **Model nên chọn** là đáp án để chốt ngay trong picker; đọc cả cột **Vì sao** vài lần là thuộc lòng logic "việc dễ → model nhẹ". · 📄 [GitHub Docs: Model comparison](https://docs.github.com/en/copilot/reference/ai-models/model-comparison)

---

## 1. Model picker ở đâu, đổi model thế nào?

**Trả lời 1 câu:** Model picker nằm ở Completions (setting), Chat sidebar (dropdown) và Agent/Edit mode — đổi model chat không ảnh hưởng completions lẫn ngược lại.

- **Completions:** setting `github.copilot.completions.model` — thường không cần đổi.
- **Chat sidebar / Agent mode:** dropdown trên khung chat, chọn theo conversation.

> 📄 **Code ví dụ:** [`./examples/02-model-context-premium/model-picker-o-au-oi-model-the.sh`](./examples/02-model-context-premium/model-picker-o-au-oi-model-the.sh)

> **Nếu picker thiếu model:** check org policy allowlist (admin ẩn), reload IDE, hỏi admin mở thêm. · 📄 [VS Code Docs: Change the model for chat](https://code.visualstudio.com/docs/agent-customization/language-models#change-the-model-for-chat)

## 2. AI Credits tính tiền thế nào?

**Trả lời 1 câu:** Từ 01/06/2026 mọi lượt tính bằng **AI Credits (1 credit = $0.01)**: chi phí = giá mỗi token của model × số token — model đắt tốn nhiều Credits hơn, còn completions thì không tốn gì.

Hãy hình dung Credits như tiền điện: mỗi thiết bị (model) có công suất khác nhau, bật điều hòa (model mạnh) cả ngày thì đồng hồ quay vù vù, còn bóng đèn LED (completions) thì gần như không đoán được ra trên hóa đơn.

- **Cách cũ (trước 06/2026):** quota "premium requests"/tháng + multiplier ×3/×5/×10 theo request — **LEGACY**, chỉ còn thấy trong tài liệu cũ.
- **Cách mới:** không còn multiplier theo request; model đắt có giá token cao → cùng 1 prompt tốn nhiều credits hơn.
- **Code completions KHÔNG trừ Credits** — không giới hạn trên plan trả phí.
- Hết credits base + flex → tính vào **additional usage budget** (spend cap cấu hình được).

| Cách dùng | Tốn AI Credits? | Mức độ |
|---|---|---|
| Completions (gợi ý xám) | Không | 0 |
| Chat 1 câu | Có (theo token) | Thấp |
| Edit mode | Có (chat + apply) | Trung bình |
| Agent mode | Có (nhiều tool-call) | Cao nhất |

Thứ tự tốn Credits tăng dần → **gõ tay được thì đừng chat; chat được thì đừng agent.**

> 📄 **Code ví dụ:** [`./examples/02-model-context-premium/ai-credits-tinh-tien-the-nao.sh`](./examples/02-model-context-premium/ai-credits-tinh-tien-the-nao.sh)

**Ví dụ cụ thể:** Pro 1.500 credits/tháng (1.000 base + 500 flex) — số liệu as of 11/2026, verify tại github.com/features/copilot. Dùng model đắt cho mọi chat linh tinh → cạn nhanh; model rẻ cho việc dễ + model mạnh cho việc khó → đủ cả tháng.

> **Khi chat báo "AI Credits limit reached":** xem usage page, đối chiếu model đắt nào dùng nhiều, có agent chạy vòng lặp không, instructions dài có bị nạp mỗi turn không. · 📄 [GitHub Docs: Models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)

## 3. Context window là gì, Copilot nhét gì vào context?

**Trả lời 1 câu:** Context là toàn bộ code + instructions + kết quả tool mà Copilot đọc mỗi lần gợi ý; tràn context thì gợi ý tệ, chat quên đầu bài, agent lặp vòng.

Ví von: context là chiếc cặp Copilot mang theo mỗi lần gặp bạn — nhét cả ngăn kéo vào cặp thì chân chính nó lùi lại phía sau, càng đi càng chậm và quên mất mình định mang gì.

Gồm: file đang mở (vùng quanh con trỏ), file liên quan (imports, file mở gần đây), `#file` / `#selection` bạn attach, `copilot-instructions.md` + instructions khớp `applyTo`, và (Agent mode) kết quả tool calls.

> 📄 **Code ví dụ:** [`./examples/02-model-context-premium/context-window-la-gi-copilot-nhet-gi.sh`](./examples/02-model-context-premium/context-window-la-gi-copilot-nhet-gi.sh)

> **Trả lời lạc đề:** 80% là context nhiễu, không phải model dốt. · 📄 [VS Code Docs: Context window & compaction](https://code.visualstudio.com/docs/agents/concepts/context#context-window-and-compaction)

## 4. Tràn context thì làm gì?

**Trả lời 1 câu:** Mở chat mới là cách rẻ nhất, rồi thu hẹp scope bằng `#file`, tóm tắt tay bối cảnh và chia task lớn thành task nhỏ.

1. **Mở chat mới** (`Ctrl+Shift+P → "Chat: New Chat"`).
2. **Thu hẹp scope:** `#file` cụ thể thay vì cả folder.
3. **Tóm tắt tay:** copy kết luận sang chat mới ("tiếp tục từ: ...").
4. **Chia task:** 1 task lớn → 3 task nhỏ (xem [bài 07](07-custom-agents-coding-agent-workflows.md)).

**Ví dụ:** agent refactor 20 file chạy 30 phút chưa xong → dừng, chia 3 đợt (models → api → tests), mỗi đợt 1 chat mới. Ngay khi agent lặp lần 3 cùng 1 lỗi — đừng để nó đốt Credits vô ích. · 📄 [VS Code Docs: Compact the conversation](https://code.visualstudio.com/docs/agents/guides/get-agent-back-on-track#compact-the-current-conversation)

## 5. BYOK (Bring Your Own Key) có được không?

**Trả lời 1 câu:** Copilot mặc định **KHÔNG BYOK** cho completions/chat — model đi qua hạ tầng GitHub; chỉ **Enterprise + Azure OpenAI** route được qua Azure tenant của bạn (admin cấu hình).

Cần gọi model ngoài cho workflow riêng → dùng **Copilot CLI / SDK** (xem [bài 10](10-ci-sdk-review-web.md)). Compliance hỏi "data đi đâu" → xem [bài 09](09-bao-mat-quyen-rieng-tu.md). 📄 Cách BYOK/usage qua API key riêng + billing: [`../01-huong-dan-su-dung/examples/14-models-chon-model-dung/byok-additional-usage.json`](../01-huong-dan-su-dung/examples/14-models-chon-model-dung/byok-additional-usage.json). · 📄 [GitHub Docs: Bring your own key](https://docs.github.com/en/copilot/concepts/models/bring-your-own-key)

## 6. Nên dùng model nào cho việc nào?

**Trả lời 1 câu:** Việc dễ dùng model nhẹ, việc khó dùng model mạnh, agent tự chạy lâu thì phải kèm instructions chặt.

- Completion gõ tay: model mặc định — latency quan trọng hơn thông minh, không tốn Credits.
- Giải thích code, viết test đơn: model tầm trung.
- Refactor multi-file, debug race condition, thiết kế: model mạnh nhất.
- Agent tự chạy lâu: model mạnh + instructions chặt (không thì nó chạy loạn bằng model đắt).

> 📄 **Code ví dụ:** [`./examples/02-model-context-premium/nen-dung-model-nao-cho-viec-nao.sh`](./examples/02-model-context-premium/nen-dung-model-nao-cho-viec-nao.sh) · 📄 [VS Code Docs: Choose the right model](https://code.visualstudio.com/docs/agents/concepts/language-models#choose-the-right-model)

## 7. Sao cùng 1 prompt mà hôm nay dở hơn hôm qua?

**Trả lời 1 câu:** Check theo thứ tự model → context → instructions → hạn mức — 4 thứ này đổi được, đừng kết luận model "dốt đột xuất".

1. **Model sau lưng bị đổi** (GitHub âm thầm update default) → check model picker.
2. **Context khác** (mở file khác, instructions khác) → check referenced files.
3. **Instructions mới thêm** làm nhiễu → thử tắt instructions custom (đối chiếu file đang nạp: [`./examples/02-model-context-premium/file-nao-copilot-tu-load-file-nao.sh`](./examples/02-model-context-premium/file-nao-copilot-tu-load-file-nao.sh)).
4. **Hết Credits → rớt model yếu** → check usage page.

**Ví dụ:** team thêm `frontend-react.instructions.md` với `applyTo: **` → mọi chat backend cũng bị nhồi React context → chất lượng tụt. Fix: sửa `applyTo` cho hẹp (xem [bài 06](06-prompts-agents-instructions.md)). · 📄 [VS Code Docs: Auto model selection](https://code.visualstudio.com/docs/agents/concepts/language-models#auto-model-selection)

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

> **Khi bill team tăng đột biến:** admin allowlist chỉ 2 model (1 rẻ + 1 mạnh) + training 10 phút về chọn model. · 📄 [GitHub Docs: Manage default models](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-organization/manage-default-models)

## 9. Hết AI Credits giữa tháng thì chữa cháy sao?

**Trả lời 1 câu:** Thứ tự: chuyển về model rẻ + tắt Agent → dùng completions và IDE refactor (0 Credits) → xin admin thêm budget / chuyển plan → chờ chu kỳ mới.

> 📄 **Code ví dụ:** [`./examples/02-model-context-premium/het-ai-credits-giua-thang-thi-chua.sh`](./examples/02-model-context-premium/het-ai-credits-giua-thang-thi-chua.sh)

**Ví dụ:** còn 100 Credits mà 10 ngày nữa mới reset → 10/ngày: chỉ bật model mạnh cho task blocker, còn lại model nhẹ. Đừng đợi cạn mới tiết kiệm — nhận cảnh báo 80% là bắt đầu.

> **Tóm gọn 1 câu:** Credits là ví có hạn: đổi sang tiền lẻ khi lương sắp vơi, ưu tiên chi cho việc chặn dòng tiền (task blocker) — và bật đèn cảnh báo lúc 80% chứ đừng đợi 0%. · 📄 [VS Code Docs: Reached the AI credits limit](https://code.visualstudio.com/docs/agents/agent-troubleshooting/faq#i-reached-my-inline-suggestions-or-ai-credits-limit)

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Check model đang chọn trong picker (đúng ý chưa).
2. Mở chat mới + attach `#file` gọn (loại trừ context nhiễu).
3. Tắt instructions custom tạm để test.
4. Check hạn mức: `github.com/settings/copilot` → "AI Credits usage".
5. Vẫn tệ → đổi model mạnh hơn 1 nấc, hoặc chia nhỏ prompt.

📄 Checklist debug 6 bước khi instructions/model gây nhiễu: [`./examples/02-model-context-premium/instructions-khong-load-checklist-6-buoc.sh`](./examples/02-model-context-premium/instructions-khong-load-checklist-6-buoc.sh).

Tham khảo chéo: [bài 01](01-tai-khoan-pricing-cai-dat.md) (cài đặt + seat) · 📄 checklist debug: [./examples/02-model-context-premium/instructions-khong-load-checklist-6-buoc.sh](./examples/02-model-context-premium/instructions-khong-load-checklist-6-buoc.sh) · [bài 06](06-prompts-agents-instructions.md) (instructions) · [bài 07](07-custom-agents-coding-agent-workflows.md) (agent tốn Credits) · [bài 09](09-bao-mat-quyen-rieng-tu.md) (bảo mật data). · 📄 [GitHub Docs: Monitor AI usage](https://docs.github.com/en/copilot/how-tos/manage-and-track-spending/monitor-ai-usage)
