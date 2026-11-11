# Restore checkpoint — Quay về trước khi agent sửa sai

> **Dành cho:** dev giao task mạo hiểm cho Agent mode · **Vấn đề:** agent sửa lan man, càng sửa càng rối, khó về lại điểm an toàn · **Đọc xong:** restore đúng mốc và biết giới hạn của checkpoint (~2 phút)
> **Harness:** Copilot · **Surface:** Chat view / Agents window (session được hỗ trợ Restore Checkpoint)

## 1 câu nôm na

Nút Undo cho cả phiên agent — đi sai thì quay xe về ngã ba cũ. Tin tốt: checkpoints **bật mặc định** (`chat.checkpoints.enabled` = on) — VS Code tự snapshot các file liên quan **trước mỗi request**, bạn không phải tạo mốc tay. Restore checkpoint đưa file về mốc đó **và xoá các turns hội thoại sau nó**. Cần phân biệt: checkpoint mạnh hơn `Ctrl+Z` vì quay **cả phiên**, nhưng nó là state **tạm** của session — mốc bền vẫn là commit git. · 📄 [VS Code Docs: Sessions (concept)](https://code.visualstudio.com/docs/agents/concepts/sessions)

## Vì sao dùng Restore checkpoint?

Giao cho agent sửa nhiều file là con dao hai lưỡi: nhanh, nhưng một turn sai có thể làm rối cả loạt file. Hệ checkpoint trong docs có **4 cơ chế**:

| Cơ chế | Nó làm gì | Khi nào dùng |
|---|---|---|
| 1. Automatic | Snapshot file trước mỗi request — mặc định bật | Không làm gì, gửi request là có mốc |
| 2. Restore checkpoint | File về mốc + xoá các turn sau đó | Agent đi sai từ một mốc rõ |
| 3. Restore conversation only | Chỉ hội thoại về mốc, **giữ** file hiện tại | Code đã đúng, muốn hỏi lại prompt sạch hơn |
| 4. Name a checkpoint | Đặt tên mốc để tìm lại đúng điểm | Session 20+ turn, nhiều mốc gần nhau |

**Nếu làm sai thì sao?** Ngộ nhận nguy hiểm nhất: tưởng checkpoint hoàn tác được **mọi thứ**. Không — docs ghi rõ nó **không** reverse lệnh terminal đã chạy, network request, deploy, hay thay đổi ở dịch vụ ngoài; và nó không thay Git. Xem ❌/✅.

> **Tóm gọn 1 câu:** Checkpoint là nút Undo cho cả phiên agent — nhưng lệnh terminal/deploy đã chạy thì nó bó tay, nên trước việc mạo hiểm vẫn commit một cái. · 📄 [VS Code Docs: Sessions (concept)](https://code.visualstudio.com/docs/agents/concepts/sessions)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** agent sửa lan man và càng sửa càng rối; muốn thử hai hướng từ cùng một điểm; code đã đúng nhưng hội thoại lệch (restore conversation only).
- **ĐỪNG dùng khi:** bạn chỉ mới sửa vài edit ở bước cuối — `Ctrl+Z` gọn hơn nhiều.
- **Cho ai:** người để agent sửa nhiều file — trước task lớn càng nên nắm phần này. · 📄 [VS Code Docs: Pick the right tool](https://code.visualstudio.com/docs/agents/best-practices#pick-the-right-tool-for-the-task)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Không thấy mốc? Kiểm tra `chat.checkpoints.enabled` và session có được hỗ trợ; palette có **Chat: Open Checkpoints…** để liệt kê mốc trong phiên. · 📄 [VS Code Docs: Restore a checkpoint](https://code.visualstudio.com/docs/agents/run/review-code-edits#restore-a-checkpoint)

## Ví dụ thật

Nghiệp vụ: bạn giao agent "đổi toàn bộ API layer sang fetch có retry". Agent chạy xong nhưng sửa lan 5 file, có file không liên quan, và làm hỏng một import. Bạn muốn về đúng lúc trước khi bắt đầu.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Prompt examples](https://code.visualstudio.com/docs/agents/guides/prompt-examples)

**Kết quả mong đợi:** Code về đúng trạng thái checkpoint; `git diff` sạch lại; thử hướng mới từ điểm an toàn.

**✅ Verify:** Chạy `git status` + test nhanh — sạch và xanh là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — đoán rằng restore sẽ "dọn hết" mọi hậu quả, kể cả lệnh đã chạy:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — commit làm mốc bền trước task lớn; restore chỉ lo phần file + hội thoại:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

**Bài học:** Checkpoint khôi phục file + history, **không** hoàn tác terminal/deploy/dịch vụ ngoài — những thứ đó dùng Git hoặc controls của chính dịch vụ.

## Lỗi thường gặp

📄 [VS Code Docs: Recover unwanted changes](https://code.visualstudio.com/docs/agents/guides/get-agent-back-on-track#recover-unwanted-changes)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không có mốc để restore | `chat.checkpoints.enabled` tắt / session không được hỗ trợ | Bật lại setting; commit git tay làm mốc bền trước task lớn |
| Restore "mất" cả phần đúng | Mốc chọn quá xa / xoá luôn turns sau | Chọn mốc sát lỗi; chỉ cần dựng lại hội thoại thì restore conversation only |
| Terminal/deploy vẫn còn hậu quả | Checkpoint không reverse tác vụ ngoài file | Dùng git + recovery của dịch vụ; đọc ❌/✅ ở trên |
## So sánh với Claude Code

📄 [VS Code Docs: Agent Harnesses](https://code.visualstudio.com/docs/agents/concepts/agent-harnesses)

| Việc | Copilot (`Restore checkpoint`) | Claude Code | Ghi chú |
|---|---|---|---|
| Quay lui cả phiên agent | File + history về mốc, xoá turns sau | Checkpoint tự động khi agent sửa, có thể rewind | Cả hai đều "undo cả phiên" |
| Undo vài edit | `Ctrl+Z` | Undo/rewind | Mức nhỏ tương đương |
| Mốc bền | Commit git | Commit git | Không bên nào thay được git làm mốc chắc |
## Best practices (kèm "vì sao")

- **Commit trước mọi task agent mạo hiểm.** *Vì sao?* Checkpoint là state tạm của session; git là mốc bền không bay theo cache IDE.
- **Đặt tên mốc trước việc dài.** *Vì sao?* Session 20+ turn có nhiều mốc gần nhau; tên rõ giúp restore đúng điểm.
- **Restore xong chạy test ngay.** *Vì sao?* Workspace về mốc cũ, nhưng bạn cần xác nhận trạng thái đó thực sự tốt.
- **Đừng kỳ vọng restore cho terminal/deploy.** *Vì sao?* Docs ghi rõ giới hạn; hậu quả ngoài file phải xử bằng công cụ của chính hệ thống đó. · 📄 [VS Code Docs: Choose your review approach](https://code.visualstudio.com/docs/agents/run/review-code-edits#choose-your-review-approach)

## Bài tập nhỏ

1. **(5 phút)** Trước khi cho agent một task nhỏ, commit một mốc bền; làm hỏng có chủ đích rồi Restore Checkpoint để thấy cả quy trình.
2. **(5 phút)** Thử hai hướng từ cùng một mốc: chạy agent cách A, restore, chạy cách B, so sánh kết quả.
3. **(5 phút)** Chạy một lệnh terminal vô hại (vd `npm ls`) sau request của agent, rồi restore — xác nhận lệnh terminal **không** bị hoàn tác. · 📄 [VS Code Docs: Restore a checkpoint](https://code.visualstudio.com/docs/agents/run/review-code-edits#restore-a-checkpoint)

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Docs: [Review & revert changes](https://code.visualstudio.com/docs/agents/run/review-code-edits) · [Get an agent back on track](https://code.visualstudio.com/docs/agents/guides/get-agent-back-on-track)
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md). Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Bắt đầu sạch sau restore: [../new-chat/README.md](../new-chat/README.md). Lưu phiên trước khi bỏ: [export](../../../local/chat-session/export/README.md).

> Restore checkpoint là lưới an toàn của Agent mode — nhưng lưới chỉ giữ được phần file và hội thoại; phần terminal và deploy vẫn cần tới git và lương tâm của bạn.
