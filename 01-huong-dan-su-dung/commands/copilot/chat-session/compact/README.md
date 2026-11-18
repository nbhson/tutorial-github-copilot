# /compact — Nén hội thoại dài thành bản tóm tắt

> **Harness:** Copilot · **Surface:** Chat view (Copilot & Claude harness), Copilot CLI · **Đọc:** ~2 phút

**Nôm na:** `/compact` gấp toàn bộ hội thoại dài thành một bản tóm tắt rồi nạp lại vào ngữ cảnh, để session đi tiếp nhẹ nhàng mà không bật sang chat trắng. Hợp khi session đã 20–30 lượt và model bắt đầu "quên" đầu chuyện.

## Vì sao dùng?

Mỗi model chỉ có một cửa sổ ngữ cảnh giới hạn. Khi hội thoại vượt ngưỡng, lượt cũ bị trượt ra ngoài — triệu chứng: model quên quyết định đã chốt, sửa lại file đã sửa, bịa tên file. `/compact` ép nó chốt lại những gì quan trọng **ngay lúc bạn chọn**, thay vì để nó âm thầm quên.

| Cách nén | Chuyện xảy ra | Khi nào |
|---|---|---|
| `/compact` | Tóm tắt hội thoại agent, session chạy tiếp | Giữa task dài |
| `/compact <chỉ dẫn>` | Tóm tắt **theo ý bạn** — "giữ lại quyết định về schema" | Khi có phần không được phép mất |
| Tự động | Session tự nén khi cửa sổ ngữ cảnh gần đầy | Mặc định, chỉnh bằng setting |
| Nút trong UI | Thanh context window có mục **Compact Conversation** | Khi thấy % ngữ cảnh tăng cao |

**Nếu làm sai:** compact **không** trả lại token đã ngốn, và bản tóm tắt có thể sót chi tiết bạn đang cần — đọc lại nó trước khi chạy tiếp. Muốn trang trắng hoàn toàn thì đó là [chat mới](../new-chat/README.md) (`Ctrl+N`), không phải compact; còn muốn giữ nguyên văn từng dòng thì export ra file trước.

## Cách dùng

Gõ trong Chat view (Copilot harness); Copilot CLI cũng có `/compact`.

```prompt
/compact tập trung vào: các file đã sửa, quyết định kiến trúc, việc còn dở
```

- **Biến thể:** `/compact` trần — model tự đoán phần để giữ; thêm chỉ dẫn khi có thứ sống còn.
- **Setting:** `github.copilot.chat.summarizeAgentConversationHistory.enabled` — bật = tự nén khi gần đầy, tắt = bạn tự bấm.
- **✅ Verify:** hỏi "ta đã chốt phương án nào về token?" — model trả lời đúng hướng cũ.

## Liên quan

- Muốn bắt đầu hẳn việc khác: [new-chat](../new-chat/README.md) · Dọn + archive để hỏi lại: [clear](../clear/README.md) · Thử hướng song song: [fork](../fork/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Compact conversation context](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#compact-conversation-context)
