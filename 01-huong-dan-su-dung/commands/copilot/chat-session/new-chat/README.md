# Chat mới (`Ctrl+N`) — Tờ giấy trắng cho task mới

> **Dành cho:** dev bắt đầu task mới trong VS Code · **Vấn đề:** chat cũ dài khiến model lẫn context, trả lời lan man · **Đọc xong:** biết mở chat mới đúng cách, không nhầm với `/new` scaffold (~2 phút)
> **Harness:** Copilot · **Surface:** Chat view / Agents window (phím + nút, không phải slash)

## 1. Chat mới là gì?

**Chat mới** là một phiên hội thoại hoàn toàn sạch — không có history, không có context từ chat cũ. Model sẽ chỉ thấy đúng task bạn đang làm, không bị "ám" bởi quyết định hoặc code của task trước.

Đường đúng: **`Ctrl+N`** (macOS `⌘N`) — "Start a new chat", hoặc bấm **New Session** ở đầu danh sách phiên rồi chọn workspace/harness.

⚠️ **Cảnh giác:** Gõ `/` thấy **`/new`** — ĐỪNG tưởng là chat mới! `/new` là lệnh **scaffold** (tạo workspace, file, hoặc notebook mới), hoàn toàn khác với mở chat mới. Xem chi tiết tại [code-actions/new](../../code-actions/new/README.md).

📄 [VS Code Docs: Sessions (concept)](https://code.visualstudio.com/docs/agents/concepts/sessions)

---

## 1.5. Phân biệt rõ: `Ctrl+N` vs `/new` vs `/clear`

Đây là điểm **nhầm lẫn nhất** — 3 lệnh đều có chữ "new/clear" nhưng làm 3 việc HOÀN TOÀN khác nhau:

| Lệnh | Làm gì | Context cũ | File/Workspace |
|---|---|---|---|
| **`Ctrl+N`** | Mở **chat mới** (tờ giấy trắng) | ❌ Xóa sạch | Không tạo file |
| **`/clear`** | Chat mới + **archive** chat cũ | ❌ Xóa sạch | Không tạo file |
| **`/new`** | **Scaffold** (tạo file/workspace mới) | ✅ Giữ nguyên | ✅ Tạo file mới |

**Ví dụ cụ thể:** Giả sử bạn đang debug bug login trong chat cũ.

- **Gõ `Ctrl+N`** → Mở chat trắng, model không biết bạn vừa debug login. File workspace giữ nguyên.
- **Gõ `/clear`** → Mở chat trắng, model không biết bạn vừa debug login. Chat cũ được **archive** (lưu lại, không mất). File workspace giữ nguyên.
- **Gõ `/new`** → **KHÔNG mở chat mới!** Model vẫn thấy history chat cũ. Nó sẽ **tạo một file/workspace mới** (scaffold). Ví dụ: tạo file `src/new-feature.ts` với cấu trúc mặc định.

> **Tóm lại:**
> - **`Ctrl+N`** và **`/clear`** → bắt đầu chat từ đầu (context sạch)
> - **`/new`** → tạo file mới (giữ nguyên chat cũ)

---

## 2. Vì sao phải dùng chat mới?

Chat càng dài, hai vấn đề càng nghiêm trọng:

| Vấn đề | Hậu quả |
|---|---|
| Model bị **loãng trọng tâm** | Trả lời lan man, không tập trung vào task hiện tại |
| Mỗi turn **nạp lại toàn bộ history** | Đốt token vô ích, chậm, tốn quota |

Chat mới giải quyết cả hai:

- ✅ **Đầu bài sạch** — model chỉ thấy task mới, không bị nhiễu bởi context cũ
- ✅ **Nhẹ quota** — không phải nạp lại N turns cũ mỗi lần hỏi
- ✅ **Chốt scope từ turn 1** — thay vì sửa dần từ mớ context hỗn độn

> **Tóm 1 câu:** Chat mới là `Ctrl+N` chứ không phải `/new` — giữ cái gì thì lưu trước, mỗi task xứng đáng một tờ giấy trắng.

---

## 3. Khi nào dùng / khi nào đừng

### ✅ DÙNG khi:

- Bắt đầu **task mới** khác hẳn task cũ (ví dụ: xong debug login → sang thêm rate-limit)
- Chat hiện tại đã **dài** (≥15 turns) và model bắt đầu **lan man**
- Muốn **chốt scope + chọn model** ngay từ turn 1

### ❌ ĐỪNG dùng khi:

- Muốn **tiếp việc dở** hôm qua → mở lại phiên trong [Session History](../history/README.md)
- Muốn chat mới **kèm archive** chat hiện tại → dùng `/clear`

📄 [VS Code Docs: Pick the right tool](https://code.visualstudio.com/docs/agents/best-practices#pick-the-right-tool-for-the-task)

---

## 4. Ví dụ thực tế

**Kịch bản:** Bạn vừa debug xong bug login trong chat cũ, giờ sang task mới là thêm rate-limit. Trước khi đổi task, muốn giữ lại phần debug.

**Cách đúng:**

1. **Export** chat cũ (`Chat: Export Chat…`) để lưu lại phần debug
2. Bấm **`Ctrl+N`** mở chat trắng
3. Gõ prompt đầu tiên kèm **scope rõ ràng**: "Thêm rate-limit cho endpoint `/api/login`, file liên quan: `src/auth/login.ts`"

**Kết quả mong đợi:**
- Chat trắng, không có history cũ
- Model trả lời tập trung vào rate-limit, không nhắc chuyện login
- ✅ **Verify:** Hỏi follow-up — nếu model không nhắc chat cũ là đạt

📄 [VS Code Docs: Prompt examples](https://code.visualstudio.com/docs/agents/guides/prompt-examples)

---

## 6. Lỗi thường gặp & cách fix

📄 [VS Code Docs: Start a new or related conversation](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#start-a-new-or-related-conversation)

| Triệu chứng | Nguyên nhân | Cách fix |
|---|---|---|
| Gõ `/new` ra scaffold file/workspace | Nhầm `/new` (scaffold) với "chat mới" | Dùng `Ctrl+N` để mở chat mới |
| Mất mạch debug khi sang task | Mở chat mới khi chưa lưu gì | Export (`Chat: Export Chat…`) hoặc mở lại từ list phiên |
| Kết quả chung chung | Prompt đầu tiên không kèm scope | Turn 1 nêu `#file` + mong đợi rõ ràng |

---

## 7. So sánh với Claude Code

📄 [VS Code Docs: Agent Harnesses](https://code.visualstudio.com/docs/agents/concepts/agent-harnesses)

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Bắt đầu mạch hội thoại sạch | `Ctrl+N` (chat) hoặc New Session | `/clear` xóa context, hoặc mở `claude` mới | Cùng mục đích: cắt context cũ |
| Kèm archive chat cũ | `/clear` = chat mới + archive | `/clear` (xóa, không archive) | Copilot cất được, Claude xóa hẳn |
| Lưu phần cũ trước khi cắt | "Chat: Export Chat…" ra file | Tự copy/ghi file | Copilot có sẵn lệnh export |

---

## 8. Best practices (kèm "vì sao")

1. **Một task = một chat mới**
   - *Vì sao?* Chat dài làm loãng trọng tâm, model quên đầu bài; mỗi task sạch đầu bài thì trả lời trúng hơn.

2. **Lưu trước khi cắt nếu còn việc dở**
   - *Vì sao?* Chat mới không có undo — không lưu thì chỉ còn cách đoán lại từ transcript.

3. **Gắn scope ngay turn 1**
   - *Vì sao?* Turn đầu đã có `#file` + mong đợi thì bớt được 1–2 turns chỉnh hướng.

4. **Đổi model ngay ở chat mới khi cần**
   - *Vì sao?* Task khó cần model mạnh, task dễ dùng model rẻ — chat mới là lúc chọn lại "bộ não".

📄 [VS Code Docs: New chat, fork, or new session](https://code.visualstudio.com/docs/agents/concepts/sessions#choose-a-new-chat-a-fork-or-a-new-session)

---

## 9. Bài tập thực hành

1. **(3 phút)** Mở chat đã có ≥10 turns, rồi `Ctrl+N` và hỏi lại câu hỏi đầu tiên. So sánh độ tập trung của câu trả lời giữa hai chat.

2. **(5 phút)** Gõ `/new` trong ô chat, đọc kỹ gì xảy ra — xác nhận nó là scaffold chứ không phải chat mới; phân biệt với `Ctrl+N`.

3. **(5 phút)** Mở chat mới **không** kèm mô tả, xem kết quả chung chung thế nào; gọi lại có scope để thấy khác biệt.

📄 [VS Code Docs: Start a session](https://code.visualstudio.com/docs/agents/run/chat-view#start-a-session)

---

## 10. Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Docs: [AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [Manage sessions](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions)
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md)
- Lệnh `/new` thật làm gì: [../../code-actions/new/README.md](../../code-actions/new/README.md)
- Lưu phần cũ: [export](../../../local/chat-session/export/README.md)
- Quay lại việc dở: [../resume/README.md](../resume/README.md)

> **Chat thông minh không nằm ở model — nằm ở chỗ mỗi lần hỏi, model chỉ phải nhìn thấy đúng việc bạn đang làm.** `Ctrl+N` mua sự sạch đó trong một cái bấm.
