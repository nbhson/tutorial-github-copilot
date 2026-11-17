# Ctrl+N (Chat: New Chat) — Mở phiên trắng tách hẳn chat hiện tại cho đầu việc mới

> **Harness:** Copilot · **Surface:** Chat view / Agents window (phím + nút, không phải slash) · **Đọc:** ~2 phút

**Nôm na:** `Ctrl+N` ("Start a new chat") mở một phiên hội thoại hoàn toàn sạch — không history, không context chat cũ, model chỉ thấy đúng task mới. Hợp khi chat cũ đã dài, model lẫn context, trả lời lan man — thói quen #1 của cả nhóm này.

## Vì sao dùng?

Chat càng dài thì hai vấn đề càng nặng: model loãng trọng tâm, và mỗi turn nạp lại toàn bộ history nên đốt token vô ích. Chat mới cắt cả hai, đồng thời cho bạn chốt scope và chọn lại model ngay turn 1 — task khó cần model mạnh, task dễ dùng model rẻ. Cái nhầm tai hại nhất nằm ngay trong bảng dưới.

| Lệnh | Làm gì | Context cũ | File/Workspace |
|---|---|---|---|
| `Ctrl+N` | mở chat mới (tờ giấy trắng) | sạch | không tạo file |
| `/clear` | chat mới + **archive** chat hiện tại | sạch | không tạo file |
| `/new` | **scaffold**: tạo file/workspace/notebook mới | giữ nguyên | tạo file mới |

**Nếu làm sai:** gõ `/new` trong ô chat rồi tưởng được chat mới — nó giữ nguyên history và bắt đầu tạo file scaffold (xem [new](../../code-actions/new/README.md)); còn muốn *nối* việc dở thì mở lại [Session History](../history/README.md), đừng mở trắng.

## Cách dùng

Bấm `Ctrl+N` (macOS `⌘N`) trong Chat view / Agents window, hoặc **New Session** ở đầu danh sách phiên rồi chọn workspace/harness.

```sh
Ctrl+N   # rồi nêu scope ngay turn 1: 1–3 #file + mong đợi rõ ràng
```

- **Biến thể:** còn việc dở thì export (`Chat: Export Chat…`) trước khi cắt — chat mới không có undo.
- **✅ Verify:** hỏi follow-up — model không nhắc lại chuyện chat cũ là đạt.

## Liên quan

- Sang trang + archive ngay trong session: [clear](../clear/README.md) · Thử hướng khác kèm history: [fork](../fork/README.md) · Nối việc dở: [resume](../resume/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Start a new or related conversation](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#start-a-new-or-related-conversation)
