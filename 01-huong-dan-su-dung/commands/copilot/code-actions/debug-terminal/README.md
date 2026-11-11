# Debug terminal — biến log đỏ thành lệnh fix có kiểm soát

> **Dành cho:** dev kẹt với lỗi đỏ trong terminal/build/test · **Vấn đề:** log dài, chưa biết nguyên nhân top-1 nằm ở đâu · **Đọc xong:** hỏi thẳng trên khối log, nhận chẩn đoán + lệnh chạy thử có kiểm soát (~2 phút)
> **Harness:** Copilot · **Surface:** Terminal — inline chat trong panel terminal (`Ctrl+I`)

## Nôm na là

Chụp ảnh màn hình lỗi đưa cho thợ — "xe kêu thế này, sửa giúp". Bạn bôi đen khối log lỗi trong terminal, bấm `Ctrl+I` để mở **inline chat ngay trong terminal**, nhận giải thích + lệnh gợi ý, rồi bấm **Run** (hay chèn xuống terminal để tự sửa trước) — thay vì copy log sang cửa sổ chat khác mô tả lại từ đầu. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Vì sao dùng debug terminal?

Log lỗi thường dài và nhiễu — dòng quan trọng nằm lẫn giữa hàng trăm dòng warning. Inline chat trong terminal đọc output **ngay tại chỗ**, chỉ ra **nguyên nhân top-1** rồi gợi ý lệnh khắc phục **xếp theo mức rủi ro**, để bạn chọn cách ít nguy hiểm nhất. Nó đặc biệt hữu ích khi bạn còn chưa biết lỗi nằm ở đâu — giúp *khoanh vùng* trước khi tự tay sửa.

**Nếu làm sai thì sao?** Nguy hiểm nhất là **tin vào lệnh mạo hiểm**: model gợi ý `rm -rf`, `git reset --hard`, `--force` — bấm Run theo là mất code. Và nếu đưa cả 500 dòng thì "chẩn đoán" chỉ là đoán mò. Vì vậy: đưa gọn log, cấm lệnh phá hủy, và đọc trước khi chạy (xem mục ❌/✅).

> **Tóm gọn 1 câu:** debug terminal biến log đỏ thành danh sách việc có thứ tự — đưa đúng 30–50 dòng quanh lỗi thì chẩn đoán mới sắc, và đừng bao giờ Run lệnh phá hủy. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** terminal báo lỗi đỏ chưa hiểu, test fail với stack trace dài, hoặc lệnh build/deploy fail.
- **ĐỪNG dùng khi:** bạn cần nó tự đi sửa nhiều file và chạy vòng lặp — đó là việc của **Agent mode**; inline chat trong terminal *chẩn đoán và gợi ý lệnh*, không thi công.
- **Lưu ý:** ❌ **`@terminal`** là *participant cũ, không còn tồn tại* — tài liệu nào còn dạy `@terminal` là đã lỗi thời; đường hiện tại là inline chat `Ctrl+I` trong terminal. · 📄 [VS Code Docs: Choose a feature](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet#choose-a-feature)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Không thấy inline chat trong terminal? Mở Command Palette (`Ctrl+Shift+P`) gõ "Terminal: Start Terminal Chat" (lệnh `workbench.action.terminal.chat.start` trong docs cheat sheet) — hoặc dùng `Ctrl+I` khi terminal đang focus. · 📄 [VS Code Docs: Fix terminal errors](https://code.visualstudio.com/docs/editing/copilot-smart-actions#fix-terminal-errors)

## Ví dụ thật

Nghiệp vụ: `npm test` vừa fail với stack trace dài, bạn không biết lỗi thật nằm ở đâu.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Code generation & editing](https://code.visualstudio.com/docs/agents/guides/prompt-examples#code-generation-and-editing)

**Kết quả mong đợi:** nguyên nhân top-1 đúng + 1–2 lệnh fix xếp theo rủi ro; bạn chọn 1 lệnh rồi tự Run.

**✅ Verify:** Run xong chạy lại đúng lệnh đã fail — hết đỏ là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — paste cả 500 dòng rồi bấm Run theo fix mạo hiểm:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — đưa log gọn + ngữ cảnh, cấm lệnh phá hủy:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

**Bài học:** log gọn + ngữ cảnh = chẩn đoán đúng; bạn vẫn là người bấm Run — mỗi lần Run là một thay đổi hệ thống thật.

## Lỗi thường gặp

📄 [VS Code Docs: Diagnose repeated failures](https://code.visualstudio.com/docs/agents/guides/get-agent-back-on-track#diagnose-repeated-failures)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Model đọc sót lỗi chính | Paste cả 500 dòng | Chỉ bôi đen 30–50 dòng quanh lỗi + lệnh đã chạy |
| Fix đoán mò | Thiếu context lệnh/môi trường | Nêu lệnh đã chạy + OS + branch trong prompt |
| Chạy nhầm lệnh phá hủy | Tin luôn không review | Dặn "không đề xuất lệnh destructive"; đọc trước khi Run |
## So sánh với Claude Code

📄 [GitHub Docs: Third-party coding agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-third-party-coding-agents)

| Việc | Copilot (inline chat terminal) | Claude Code | Ghi chú |
|---|---|---|---|
| Đọc output lỗi | Bôi đen log + `Ctrl+I` tại chỗ | Agent tự đọc output lệnh nó vừa chạy | Copilot: bạn trỏ vào log; Claude: gắn với phiên chạy của chính nó |
| Chẩn đoán nguyên nhân | Nguyên nhân top-1 + fix theo rủi ro | Agent tự phân tích output khi được yêu cầu | Cùng tư tưởng: log là dữ liệu, không phải lời kết tội |
| Kiểm chứng | Bạn bấm Run / chạy lại lệnh, xác nhận hết đỏ | Bạn vẫn là người verify | "Hết đỏ" do lệnh quyết định, không do lời gợi ý |
## Best practices (kèm "vì sao")

- **Chỉ đưa 30–50 dòng quanh lỗi + lệnh đã chạy.** *Vì sao?* Log dài làm loãng tín hiệu; đúng khung quanh lỗi cho chẩn đoán sắc hơn.
- **Nêu ngữ cảnh: OS, branch, lệnh đã chạy.** *Vì sao?* Cùng một lỗi có nhiều nguyên nhân tùy môi trường; thiếu context là đoán.
- **Cấm lệnh destructive (`rm -rf`, `--force`, `reset --hard`).** *Vì sao?* Fix sai thì sửa lại được, chạy nhầm lệnh phá hủy thì mất code.
- **Áp fix rồi chạy lại đúng lệnh đã fail.** *Vì sao?* Đây là cách duy nhất xác nhận đã hết lỗi, thay vì chỉ tin vào gợi ý. · 📄 [VS Code Docs: Terminal inline chat](https://code.visualstudio.com/docs/chat/inline-chat#use-terminal-inline-chat)

## Bài tập nhỏ

1. **(5 phút)** Cố tình paste cả log dài vào inline chat, sau đó làm lại với 30 dòng quanh lỗi. So sánh độ chính xác.
2. **(10 phút)** Lấy 1 lỗi build thật: hỏi nguyên nhân top-1 + 2 cách fix, áp cách ít rủi ro nhất rồi chạy lại lệnh.
3. **(10 phút)** Tập từ chối: tìm 1 gợi ý "fix mạo hiểm" (xóa/force) và viết lại yêu cầu có dòng "đừng đề xuất lệnh destructive". · 📄 [VS Code Docs: Fix terminal errors](https://code.visualstudio.com/docs/editing/copilot-smart-actions#fix-terminal-errors)

## Tham khảo

- Docs: [AI features cheat sheet (mục Terminal)](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [Inline chat](https://code.visualstudio.com/docs/chat/inline-chat)
- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Cần nó tự đi sửa nhiều bước: Agent mode — [../../model-agent/agent-mode/README.md](../../model-agent/agent-mode/README.md).

> Chốt: inline chat trong terminal biến một đống log đỏ thành **danh sách việc có thứ tự** — nhưng bạn vẫn là người chọn lệnh nào được phép Run.
