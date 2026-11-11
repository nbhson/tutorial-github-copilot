# /doc — Sinh docstring/JSDoc trong 1 nốt

> **Dành cho:** dev vừa viết xong hàm public · **Vấn đề:** docs thiếu params/example nên người khác không dám dùng · **Đọc xong:** ra docstring/JSDoc đủ @param/@returns/example chạy được (~2 phút)
> **Harness:** Copilot · **Surface:** Editor inline chat (`Ctrl+I`) — docs ghi `/doc` "từ editor inline chat"; ngoài ra có code action **Generate Code → Generate Docs** khi chuột phải vào code

## 1 câu nôm na

Nhờ viết "nhãn mác cho lọ thuốc" — tên, công dụng, cách dùng, ví dụ. Bạn bôi đen hàm, mở inline chat bằng `Ctrl+I` (macOS `⌘I`) rồi gõ `/doc` — nó viết docstring theo chuẩn repo ngay tại chỗ; việc bạn phải nhớ là **chạy lại mỗi khi đổi signature**, không thì docs sẽ dần nói sai params. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Vì sao dùng /doc?

Docs viết tay hay bị bỏ qua, mà khi có thì thường thiếu đúng phần người khác cần nhất: ví dụ chạy được. `/doc` không chỉ điền `@param`/`@returns` mà còn sinh một example copy-paste chạy thử được — chính phần đó biến docs từ "trang trí" thành "hướng dẫn". Hàm public càng nhiều người dùng, docs rõ càng đỡ tốn thời gian trả lời hỏi han.

**Nếu làm sai thì sao?** Mặt trái nguy hiểm là **docs cũ nhưng nghe rất chắc**: bạn đổi tham số, docs vẫn mô tả tham số cũ, người sau làm theo rồi dính bug. Một example trong docs mà chạy không được còn tệ hơn không có example, vì nó tạo niềm tin sai. Vì vậy sau mỗi lần đổi signature phải regen `/doc` (xem mục ❌/✅).

> **Tóm gọn 1 câu:** `/doc` viết hộ nhãn mác cho lọ thuốc — nhưng công thức đổi thì nhớ in lại nhãn, kẻo người sau uống theo liều cũ. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bạn vừa viết hàm public cần docs chuẩn, cần chuẩn hóa docs cũ thiếu params/example, hoặc muốn onboard dễ (đọc docs là hiểu module).
- **ĐỪNG dùng khi:** hàm private/đơn giản mà tên đã nói hết (`getUserId()` thì khỏi), hoặc bạn cần *hiểu* code chứ không phải *viết docs* (đó là `/explain`).
- **Cho ai:** người giữ API/hàm public, team đang chuẩn hóa docs cho module cũ.

> **Tóm gọn 1 câu:** Cửa ra vào có người qua lại thì đáng gắn bảng chỉ dẫn — hàm tên đã tự kể hết công việc thì khỏi mất công dán biển. · 📄 [VS Code Docs: Choose a feature](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet#choose-a-feature)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Gõ `/` trong Chat view không thấy `/doc`? Docs ghi nhận `/doc` cho **editor inline chat** — bôi đen code, `Ctrl+I`, rồi gõ `/doc`. Muốn dùng Code Action: chuột phải → Generate Code → Generate Docs. · 📄 [VS Code Docs: Generate documentation](https://code.visualstudio.com/docs/editing/copilot-smart-actions#generate-documentation)

## Ví dụ thật

Nghiệp vụ: `parseInvoiceNumber()` trong `src/billing/` vừa được refactor, người khác muốn dùng lại nhưng docs cũ đã lệch.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Code generation & editing](https://code.visualstudio.com/docs/agents/guides/prompt-examples#code-generation-and-editing)

**Kết quả mong đợi:** docstring đúng chuẩn repo (params/returns/example), và example trong docs copy ra chạy được.

**✅ Verify:** copy nguyên example trong docs vào một snippet chạy thử — chạy được và ra kết quả đúng là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — sinh docs một lần rồi quên; đổi signature mà không regen:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — nêu chuẩn rõ + regen sau mỗi lần đổi signature:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

**Bài học:** docs sai params nguy hiểm hơn không có docs — regen `/doc` ngay sau khi hàm thay đổi.

## Lỗi thường gặp

📄 [VS Code Docs: Record what you verified](https://code.visualstudio.com/docs/agents/guides/explore-a-codebase#5-record-what-you-verified)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Docs chung chung, thiếu example | Prompt thiếu yêu cầu example | Thêm "gồm 1 example chạy được" |
| Docs sai params | Hàm đổi mà docs cũ | Regen `/doc` sau mỗi lần đổi signature |
| Docs dài hơn code | Cố docs mọi thứ | Chỉ docs cho hàm public/phức tạp |
## So sánh với Claude Code

Bạn cũng dùng Claude Code thì bảng này cho biết `/doc` ánh xạ sang công cụ kia ở đâu — đọc để khỏi đi tìm một lệnh không tồn tại. · 📄 [GitHub Docs: Third-party coding agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-third-party-coding-agents)

| Việc | Copilot (`/doc`) | Claude Code | Ghi chú |
|---|---|---|---|
| Sinh docstring/JSDoc | Slash command có sẵn `/doc` | Không có lệnh riêng — yêu cầu bằng prompt hoặc tự tạo command | Cùng kết quả, Copilot có sẵn nút |
| Bám chuẩn docs của repo | Khớp hơn khi bạn nêu file/module mẫu | Agent tự tìm file mẫu trong repo | Cả hai đều cần bạn chỉ chuẩn nếu repo có style đặc thù |
| Kiểm chứng | Bạn chạy thử example trong docs | Bạn vẫn phải chạy thử | Example chạy được mới là docs đáng tin |

## Best practices (kèm "vì sao")

Bốn mẹo dưới đây là tập quán của người giữ API — mỗi mẹo đều có lý do để bạn biết khi nào ngoại lệ được chấp nhận.

- **Yêu cầu 1 example chạy được, không chỉ mô tả suông.** *Vì sao?* Example là thứ người dùng thật copy ra chạy — nó buộc docs phải khớp code.
- **Regen `/doc` ngay sau khi đổi signature.** *Vì sao?* Docs cũ nói sai params sẽ dẫn người sau vào bug, mà họ lại tin vì "đã có docs".
- **Ghi rõ `@throws` / lỗi có thể xảy ra.** *Vì sao?* Người gọi cần biết khi nào hàm ném lỗi để xử lý, thay vì tự đoán từ code.
- **Chỉ docs hàm public/phức tạp.** *Vì sao?* Docs dài hơn code làm loãng; hàm tự-giải-thích bằng tên thì không cần. · 📄 [VS Code Docs: Crafting effective prompts](https://code.visualstudio.com/docs/agents/guides/prompt-examples#tips-for-crafting-effective-prompts)

## Bài tập nhỏ

1. **(5 phút)** Chạy `/doc` không yêu cầu example, rồi chạy lại có yêu cầu. So xem lần nào docs dùng được ngay.
2. **(10 phút)** Chọn 1 hàm public: `/doc` rồi copy example trong docs ra chạy thật. Example sai thì sửa lại docs.
3. **(10 phút)** Đổi tên 1 tham số của hàm rồi *không* regen docs — chạy thử example cũ để thấy nó lệch thế nào. · 📄 [VS Code Docs: Generate documentation](https://code.visualstudio.com/docs/editing/copilot-smart-actions#generate-documentation)

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Docs: [AI features cheat sheet (chat reference)](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [Inline chat](https://code.visualstudio.com/docs/agents/run/chat-view)
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Cần hiểu code trước khi viết docs: `/explain` — [../explain/README.md](../explain/README.md).

> Chốt: docs của `/doc` chỉ đáng tin khi **example trong đó chạy được** — hãy biến việc copy example ra chạy thành phản xạ sau mỗi lần regen.
