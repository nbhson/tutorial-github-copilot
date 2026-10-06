# Cheatsheet Muse (2026) — 1 trang (lệnh nào cũng có ví dụ mini)

> Cách đọc: `lệnh` → ví dụ copy-paste ngay bên cạnh (sau `→`). Gõ `/` (slash), `@` (participant), `#` (biến) trong Chat để xem list khả dụng ở máy bạn.

## CLI (terminal)

| Lệnh | Ví dụ mini |
|---|---|
| `gh copilot suggest` | `gh copilot suggest "tìm file >100MB trong git history" → dán lệnh được gợi ý vào terminal` |
| `gh copilot explain` | `gh copilot explain "docker run -p 5432:5432 postgres" → hiểu từng flag trước khi chạy` |
| `copilot -p` (Copilot CLI) | `copilot -p "sửa lỗi test ở packages/api, chỉ đụng 2 file" → agent chạy trong terminal` |
| Check version | `gh copilot --version && gh extension list → thấy version để đối chiếu docs` |

## VS Code Chat (hỏi + sửa)

| Phím tắt / lệnh | Ví dụ mini |
|---|---|
| `Ctrl+I` inline chat | `bôi đen hàm → Ctrl+I → "thêm null check, giữ nguyên API" → review diff từng hunk` |
| `Ctrl+Shift+I` quick chat | `đang code dở → Ctrl+Shift+I → "hàm này time complexity bao nhiêu?" → trả lời xong về code ngay` |
| `Ctrl+Alt+I` mở Chat view | `Ctrl+Alt+I → "@workspace hàm login nằm ở file nào?" → tìm file không cần grep` |
| `@workspace` | `@workspace "liệt kê chỗ nào gọi API /payments?" → tìm cross-file thay vì đoán` |
| `@terminal` | `@terminal "giải thích lỗi đỏ vừa rồi + gợi ý fix" → biến log thành task` |
| `/explain` | `bôi đen 20 dòng → /explain "giải thích như cho intern mới" → hiểu code lạ trong 30s` |
| `/fix` | `bôi đen dòng lỗi → /fix "thêm null check cho params" → Accept sau khi đọc diff` |
| `/tests` | `bôi đen hàm → /tests "sinh test theo mẫu repo, mock DB" → chạy thử, phải xanh mới Accept` |
| `/doc` | `bôi đen hàm → /doc "viết JSDoc gồm params + example" → docs chuẩn repo trong 1 nốt` |
| `/new` | `/new "bắt đầu task refactor login, cho checklist 5 bước" → chat sạch mỗi task mới` |
| `/clear` | `/clear → xóa turns cũ khi chat bắt đầu loạn, giữ instructions` |
| `/summarize` | `/summarize "nén chat này thành 5 gạch đầu dòng + việc còn dở" → giữ đà task dài` |
| `/help` | `/help → xem slash/participant khả dụng ở plan + version của bạn` |
| `Tab` nhận gợi ý | `gõ nửa hàm → Tab nhận, Alt+] / Alt+[ đổi gợi ý, Esc từ chối` |

## Modes (Ask → Edit → Agent leo thang)

| Mode | Ví dụ mini |
|---|---|
| `Ask` (chỉ hỏi, không sửa) | `chọn Ask → "so sánh 2 cách cache này, chưa cần sửa code" → an toàn khi tìm hiểu` |
| `Edit` (sửa file chỉ định) | `chọn Edit + tick 2 file → "đổi message lỗi sang tiếng Việt" → sửa có kiểm soát` |
| `Agent` (tự tìm file + chạy tool) | `chọn Agent → "thêm rate-limit cho /api/login + test" → duyệt plan trước khi để nó chạy` |
| `/model` đổi model | `/model → chọn model rẻ cho /explain, model mạnh cho agent/kiến trúc khó` |
| `/usage` xem quota | `/usage → xem premium requests đã dùng; hết thì đổi model nhẹ chờ reset` |

## instructions / prompts / skills / MCP

| Cái gì | Ví dụ mini |
|---|---|
| `.github/muse-instructions.md` | `ghi stack + 6 lệnh Dev/Build/Test đã chạy thử → mọi câu trả lời theo chuẩn team` |
| `*.instructions.md` + `applyTo` | `backend-api.instructions.md với applyTo: apps/api/** → chỉ áp cho backend` |
| `*.prompt.md` | `/review-pr "review diff này theo correctness/security/tests" → prompt tái dùng` |
| `*.agent.md` | `gọi agent explorer: "vẽ bản đồ file chạm tới auth" → việc ồn ào đẩy sang sub-agent` |
| `.github/skills/` | `nhờ "review PR giúp" → model tự gọi Skill review-pr, không cần nhớ tên` |
| `.vscode/mcp.json` | `thêm server github → hỏi "dùng github tool liệt kê 5 PRs mới nhất" → test sống` |
| MCP config mẫu | Xem JSON mẫu ở `templates/README.md` → copy rồi sửa token qua `${input}` (không hardcode) |

## Vòng chuẩn (mọi task)

`Explore (explorer vẽ bản đồ) → Plan (duyệt plan) → Implement (chia phase, mỗi phase xong chạy test) → Verify (test + review fresh). Rule nào miss 2 lần → đưa vào instructions/policy.`

## Coding agent + Review

| Việc | Ví dụ mini |
|---|---|
| Giao issue cho agent | `trên GitHub: assign issue cho Copilot → nó tự tạo branch + PR → bạn review → merge` |
| Review tự động | `mở PR → Copilot comment "thiếu test cho nhánh null" → sửa trước khi merge` |
| `/review` trong Chat | `/review "check diff này về security + missing tests" → review trước khi đẩy` |
| Policy là luật chặn cuối | `policy chặn `*.pem` → dù prompt bảo đọc, Copilot vẫn từ chối (xem FAQ 05)` |

## Tra cứu chi tiết

Index 46 lệnh: [01-huong-dan-su-dung/commands/README.md](01-huong-dan-su-dung/commands/README.md) · Hỏi đáp: [03-cau-hoi-thuong-gap/README.md](03-cau-hoi-thuong-gap/README.md) · Mẫu copy-paste: [templates/README.md](templates/README.md)
