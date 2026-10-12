# /mcp — Xem MCP servers/tools đang bật

> **Dành cho:** dev dùng tool ngoài (GitHub, DB, browser) qua MCP · **Vấn đề:** tools đột nhiên mất, không biết server nào đang rớt · **Đọc xong:** xem trạng thái servers/tools và test lại bằng 1 lệnh thật (~2 phút)

## 1 câu nôm na

`/mcp` là bảng điện tổng của nhà: nhìn một cái là biết cầu dao nào đang bật, cái nào vừa nhảy. Nó liệt kê MCP servers + tools đang khả dụng và cho reconnect khi rớt. Thói quen tốt: session đầu tiên trên mỗi repo chạy `/mcp` một lần — setup GitHub (và DB nếu có), rồi test bằng một câu hỏi nhỏ.

## Vì sao dùng /mcp?

MCP server chạy **ngoài** VS Code: nó có thể rớt mạng, hết hạn token, hoặc crash sau khi bạn cập nhật gì đó. Không có `/mcp`, bạn chỉ thấy “sao Copilot không mở được PR nữa” mà không biết vì server chưa lên. Lệnh này là cách nhanh nhất để trả lời “server nào sống, tool nào có” *trước khi* bạn nhờ nó làm việc cần dữ liệu ngoài.

**Nếu bỏ qua thì sao?** Bạn sẽ đổ lỗi cho model trong khi lỗi nằm ở tầng kết nối (token hết hạn, `npx` không chạy). Check `/mcp` trước, đoán sau.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** session đầu mỗi repo (setup một lần); tools MCP đột nhiên mất; trước khi nhờ việc cần tool ngoài (PR/DB/browser).
- **ĐỪNG dùng khi:** bạn cần **thêm hoặc sửa** server mới — việc đó là `MCP add` (xem [../mcp-add/README.md](../mcp-add/README.md)), không phải `/mcp`.

> `/mcp` vs `MCP add`:

| Việc | Lệnh | Khi nào dùng |
|---|---|---|
| Xem/reconnect server đang bật | `/mcp` | Đầu session, nghi tool rớt |
| Thêm/sửa server mới vào config | `MCP add` (`.vscode/mcp.json`) | Cần tool ngoài mới (github/playwright/postgres) |

## Cách gọi (copy-paste)

```bash
/mcp
# liệt kê servers/tools đang bật
# Kỳ vọng: thấy list servers connected + tools khả dụng
# Verify: test 1 tool thật (list PRs / query / test browser) chạy được
```

> Không thấy `/mcp` trong list khi gõ `/`? Kiểm `/status` + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: bạn cần Copilot đọc PR trên GitHub, nhưng vừa nâng cấp gì đó nên không rõ server còn sống không.

```bash
/mcp
# Đọc kết quả: server "github" có connected? tool list_prs/create_prs có trong list?

# Rồi test bằng 1 câu NHỎ (đừng test bằng việc lớn):
"dùng github tool liệt kê 5 PRs mới nhất"
# → trả về đúng 5 PR = server sống, tool chạy thật.
# → báo "tool không khả dụng" = quay lại xem /mcp, server đang rớt.
```

**Kết quả mong đợi:** thấy list servers connected + tools khả dụng; test một tool nhỏ chạy thành công.

**✅ Verify:** một tool thật (list PRs / query / test browser) chạy được là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — nhờ việc lớn trong khi chưa kiểm kết nối:**

```text
"tạo PR cho branch này" → model báo lỗi tool → tưởng Copilot hỏng,
thực ra server MCP chưa lên.
```

**✅ ĐÚNG — kiểm bảng điện rồi test bằng câu nhỏ trước:**

```text
/mcp → thấy github connected? → "liệt kê 5 PRs mới nhất" → chạy được
→ lúc đó mới nhờ việc thật.
```

**Bài học:** kiểm kết nối bằng một việc **nhỏ** trước; fail ở việc lớn không cho bạn biết lỗi nằm ở tầng nào.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tools không hiện | Sai key (`servers`/`mcpServers`) hoặc server crash | So key với mẫu + xem Output → MCP log |
| Auth fail | Token sai/thiếu env | Token qua `${input}`/env, không hardcode; test lại |
| Server nặng (playwright) | Mỗi máy spawn riêng | Team share 1 remote `http`/`sse` server |

## So sánh với Claude Code

| Việc | Copilot (`/mcp`) | Claude Code | Ghi chú |
|---|---|---|---|
| Xem server/tool đang bật | Có `/mcp` liệt kê + reconnect | Có MCP, quản lý qua CLI/cấu hình | Cùng chuẩn giao thức MCP |
| Khai báo server | `.vscode/mcp.json` | Cấu hình MCP riêng của Claude Code | Cùng ý tưởng, khác chỗ đặt file |
| Tool gọi ra trong chat | `mcp__<server>__<tool>` | `mcp__<server>__<tool>` | Cách gọi tool nhất quán giữa hai bên |

## Best practices (kèm "vì sao")

- **Chạy `/mcp` đầu mỗi session trên repo.** *Vì sao?* Server chạy ngoài nên có thể rớt giữa các session — kiểm một lần rẻ hơn debug cả tiếng.
- **Test bằng việc nhỏ trước.** *Vì sao?* Một câu nhỏ phân biệt được “lỗi kết nối” với “lỗi task”, còn việc lớn thì cả hai đều trông giống nhau.
- **Giữ 3–6 servers.** *Vì sao?* Càng nhiều tool, model càng dễ chọn nhầm.
- **Token luôn qua `${input}`/env.** *Vì sao?* File config nằm trong repo — hardcode là lộ.
- **Server nặng cho team thì dùng remote chung.** *Vì sao?* Đỡ mỗi máy phải spawn một server riêng, và cấu hình nhất quán hơn.

## Bài tập nhỏ

1. **(5 phút)** Chạy `/mcp` trên repo đang làm; ghi lại có bao nhiêu server `connected` và bao nhiêu tool.
2. **(10 phút)** Test một tool nhỏ (list PRs hoặc query 1 dòng) để xác nhận kết nối thật sự sống.
3. **(10 phút)** Cố tình đặt sai 1 key trong `.vscode/mcp.json`, xem `/mcp` báo gì, rồi sửa lại cho đúng.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh System & Knowledge.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Thêm/sửa server (khác với xem ở đây): [../mcp-add/README.md](../mcp-add/README.md).

> **Chốt:** `/mcp` không phải để “khoe server xịn”, mà để bạn biết chắc đường ra ngoài còn thông — kiểm trước một câu nhỏ, đỡ đổ oan cho model.
