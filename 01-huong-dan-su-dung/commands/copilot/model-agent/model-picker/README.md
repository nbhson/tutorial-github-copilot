# Model picker — đổi "bộ não" giữa chat: việc nhẹ model rẻ, việc khó model mạnh

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Agents window / Copilot CLI · **Đọc:** ~2 phút

**Nôm na:** Đang ăn giữa bữa mà món khó quá thì gọi bếp trưởng — nút model ở đáy Chat view cho bạn đổi hẳn model đang trả lời, ngay giữa cuộc chat: việc nhẹ dùng model rẻ cho đỡ tốn AI Credits, việc khó mới gọi model mạnh. Hợp khi credits bị đốt đều mà bạn nghi mình đang "để mạnh cho chắc" mọi việc.

## Vì sao dùng?

Giá giữa model rẻ nhất và đắt nhất chênh nhau nhiều lần — mặc định "mạnh cho chắc" là cách đốt AI Credits nhanh nhất, và đổi model theo cỡ việc thường tiết kiệm hơn cả ngồi tối ưu prompt. Hai thứ hay lẫn: nút model đổi "bộ não", không đổi "nơi chạy" — cái đó là [Session Target](../session-target/README.md).

| Surface | Cách gọi |
|---|---|
| Copilot harness | dropdown model ở đáy Chat view / Agents window — đường chuẩn; plan + chính sách org quyết danh sách |
| Local harness | `/models` trong local chat |
| Copilot CLI | `/model [MODEL\|auto TIER]` hoặc `/models` — kèm phạm vi lưu `--session` / `--global` / `--repo` / `--local` |

**Nếu làm sai:** gõ `/model` trong Chat view rồi thấy "không có gì" — slash đó thuộc CLI, Copilot harness xài dropdown. Và đổi model không cứu được prompt thiếu scope: model mạnh nhất cũng chỉ đoán mò, lại còn tốn thêm.

## Cách dùng

Bấm dropdown model ở đáy Chat view (Copilot harness); gắn scope trước, đổi model sau:

```prompt
#file:src/auth/login.ts — login email có dấu bị trả 500, tìm nguyên nhân, giữ API shape.
Câu trả lời còn mờ? lúc đó mới đổi lên model mạnh (CLI: /model).
```

- **Biến thể:** tier **Auto** — Copilot tự cân model theo độ khó task, khi chưa chắc thì khỏi phải nghĩ.
- **Setting:** trên CLI, cờ phạm vi lưu chọn model: `--session` / `--global` / `--repo` / `--local`.
- **✅ Verify:** chạy **cùng một prompt** trên bản rẻ và bản mạnh, đặt cạnh nhau — thấy được lúc nào đáng tiền là dùng đúng.

## Liên quan

- Model nào đang ngốn credit: [ai-credits](../ai-credits/README.md) · chọn "nơi chạy" (khác "bộ não"): [session-target](../session-target/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Customize the model picker](https://code.visualstudio.com/docs/agent-customization/language-models#customize-the-model-picker) · [VS Code Docs — Choose the right model](https://code.visualstudio.com/docs/agents/concepts/language-models#choose-the-right-model)
