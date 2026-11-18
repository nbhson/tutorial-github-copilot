# Copilot connectors — MCP server do GitHub host, bấm Connect là có tool

> **Harness:** Copilot · **Surface:** Agent Customizations editor / Copilot Connectors · **Đọc:** ~2 phút

**Nôm na:** Connector là "ổ cắm đã kiểm định sẵn hãng": bản chất là MCP server nhưng do GitHub host và maintain — bạn không có (và không cần) file cấu hình nào, chỉ bấm Connect. Hợp khi dịch vụ team cần đã nằm trong danh sách Copilot Connectors và bạn không muốn tự vận hành hạ tầng.

## Vì sao dùng?

MCP tự quản lý kéo theo 4 khoản chi phí: cài process, giữ phiên bản, quản token, sửa khi server rớt — connector cắt hết vì hạ tầng là việc của GitHub. Đổi lại, docs ghi nguyên văn: connector **chỉ cấp tool cho Copilot harness**, không cho session Local — cùng một connector, phiên Copilot thấy tool, phiên Local thì không.

| Bạn thấy | Kết luận |
|---|---|
| Dòng nhãn `Connector: <name>` trong card MCP Servers | connector do GitHub host — không có "file của bạn", đó là dấu hiệu tồn tại duy nhất |
| Dòng MCP không mang nhãn | server bạn tự khai báo, có file cấu hình riêng |
| Danh sách Connectors trống/khóa (Business/Enterprise) | org chưa bật policy "Editor preview features" — nhờ admin; tài khoản cá nhân không vướng |
| Tool có ở phiên Copilot, mất ở phiên Local | đúng như docs — đừng kết luận "connector hỏng" rồi sửa sai hướng |

**Nếu làm sai:** ngộ nhận "connector = MCP dùng chung mọi session" là bẫy phổ biến; còn chờ connector cho hệ thống nội bộ thì vô ích — không có trong danh sách thì đi đường MCP tự quản lý.

## Cách dùng

Không có slash command — tất cả qua Agent Customizations editor: `Chat: Open Customizations` → card **MCP Servers** → **Browse** → **Copilot Connectors** → **Connect** → hoàn tất màn hình login của dịch vụ.

```prompt
work-item mới nhất của tôi thế nào?
```

- **Setting:** org Business/Enterprise phải bật policy **"Editor preview features"** thì danh sách connector mới hiện.
- **Biến thể:** cần tool cho session Local hoặc hệ nội bộ → tự khai báo MCP server ([mcp-add](../mcp-add/README.md)), connector không phục vụ.
- **✅ Verify:** gửi câu nhỏ cần đúng dữ liệu từ dịch vụ đó (câu trên) — agent gọi tool thay vì nói "tôi không có cách nào truy cập".

## Liên quan

- Bảng server đang bật: [mcp](../mcp/README.md) · Server tự quản lý: [mcp-add](../mcp-add/README.md) · Gói skills/MCP: [plugins](../plugins/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/) · Bài chủ: [08-mcp-ket-noi-cong-cu-ngoai.md](../../../../08-mcp-ket-noi-cong-cu-ngoai.md)
- Nguồn: [VS Code Docs — Connect a service](https://code.visualstudio.com/docs/agent-customization/copilot-connectors#connect-a-service) · [GitHub Docs — Supported connectors](https://docs.github.com/en/copilot/reference/supported-connectors)
