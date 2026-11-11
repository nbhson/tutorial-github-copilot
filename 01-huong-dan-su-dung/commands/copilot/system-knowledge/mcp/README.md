# MCP — Xem server/tool đang bật cho Copilot

> **Dành cho:** dev dùng tool ngoài (GitHub, DB, browser) qua MCP · **Vấn đề:** tools đột nhiên mất, không biết server nào đang rớt · **Đọc xong:** xem trạng thái servers/tools và test lại bằng 1 lệnh thật (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI

## 1 câu nôm na

Bảng điện tổng của nhà: nhìn một cái là biết cầu dao nào đang bật, cái nào vừa nhảy. Nó liệt kê MCP servers + tools đang khả dụng và cho reconnect khi rớt. Thói quen tốt: session đầu trên mỗi repo kiểm một lần — setup GitHub (và DB nếu có), rồi test bằng một câu hỏi nhỏ.

| Bạn ở đâu | Lệnh xem trạng thái | Server đọc từ file nào |
|---|---|---|
| Copilot harness (VS Code) | `Chat: Open Customizations` → tab **MCP Servers**, hoặc `MCP: List Servers` | `.mcp.json` ở root repo (key `mcpServers`) + `~/.copilot/mcp-config.json` |
| Copilot CLI | `copilot mcp` (ngoài phiên) hoặc `/mcp list` / `/mcp show` (trong phiên) | như trên |
| **Local harness** (VS Code Chat) | `MCP: List Servers` | `.vscode/mcp.json` (key `servers`) — **Copilot harness không đọc file này** ([vscode-mcp-json](../../../local/system-knowledge/vscode-mcp-json/README.md)) |

## Vì sao phải kiểm MCP?

MCP server chạy **ngoài** editor: nó có thể rớt mạng, hết hạn token, hoặc crash sau khi bạn cập nhật gì đó. Không kiểm trạng thái, bạn chỉ thấy "sao Copilot không mở được PR nữa" mà không biết vì server chưa lên. Đây là cách nhanh nhất để trả lời "server nào sống, tool nào có" *trước khi* nhờ nó làm việc cần dữ liệu ngoài.

**Nếu bỏ qua thì sao?** Bạn đổ lỗi cho model trong khi lỗi nằm ở tầng kết nối (token hết hạn, `npx` không chạy). Kiểm bảng điện trước, đoán sau.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** session đầu mỗi repo; tools MCP đột nhiên mất; trước khi nhờ việc cần tool ngoài (PR/DB/browser).
- **ĐỪNG dùng khi:** cần **thêm/sửa** server — việc đó ở [../mcp-add/README.md](../mcp-add/README.md); cần công cụ do GitHub quản lý (Jira, Sentry…) — đó là [connector](../connector/README.md), chỉ cấp tool cho **Copilot harness**, không cấp cho Local.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Không thấy `/mcp` khi gõ `/` trong Chat view? Đúng rồi — slash đó thuộc **Copilot CLI**; trong VS Code dùng `MCP: List Servers` hoặc Customizations editor.

## Ví dụ thật

Nghiệp vụ: bạn cần Copilot đọc PR trên GitHub, nhưng vừa nâng cấp gì đó nên không rõ server còn sống không.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** thấy list servers connected + tools khả dụng; test một tool nhỏ chạy thành công.

**✅ Verify:** một tool thật (list PRs / query 1 dòng / mở browser) chạy được là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

```text
SAI : "tao PR cho branch nay" -> model bao loi tool -> tuong Copilot hong,
      thuc ra server MCP chua len.
DUNG: kiem trang thai server (github connected?) -> "liet ke 5 PRs moi nhat"
      -> chay duoc -> luc do moi nho viec that.
```

**Bài học:** kiểm kết nối bằng một việc **nhỏ** trước; fail ở việc lớn không cho bạn biết lỗi nằm ở tầng nào.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Thêm server mà Copilot không thấy | Viết vào `.vscode/mcp.json` (đúng cho Local, sai cho Copilot) | Chuyển khối sang `.mcp.json` với key `mcpServers` |
| Tools không hiện | Sai key (`servers` vs `mcpServers`) hoặc server crash | So key với mẫu + xem Output → MCP log |
| Auth fail | Token sai/thiếu env | Token qua env `${NAME}`, không hardcode trong file |
| Server nặng (playwright) | Mỗi máy spawn riêng | Team share 1 remote `http`/`sse` server |

## So sánh với Claude Code

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Xem server/tool đang bật | `MCP: List Servers` / Customizations editor; CLI `/mcp list` | `claude mcp list` | Cùng chuẩn giao thức MCP |
| Khai báo server portable | `.mcp.json` (key `mcpServers`) ở root repo | `.mcp.json` cùng chuẩn | Cùng ý tưởng "commit cho team", khác chỗ đọc của từng harness |
| Tool gọi ra trong chat | `mcp__<server>__<tool>` | `mcp__<server>__<tool>` | Cách gọi tool nhất quán giữa hai bên |

## Best practices (kèm "vì sao")

- **Kiểm trạng thái đầu mỗi session trên repo.** *Vì sao?* Server chạy ngoài nên có thể rớt giữa các session — kiểm một lần rẻ hơn debug cả tiếng.
- **Test bằng việc nhỏ trước.** *Vì sao?* Một câu nhỏ phân biệt được "lỗi kết nối" với "lỗi task", còn việc lớn thì cả hai đều trông giống nhau.
- **Giữ 3–6 servers.** *Vì sao?* Càng nhiều tool, model càng dễ chọn nhầm.
- **Token luôn qua env, không hardcode.** *Vì sao?* File config nằm trong repo — hardcode là lộ.
- **Server nặng cho team thì dùng remote chung.** *Vì sao?* Đỡ mỗi máy spawn một server riêng, và cấu hình nhất quán hơn.

## Bài tập nhỏ

1. **(5 phút)** Mở `MCP: List Servers` trên repo đang làm; ghi lại có bao nhiêu server `connected` và bao nhiêu tool.
2. **(10 phút)** Test một tool nhỏ (list PRs hoặc query 1 dòng) để xác nhận kết nối thật sự sống.
3. **(10 phút)** Cố tình đặt sai key (`servers` thay vì `mcpServers`) trong `.mcp.json`, xem Copilot còn thấy server không, rồi sửa lại.

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Thêm/sửa server: [../mcp-add/README.md](../mcp-add/README.md) · Connector (tool do GitHub quản lý): [../connector/README.md](../connector/README.md) · Bản Local: [vscode-mcp-json](../../../local/system-knowledge/vscode-mcp-json/README.md).
- Bài chủ: [08-mcp-ket-noi-cong-cu-ngoai.md](../../../../08-mcp-ket-noi-cong-cu-ngoai.md) · Cheatsheet: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · FAQ: [08-loi-thuong-gap-troubleshooting.md](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- VS Code — [MCP servers](https://code.visualstudio.com/docs/agent-customization/mcp-servers) · [MCP configuration reference](https://code.visualstudio.com/docs/agents/reference/mcp-configuration) · GitHub — [MCP concepts](https://docs.github.com/en/copilot/concepts/context/mcp).

> **Chốt:** đây không phải để "khoe server xịn", mà để bạn biết chắc đường ra ngoài còn thông — kiểm trước một câu nhỏ, đỡ đổ oan cho model.
