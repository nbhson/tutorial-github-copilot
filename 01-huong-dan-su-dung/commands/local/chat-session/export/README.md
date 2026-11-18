# Chat: Export Chat… — Lưu cả hội thoại ra file JSON, còn Markdown là đường Copy All

> **Harness:** Local · **Surface:** Command Palette trong VS Code Chat view (Session Target = Local) — Chat view này **không có** slash `/export`; **Copilot CLI** mới có `/export` · **Đọc:** ~2 phút

**Nôm na:** Kéo cuộc trò chuyện ra khỏi chat thành một file riêng: JSON đủ mọi prompts/responses, Markdown là chuột-phải → **Copy All**. Hợp khi chat ra kết quả đáng giữ, sắp `/clear` mà còn việc dở, hoặc cần bàn giao context cho teammate.

## Vì sao dùng?

Giá trị thật của một phiên thường nằm ở **đoạn giữa** — những lần thử sai, quyết định chốt, đoạn code cuối — và export biến mạch đó thành tài sản dùng lại được: bàn giao context, lưu wiki, backup trước khi `/clear` (lệnh mở chat mới và archive chat hiện tại). Thứ gì nằm trong chat cũng nằm trong file, nên docs cảnh báo hẳn một dòng: file export và message đã copy **có thể chứa prompt, phản hồi hoặc kết quả tool nhạy cảm**.

| Đường | Đầu ra | Khi nào |
|---|---|---|
| `Chat: Export Chat...` (Command Palette) | file **JSON** đủ mọi prompts/responses | cần bản ghi đầy đủ |
| Chuột-phải → **Copy All** | **Markdown** cả cuộc trò chuyện, vào clipboard | dán wiki |
| Chuột-phải → **Copy Final Response** | riêng phản hồi cuối, không kể tool trung gian | chỉ cần kết quả |
| `/export` — **Copilot CLI** | alias của `/share` | đừng nhầm với VS Code Chat — ở đây không có slash này |

**Nếu làm sai:** attach file chứa token rồi export nguyên thì token đi theo — không công cụ nào tự che secrets; chat 50+ turns export thẳng thành file khó đọc. Thứ tự đúng là *nén → soát → export*; còn muốn người khác *tiếp tục làm việc* chứ không chỉ đọc, đó là share session (sync), không phải export file.

## Cách dùng

Mở Chat view (Session Target = Local) rồi gọi lệnh palette; đường Markdown là chuột-phải trong Chat view:

```prompt
Ctrl+Shift+P → Chat: Export Chat... → chọn nơi lưu file JSON đủ mọi prompts/responses
# trước khi đưa ai, soát: grep -iE "token|secret|password" <file> → 0 kết quả là an toàn
```

- **Biến thể:** chat dài thì [compact](../../../copilot/chat-session/compact/README.md) trước rồi export — bản gọn vẫn giữ file + quyết định quan trọng.
- **Setting:** JSON do lệnh `Chat: Export Chat...`; Markdown do Copy All / Copy Final Response; đưa file export vào `.gitignore` nếu nó chứa nội dung nội bộ.
- **✅ Verify:** mở file export, đọc lại 1 lượt thấy đủ ý, và `grep -iE "token|secret|password" <file>` trả 0 kết quả.

## Liên quan

- Nghi "mất lệnh", tra trước khi kết luận: [help](../help/README.md) · Chat trắng sau khi lưu: [new-chat](../../../copilot/chat-session/new-chat/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Session history (Export or copy a conversation)](https://code.visualstudio.com/docs/agents/run/sessions/session-history#export-or-copy-a-conversation)
