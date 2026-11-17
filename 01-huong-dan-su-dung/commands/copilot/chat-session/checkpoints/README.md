# Restore checkpoint — Đưa file về mốc trước khi agent sửa sai

> **Harness:** Copilot · **Surface:** Chat view / Agents window (session được hỗ trợ Restore Checkpoint) · **Đọc:** ~2 phút

**Nôm na:** Nút undo cho cả phiên agent — VS Code tự snapshot các file liên quan **trước mỗi request**, đi sai thì quay về ngã ba cũ, bạn không phải tạo mốc tay. Hợp khi agent sửa lan man qua nhiều file, càng sửa càng rối, khó tìm điểm an toàn để quay xe.

## Vì sao dùng?

Giao task cho Agent mode là con dao hai lưỡi: một turn sai có thể làm rối cả loạt file. Checkpoints **bật mặc định**, restore đưa file về mốc đó **và xoá các turns hội thoại sau nó** — mạnh hơn `Ctrl+Z` vì quay cả phiên. Nhưng đừng ngộ nhận hoàn tác được mọi thứ: docs ghi rõ nó **không** reverse lệnh terminal đã chạy, network request, deploy hay thay đổi ở dịch vụ ngoài; mốc bền vẫn là commit git.

| Cơ chế | Nó làm gì | Khi nào |
|---|---|---|
| Automatic | snapshot file trước mỗi request (mặc định bật) | giữa các lần thử hướng |
| Restore checkpoint | file về mốc + xoá turns sau đó | agent đi sai từ một mốc rõ |
| Restore conversation only | chỉ hội thoại về mốc, **giữ** file hiện tại | code đã đúng, muốn hỏi lại prompt sạch hơn |
| Name a checkpoint | đặt tên mốc để tìm lại đúng điểm | session 20+ turn, nhiều mốc gần nhau |

**Nếu làm sai:** checkpoint là state **tạm** của session, không thay Git — tin rằng restore "dọn hết" mọi hậu quả, kể cả lệnh terminal/deploy đã chạy, là cái giá đắt nhất; trước việc mạo hiểm vẫn commit một cái.

## Cách dùng

Trong Chat view / Agents window, điều hướng tới request cũ → hover → **Restore Checkpoint**; palette có **Chat: Open Checkpoints…** để liệt kê mốc trong phiên.

```jsonc
// settings.json — mặc định đã bật; không có mốc thì kiểm lại setting + session được hỗ trợ
"chat.checkpoints.enabled": true
```

- **Biến thể:** code đã đúng, chỉ muốn hỏi lại prompt sạch → **Restore conversation only**; session dài → **đặt tên mốc** để restore đúng điểm.
- **Setting:** `chat.checkpoints.enabled` — on = tự snapshot, off = mất luôn lưới an toàn.
- **✅ Verify:** `git status` sạch lại + test xanh sau restore.

## Liên quan

- Muốn thử hướng song song (không đụng file): [fork](../fork/README.md) · Bắt đầu sạch sau restore: [new-chat](../new-chat/README.md) · Lưu phiên trước khi bỏ: [export](../../../local/chat-session/export/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Restore a checkpoint](https://code.visualstudio.com/docs/agents/run/review-code-edits#restore-a-checkpoint)
