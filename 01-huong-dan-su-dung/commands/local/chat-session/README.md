# Nhóm Chat Session (3 lệnh)

> **Dành cho:** ai cần quản lý vòng đời một cuộc trò chuyện trong Chat · **Đọc xong:** tra đúng lệnh theo bảng dưới rồi bấm sang README chi tiết (~2 phút).

Nhóm này lo phần "hậu cần" của Chat: bắt đầu một phiên mới, dọn context, tìm lại phiên cũ, lưu lại để chia sẻ, và gắn file vào prompt. Nói cách khác — nó không giúp bạn viết code giỏi hơn, nhưng nó quyết định model có *nhớ đúng chuyện* và *đọc đúng file* hay không.

**Tra thế nào?** Tự hỏi bạn đang ở bước nào của một phiên: *mở đầu* (`/new`), *đang lỡ dài* (`/clear`, `/summarize` — tên cũ của `/compact`), *muốn tìm lại* (`/history`, `/resume`), *muốn lưu/gửi* (`/export`), *muốn chèn context* (`Attach / #file`), hay *vừa bị agent sửa hỏng* (`Restore checkpoint`).

**Vì sao quan trọng?** Chat không có "nút hoàn tác" tự động cho hội thoại. Nếu cứ để một phiên chạy mãi qua nhiều task, context cũ rác dần và model bắt đầu lẫn giữa việc cũ với việc mới. Quản phiên tốt là cách rẻ nhất để câu trả lời sắc lại.

**Nếu làm sai?** Hai lỗi hay gặp: (1) nhầm `/clear` với `/new` — một cái giữ instructions, một cái xóa hết; (2) gắn cả repo vào prompt thay vì đúng file — vừa tốn token vừa loãng ngữ cảnh.

| Lệnh | Mô tả 1 dòng | Chi tiết |
|---|---|---|
| `/new` | Mở chat mới, xóa history — thói quen #1 mỗi task | [./new-chat/README.md](../../copilot/chat-session/new-chat/README.md) |
| `/clear` | Xóa context chat hiện tại, giữ instructions | [./clear/README.md](../../copilot/chat-session/clear/README.md) |
| `/history` | Xem lại lịch sử chats, quay lại chat cũ | [./history/README.md](../../copilot/chat-session/history/README.md) |
| `/export` | Export conversation ra file để lưu/share | [./export/README.md](./export/README.md) |
| `/rename` | Đổi tên phiên chat cho dễ tìm lại | [./rename/README.md](./rename/README.md) |
| `/resume` | Mở lại / tiếp tục phiên chat đã lưu | [./resume/README.md](../../copilot/chat-session/resume/README.md) |
| `Ctrl+I` inline | Chat inline ngay trong editor, sửa tại chỗ | [./inline-chat/README.md](../../copilot/chat-session/inline-chat/README.md) |
| `Ctrl+Shift+Alt+L` (Quick Chat) | Mở Quick Chat hỏi nhanh không rời editor | [./quick-chat/README.md](../../copilot/chat-session/quick-chat/README.md) |
| `Restore checkpoint` | Quay về checkpoint trước khi agent sửa sai | [./checkpoints/README.md](../../copilot/chat-session/checkpoints/README.md) |
| `Attach / #file` | Đính kèm file/folder/ảnh vào prompt | [./attachments/README.md](../../copilot/chat-session/attachments/README.md) |
| `/help` | Xem help + nhóm lệnh khả dụng | [./help/README.md](./help/README.md) |
| `Shortcuts` | Liệt kê phím tắt Chat trong IDE này | [./shortcuts/README.md](../../copilot/chat-session/shortcuts/README.md) |
| `/compact` (tên cũ Local: `/summarize`) | Tóm tắt hội thoại dài thành bản gọn giữ đà task | [./compact/README.md](../../copilot/chat-session/compact/README.md) |

> **Cách đọc bảng này:** mỗi dòng là một lệnh, xếp gần theo vòng đời một phiên (mở đầu → đang lỡ dài → tìm lại → lưu/chèn context → sửa sai). Cột "Mô tả 1 dòng" đủ để chọn lệnh; cần cú pháp và ví dụ thì bấm sang cột "Chi tiết".

> **Tóm gọn 1 câu:** Nhóm này là hậu cần của Chat — giữ phiên sạch và context đúng để model *nhớ đúng chuyện* và *đọc đúng file*, tiền đề của mọi câu trả lời tốt.

## So sánh với Claude Code

| Việc | Copilot | Claude Code |
|---|---|---|
| Bắt đầu phiên mới | `/new` | Dùng `/clear` để làm mới; không có `/new` riêng |
| Dọn context nhưng giữ rule | `/clear` | `/clear` (xóa hội thoại, giữ memory/CLAUDE.md) |
| Nén hội thoại dài | `/compact` | `/compact` |
| Tìm lại/tiếp tục phiên cũ | Session History (view), `/resume` | `/resume` |
| Chat inline trong editor | `Ctrl+I` (inline chat), `Ctrl+Shift+Alt+L` (Quick Chat) | Không có tương đương trực tiếp — Claude Code chạy trong terminal, không có chat inline trong editor theo cách này |
| Quay lui khi agent sửa sai | `Restore checkpoint` | `/rewind` (auto-checkpoint mỗi prompt) |
| Gắn file vào prompt | `Attach` / `#file` | Mention `@file` |
| Export hội thoại | `/export` | Không có lệnh export built-in ổn định — thường phải copy thủ công |

Quay về: [../README.md](../../README.md) · Bài tổng: [../../04-chat-commands-toan-tap.md](../../../04-chat-commands-toan-tap.md)

> Phiên chat cũng giống bàn làm việc: dọn trước khi làm việc mới thì tìm đồ nhanh hơn nhiều — `/new` mỗi task là thói quen rẻ nhất mà hiệu quả nhất trong cả nhóm này.
