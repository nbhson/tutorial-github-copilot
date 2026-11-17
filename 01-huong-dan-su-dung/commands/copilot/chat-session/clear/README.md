# /clear — Dọn hội thoại hiện tại, giữ nguyên instructions và MCP

> **Harness:** Copilot · **Surface:** Chat view (chat reference) · **Đọc:** ~2 phút

**Nôm na:** Docs định nghĩa `/clear` là **mở chat mới VÀ archive (mark done) chat hiện tại** — như gấp cuốn sổ cũ cắm vào ngăn kéo, còn phấn, bảng và nội quy lớp vẫn nguyên. Hợp khi một phiên phình to, model bắt đầu quên đầu bài nhưng bạn vẫn cần instructions/MCP đã setup.

## Vì sao dùng?

Chat dài khiến turns cũ nhiễu ngữ cảnh và model quên đầu bài, nhưng kiểu reset nào cũng phải trả giá; `/clear` sang trang mà cấu hình không bay — instructions trong repo nạp lại từ file, MCP vẫn connected, cái mất duy nhất là mạch hội thoại (và nó chỉ bị cất, không bị xoá). Gõ `/` không thấy `/clear` thì đó chưa phải lỗi công cụ: availability phụ thuộc surface/harness/role.

|  | `/clear` | `Ctrl+N` |
|---|---|---|
| Chuyện xảy ra | chat mới + archive chat hiện tại | session riêng tách hẳn |
| Chat cũ | về filter **Archived**, mở lại được | vẫn active, hỏi tiếp ngay |
| Hợp khi | cùng repo, muốn gọn danh sách | bắt đầu hẳn đầu việc khác |

**Nếu làm sai:** hai ngộ nhận hay gặp — tưởng `/clear` xoá history mãi mãi (không, muốn mất hẳn là **Delete**), và clear xong vẫn lan man vì scope chat mới còn rộng; attach cả repo từ câu đầu thì context phình lại như cũ.

## Cách dùng

Gõ trong Chat view (Copilot harness).

```prompt
/clear
```

- **Biến thể:** `/clear` không có dạng kèm tham số; clear xong gắn scope lại bằng 1–3 `#file`, còn việc dở thì export (`Chat: Export Chat…`) trước.
- **✅ Verify:** hỏi "liệt kê quy tắc đang áp dụng" ở chat mới — trả lời đúng là instructions/MCP còn nguyên; chat cũ mở lại được từ filter **Archived**.

## Liên quan

- Muốn giữ nguyên phiên mà ngắn lại: [compact](../compact/README.md) · Muốn chat cũ active hỏi tiếp: [new-chat](../new-chat/README.md) · Lưu bằng chứng: [export](../../../local/chat-session/export/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Manage sessions](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions)
