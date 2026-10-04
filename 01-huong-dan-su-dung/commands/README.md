# Commands — Index tra cứu 46 lệnh Copilot 2026

> Index tổng 46 lệnh chi tiết, chia 4 nhóm. Mỗi dòng = 1 lệnh: mô tả 1 dòng + link sang folder chi tiết (`./<nhóm>/<slug>/README.md`). Mỗi README chi tiết 120–200 dòng, 8 mục: tiêu đề + quote, cú pháp bảng 3 cột, cơ chế + sơ đồ text + khác lệnh dễ nhầm, 2 ví dụ bash copy-paste, rủi ro + token + plan gating, combo workflow, lỗi hay gặp, tham khảo. Tiếng Việt.

**Cách dùng:** tìm nhóm → đọc mô tả 1 dòng → click link sang folder chi tiết. Gõ `/` (slash), `@` (participant), `#` (variable) trong Chat input để xem list khả dụng **ở môi trường của bạn** (khác plan/model/version sẽ khác).

## Nhóm 1 — Chat session (12)

Chi tiết nhóm: [./chat-session/README.md](./chat-session/README.md)

| Lệnh | Mô tả 1 dòng | Chi tiết |
|---|---|---|
| `/new` | Mở chat mới, xóa history — thói quen #1 mỗi task | [./chat-session/new-chat/README.md](./chat-session/new-chat/README.md) |
| `/clear` | Xóa context chat hiện tại, giữ instructions | [./chat-session/clear/README.md](./chat-session/clear/README.md) |
| `/history` | Xem lại lịch sử chats, quay lại chat cũ | [./chat-session/history/README.md](./chat-session/history/README.md) |
| `/export` | Export conversation ra file để lưu/share | [./chat-session/export/README.md](./chat-session/export/README.md) |
| `/resume` | Mở lại / tiếp tục phiên chat đã lưu | [./chat-session/resume/README.md](./chat-session/resume/README.md) |
| `Ctrl+I` inline | Chat inline ngay trong editor, sửa tại chỗ | [./chat-session/inline-chat/README.md](./chat-session/inline-chat/README.md) |
| `Shift+Alt+I` quick | Mở Quick Chat hỏi nhanh không rời editor | [./chat-session/quick-chat/README.md](./chat-session/quick-chat/README.md) |
| `Restore checkpoint` | Quay về checkpoint trước khi agent sửa sai | [./chat-session/checkpoints/README.md](./chat-session/checkpoints/README.md) |
| `Attach / #file` | Đính kèm file/folder/ảnh vào prompt | [./chat-session/attachments/README.md](./chat-session/attachments/README.md) |
| `/help` | Xem help + nhóm lệnh khả dụng | [./chat-session/help/README.md](./chat-session/help/README.md) |
| `Shortcuts` | Liệt kê phím tắt Chat trong IDE này | [./chat-session/shortcuts/README.md](./chat-session/shortcuts/README.md) |
| `/summarize` | Tóm tắt hội thoại dài thành bản gọn giữ đà task | [./chat-session/summarize/README.md](./chat-session/summarize/README.md) |

## Nhóm 2 — Model & Agent (9)

Chi tiết nhóm: [./model-agent/README.md](./model-agent/README.md)

| Lệnh | Mô tả 1 dòng | Chi tiết |
|---|---|---|
| `/model` | Đổi model giữa chat (mạnh/rẻ tùy task) | [./model-agent/model-picker/README.md](./model-agent/model-picker/README.md) |
| `Ask mode` | Về Ask read-only: chỉ hỏi, không sửa | [./model-agent/ask-mode/README.md](./model-agent/ask-mode/README.md) |
| `Edit mode` | Vào Edit với files bạn chọn, sửa có kiểm soát | [./model-agent/edit-mode/README.md](./model-agent/edit-mode/README.md) |
| `/agent` | Vào Agent mode: tự tìm file, sửa, chạy terminal | [./model-agent/agent-mode/README.md](./model-agent/agent-mode/README.md) |
| `Custom agent` | Gọi custom agent trong .github/agents/ | [./model-agent/custom-agent/README.md](./model-agent/custom-agent/README.md) |
| `/usage` | Xem premium requests đã dùng (link dashboard) | [./model-agent/premium-requests/README.md](./model-agent/premium-requests/README.md) |
| `Coding agent assign` | Giao issue cho Copilot coding agent xử lý async | [./model-agent/coding-agent-assign/README.md](./model-agent/coding-agent-assign/README.md) |
| `Coding agent PR` | Tóm tắt diff thành PR, review flow issue→PR | [./model-agent/coding-agent-pr/README.md](./model-agent/coding-agent-pr/README.md) |
| `Policy approval` | Xem/duyệt policy, approve chạy lệnh nhạy cảm | [./model-agent/policy-approval/README.md](./model-agent/policy-approval/README.md) |

## Nhóm 3 — Code actions (10)

Chi tiết nhóm: [./code-actions/README.md](./code-actions/README.md)

| Lệnh | Mô tả 1 dòng | Chi tiết |
|---|---|---|
| `/explain` | Giải thích code đang chọn bằng model hiện tại | [./code-actions/explain/README.md](./code-actions/explain/README.md) |
| `/fix` | Fix lỗi/selection đang chọn nhanh hơn prompt tay | [./code-actions/fix/README.md](./code-actions/fix/README.md) |
| `/tests` | Sinh unit tests theo mẫu repo cho code đang chọn | [./code-actions/tests/README.md](./code-actions/tests/README.md) |
| `/doc` | Sinh docstring/JSDoc cho hàm đang chọn | [./code-actions/doc/README.md](./code-actions/doc/README.md) |
| `/new` (code) | Sinh code mới từ mô tả: hàm/file/module | [./code-actions/new/README.md](./code-actions/new/README.md) |
| `/optimize` | Đề xuất tối ưu perf cho đoạn code đang chọn | [./code-actions/optimize/README.md](./code-actions/optimize/README.md) |
| `/commit` | Gợi ý commit message từ staged diff | [./code-actions/commit-message/README.md](./code-actions/commit-message/README.md) |
| `/pr` | Tóm tắt diff thành PR title + body | [./code-actions/pr-desc/README.md](./code-actions/pr-desc/README.md) |
| `/refactor` | Refactor giữ behavior, tách hàm/file | [./code-actions/refactor/README.md](./code-actions/refactor/README.md) |
| `@terminal` | Biến lỗi terminal thành task fix cho agent | [./code-actions/debug-terminal/README.md](./code-actions/debug-terminal/README.md) |

## Nhóm 4 — System & Knowledge (15)

Chi tiết nhóm: [./system-knowledge/README.md](./system-knowledge/README.md)

| Lệnh | Mô tả 1 dòng | Chi tiết |
|---|---|---|
| `/instructions` | Xem/sửa instructions đang load cho repo này | [./system-knowledge/instructions/README.md](./system-knowledge/instructions/README.md) |
| `/prompts` | Liệt kê prompt files .github/prompts/ khả dụng | [./system-knowledge/prompt-file/README.md](./system-knowledge/prompt-file/README.md) |
| `/skills` | Liệt kê Agent Skills .github/skills/ khả dụng | [./system-knowledge/agent-skill/README.md](./system-knowledge/agent-skill/README.md) |
| `/mcp` | Xem MCP servers/tools đang bật, reconnect khi rớt | [./system-knowledge/mcp/README.md](./system-knowledge/mcp/README.md) |
| `MCP add` | Thêm MCP server mới vào cấu hình | [./system-knowledge/mcp-add/README.md](./system-knowledge/mcp-add/README.md) |
| `/extensions` | Quản lý Copilot Extensions đã cài | [./system-knowledge/extensions/README.md](./system-knowledge/extensions/README.md) |
| `Content exclusion` | Xem files Copilot không được đọc | [./system-knowledge/content-exclusion/README.md](./system-knowledge/content-exclusion/README.md) |
| `Telemetry` | Xem/sửa code-telemetry consent | [./system-knowledge/telemetry/README.md](./system-knowledge/telemetry/README.md) |
| `/status` | Xem trạng thái Copilot: active, account, model | [./system-knowledge/status/README.md](./system-knowledge/status/README.md) |
| `/login` | Đăng nhập GitHub account cho Copilot | [./system-knowledge/login/README.md](./system-knowledge/login/README.md) |
| `/logout` | Đăng xuất, xóa credentials local | [./system-knowledge/logout/README.md](./system-knowledge/logout/README.md) |
| `/feedback + /bug` | Gửi feedback/bug về câu trả lời cho GitHub | [./system-knowledge/bug-feedback/README.md](./system-knowledge/bug-feedback/README.md) |
| `Knowledge base` | Hỏi tri thức team (docs nội bộ, wiki, RAG) | [./system-knowledge/knowledge-base/README.md](./system-knowledge/knowledge-base/README.md) |
| `gh copilot suggest` | Gợi ý lệnh CLI trong terminal (gh copilot) | [./system-knowledge/cli-suggest/README.md](./system-knowledge/cli-suggest/README.md) |
| `gh copilot explain` | Giải thích lệnh CLI vừa chạy/gặp | [./system-knowledge/cli-explain/README.md](./system-knowledge/cli-explain/README.md) |

## Công thức session đầu (giữ nguyên, 1 lần/repo)

```text
/status → /instructions → /mcp → custom agent → /policy
```

> Mẹo 1 dòng: _chat mới mỗi task (`/new`), gắn scope mọi prompt (`#file`/`@workspace`), review diff trước khi Accept._
