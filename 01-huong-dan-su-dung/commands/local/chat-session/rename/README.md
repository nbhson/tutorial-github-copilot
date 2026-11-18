# /rename — Đổi tên phiên chat đang mở cho dễ tìm lại

> **Harness:** Local · **Surface:** VS Code Chat — docs ghi `/rename <tên mới>` trong **local Ask chat**; cũng làm được bằng nút trong Session History · **Đọc:** ~2 phút

**Nôm na:** Dán nhãn lên lọ gia vị trước khi cất vào tủ: `/rename <tên>` đổi tên phiên chat đang mở, không đụng nội dung hội thoại — để Session History hết là một loạt "New Chat" lẫn lộn. Hợp khi chạy 3–4 phiên song song, hoặc sắp bỏ dở một việc mà ngày sau quay lại.

## Vì sao dùng?

Session History toàn tên mặc định thì phải mở từng phiên ra dò việc — chi phí đó lặp lại hàng ngày; `/rename` dán nhãn một lần mất 5 giây và biến list thành cuốn sổ có mục lục. Docs gắn nhãn lệnh "in a local chat" — không thấy nó trong menu `/` thì kiểm Session Target trước khi kết luận extension lỗi; agent session trong Agents window được quản lý riêng, muốn đổi tên thì làm ở đúng cửa sổ.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ `/` không thấy `/rename` | harness/version không bật, hoặc đang ở session Copilot | kiểm Session Target; hoặc dùng nút trong Session History |
| Đổi tên xong không thấy trong Session History | nhầm giữa Chat view và Agents window | agent session quản lý riêng — đổi tên ở đúng cửa sổ |
| Tưởng đổi được tên file/biến trong code | hiểu nhầm phạm vi lệnh | `/rename` chỉ đổi tên phiên; rename symbol là F2 |

**Nếu làm sai:** tưởng `/rename` đổi tên biến/file trong code là đem lệnh quản phiên giao cho nhầm việc — lệnh không đụng file nào; ngược lại, để cả loạt "New Chat" rồi mò từng cái là trả giá bằng hàng chục phút tìm kiếm cho thứ đáng ra tốn 5 giây.

## Cách dùng

Gõ trong Chat (Local harness), hoặc chuột phải vào phiên trong Session History → Rename:

```prompt
/rename Sửa bug thanh toán
# hoặc: Session History → chuột phải phiên → Rename (bút chì)
```

- **Biến thể:** đặt tên theo việc chứ không theo ngày — "Sửa lỗi payment" dễ tìm hơn "Task 14/11"; rename ngay khi phiên rõ hướng, lúc đó tên chính xác hơn lúc quay lại dò.
- **Setting:** `/rename <tên mới>` là cú pháp docs gắn cho local Ask chat; Copilot CLI có `/rename` riêng cho session hiện tại.
- **✅ Verify:** mở Session History — phiên vừa đổi hiển thị đúng tên mới.

## Liên quan

- Tìm lại phiên: [history](../../../copilot/chat-session/history/README.md) · phiên sạch để đặt tên rõ: [new-chat](../../../copilot/chat-session/new-chat/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [VS Code Docs — Manage agent sessions](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions)
