# Agent mode — giao task mở nhiều bước: tự tìm file, sửa, chạy terminal; bạn duyệt plan và diff

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Agents window / Copilot CLI · **Đọc:** ~2 phút

**Nôm na:** Giao chìa khóa cho đội thợ: chọn **Agent** trong trình chọn chế độ ở Chat view, nó tự đi tìm file, sửa code, chạy terminal rồi đọc lỗi mà sửa tiếp. Hợp khi task mở nhiều bước mà bạn chưa biết chạm file nào — Ask chỉ có chữ, còn Agent thì làm.

## Vì sao dùng?

Có những task bạn chưa biết file nào dính tới: "thêm rate-limit cho /api/login + test". Agent mạnh vì tự đi tìm việc — và cũng vì vậy, giao task mơ hồ không plan thì nó sửa lung tung, lan ra file ngoài phạm vi. Copilot harness có ba built-in agent xếp theo độ tự chủ tăng dần, dừng ở dòng đầu tiên còn đủ dùng:

| Built-in agent | Được phép | Khi nào dùng |
|---|---|---|
| **Ask** | chỉ đọc, trả lời | hỏi / khảo sát / so phương án trước khi đụng code |
| **Plan** | nghiên cứu + lập plan, chưa thực thi | task đủ lớn cần xem hình hài trước khi chạy |
| **Agent** | tự tìm file, sửa, chạy terminal | task mở nhiều bước, chưa biết chạm file nào |

**Nếu làm sai:** thả một task to không plan, không checkpoint thì không có đường lùi. Hàng rào rất đơn giản: bắt nó đề xuất plan chờ duyệt, chia phase, chỉ allow tool đọc, để permission level **Manual** (mặc định), và commit git tay trước khi giao.

## Cách dùng

Chọn **Agent** trong Chat view (Copilot harness; Agents window và Copilot CLI cũng có); commit checkpoint rồi giao task kèm phạm vi và plan gate:

```prompt
trong apps/api: thêm rate-limit cho POST /api/login (5 lần/phút theo IP).
Đề xuất plan chờ tôi duyệt, duyệt rồi mới code + test. Đừng đụng thư mục web/.
```

- **Biến thể:** muốn giao trọn vẹn tới xong → **Autopilot** là *agent mode* chứ không phải permission level — chỉ bật khi có sandbox + repo sạch ([sandbox-policy](../sandbox-policy/README.md)).
- **Setting:** permission level để **Manual** (mặc định, hỏi trước mỗi tool cần duyệt); allow chỉ tool đọc, để `ask` cho lệnh ghi/xóa.
- **✅ Verify:** plan được duyệt trước khi code + test xanh + diff gọn trong scope; dòng đầu `git log` là commit checkpoint của bạn.

## Liên quan

- Chưa tới lượt Agent: [ask-mode](../ask-mode/README.md) · cần plan duyệt trước: [plan](../../code-actions/plan/README.md) · đã biết file, sửa kiểu tick từng file ở Local harness: [edit-mode](../../../local/model-agent/edit-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Work with the agent](https://code.visualstudio.com/docs/agents/run/chat-view#work-with-the-agent) · [VS Code Docs — Plan first, then implement](https://code.visualstudio.com/docs/agents/best-practices#plan-first-then-implement)
