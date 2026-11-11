# /compact — Nén hội thoại dài thành bản tóm tắt

> **Dành cho:** bạn vừa chạy agent 30–40 lượt, chat bắt đầu "quên" đầu chuyện · **Vấn đề:** ngữ cảnh tràn, model đoán mò, mỗi câu trả lời càng lúc càng lệch · **Đọc xong:** biết nén hội thoại đúng cách để đi tiếp mà không mất mạch (~2 phút)
> **Harness:** Copilot · **Surface:** Chat view — `/compact` có trong **Local, Copilot, Claude** (docs cheat-sheet); Copilot CLI cũng có `/compact`

## 1 câu nôm na

`/compact` là nút "gấp hành lý": toàn bộ hội thoại dài được nén thành một bản tóm tắt đưa vào ngữ cảnh, để session tiếp tục nhẹ mà không bật sang chat trắng. Nó **thay thế** `/summarize` — tên cũ này không còn trong docs, đừng dạy lại.
## Vì sao dùng /compact?

Mỗi model chỉ có cửa sổ ngữ cảnh giới hạn. Khi hội thoại vượt ngưỡng, lượt cũ bị trượt ra ngoài — triệu chứng: model quên quyết định đã chốt, sửa lại file đã sửa, bịa tên file. Gõ `/compact` ép nó chốt lại những gì quan trọng **ngay lúc bạn chọn**, thay vì để nó âm thầm quên.

| Cách nén | Xảy ra | Khi nào |
|---|---|---|
| `/compact` | Tóm tắt hội thoại agent, giữ session chạy tiếp | Giữa task dài |
| `/compact <chỉ dẫn>` | Tóm tắt **theo ý bạn**: "focus on the open TODOs", "giữ lại quyết định về schema" | Khi có phần không muốn mất |
| Tự động | Session tự compact khi cửa sổ ngữ cảnh gần đầy | Mặc định; chỉnh qua setting |
| Nút trong UI | Kèm thanh context window có mục **Compact Conversation** | Khi thấy % ngữ cảnh tăng cao |

**Nếu làm sai thì sao?** Compact **không** trả lại token đã ngốn trong session, và bản tóm tắt có thể sót chi tiết bạn đang cần — đọc lại nó trước khi chạy tiếp. Muốn trang trắng hoàn toàn thì đó là [chat mới](../new-chat/README.md) (`Ctrl+N`), không phải compact.

> **Tóm gọn 1 câu:** `/compact` gấp hành lý hộ bạn giữa đường — nhưng nhớ mở va li ra kiểm tra trước khi lên xe tiếp.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** session đã 20+ lượt, sắp đổi fase (hỏi→làm) mà chưa muốn mất lịch sử; chuẩn bị commit "toàn bộ context mất".
- **ĐỪNG dùng khi:** bạn cần chat trắng để đổi hẳn việc — dùng `Ctrl+N` ([New chat](../new-chat/README.md)); cần giữ nguyên văn từng dòng — export ra file trước.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> ```prompt
> /compact tập trung vào: các file đã sửa, quyết định kiến trúc, việc còn dở
> ```

## Ví dụ thật (lấy đúng nghiệp vụ của lệnh này)

Bạn debug luồng login suốt 35 lượt: đổi middleware, thêm test, chốt hướng "JWT + blacklist trong Redis". Session bắt đầu lặp lại lỗi cũ.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** một bản tóm tắt hiện ra — file đã sửa, quyết định đã chốt, việc còn dở; session mới nối mạch được ngay. **✅ Verify:** hỏi "ta đã chốt phương án nào về token?" — model trả lời đúng hướng cũ.

**Setting liên quan:** tự động nén khi cửa sổ ngữ cảnh gần đầy điều khiển bằng `github.copilot.chat.summarizeAgentConversationHistory.enabled` (bật = auto-compact; tắt = bạn tự bấm `/compact`).

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — gõ `/summarize` như các tutorial cũ dạy:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — compact kèm chỉ dẫn giữ đúng phần sống còn:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** docs chỉ liệt kê `/compact` trong cheat-sheet; `/summarize` không còn trong tài liệu — thấy ở đâu là đồ cũ hoặc bịa.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ `/` không thấy `/compact` | Surface/harness không có lệnh này ở phiên hiện tại | Docs: "availability depends on surface, harness, role, features"; thử chat Local hoặc Copilot harness |
| Tóm tắt mất quyết định quan trọng | Compact "quét" toàn session, ưu tiên gì model tự đoán | `/compact` kèm chỉ dẫn (vd "giữ lại: ..."); hoặc export trước — [Clear & Export](../clear/README.md) |
| Muốn quay lại nội dung trước compact | Bản tóm tắt đã thay transcript trong ngữ cảnh | Cuộn đọc lại transcript cũ trong phiên; nếu muốn nguyên văn: export từ trước |

## So sánh với Claude Code

| Việc | Copilot (`/compact`) | Claude Code | Ghi chú |
|---|---|---|---|
| Nén giữa session | `/compact [chỉ dẫn]` trong Chat view | `/compact` trong CLI | Ý tưởng tương đương |
| Nén khi sắp tràn | Tự động theo setting | Tự khi gần giới hạn | Copilot chỉnh được |
| Đổi việc hẳn | `Ctrl+N` chat mới | `/clear` | Đừng nhầm: compact ≠ xóa |

## Best practices (kèm "vì sao")

- **Compact kèm chỉ dẫn thay vì trần trụi.** *Vì sao?* Không có chỉ dẫn, model tự chọn thứ để giữ; chỉ dẫn nói rõ phần nào sống còn.
- **Compact ngay khi nhận thấy model lặp quyết định cũ.** *Vì sao?* Dấu hiệu cửa sổ ngữ cảnh đã tràn — để lâu, lệch chồng lệch.
- **Trước khi compact việc hệ trọng, export phiên đã.** *Vì sao?* Transcript gốc vẫn còn trong session, nhưng bản nén có thể làm bạn chủ quan không giữ gì.
- **CLI dài thì `/compact` trong Copilot CLI — hoặc `copilot --continue` để mở lại session.** *Vì sao?* Hai lệnh này của Copilot CLI, đừng lẫn với Chat view.

## Bài tập nhỏ

1. **(5 phút)** Mở session 20+ lượt (task cũ cũng được), gõ `/compact` rồi đọc bản tóm tắt: sót gì, sai gì — sửa tay một câu.
2. **(3 phút)** Chạy `/compact tập trung vào các file đã sửa và việc còn dở` — so chất lượng tóm tắt với câu trần.
3. **(5 phút)** Bật rồi tắt `github.copilot.chat.summarizeAgentConversationHistory.enabled`, quan sát session dài có tự nén hay không.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Docs: [Cheat sheet of agents, tools, and slash commands](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [Session management (context window, compact)](https://code.visualstudio.com/docs/agents/concepts/sessions)
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md). Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Mở chat trắng khi cần: [../new-chat/README.md](../new-chat/README.md). Lưu transcript: [../clear/README.md](../clear/README.md).

> `/compact` không làm model thông minh hơn — nó chỉ đảm bảo thứ nó nhớ là thứ **bạn** chọn để nhớ.
