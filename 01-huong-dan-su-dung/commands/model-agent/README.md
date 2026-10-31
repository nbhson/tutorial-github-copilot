# Nhóm Model & Agent (10 lệnh)

> **Dành cho:** người chọn model, chọn chế độ làm việc và gọi agent · **Đọc xong:** tra đúng lệnh theo bảng dưới rồi bấm sang README chi tiết (~2 phút).

Nhóm này quyết định *ai làm việc và làm ở đâu*: chọn "bộ não" (`/model`), chọn mức can thiệp của nó vào code (Ask / Edit / Agent), gọi agent đã cấu hình sẵn, giao việc chạy nền cho coding agent, và kiểm soát quyền chạy lệnh nhạy cảm. Hiểu nhóm này là hiểu cách Copilot chuyển từ "trả lời câu hỏi" sang "tự làm rồi trả kết quả".

**Tra thế nào?** Hai câu hỏi bao quát hết: *"tôi muốn đổi cách model phản hồi"* → `Ask`/`Edit`/`/agent`; *"tôi muốn đổi model hoặc nơi nó chạy / giao việc / soi quota / duyệt policy"* → các dòng còn lại.

**Vì sao quan trọng?** Chọn sai chế độ là nguyên nhân số một của "Copilot tự sửa linh tinh". Ask chỉ đọc, Edit sửa có kiểm soát trên file bạn chọn, Agent tự đi tìm và chạy terminal — cùng một prompt nhưng hệ quả rất khác. Chọn đúng mức can thiệp trước khi gõ tiết kiệm cả vòng sửa đi sửa lại.

**Nếu làm sai?** Đừng bật Agent mode cho việc chỉ cần hỏi — nó có quyền chạy lệnh, sửa nhiều file, và diff sẽ to hơn bạn muốn. Ngược lại, đừng dùng Ask mode cho việc cần sửa xuyên nhiều file; bạn sẽ phải gõ tay lại từng bước.

| Lệnh | Mô tả 1 dòng | Chi tiết |
|---|---|---|
| `/model` | Đổi model giữa chat (mạnh/rẻ tùy task) | [./model-picker/README.md](./model-picker/README.md) |
| `Ask mode` | Về Ask read-only: chỉ hỏi, không sửa | [./ask-mode/README.md](./ask-mode/README.md) |
| `Edit mode` | Vào Edit với files bạn chọn, sửa có kiểm soát | [./edit-mode/README.md](./edit-mode/README.md) |
| `/agent` | Vào Agent mode: tự tìm file, sửa, chạy terminal | [./agent-mode/README.md](./agent-mode/README.md) |
| `Custom agent` | Gọi custom agent trong .github/agents/ | [./custom-agent/README.md](./custom-agent/README.md) |
| `/usage` | Xem AI Credits đã dùng (link dashboard) | [./premium-requests/README.md](./premium-requests/README.md) |
| `Coding agent assign` | Giao issue cho Copilot coding agent xử lý async | [./coding-agent-assign/README.md](./coding-agent-assign/README.md) |
| `Coding agent PR` | Tóm tắt diff thành PR, review flow issue→PR | [./coding-agent-pr/README.md](./coding-agent-pr/README.md) |
| `Policy approval` | Xem/duyệt policy, approve chạy lệnh nhạy cảm | [./policy-approval/README.md](./policy-approval/README.md) |
| `Session Target` | Chọn harness + nơi agent chạy: Local/Copilot/Cloud | [./session-target/README.md](./session-target/README.md) |

## So sánh với Claude Code

| Việc | Copilot | Claude Code |
|---|---|---|
| Đổi model | `/model` | `/model` |
| Chế độ "chỉ hỏi, không sửa" | `Ask mode` | Plan mode (đọc/không sửa) |
| Sửa trên file chỉ định | `Edit mode` | Không tách riêng — Claude Code tự quyết phạm vi sửa hoặc dùng plan mode để chốt trước |
| Agent tự tìm file + chạy lệnh | `/agent` (Agent mode) | Chế độ thực thi mặc định (không có tên mode riêng) |
| Agent tuỳ biến | Custom agent trong `.github/agents/` | Subagents trong `.claude/agents/` |
| Giao issue chạy nền ra PR | Copilot coding agent (assign issue) | Claude Code GitHub Actions / mention `@claude` trên issue |
| Xem mức dùng / chi phí | `/usage` (AI Credits) | `/cost` (token & chi phí) |
| Duyệt quyền chạy lệnh | Policy approval | `/permissions` + allow/deny trong settings |
| Chọn nơi agent chạy (Local/Copilot/Cloud) | `Session Target` | Không có tương đương trực tiếp — Claude Code chạy local, hoặc qua CI/Actions |

Quay về: [../README.md](../README.md) · Bài tổng: [../../04-chat-commands-toan-tap.md](../../04-chat-commands-toan-tap.md)

> Trong nhóm này, thứ đáng nhớ không phải tên lệnh mà là *mức can thiệp*: hỏi thì Ask, sửa có kiểm soát thì Edit, giao việc lớn thì Agent — chọn đúng mức trước khi gõ, đỡ phải undo sau.
