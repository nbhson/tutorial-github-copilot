# Attach / #file — Gắn đúng scope vào prompt

> **Dành cho:** mọi người prompt về code, nhất là người mới · **Vấn đề:** không gắn scope thì model đoán mò, sửa sai file · **Đọc xong:** gắn đúng 1–3 file mỗi prompt, trả lời trúng hơn với ít token hơn (~2 phút)
> **Harness:** Copilot · **Surface:** Chat view / Quick Chat / inline chat (mọi ô chat có `#`)

## 1 câu nôm na

Kẹp tài liệu vào câu hỏi — hỏi về file nào thì kẹp file đó vào: gõ `#` để gọi context items (file, folder, symbol, terminal output, source control changes...), bấm **Add Context** (`+`) mở picker, hoặc kéo-thả file/ảnh vào Chat input. Câu hỏi xuyên file ("hàm này ai gọi") cứ hỏi thẳng agent — nó có sẵn công cụ search + đọc file. **`@workspace`, `@terminal`... là chat participants đã deprecated, không chạy trong Copilot harness.**

## Vì sao dùng Attach / #file?

Đây có lẽ là kỹ năng quan trọng nhất với người mới: model không tự "nhìn thấy" repo của bạn. Không gắn scope thì nó đoán mò. Attach giúp:

- **Trả lời trúng** — model đọc đúng file bạn quan tâm.
- **Ít token hơn** — đưa 1–3 file thay vì cả repo.
- **Ít sửa sai hơn** — scope càng hẹp, diff càng đúng chỗ.

**Nếu làm sai thì sao?** Hai cực đều hại: (1) quên attach nên model đoán mò; (2) attach cả repo nên chậm và tốn token. Thêm rủi ro âm thầm: attach file chứa token mà không soát.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** mọi prompt về code; muốn model đọc đúng file thay vì đoán; cần đính kèm ảnh lỗi UI, log, file ngoài workspace (Add Context → Files → Attach).
- **ĐỪNG dùng khi:** câu hỏi hoàn toàn ngoài code (định nghĩa chung, cú pháp ngôn ngữ) — attach chỉ thêm nhiễu.

| Cách | Hỏi được gì | Khi nào dùng |
|---|---|---|
| `#file`, `#folder` | Đúng 1 file/1 vùng cụ thể | Sửa/hỏi trong phạm vi hẹp, cần chính xác cao |
| `#symbol`, `#terminal`, SCM changes | Một ký hiệu, output terminal, diff đang treo | Gọi thẳng "nguyên liệu" thay vì mô tả bằng chữ |
| Kéo-thả / Add Context → Files | File/ảnh ngoài editor (log, ảnh UI) | Cần đưa bằng chứng log/screenshot cho model |
| Hỏi thẳng agent (không attach) | Quan hệ xuyên file: "hàm này ai gọi" | Agent tự dùng công cụ search + đọc file trong repo |

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Kiểm tra: gõ `#` trong ô Chat xem có danh sách context items không; hoặc bấm **Add Context** (`+`). Thiếu → kiểm tra extension Copilot Chat đã bật.

## Ví dụ thật

Nghiệp vụ: bạn cần biết field `customerId` được đọc/ghi ở đâu trong repo trước khi đổi kiểu dữ liệu của nó, và muốn model xác nhận đã đọc đúng file trung tâm.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** Model liệt kê đúng file đã đọc + trả lời trúng scope; không sửa sai file.

**✅ Verify:** Bắt model "liệt kê file mày đã đọc" — khớp file bạn gắn là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — quên attach, attach cả folder cho câu hỏi 1 file, hoặc tật cũ gọi `@workspace`:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — gắn đúng 1–3 context item liên quan nhất, chỉ rõ muốn model đọc gì:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** Scope vừa đủ là 1–3 mục liên quan nhất. Rộng quá tốn token, hẹp quá model thiếu dữ liệu; `@`-participants đã về hưu — dùng `#` và hỏi thẳng agent.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Attach cả repo → chậm + tốn token | Scope quá rộng | Chỉ gắn 1–3 file/symbol liên quan nhất |
| Quên attach → model đoán mò | Tưởng model tự đọc cả repo | Luôn gắn `#file`/`#symbol` hoặc nêu scope rõ khi hỏi agent |
| Gõ `@workspace` không ai trả lời | Participant đã deprecated trong Copilot harness | Hỏi thẳng agent + `#`-mentions; vì sao: [participants](../../../local/model-agent/participants/README.md) |
| Attach file chứa secret | Soát không kỹ | Kiểm tra file trước khi attach/share/export |

## So sánh với Claude Code

| Việc | Copilot (`Attach / #file`) | Claude Code | Ghi chú |
|---|---|---|---|
| Đưa file vào context | `#file`, `#symbol`, kéo-thả, Add Context | `@file` hoặc để agent tự đọc | Cùng tư tưởng: đưa đúng file, đừng cả repo |
| Hỏi quan hệ xuyên file | Hỏi thẳng agent — nó có tool search/đọc file | Agent tự search trong repo | Copilot không cần `@participant` |

## Best practices (kèm "vì sao")

- **Mỗi prompt code đều phải có scope.** *Vì sao?* Model không tự thấy repo; thiếu scope là nguyên nhân số 1 của "sửa sai file".
- **Giữ 1–3 mục, không attach cả repo.** *Vì sao?* Context rộng làm chậm và loãng trọng tâm.
- **Soát secret trước khi attach.** *Vì sao?* File attach có thể đi vào export/share; kiểm trước rẻ hơn gỡ sau.

## Bài tập nhỏ

1. **(3 phút)** Hỏi cùng một câu về `src/auth/login.ts` hai lần: một lần không attach, một lần `#file` — so sánh độ trúng.
2. **(5 phút)** Hỏi agent "hàm X được gọi ở đâu" không attach, rồi hỏi lại khi đã gắn `#file` hai chỗ nghi ngờ; so số bước model phải tự dò.
3. **(5 phút)** Kéo-thả một screenshot UI vào Chat và hỏi "component nào render khối này"; kiểm model đọc đúng ảnh.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Docs: [Add context to chat](https://code.visualstudio.com/docs/chat/copilot-chat-context) · [Replace chat participants](https://code.visualstudio.com/docs/agent-customization/migrate-customizations)
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md). Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Sửa tại chỗ sau khi gắn scope: [../inline-chat/README.md](../inline-chat/README.md). Lưu chat có kèm file nhạy cảm: [export](../../../local/chat-session/export/README.md).

> Gắn scope không phải thao tác phụ — nó là phần lớn của một prompt tốt. Hỏi về file nào, kẹp file đó bằng `#`; đừng để model đoán, cũng đừng gọi participant đã về hưu.
