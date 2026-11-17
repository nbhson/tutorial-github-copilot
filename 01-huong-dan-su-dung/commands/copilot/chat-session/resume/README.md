# Resume phiên chat — Mở lại việc dở hôm qua bằng danh sách phiên

> **Harness:** Copilot · **Surface:** Chat view / Agents window (danh sách phiên) · Copilot CLI (`--continue`) · **Đọc:** ~2 phút

**Nôm na:** Trong VS Code, resume **không có slash** — phiên chat *mở lại* từ danh sách phiên, như mở file gần đây; gõ `/resume` trong Chat view là vô nghĩa vì docs VS Code không ghi slash này. Hợp khi cùng một task chạy qua nhiều ngày và bạn không muốn giải thích lại từ đầu.

## Vì sao dùng?

Mỗi sáng mở chat mới là bạn mất những gì đã chốt (kiến trúc, ràng buộc, việc dở) và model đoán lại từ đầu; mở đúng phiên cũ để model nhìn thấy toàn bộ lịch sử đó — nối việc trong một câu hỏi thay vì mười phút giải thích. Điểm dễ lẫn: **`/resume` chỉ tồn tại trong Copilot CLI** (`copilot --continue`, `/resume`), không phải Chat view.

| Cách mở lại | Ở đâu | Nó làm gì |
|---|---|---|
| Danh sách phiên | Chat view / Agents window | mở transcript + history của phiên đã lưu |
| `copilot --continue` | Copilot CLI | nối session mới nhất của thư mục hiện tại |
| `/resume [SESSION-ID]` | Copilot CLI | chọn đúng phiên CLI để gọi lại |
| Resume in Terminal | menu phiên | đẩy phiên IDE ra CLI (harness hỗ trợ) |

**Nếu làm sai:** cạm bẫy thật là mở đúng phiên rồi ra lệnh cụt "tiếp tục đi" khi code trên đĩa đã đổi tay người khác — resume giữ *lịch sử hội thoại*, **không** giữ *trạng thái đĩa*, nên luôn recap một câu + kiểm file chính trước khi giao việc.

## Cách dùng

Mở Chat view (`Ctrl+Alt+I`, macOS `⌃⌘I`) → danh sách phiên ở đầu view → chọn phiên cũ.

```sh
copilot --continue   # Copilot CLI: nối session mới nhất của thư mục hiện tại
```

- **Biến thể:** list ẩn? chuột phải vùng chat → **Show Sessions**; phiên archive/xong? đổi filter **Archived** (Chat view) / **Done** (Agents window).
- **✅ Verify:** hỏi "còn việc gì chưa xong?" — model kể đúng phần còn dở của hôm qua.

## Liên quan

- Tìm theo chủ đề thay vì lướt list: [history](../history/README.md) · Mở trắng cho task mới: [new-chat](../new-chat/README.md) · Nén phiên đang chạy: [compact](../compact/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Find and resume a session](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#find-and-resume-a-session) · [Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
