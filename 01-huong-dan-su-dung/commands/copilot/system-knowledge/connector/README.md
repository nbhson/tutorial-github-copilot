# Copilot connectors — MCP do GitHub quản lý, chỉ cho Copilot harness

> **Dành cho:** dev muốn agent chạm hệ thống ngoài mà ngại tự nuôi MCP server · **Vấn đề:** lẫn connector với MCP tự quản lý, không rõ nó chạy ở harness nào · **Đọc xong:** cài connector qua Customizations editor và kiểm được harness nào đọc nó (~2 phút)
> **Harness:** Copilot · **Surface:** Agent Customizations editor / Copilot Connectors

## 1 câu nôm na

Connector là "ổ cắm điện đã kiểm định sẵn hãng": bản chất là MCP server nhưng do GitHub host và maintain — bạn không có (và không cần) file cấu hình nào, chỉ bấm Connect. Docs ghi nguyên văn: **connectors cung cấp tool cho Copilot harness, không cho session Local** — cùng một connector, phiên Copilot thấy tool, phiên Local thì không. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Vì sao dùng connector?

MCP tự quản lý kéo theo 4 khoản chi phí: cài process, giữ phiên bản, quản token, và sửa mỗi khi server rớt. Connector cắt hết khoản đó vì hạ tầng là việc của GitHub. Hai điểm khác biệt thật:

- **Không file cấu hình:** khác hẳn server tự quản lý; bạn chỉ tương tác trong **Agent Customizations editor**.
- **Ranh giới harness rõ:** tool chỉ vào session Copilot. Đây là lý do bài này tách riêng, không gộp vào [../mcp/README.md](../mcp/README.md).

**Nếu làm sai?** Ngộ nhận phổ biến: "connector = MCP dùng chung cho mọi session". Connect xong mà tool không hiện trong phiên Local → bạn kết luận nhầm "connector hỏng" và sửa sai hướng. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** dịch vụ đội bạn cần nằm trong danh sách Copilot Connectors; bạn muốn thêm tool nhanh, không muốn vận hành gì; session đang chạy Copilot harness (Chat view / Agents window).
- **ĐỪNG dùng khi:** bạn cần tool cho session Local — connector không phục vụ; hoặc hệ thống nội bộ không có trong danh sách → đi đường MCP tự quản lý ([../mcp-add/README.md](../mcp-add/README.md)).
- **Business/Enterprise:** danh sách connector chỉ hiện khi org bật policy **"Editor preview features"** (tên policy có trong docs GitHub về các surface được policy áp dụng). · 📄 [VS Code Docs: Choose a customization scope](https://code.visualstudio.com/docs/agent-customization/overview#choose-a-customization-scope)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh) · 📄 [VS Code Docs: Connect a service](https://code.visualstudio.com/docs/agent-customization/copilot-connectors#connect-a-service)

Không có slash command cho connector — tất cả qua **Agent Customizations editor** (lệnh `Chat: Open Customizations`): card **MCP Servers** → **Browse** → **Copilot Connectors** → **Connect**.

## Ví dụ thật

Nghiệp vụ: team cần agent đọc được work-item từ công cụ quản lý việc đang dùng, nhưng không ai muốn tự viết MCP server để rồi nuôi nó.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Create project instructions](https://code.visualstudio.com/docs/agents/guides/customize-copilot-guide#step-1-create-project-instructions)

**Kết quả mong đợi:** connector đã Connect xuất hiện ở card MCP Servers với nhãn `Connector: <name>`; trong session Copilot, agent gọi được tool của nó.

**✅ Verify:** gửi một câu nhỏ cần đúng dữ liệu từ dịch vụ đó (ví dụ "work-item mới nhất của tôi thế nào") — agent phải gọi tool thay vì nói "tôi không có cách nào truy cập".

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — Connect connector xong mở session Local để dùng:** tool không hiện, rồi đoán sai là connector lỗi.
**✅ ĐÚNG — nhận diện harness trước:** connector chỉ phục vụ Copilot harness; nếu buộc phải chạy Local, dùng MCP tự quản lý cho session đó.

**❌ SAI — nhầm connector với plugins:** plugins phân phối skill/agent/MCP đóng gói; connector là MCP server hosted, hiện dạng một dòng trong danh sách MCP Servers.
**✅ ĐÚNG — phân loại theo nhãn:** dòng có nhãn `Connector:` là connector; dòng còn lại là server bạn tự khai báo.

**Bài học:** connector không có "file của bạn" — nó sống hoàn toàn trên hạ tầng GitHub, nên dấu hiệu tồn tại duy nhất là nhãn `Connector: <name>` trong MCP Servers. · 📄 [VS Code Docs: Troubleshoot customization issues](https://code.visualstudio.com/docs/agent-customization/overview#troubleshoot-customization-issues)

## Lỗi thường gặp

📄 [VS Code Docs: Troubleshoot a connection](https://code.visualstudio.com/docs/agent-customization/copilot-connectors#troubleshoot-a-connection)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Danh sách Copilot Connectors trống/khóa | Org Business/Enterprise chưa bật policy "Editor preview features" | Nhờ admin bật; tài khoản cá nhân không vướng policy này |
| Đã Connect nhưng không thấy trong MCP Servers | Chưa xong bước xác thực tài khoản của dịch vụ | Bấm Connect lại tới khi đăng nhập hoàn tất |
| Tool có ở phiên Copilot, không có ở phiên Local | Đúng như docs — connector chỉ cấp tool cho Copilot harness | Session cần tool thì chuyển sang Copilot harness, hoặc tự quản lý MCP cho Local |
| Tool do extension cung cấp mất khi tắt cửa sổ | đó là boundary của extension-provided tools (chỉ chạy khi editor còn kết nối) — khác connector/MCP | Đưa năng lực cần chạy nền vào MCP/connector, không dựa extension |
## So sánh với Claude Code

📄 [GitHub Docs: Comparing customizations](https://docs.github.com/en/copilot/concepts/customizations/comparing-customizations)

| Việc | Copilot (connector) | Claude Code | Ghi chú |
|---|---|---|---|
| Thêm tool ngoài | Bấm Connect, không file cấu hình | `claude mcp add` / tự sửa file project | Claude Code không có tầng "GitHub host sẵn" |
| Ai vận hành server | GitHub (managed MCP) | Bạn (process local) hoặc CI tự dựng | Bù lại, connector chỉ phủ dịch vụ có trong danh sách |
| Phổ harness | Chỉ Copilot harness | Không có khái niệm tương đương — một thế giới config | Connector là khái niệm riêng của hệ Copilot |
## Best practices (kèm "vì sao")

- **Kiểm tra harness đang chạy trước khi connect.** *Vì sao?* Connector không cho session Local thấy gì; connect "để đó dùng sau" chỉ tạo công cụ ma.
- **Ghi chú phân biệt connector và server tự quản trong tài liệu nội bộ.** *Vì sao?* Khi tool rớt, biết ngay bên nào lỗi để gọi đúng người sửa.
- **Hỏi admin về policy "Editor preview features" trước khi triển khai cho team.** *Vì sao?* Org chưa bật thì cả team không thấy danh sách, bạn báo nhầm "mất tính năng".
- **Dịch vụ nội bộ → MCP tự quản lý, đừng cố chờ connector.** *Vì sao?* Connector phủ dịch vụ có sẵn; hệ riêng của bạn chỉ bạn hiểu. · 📄 [GitHub Docs: Supported connectors](https://docs.github.com/en/copilot/reference/supported-connectors)

## Bài tập nhỏ

1. **(5 phút)** Mở `Chat: Open Customizations` → Browse → Copilot Connectors; connect một connector bạn có tài khoản, xác nhận dòng `Connector: <name>` xuất hiện.
2. **(4 phút)** Gửi cùng một câu hỏi cần dữ liệu từ connector đó ở phiên Copilot và (nếu có) phiên Local — ghi lại bên nào gọi được tool.
3. **(3 phút)** Liệt kê vào ghi chú cá nhân: tool nào đang tới từ connector, tool nào từ server bạn tự khai báo. · 📄 [VS Code Docs: Connect a service](https://code.visualstudio.com/docs/agent-customization/copilot-connectors#connect-a-service)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Xem MCP servers đang bật: [../mcp/README.md](../mcp/README.md) · Thêm server tự quản lý: [../mcp-add/README.md](../mcp-add/README.md) · Plugins: [../plugins/README.md](../plugins/README.md)
- Vùng Local (file `.vscode/mcp.json`): [../../../local/system-knowledge/vscode-mcp-json/README.md](../../../local/system-knowledge/vscode-mcp-json/README.md)
- Bài học: [08 — MCP & kết nối](../../../../08-mcp-ket-noi-cong-cu-ngoai.md) · [17 — Agent Customizations](../../../../17-agent-customizations-hub.md) · FAQ: [MCP](../../../../../03-cau-hoi-thuong-gap/04-mcp-faq.md) · Index lệnh: [../../../README.md](../../../README.md) · [CHEATSHEET](../../../../../CHEATSHEET.md)
- VS Code docs — Copilot Connectors: https://code.visualstudio.com/docs/agent-customization/copilot-connectors · MCP Servers: https://code.visualstudio.com/docs/agent-customization/mcp-servers
- GitHub docs — policy áp dụng cho surface: https://docs.github.com/en/copilot/reference/supported-surfaces-for-policies

> Connector bán sự nhàn hạ: GitHub vận hành, bạn chỉ Connect — nhưng cái giá là nó chỉ nói chuyện với Copilot harness, nên nhìn nhãn `Connector:` trước khi đòi tool ở nơi khác.
