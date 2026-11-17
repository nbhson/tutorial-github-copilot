# /troubleshoot — Đọc debug logs để chỉ ra nguyên nhân thật của session lỗi

> **Harness:** Local · Copilot CLI · **Surface:** VS Code Chat (Local harness) hoặc Copilot CLI session — docs không đặt lệnh này ở Copilot harness · **Đọc:** ~2 phút

**Nôm na:** Thợ sửa xe đời mới không nghe tiếng đoán bệnh — họ cắm máy đọc mã lỗi; `/troubleshoot` là cái máy đọc đó: phân tích debug logs của session và đưa bản chẩn đoán kèm dẫn chứng. Hợp khi chat bỗng dở — tool lỗi, trả lời lạ, chạy chậm — và bạn cần bằng chứng thay vì ấn tượng.

## Vì sao dùng?

"Chat lạ lạ" là lớp triệu chứng, nguyên nhân nằm dưới log: MCP không start, permission bị chặn, config sai tên file. Đọc log tay mất 20 phút và dễ đọc nhầm dòng, còn `/troubleshoot` chỉ rõ dòng/file nào và cho bạn nguyên văn log để dán vào issue khi cần escalate. Lưu ý mặt bằng: docs gắn lệnh này cho **Local harness hoặc Copilot CLI** — gõ `/` không thấy trong chat Copilot harness là đúng.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy `/troubleshoot` trong chat Copilot harness | docs gắn lệnh cho local session hoặc Copilot CLI | chẩn đoán ở đúng surface, hoặc mở Copilot CLI để chạy |
| Kết luận chung chung, không dẫn chứng | chưa reproduce, log rỗng dữ liệu mới | gây lại lỗi một lần rồi chạy lệnh, mô tả kèm triệu chứng |
| Debug logs không có gì để đọc | log chưa bật hoặc bị ghi đè trước khi xem | bật log, gây lại lỗi, chạy lệnh ngay sau đó |

**Nếu làm sai:** gọi lệnh khi vừa restart, chưa hề reproduce lỗi — nhận về "không phát hiện bất thường"; và phân biệt với `/debug`: `/debug` mở Chat Debug view để soi log sống, `/troubleshoot` phân tích log — hai lệnh hai việc.

## Cách dùng

Gõ trong local chat hoặc Copilot CLI, sau khi đã gây lại lỗi một lần.

```prompt
/troubleshoot
/troubleshoot MCP tool "github" fail lúc 14:30, mới thay file cấu hình
```

- **Biến thể:** `/troubleshoot` trần khi chưa rõ mô tả; thêm triệu chứng ("call tool X fail lúc 14:32") để khoanh vùng dòng log giữa một đống log vô hướng.
- **✅ Verify:** làm đúng chỉ dẫn trong bản chẩn đoán (vd bổ sung env var) rồi lặp lại thao tác cũ — lỗi hết là bắt đúng bệnh.

## Liên quan

- Tra nhanh cả nhóm: [../README.md](../README.md) · Liệt kê lệnh khả dụng ở Local: [help](../../../local/chat-session/help/README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Troubleshoot agents in VS Code](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting)
