# /rename — Đổi tên phiên chat cho dễ tìm lại

> **Dành cho:** người hay chạy nhiều phiên song song trong một ngày · **Vấn đề:** list phiên toàn những tên mặc định "New Chat", không phân biệt được đâu là task nào · **Đọc xong:** đặt tên rõ ràng cho phiên và tìm lại nhanh trong Session History (~1 phút)
> **Harness:** Local · **Surface:** VS Code Chat (Local harness) — docs ghi `/rename` đổi tên chat trong **một local Ask chat** (`/rename <tên mới>`); CLI có bản riêng `/rename` (đổi tên session hiện tại)

## 1 câu nôm na

Dán nhãn lên lọ gia vị trước khi cất vào tủ: `/rename <tên>` đổi tên phiên chat đang mở, để lát nữa mở Session History là thấy ngay "Dựng API login" thay vì một loạt "New Chat" lẫn lộn. Đây là lệnh vệ sinh phiên, không đổi nội dung hội thoại. · 📄 [VS Code Docs: AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

## Vì sao dùng /rename?

Multi-tasking bằng chat dạng phiên chỉ hiệu quả nếu bạn tìm lại được việc của mình. `/rename` biến Session History thành một cuốn sổ có mục lục: mỗi phiên một tiêu đề mô tả việc thật, thay vì phải mở từng phiên ra dò.

**Nếu làm sai thì sao?** Tưởng `/rename` là lệnh đổi tên biến/file trong code thì nhầm sang nhầm để — nó chỉ đổi **tên phiên chat**, không đụng bất kỳ file nào. Cũng đừng tìm nó trong session Copilot harness nếu máy bạn không có: docs gắn nhãn "in a local chat".

> **Tóm gọn 1 câu:** `/rename <tên>` dán nhãn cho phiên chat hiện tại — đắt giá nhất ở chỗ nó giúp Session History đọc được sau 3 ngày.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bắt đầu một task sẽ kéo dài; có 3-4 phiên mở song song; chuẩn bị quay lại việc bỏ dở sau một buổi.
- **ĐỪNG dùng khi:** phiên chỉ để hỏi thoáng qua rồi đóng — thêm bước thừa; bạn cần đổi tên file/biến trong code — đó là việc của editor, không phải chat. · 📄 [VS Code Docs: Pick the right tool](https://code.visualstudio.com/docs/agents/best-practices#pick-the-right-tool-for-the-task)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> `/rename Sửa bug thanh toán` — đổi tên phiên đang mở thành tên mới. Bạn cũng có thể đổi tên ngay trong **Session History** (nút chuột phải / pencil) thay vì dùng slash. · 📄 [VS Code Docs: Cheat Sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

## Ví dụ thật

Đang làm 3 việc cùng lúc: refactor model, viết test, sửa CI. Mỗi lần mở phiên mới làm một việc rồi `/rename` theo tên task — cuối ngày Session History là 3 ô rõ tên, ngày mai bấm tiếp mà không phải dò lại.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**✅ Verify:** mở Session History, thấy phiên vừa đổi tên hiển thị đúng tên mới — đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — để cả loạt phiên tên "New Chat" rồi mò từng cái:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — rename ngay khi phiên bắt đầu một việc rõ ràng:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** tên phiên là chi phí nhỏ nhưng trả về khả năng tìm lại — làm từ đầu thì không phải bò từng phiên.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy `/rename` khi gõ `/` | Harness/version không bật, hoặc đang ở Copilot session | Kiểm Session Target; dùng nút đổi tên trong Session History |
| Đổi tên xong không thấy trong Session History | Nhầm giữa Chat view và Agents window | Agent session ở Agents window quản lý riêng — đổi tên ở đúng cửa sổ |
| Tưởng đổi tên được cả file code | Hiểu nhầm phạm vi lệnh | `/rename` chỉ đổi tên phiên chat, không phải rename symbol |

## So sánh với Claude Code

| Việc | Copilot (`/rename`) | Claude Code | Ghi chú |
|---|---|---|---|
| Đổi tên phiên chat | `/rename <tên>` (local chat) + nút trong Session History | Đổi tên trong session renaming / UI | Cả hai đều là quản lý phiên, không phải code |
| Đổi tên biến/file trong code | Công cụ editor (F2 rename) | `/rename` nếu dùng qua agent hoặc editor | Đừng nhầm hai thứ này |

## Best practices (kèm "vì sao")

- **Rename ngay khi phiên rõ hướng.** *Vì sao?* Đặt tên lúc đầu còn nhớ ngữ cảnh, tên chính xác hơn lúc quay lại.
- **Dùng tên theo việc chứ không theo ngày.** *Vì sao?* "Sửa lỗi payment" dễ tìm hơn "Task 14/11".
- **Phối hợp với folder/workspace để gom phiên.** *Vì sao?* Session History gom theo workspace — cùng một dự án thì mở cùng workspace. · 📄 [VS Code Docs: Crafting effective prompts](https://code.visualstudio.com/docs/agents/guides/prompt-examples#tips-for-crafting-effective-prompts)

## Bài tập nhỏ

1. **(2 phút)** Mở một phiên mới, gõ `/rename Viết API login` rồi mở Session History xác nhận tên mới.
2. **(3 phút)** Tạo 3 phiên, rename theo 3 task khác nhau, ngày sau quay lại tìm đúng phiên chỉ bằng tên. · 📄 [VS Code Docs: Cheat Sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Tìm lại phiên: [history](../../../copilot/chat-session/history/README.md) · Mở phiên mới: [new-chat](../../../copilot/chat-session/new-chat/README.md)
- Nguồn docs: [VS Code — AI features cheat sheet (Slash commands, `/rename <name>`)](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [VS Code — Session management](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions)

> Đặt tên phiên là thói quen 5 giây trả về hàng chục phút tìm kiếm sau này — làm từ đầu, đừng chờ list đầy "New Chat".
