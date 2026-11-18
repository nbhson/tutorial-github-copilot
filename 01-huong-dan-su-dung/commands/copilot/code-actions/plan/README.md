# /plan — bắt Copilot đọc repo thật rồi đề xuất kế hoạch, chưa sửa file nào

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) và Claude harness; Local harness dùng **Plan agent** built-in · **Đọc:** ~2 phút

**Nôm na:** Kiến trúc sư vẽ bản vẽ rồi thợ mới khởi công — `/plan` (docs: "research + propose a plan") đọc code thật và trả về danh sách bước + điểm rủi ro để bạn duyệt. Hợp khi sắp để agent sửa nhiều file một lúc (migration, đổi interface dùng chung) và hướng đi sai sẽ đắt hơn hướng đi đúng.

## Vì sao dùng?

Hầu hết giờ vứt đi không đến từ code dở mà từ hướng đi sai — và hướng sai chỉ lộ ra sau khi đã sửa nửa repo. `/plan` trả giá sai lầm đó trên giấy: sửa vài dòng kế hoạch nhẹ hơn hoàn tác hàng chục file, và bản kế hoạch còn là thứ bàn giao được — paste sang chat mới hoặc đưa đồng nghiệp tiếp quản. Hai điều hay nhầm: plan chỉ **đề xuất**, không tự chạy thành code; và nó theo **harness**, không phải surface nào cũng có slash này.

| Bề mặt | Cách gọi đúng | Ghi chú |
|---|---|---|
| Copilot harness | `/plan` | thấy khi gõ `/` trong ô Chat |
| Claude harness | `/plan` | Plan mode là permission mode của Claude harness |
| Local harness | Plan agent (built-in) | **không** có slash `/plan` ở đây |
| Copilot in the cloud | — | docs không ghi `/plan` chạy cho cloud agent |

**Nếu làm sai:** thấy `/plan` không xuất hiện trong chat Local rồi kết luận "Copilot hỏng" — slash và agent không phải một, kiểm harness bằng cách gõ `/` trước đã.

## Cách dùng

Gõ trong Chat view ở Copilot harness, mô tả hẹp kèm yêu cầu đường dẫn file và cách test:

```prompt
/plan chuyển login sang JWT: liệt kê file cần sửa theo thứ tự, chỉ ra bước nào có rủi ro, kèm lệnh test cho từng bước
```

- **Biến thể:** task đã rõ cách làm thì nói thẳng Agent cho khỏi mất vòng research; plan dài thì paste sang [chat mới](../../chat-session/new-chat/README.md) để thực thi cho sạch context.
- **✅ Verify:** copy 2–3 đường dẫn file trong kế hoạch đi grep — file thật tồn tại là plan "có nghiên cứu", không ảo.

## Liên quan

- Duyệt plan xong mới giao việc: [agent-mode](../../model-agent/agent-mode/README.md) · Kiểm tra đang nói chuyện với harness nào: [session-target](../../model-agent/session-target/README.md) · Sai lầm tương đương ở Local harness: [edit-mode](../../../local/model-agent/edit-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Ask the current agent to plan](https://code.visualstudio.com/docs/agents/run/planning#ask-the-current-agent-to-plan) · [Plan first, then implement](https://code.visualstudio.com/docs/agents/best-practices#plan-first-then-implement)
