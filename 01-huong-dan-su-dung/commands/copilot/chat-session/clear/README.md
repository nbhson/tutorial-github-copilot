# /clear — Mở chat mới + archive chat hiện tại

> **Dành cho:** dev đang chat dồn 1 phiên dài · **Vấn đề:** model bắt đầu quên đầu bài nhưng bạn vẫn cần giữ instructions/MCP · **Đọc xong:** dùng `/clear` đúng nghĩa — sang chat mới sạch, chat cũ được archive chứ không mất, và cấu hình vẫn nguyên (~2 phút)
> **Harness:** Copilot · **Surface:** Chat view (chat reference)

## 1 câu nôm na

Gấp cuốn sổ cũ lại cắm vào ngăn kéo, mở cuốn mới — phấn, bảng và nội quy lớp vẫn nguyên. Docs định nghĩa `/clear` là: **mở chat mới VÀ archive (hoặc mark done) chat hiện tại**. Chat cũ không biến mất — nó nằm trong filter **Archived** của danh sách phiên và mở lại được.

Còn cái bạn "mang theo" là cấu hình: instructions trong repo nạp lại từ file, MCP giữ kết nối. Gắn scope gọn thì 1–2 turns là vào việc.

## Vì sao dùng /clear?

Khi một phiên chat phình to, model bắt đầu quên đầu bài — nhưng reset kiểu gì cũng phải trả giá. `/clear` gọn hơn mở Chat view mới tay vì:

- **Sang trang mới** — turns cũ không còn nhiễu context của chat mới.
- **Chat cũ vẫn còn** — được archive/mark done, tìm lại qua bộ lọc, không phải xóa trắng.
- **Giữ cấu hình** — instructions nạp lại từ file, MCP vẫn connected.

**Nếu làm sai thì sao?** Hai ngộ nhận hay gặp: (1) tưởng `/clear` xóa history mãi mãi — không, nó archive; muốn mất hẳn là Delete; (2) clear xong vẫn lan man vì scope chat mới còn rộng. Xem ❌/✅.

> **Tóm gọn 1 câu:** `/clear` = "chat mới + gấp chat cũ lại" — mạch hội thoại được cất vào ngăn Archived, còn instructions và MCP nằm trên file nên vẫn nguyên.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** chat dài quá và model bắt đầu quên đầu bài; chuyển sang đầu việc khác trong cùng repo mà muốn gọn danh sách; giữ instructions/MCP đã setup.
- **ĐỪNG dùng khi:** bạn muốn chat cũ vẫn active để hỏi tiếp ngay — khi đó chỉ mở chat mới (`Ctrl+N`), hoặc nếu chat dài mà chưa quên đầu bài thì `/compact` (nén ngữ cảnh, giữ nguyên phiên).
- **Cho ai:** ai cũng dùng được — nhất là người mở một chat rồi hỏi dồn cả ngày.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Kiểm tra: gõ `/` trong ô Chat, tìm `/clear` (mục chat reference). Availability phụ thuộc surface/harness/role — không thấy thì xem trạng thái Copilot + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: bạn đang giữa phiên sửa `payment.ts` với MCP `github` đang kết nối, đã 30 turns và model bắt đầu nhắc lại chuyện cũ. Bạn muốn sang trang mới nhưng **giữ** MCP và instructions.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** Chat mới mở ra sạch; chat cũ chuyển sang Archived; instructions + MCP vẫn còn ở chat mới.

**✅ Verify:** Hỏi "liệt kê quy tắc đang áp dụng" ở chat mới — trả lời đúng là đạt; chat cũ vẫn mở lại được từ filter Archived.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — tưởng `/clear` xóa sạch chat cũ nên... không dám dùng, hoặc ngược lại tưởng nó xóa sạch để "dọn danh sách":**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — biết `/clear` = chat mới + archive; cần giữ bằng chứng vẫn export trước:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** `/clear` không phải thùng rác — nó là trang mới + tủ lưu. Cái mất duy nhất là mạch hội thoại đang hiện; cấu hình nằm ở file nên không sao.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tưởng mất chat cũ sau `/clear` | Không biết nó được archive | Bật filter **Archived** trong danh sách phiên, mở lại bình thường |
| Chat mới vẫn trả lời lan man | Scope chưa gọn (attach cả repo từ câu đầu) | Mở đầu bằng 1–3 `#file` liên quan |
| Lo mất instructions/MCP | Nhầm "clear turns" với "reset cấu hình" | Yên tâm: chúng nạp lại từ file, không nằm trong turns |

## So sánh với Claude Code

| Việc | Copilot (`/clear`) | Claude Code | Ghi chú |
|---|---|---|---|
| Sang phiên sạch | `/clear` mở chat mới + archive chat hiện tại | `/clear` xóa conversation history của phiên | Claude "xóa", Copilot "cất" — khác nhau chỗ này |
| Giữ cấu hình repo | Instructions + MCP nạp lại từ file | `CLAUDE.md` + `.claude/` vẫn còn | Cả hai đều không mất config |
| Nén thay vì cắt | Dùng `/compact` nếu muốn giữ phiên | `/compact` tương tự | Chat dài nhưng chưa đổi việc → compact |

## Best practices (kèm "vì sao")

- **Còn việc dở thì export trước khi `/clear`.** *Vì sao?* Chat archived vẫn mở được, nhưng bản export là văn bản bền để bàn giao/so sánh.
- **Clear khi bắt đầu chủ đề mới trong cùng repo.** *Vì sao?* Giữ nguyên instructions/MCP đã setup, chỉ bỏ hội thoại không còn liên quan.
- **Sau clear, gắn scope lại từ đầu.** *Vì sao?* Chat mới mà vẫn attach dàn trải thì context nhanh phình lại như cũ.
- **Đừng clear liên tục cho chat ngắn.** *Vì sao?* Chat chưa có vấn đề context; clear chỉ thêm một lần gấp-sổ mở-sổ vô ích.

## Bài tập nhỏ

1. **(3 phút)** Trong một chat có MCP đang connected, gõ `/clear`; hỏi "liệt kê quy tắc đang áp dụng" ở chat mới — xác nhận instructions vẫn còn.
2. **(5 phút)** So sánh `/clear` và `Ctrl+N`: ghi lại cái nào archive chat cũ, cái nào giữ chat cũ active.
3. **(5 phút)** Tìm lại chính chat vừa archive qua filter **Archived** — xác nhận "clear" không phải "delete".

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Docs: [AI features cheat sheet — chat reference](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [Manage sessions](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions)
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md). Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Lưu phần cũ: [export](../../../local/chat-session/export/README.md). Nén ngữ cảnh thay vì cắt: [../compact/README.md](../compact/README.md).

> `/clear` là mức "sang trang có lưu sổ cũ": đủ để lấy lại sự tập trung của model mà không đốt mất những gì bạn đã nói — instructions và MCP thì chưa bao giờ nằm trong sổ.
