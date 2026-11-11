# Resume phiên chat — Mở lại việc dở hôm qua

> **Dành cho:** dev quay lại máy sau giấc ngủ, muốn nối tiếp session hôm qua · **Vấn đề:** tưởng có lệnh `/resume` trong chat VS Code nên gõ mãi không thấy · **Đọc xong:** mở lại đúng phiên cũ bằng danh sách phiên, biết "Resume in Terminal" và `copilot --continue` (~2 phút)
> **Harness:** Copilot · **Surface:** Chat view / Agents window (danh sách phiên) · Copilot CLI (`--continue`)

## 1 câu nôm na

Phiên chat trong VS Code không "resume" bằng slash — nó **mở lại** từ danh sách phiên, như mở file gần đây. Gõ `/resume` trong Chat view là vô nghĩa: docs VS Code không có slash này. Muốn tiếp tục trong terminal thì có **Resume in Terminal** (bấm từ menu phiên) hoặc `copilot --continue` trong Copilot CLI. · 📄 [VS Code Docs: Sessions (concept)](https://code.visualstudio.com/docs/agents/concepts/sessions)

## Vì sao dùng danh sách phiên?

Task thật trải qua nhiều ngày. Nếu mỗi sáng mở chat mới, bạn mất những gì đã chốt (kiến trúc, ràng buộc, việc dở) và model đoán lại từ đầu. Mở đúng phiên cũ nghĩa là model nhìn thấy toàn bộ lịch sử đó — nối việc trong một câu hỏi thay vì mười phút giải thích.

**Nếu làm sai thì sao?** Hai kiểu sai phổ biến: (1) gõ `/resume` rồi kết luận "Copilot không biết resume"; (2) mở đúng phiên nhưng ra lệnh cụt "tiếp tục đi" sau khi code trên đĩa đã đổi tay người khác — model tưởng context cũ vẫn đúng. Xem ❌/✅.

> **Tóm gọn 1 câu:** Resume trong VS Code là mở đúng phiên từ danh sách — slash `/resume` chỉ tồn tại trong Copilot CLI, và "tiếp tục đi" phải kèm một câu chốt trạng thái. · 📄 [VS Code Docs: Sessions (concept)](https://code.visualstudio.com/docs/agents/concepts/sessions)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** cùng một task tiếp diễn qua nhiều ngày; cần xem lại quyết định cũ; phiên CLI dài muốn gọi lại.
- **ĐỪNG dùng khi:** task mới hẳn — mở [chat mới](../new-chat/README.md) (`Ctrl+N`) cho sạch đầu bài; phiên cũ chỉ dài cổ — cân nhắc [compact](../compact/README.md) phiên đang chạy thay vì kéo đồ cũ.
- **Không có slash:** đừng tìm `/resume`, `/history`, `/export` trong Chat view — ba cái đó docs VS Code không ghi nhận (xem [history](../history/README.md)). · 📄 [VS Code Docs: Pick the right tool](https://code.visualstudio.com/docs/agents/best-practices#pick-the-right-tool-for-the-task)

## Cách mở lại phiên (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Mở Chat view (`Ctrl+Alt+I`, macOS `⌃⌘I`) → danh sách phiên ở **đầu view** → chọn phiên cần mở. Danh sách ẩn? Chuột phải vùng chat → **Show Sessions**. Session đã archive/xong? Đổi bộ lọc **Archived** (Chat view) / **Done** (Agents window). · 📄 [VS Code Docs: Find and resume a session](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#find-and-resume-a-session)

## Ví dụ thật (lấy đúng nghiệp vụ của lệnh này)

Hôm qua bạn làm tới bước 3/5 của task "thêm rate-limit cho POST /login" trong session "rate-limit login". Hôm nay mở máy, việc hôm qua chưa xong.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Prompt examples](https://code.visualstudio.com/docs/agents/guides/prompt-examples)

**Kết quả mong đợi:** phiên cũ hiện lại nguyên lịch sử; một câu recap ngắn là model nối đúng bước 3.
**✅ Verify:** hỏi "còn việc gì chưa xong?" — model kể đúng phần còn dở của hôm qua.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — gõ `/resume` trong Chat view như gõ trong CLI:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — mở đúng phiên rồi recap một câu trước khi ra lệnh:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

**Bài học:** phiên mở lại giữ *lịch sử hội thoại*, không giữ *trạng thái đĩa* — code có thể đã đổi; một câu recap + kiểm tra file hiện tại là rẻ nhất.

## Lỗi thường gặp

📄 [VS Code Docs: Find a missing session](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#find-a-missing-session)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ `/resume` không ra gì | VS Code Chat không có slash này | Mở từ danh sách phiên; `/resume` là lệnh của **Copilot CLI** |
| Không thấy phiên hôm qua | Bị lọc: phiên đã archive / nhóm thời gian khác | Đổi filter **Archived** (Chat view) hoặc **Done** (Agents window) |
| Menu phiên không có "Resume in Terminal" | Không phải harness/session type nào cũng hỗ trợ | Dùng Copilot CLI: `copilot --continue` (nối session mới nhất của thư mục hiện tại) |
## So sánh với Claude Code

📄 [VS Code Docs: Agent Harnesses](https://code.visualstudio.com/docs/agents/concepts/agent-harnesses)

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Mở lại phiên trong IDE | Danh sách phiên Chat view (không slash) | Không có IDE equivalent (CLI-first) | Copilot: UI dẫn đường |
| Nối session gần nhất ở terminal | `copilot --continue` (CLI) | `claude --continue` / `claude --resume` | Cùng kiểu flag |
| Đổi session trong CLI | `/resume [SESSION-ID]` (Copilot CLI) | `/resume` | Slash này chỉ có trong CLI |
## Best practices (kèm "vì sao")

- **Recap một câu ngay khi mở phiên cũ.** *Vì sao?* Lịch sử chat còn nguyên nhưng code trên đĩa có thể đã đổi — recap ép model bám trạng thái thật.
- **Đặt tên/để ý chủ đề phiên khi làm task dài.** *Vì sao?* Vài phiên cùng ngày dễ lẫn; phiên có mạch rõ (diff, file đang sửa) nhận ra nhanh.
- **Trước khi nối, kiểm tra các file chính còn như hôm qua không.** *Vì sao?* Resume chỉ restore hội thoại, không restore file — khác [checkpoint](../checkpoints/README.md). · 📄 [VS Code Docs: Continue across views](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#continue-between-the-chat-view-and-agents-window)

## Bài tập nhỏ

1. **(3 phút)** Liệt kê 3 phiên gần nhất bằng danh sách phiên; mở một phiên archive và xác nhận nó nằm sau filter Archived.
2. **(3 phút)** Gõ `/resume` trong Chat view và xác nhận: không có lệnh này (so sánh với `/clear`, `/compact` có sẵn).
3. **(5 phút)** Trong terminal, chạy `copilot --continue` — xác nhận nó nối phiên CLI mới nhất, rồi mở menu một phiên trong Chat view thử **Resume in Terminal** nếu có. · 📄 [VS Code Docs: Find and resume a session](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#find-and-resume-a-session)

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Docs: [Manage sessions (find and resume, Resume in Terminal)](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions) · [Copilot CLI command reference (`--continue`, `/resume`)](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md). Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Lệnh CLI dài: [../compact/README.md](../compact/README.md). Mở trắng thay vì nối: [../new-chat/README.md](../new-chat/README.md).

> Mở lại được phiên cũ là kỹ năng của người làm việc *dài hạn* với Copilot — chat một ngày là đồ chơi, chat nối ngày mới là workflow.
