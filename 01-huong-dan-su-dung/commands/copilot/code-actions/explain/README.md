# /explain — Hiểu code đang chọn trong 30 giây

> **Dành cho:** dev đọc code người khác / code legacy · **Vấn đề:** đoạn code lạ mất hàng giờ mới hiểu · **Đọc xong:** hiểu từng bước + edge case trong ~30 giây, đủ để review/sửa tiếp (~2 phút)
> **Harness:** Copilot · **Surface:** Chat view — `/explain` thuộc nhóm "editor" trong chat reference; gõ `/` để thấy những gì khả dụng cho phiên hiện tại (docs: availability phụ thuộc surface, harness, role, tính năng bật)

## 1 câu nôm na

Chỉ vào đoạn code lạ rồi hỏi "đoạn này làm gì vậy?". Bạn **bôi đen 10–40 dòng trọng tâm** rồi gọi `/explain` — nó giảng từng bước ngay trong khung Chat; còn bôi cả file thì câu trả lời chung chung, đọc xong chẳng đọng lại gì.

## Vì sao dùng /explain?

Tự đọc thì bạn phải nhảy qua lại giữa hàm, caller, type... 15 phút sau vẫn chưa chắc mình hiểu đúng. `/explain` trả lời ngay ba thứ bạn cần: **từng bước làm gì → input/output → edge case**, và bạn còn đòi được đúng kiểu mình muốn ("giải thích như cho intern mới"). Vì nó chỉ *đọc*, không sửa file, nên đây là cách rẻ nhất để làm quen một đoạn code trước khi quyết định có nên đụng vào hay không.

**Nếu làm sai thì sao?** Cạm bẫy lớn nhất không phải câu trả lời dở mà là **tin mù**. Model đọc code chứ không chạy code — gặp đoạn "mẹo" (đệ quy, side-effect ẩn, macro) nó có thể kể một câu chuyện nghe rất hợp lý mà sai. Vì vậy đọc xong phải tự diễn giải lại + chỉ ra được một edge case (xem mục ❌/✅).

> **Tóm gọn 1 câu:** `/explain` là bạn đồng học giỏi kể lại bài cho bạn nghe — nhưng bạn phải tự làm lại một bài tập để chắc là nó kể đúng.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bạn vừa mở một đoạn code người khác viết và cần hiểu trước khi review/sửa — code legacy, PR có đoạn khó, hoặc module mới trong lúc onboard.
- **ĐỪNG dùng khi:** bạn cần nó *sửa* luôn (`/fix`, `/refactor`) hoặc cần hỏi xuyên cả repo kiểu "hàm này được gọi ở đâu" — gắn symbol/`#` context rồi hỏi trong session lớn, đừng bám `@workspace` (participant đã deprecated).
- **Cho ai:** người mới vào codebase, reviewer PR, ai phải đọc code legacy.

> **Tóm gọn 1 câu:** Đoạn code lạ trước khi đụng tay thì `/explain` cho bản đồ, còn bước "đi thử đường" (kể lại + bắt edge case) vẫn phải là của bạn.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Gõ `/` trong Chat mà không thấy `/explain`? Docs ghi availability phụ thuộc surface/harness/role — kiểm tra bạn đang ở Chat view hay Agents window, phiên Ask hay Agent, rồi kết luận.

## Ví dụ thật

Nghiệp vụ: một đồng nghiệp đã nghỉ để lại `src/middleware/verifySignedRequest.ts` — bạn không rõ nó chặn request theo tiêu chí nào.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** từng bước đúng logic, chỉ rõ input/output, và liệt kê edge case (ví dụ header thiếu thì nhánh nào chạy).

**✅ Verify:** tự giải thích lại bằng lời mình + chỉ ra 1 edge case là đạt; nếu không kể lại nổi thì bạn chưa thật hiểu.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — bôi cả file rồi hỏi chung chung:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — khoanh 10–40 dòng trọng tâm + nêu tên file:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** `/explain` càng khoanh gọn thì trả lời càng sâu; bôi cả file chỉ nhận lại mô tả bề mặt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Giải thích chung chung | Bôi quá ít hoặc quá nhiều (cả file) | Bôi 10–40 dòng trọng tâm + nêu tên file |
| Giải thích sai logic tricky | Code quá "mẹo" hoặc thiếu context | Gắn thêm `#file` của caller + hỏi "check lại dòng X" |
| Hiểu mà không verify | Tin luôn lời giải thích | Đặt breakpoint/log, chạy thử 1 case để đối chiếu |

## So sánh với Claude Code

Nếu song song cả hai công cụ, bảng này chỉ chỗ `/explain` tương ứng với gì bên Claude Code — tránh việc cứ tìm nút bấm mà không có.

| Việc | Copilot (`/explain`) | Claude Code | Ghi chú |
|---|---|---|---|
| Giải thích đoạn đang chọn | Slash command có sẵn `/explain` | Không có lệnh riêng — bôi đen rồi hỏi, hoặc tự tạo command trong `.claude/commands/` | Copilot bấm-là-chạy; Claude Code phải tự dựng workflow |
| Lấy scope từ selection | Tự gắn selection khi bôi đen | Cũng đọc selection/`@file` khi bạn trỏ tới | Cùng tư tưởng: đưa đúng đoạn, đừng đưa cả file |
| Kiểm chứng | Bạn tự kể lại / chạy thử | Cùng vậy — lời giải thích vẫn cần bạn đối chiếu | Không agent nào chạy code hộ để chứng minh nó hiểu đúng |

## Best practices (kèm "vì sao")

Bốn thói quen dưới đây biến `/explain` từ "đọc cho vui" thành công cụ hiểu code thật sự — mỗi thói quen kèm lý do.

- **Luôn bôi đen 10–40 dòng trọng tâm.** *Vì sao?* Cả file làm loãng ngữ cảnh; một khối gọn cho câu trả lời sâu và đúng hơn.
- **Nói rõ "giải thích như cho intern mới" (hoặc "như senior").** *Vì sao?* Cùng đoạn code, độ sâu bạn cần khác nhau — nói ra thì khỏi hỏi lại 2–3 lần.
- **Gắn `#file` của caller khi logic phụ thuộc chỗ gọi.** *Vì sao?* Nhiều hàm chỉ hiểu đúng khi biết ai truyền gì vào; thiếu caller là đoán.
- **Tự kể lại + chỉ ra 1 edge case sau khi đọc.** *Vì sao?* Đây là cách duy nhất biến "đọc xong thấy hiểu" thành "hiểu thật".

## Bài tập nhỏ

1. **(5 phút)** Bôi cả một file rồi `/explain`, sau đó bôi đúng 20 dòng trọng tâm và hỏi lại. Ghi lại câu trả lời nào dùng được.
2. **(10 phút)** Chọn 1 hàm legacy trong repo: `/explain` rồi tự kể lại từng bước trong 4 câu. Chỗ nào kể không nổi chính là chỗ bạn còn chưa hiểu.
3. **(10 phút)** Tìm 1 edge case mà `/explain` không nhắc tới, viết 1 test case chứng minh nó bằng cách chạy thật.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Docs: [AI features cheat sheet (chat reference)](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [Chat in VS Code](https://code.visualstudio.com/docs/agents/run/chat-view)
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Hỏi xuyên cả repo (ai gọi hàm này, nằm ở đâu): xem [04 — Chat commands toàn tập](../../../../04-chat-commands-toan-tap.md) — cách hỏi phạm vi repo trong Chat view.

> Chốt: `/explain` rẻ và nhanh, nhưng chỉ đáng tin khi bạn khoanh gọn và **tự kể lại được** — hiểu thật là hiểu tới mức giải thích lại được cho người khác.
