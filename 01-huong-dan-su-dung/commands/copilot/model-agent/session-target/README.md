# Session Target — chọn "đội thợ + nhà xưởng": harness và nơi agent chạy (Local / Copilot / Cloud)

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Agents window / Copilot in the cloud · **Đọc:** ~2 phút

**Nôm na:** Công tắc ở đáy khung Chat quyết ai làm và làm ở đâu: **Local** làm ngay trong VS Code, **Copilot** chạy nền trên Agent Host, **Cloud** giao cho hạ tầng managed của GitHub rồi nhận PR về. Hợp khi muốn chạy nền, mở nhiều phiên song song, hoặc giao hẳn task cho team review.

## Vì sao dùng?

Cùng một task, chỗ chạy quyết định bạn được gì và mất gì: Local dùng được tool/extension của VS Code nhưng phải giữ cửa sổ; Copilot chạy nền nên mở nhiều phiên song song và mở lại ở cửa sổ khác được; Cloud giao được nhưng **không thấy context local**. Hai điểm hay nhầm nhất: đổi target **không phải** đổi model, và Cloud **không phải một harness** — nó là execution target chạy chính Copilot harness.

| Lựa chọn trong picker | Nó là gì | Khi nào chọn |
|---|---|---|
| **Local** | harness của VS Code, chạy trong cửa sổ của bạn | cần tool/extension/model cấu hình trong VS Code |
| **Copilot** | harness Copilot, chạy nền trên Agent Host | chạy nền, nhiều phiên song song, mở lại ở cửa sổ khác |
| **Claude / Codex** | harness thật của provider, hiện trong picker | quen workflow của provider (bị chặn khi org bật managed settings) |
| **Cloud** | **không phải harness** — execution target chạy Copilot harness, kết thúc bằng PR | task gọn, độc lập, giao hẳn cho team review |

**Nếu làm sai:** muốn chạy nền mà ở mãi Local thì phải giữ cửa sổ mở; cần tool VS Code mà giao Cloud thì kết quả cụt vì Cloud không thấy context local.

## Cách dùng

Mở dropdown Session Target ở đáy khung Chat (Copilot harness / Agents window), chọn theo "cần tay chân gì":

```prompt
→ Local     sửa src/auth/login.ts, chạy npm test ngay trong editor
→ Copilot   refactor module payments + chạy test   (chạy nền, nhiều phiên song song)
→ Cloud     thêm endpoint /healthz + test          → agent mở PR cho team review
```

- **Biến thể:** dời phiên mà giữ history + context thì dùng **Handoff** (chỉ khởi tạo được từ session Local), đừng tưởng đổi target là chat mới.
- **Setting:** không thấy Copilot/Cloud trong list? Thường do chưa đăng nhập GitHub, Agent Host chưa bật, hoặc org policy chặn harness — kiểm tra trước khi kết luận "lỗi tool".
- **✅ Verify:** session hiện đúng target ở Agent Sessions sidebar; Cloud chạy xong phải có PR mới trên GitHub.

## Liên quan

- Đổi "bộ não" (khác đổi nơi chạy): [model-picker](../model-picker/README.md) · 3 núm modes/tools/environment của phiên cloud: [cloud-agent-session](../../../cloud/model-agent/cloud-agent-session/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Choose an Agent Harness](https://code.visualstudio.com/docs/agents/run/agent-harnesses) · [VS Code Docs — Choose the right agent harness](https://code.visualstudio.com/docs/agents/best-practices#choose-the-right-agent-harness)
