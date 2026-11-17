# Session History — Tìm và mở lại chat cũ trong danh sách phiên

> **Harness:** Copilot · **Surface:** danh sách phiên ở Chat view / Agents window (không phải slash) · **Đọc:** ~2 phút

**Nôm na:** Session History là sổ đầu bài của các phiên chat — nằm ở **danh sách phiên** đầu Chat view (gom theo thời gian/workspace) hoặc sidebar Agents window (xuyên workspace), chứ **không có slash `/history`**. Hợp khi cần nối việc hôm qua, đối chiếu hai cách làm ở hai phiên, hay thu lại một prompt hay.

## Vì sao dùng?

Trí nhớ bạn không phải nơi lưu tốt cho hàng chục phiên; history cho phép tìm lại bối cảnh cũ, so cách A với cách B, và lôi prompt hiệu quả ra làm template. Ngộ nhận lớn nhất khi mở lại chat cũ: nghĩ model "nhớ hết" — history giữ *transcript*, còn trạng thái tool (file đang mở, output terminal treo) có thể không còn nguyên, nên mở lại nên nhắc vài dòng bối cảnh trước khi giao việc.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy chat hôm qua | chat ở máy/profile khác, hoặc đã archive | kiểm đúng VS Code profile + máy; bật filter **Archived/Done** |
| Mở lại nhưng model quên chi tiết tool | trạng thái tool không đi theo transcript | tóm tắt 3 dòng bối cảnh rồi hỏi tiếp |
| List quá dài khó tìm | để tên mặc định + không tìm theo chủ đề | đặt tên rõ; hỏi Chronicle; export chat hay ra file |

**Nếu làm sai:** đừng gõ `/history` hay `/resume` trong ô chat (VS Code không dạy hai slash này) — cửa vào lịch sử là danh sách phiên, list ẩn thì chuột phải vùng chat trống → **Show Sessions**; và muốn mất hẳn một phiên là **Delete**, không phải ẩn sau `/clear`.

## Cách dùng

Mở bằng danh sách phiên (view), không phải slash; đây cũng là cửa vào để resume.

```prompt
/chronicle:search bug timezone
```

- **Biến thể:** chưa nhớ tên → lướt list (Chat view gom theo thời gian/workspace, Agents window xuyên workspace); nhớ chủ đề/file → hỏi Chronicle; phiên đã xong bị ẩn → đổi filter **Archived** (Chat view) / **Done** (Agents window).
- **✅ Verify:** mở đúng phiên cũ, nhắn 1 câu follow-up — model nhớ context cũ là đạt.

## Liên quan

- Mở lại đúng phiên để nối việc: [resume](../resume/README.md) · Export chat giá trị cao ra file: [export](../../../local/chat-session/export/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Session History](https://code.visualstudio.com/docs/agents/run/sessions/session-history)
