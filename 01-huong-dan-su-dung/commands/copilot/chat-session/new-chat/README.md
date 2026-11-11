# Chat mới (`Ctrl+N`) — Đầu bài sạch cho task mới

> **Dành cho:** dev bắt đầu task mới trong VS Code · **Vấn đề:** chat cũ dài khiến model lẫn context, trả lời lan man · **Đọc xong:** mở đúng "chat mới" bằng phím, và không nhầm với `/new` scaffold (~2 phút)
> **Harness:** Copilot · **Surface:** Chat view / Agents window (phím + nút, không phải slash)

## 1 câu nôm na

Đóng chat cũ đang rối, mở tờ giấy trắng để bắt đầu task mới. Đường đúng: **`Ctrl+N`** (macOS `⌘N`) — "Start a new chat", hoặc bấm **New Session** ở đầu danh sách phiên rồi chọn workspace/harness.

Chỗ phải cảnh giác: gõ `/` thấy **`/new`** đừng tưởng là chat mới — docs định nghĩa `/new` là **scaffold a workspace, file, or notebook** (đẻ ra cấu trúc dự án/file mới). Hai việc khác nhau, xem [code-actions/new](../../code-actions/new/README.md).

## Vì sao dùng chat mới?

Chat càng dài thì hai thứ xấu đi cùng lúc: model bị **loãng trọng tâm** và mỗi turn lại **nạp lại toàn bộ history cũ** vào context. Hệ quả: vừa nhận câu trả lời lan man, vừa đốt token vô ích. Chat mới giải quyết cả hai:

- **Đầu bài sạch** — model chỉ thấy task mới, không bị ám bởi quyết định của task cũ.
- **Nhẹ quota** — không nạp lại N turns cũ mỗi lần hỏi.
- **Chốt scope từ turn 1** — thay vì sửa dần từ một mớ context hỗn độn.

**Nếu làm sai thì sao?** Lỗi hay gặp nhất: mở chat mới giữa việc dở mà chưa lưu gì — coi như mất mạch. Cách tránh: mở lại từ danh sách phiên khi cần, hoặc export (`Chat: Export Chat…`) trước. Và lỗi mới hay gặp: gõ `/new` định mở chat, nhận về một... scaffold dự án.

> **Tóm gọn 1 câu:** Chat mới là phím `Ctrl+N` chứ không phải slash `/new` — giữ cái gì thì lưu trước, và mỗi task xứng đáng một tờ giấy trắng.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bắt đầu task mới khác hẳn task cũ; chat hiện tại đã dài và model bắt đầu lan man; muốn chốt scope + model ngay từ turn 1.
- **ĐỪNG dùng khi:** muốn tiếp việc dở hôm qua — mở lại phiên trong [Session History](../history/README.md); muốn chat mới **kèm archive** chat hiện tại — đó là `/clear`.
- **Cho ai:** mọi người mở task mới hằng ngày — người mới nên xem đây là thói quen #1 mỗi task.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Kiểm tra: `Ctrl+N` phải mở chat trắng ngay lập tức. Nếu gõ `/` thấy `/new` — đó là lệnh scaffold (docs chat reference), không dùng để mở chat.

## Ví dụ thật

Nghiệp vụ: bạn vừa debug xong bug login trong chat cũ, giờ sang task mới là thêm rate-limit. Trước khi đổi task, muốn giữ lại phần debug.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** Chat trắng + checklist 5 bước đúng scope; history cũ (phần debug login) không lẫn vào.

**✅ Verify:** Hỏi tiếp 1 câu follow-up — nếu model không nhắc chuyện chat cũ là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — `/new` để "mở chat", giữa việc dở không lưu gì:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — lưu/export trước, rồi `Ctrl+N` mở chat trắng kèm scope:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** `Ctrl+N` là cắt cầu, không phải dọn nhà. Muốn giữ cái gì thì lưu trước; muốn cắt **và** archive chat cũ thì `/clear` mới là lệnh của bạn.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ `/new` ra scaffold file/workspace | Nhầm nghĩa docs của `/new` với "chat mới" | Chat mới: `Ctrl+N`; `/new` xem [code-actions/new](../../code-actions/new/README.md) |
| Mất mạch debug khi sang task | Mở chat mới khi chưa lưu | Export (palette "Chat: Export Chat…") hoặc mở lại từ list phiên |
| Kết quả chung chung | Prompt đầu tiên không kèm scope | Turn 1 nêu file + mong đợi rõ ràng |

## So sánh với Claude Code

| Việc | Copilot (`Ctrl+N`) | Claude Code | Ghi chú |
|---|---|---|---|
| Bắt đầu mạch hội thoại sạch | `Ctrl+N` (chat) hoặc New Session (phiên) | `/clear` xóa context phiên, hoặc mở `claude` mới | Cùng mục đích: cắt context cũ trước task mới |
| Kèm dọn danh sách phiên | `/clear` = chat mới + archive chat hiện tại | `/clear` (xóa, không "archive") | Copilot cất được, Claude xóa hẳn |
| Lưu phần cũ trước khi cắt | "Chat: Export Chat…" ra file | Không có tương đương trực tiếp (tự copy/ghi file) | Copilot có sẵn lệnh export |

## Best practices (kèm "vì sao")

- **Một task = một chat mới.** *Vì sao?* Chat dài làm loãng trọng tâm và model quên đầu bài; mỗi task sạch đầu bài thì trả lời trúng hơn.
- **Lưu trước khi cắt nếu còn việc dở.** *Vì sao?* Chat mới không có undo — không lưu thì chỉ còn cách đoán lại từ transcript.
- **Gắn scope ngay turn 1.** *Vì sao?* Turn đầu đã có `#file` + mong đợi thì bạn bớt được 1–2 turns chỉnh hướng.
- **Đổi model ngay ở chat mới khi cần.** *Vì sao?* Task khó cần model mạnh, task dễ dùng model rẻ — chat mới là lúc chọn lại "bộ não".

## Bài tập nhỏ

1. **(3 phút)** Mở một chat đã có ≥10 turns, rồi `Ctrl+N` và hỏi lại câu hỏi đầu tiên. So sánh độ tập trung của câu trả lời giữa hai chat.
2. **(5 phút)** Gõ `/new` trong ô chat và đọc kỹ gì xảy ra — xác nhận nó là scaffold chứ không phải chat mới; phân biệt với `Ctrl+N`.
3. **(5 phút)** Mở chat mới **không** kèm mô tả, xem kết quả chung chung thế nào; gọi lại có scope để thấy khác biệt.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Docs: [AI features cheat sheet (chat reference + phím)](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [Manage sessions](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions)
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md). Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Lệnh `/new` thật làm gì: [../../code-actions/new/README.md](../../code-actions/new/README.md). Lưu phần cũ: [export](../../../local/chat-session/export/README.md). Quay lại việc dở: [../resume/README.md](../resume/README.md).

> Chat thông minh không nằm ở model — nằm ở chỗ mỗi lần hỏi, model chỉ phải nhìn thấy đúng việc bạn đang làm. `Ctrl+N` mua sự sạch đó trong một cái bấm.
