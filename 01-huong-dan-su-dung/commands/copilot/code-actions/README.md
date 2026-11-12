# Nhóm Code Actions (12 lệnh)

> **Dành cho:** dev làm tác vụ code trên selection hoặc diff · **Đọc xong:** tra đúng lệnh theo bảng dưới rồi bấm sang README chi tiết (~2 phút).

Nhóm này là các "động tác nhanh" trên code bạn đang chọn: giải thích, sửa lỗi, viết test, viết doc, tạo mới, tối ưu, refactor, và chốt git (commit/PR). Điểm chung: chúng thao tác trên một *phạm vi nhỏ* — đoạn bôi đen, file bạn chọn, hay staged diff — chứ không tự đi tìm việc khắp repo.

**Tra thế nào?** Nhìn vào việc bạn đang muốn làm với đoạn code trước mặt: *hiểu nó* → `/explain`; *chữa nó* → `/fix`; *đảm bảo nó* → `/tests`; *ghi lại nó* → `/doc`; *viết mới* → `/new`; *làm cho nhanh hơn* → `/optimize`; *dọn mà giữ hành vi* → `/refactor`; *chốt lại* → `/commit`, `/pr`; *nó đang crash* → Terminal Inline Chat.

**Vì sao quan trọng?** Vì scope nhỏ là lợi thế, không phải hạn chế. Khi bạn bôi đen đúng chỗ, lệnh tự lấy vùng đó làm ngữ cảnh — ít token hơn, ít sửa nhầm hơn so với việc đưa cả file vào rồi mô tả "sửa chỗ nào". Ngược lại, dùng lệnh nhỏ cho việc lớn (bug sâu nhiều file) là cách nhanh nhất để tạo diff loạn.

**Nếu làm sai?** Quên bôi đen là lỗi phổ biến nhất: model tự đoán scope và sửa rộng hơn dự kiến. Còn Terminal Inline Chat (`Ctrl+I` trong terminal) không phải để "sửa giúp tôi" — nó *biến lỗi terminal thành task* có ngữ cảnh; nếu chỉ dán log rồi hỏi chung chung, agent sẽ đoán mò.

> **Tóm gọn 1 câu:** Nhóm này là bộ động tác nhanh trên đoạn code trước mặt — bôi đen càng chính xác thì động tác càng gọn, còn việc lớn nhiều file thì phải đổi sang Agent mode.

| Lệnh | Mô tả 1 dòng | Chi tiết |
|---|---|---|
| `/explain` | Giải thích code đang chọn bằng model hiện tại | [./explain/README.md](./explain/README.md) |
| `/fix` | Fix lỗi/selection đang chọn nhanh hơn prompt tay | [./fix/README.md](./fix/README.md) |
| `/tests` | Sinh unit tests theo mẫu repo cho code đang chọn | [./tests/README.md](./tests/README.md) |
| `/setupTests` (Experimental) | Chọn & dựng khung test framework theo stack repo — khác `/tests` | [./setup-tests/README.md](./setup-tests/README.md) |
| `/plan` | Lập kế hoạch nhiều bước trước khi sửa (plan-first) | [./plan/README.md](./plan/README.md) |
| `/doc` (inline chat) | Sinh docstring/JSDoc cho hàm đang chọn | [./doc/README.md](./doc/README.md) |
| `/new`, `/newNotebook` | Scaffold workspace/file/notebook mới từ mô tả — **không phải** "viết hàm hộ" | [./new/README.md](./new/README.md) |
| Inline chat `Ctrl+I` (docs không có slash `/optimize`) | Tối ưu perf cho đoạn code đang chọn, có đo đạc | [./optimize/README.md](./optimize/README.md) |
| ✨ cạnh ô commit message (Source Control) | Sinh commit message từ staged diff | [./commit-message/README.md](./commit-message/README.md) |
| ✨ cạnh ô title trong Create Pull Request view | PR title + body từ diff, tôn trọng PR template | [./pr-desc/README.md](./pr-desc/README.md) |
| Inline chat + 💡 Code Actions (docs không có slash `/refactor`) | Refactor giữ behavior, tách hàm/file | [./refactor/README.md](./refactor/README.md) |
| Terminal Inline Chat (`Ctrl+I` trong terminal) | Biến lỗi terminal thành task fix cho agent | [./debug-terminal/README.md](./debug-terminal/README.md) |

> **Cách đọc bảng này:** mỗi dòng một lệnh, xếp theo nhóm việc (hiểu → chữa → đảm bảo → ghi lại → viết mới → chốt git); đọc cột Mô tả 1 dòng là đủ chọn, bấm cột Chi tiết khi cần prompt mẫu và ví dụ.

## So sánh với Claude Code

Nếu bạn làm việc song song cả hai công cụ, bảng này cho biết mỗi lệnh Copilot "tương đương" bên Claude Code là gì — và chỗ nào không có, đừng đi tìm.

| Việc | Copilot | Claude Code |
|---|---|---|
| Giải thích code đang chọn | `/explain` | Không có built-in — chọn code rồi hỏi, hoặc custom command |
| Sửa lỗi trên selection | `/fix` | Không có built-in — thường tự tạo custom command |
| Sinh test / doc / tối ưu / refactor | `/tests`, `/doc`, `/optimize`, `/refactor` | Không có built-in tương ứng; cộng đồng hay viết custom command |
| Sinh code mới từ mô tả | `/new` (code) | Gõ thẳng yêu cầu cho agent |
| Gợi ý commit message | `/commit` | Không có built-in ổn định — nhiều người dùng custom command |
| Tóm tắt diff thành PR | `/pr` | Không có built-in ổn định — dùng `gh` hoặc custom command |
| Biến lỗi terminal thành task | Terminal Inline Chat (`Ctrl+I` trong terminal) | Không cần participant riêng — Claude Code chạy trong terminal nên tự thấy output |

> **Cách đọc bảng này:** đọc cột Copilot trước, rồi nhìn sang Claude Code xem phải tự dựng gì; mỗi dòng ghi "không có built-in" là một chỗ bạn phải tự viết custom command.

Quay về: [../README.md](../../README.md) · Bài tổng: [../../04-chat-commands-toan-tap.md](../../../04-chat-commands-toan-tap.md)

> Sức mạnh của nhóm này nằm ở chữ "selection": bôi đen càng chính xác, lệnh càng gọn — còn nếu việc đã lan ra nhiều file, hãy khoan gọi chúng, chuyển sang Agent mode trước.
