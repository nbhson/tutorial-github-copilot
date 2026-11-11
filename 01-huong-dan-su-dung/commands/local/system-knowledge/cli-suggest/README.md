# gh copilot suggest — mô tả việc, nhận lệnh shell (và hiểu nó)

> **Dành cho:** người dùng terminal hay quên cú pháp · **Vấn đề:** đoán flag thì dễ chạy lệnh phá hủy · **Đọc xong:** biết cách lấy lệnh + bắt nó giải thích flag + dry-run trước khi Enter (~2 phút)
>
> **Harness:** Local · **Surface:** terminal (`gh copilot` extension) — chạy ở máy bạn, không phải harness Chat/agent nào

## 1 câu nôm na

Như hỏi đường miệng: bạn nói "tôi muốn xóa branch đã merge", nó đưa đúng câu lệnh kèm giải thích. Bạn vẫn là người bấm Enter — và vẫn phải nhìn biển báo (flag) trước khi lái. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Vì sao dùng gh copilot suggest?

Vì trí nhớ con người kém đúng chỗ nguy hiểm nhất: flag. Bạn nhớ `git branch -d`, nhưng quên rằng `-D` là xóa **force** mất cả commit chưa merge. `suggest` biến ý định thành lệnh cụ thể, và điểm mạnh thật sự nằm ở phần giải thích đi kèm: bạn hiểu rồi mới chạy, thay vì copy mù.

| Bạn nói | Nhận được | Flag phải đọc kỹ |
|---|---|---|
| "xóa branch đã merge, trừ main/develop" | `git branch --merged \| grep -v ... \| xargs git branch -d` | `-d` (an toàn) khác `-D` (force, mất commit) |
| "tìm file lớn hơn 100MB trong repo" | `find . -size +100M -type f` | có chỗ thêm `-delete` là thành xóa |
| "undo commit cuối nhưng giữ thay đổi" | `git reset --soft HEAD~1` | `--soft` giữ code, `--hard` thì mất |

> **Cách đọc bảng này:** hàng nào cũng có một flag "một chữ cái, hai số phận" — `-d`/`-D`, `--soft`/`--hard`; đọc cột cuối trước khi chạy cột giữa. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** quên cú pháp git/docker/gh/kubectl; cần lệnh một dòng cho việc lạ; muốn học flag mới có giải thích.
- **ĐỪNG dùng khi:** việc nhiều bước cần đọc–sửa repo (extension không làm; dùng [Copilot CLI](https://docs.github.com/en/copilot/concepts/copilot-surfaces/copilot-cli) hoặc [Agent](../../../copilot/model-agent/agent-mode/README.md) mode); khi bạn chưa đọc phần flag.
- **Cho ai:** người sống trong terminal, người đang học lệnh mới. · 📄 [VS Code Docs: Choose a customization scope](https://code.visualstudio.com/docs/agent-customization/overview#choose-a-customization-scope)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Gợi ý ra lệnh cho Linux trong khi bạn dùng macOS? Thêm OS vào câu hỏi ("trên macOS zsh") — đây là lỗi phổ biến nhất. · 📄 [GitHub Docs: Get code suggestions](https://docs.github.com/en/copilot/how-tos/copilot-in-your-ide/copilot-for-common-tasks/get-ide-code-suggestions)

## Ví dụ thật

Bạn dọn repo: muốn xóa các branch local đã merge, giữ `main` và `develop`, và không muốn mất branch chưa merge.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Customize Copilot guide](https://code.visualstudio.com/docs/agents/guides/customize-copilot-guide)

**Kết quả mong đợi:** 1–2 lệnh, dùng `-d` (không force); bạn chạy được ở bản an toàn rồi mới nâng cấp lên `-D`.

**✅ Verify:** `git branch --merged` khớp danh sách sẽ xóa; sau khi xóa, `git log main` vẫn đủ các commit đã merge.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — Enter luôn không đọc flag:** bạn lấy lệnh gợi ý về rồi chạy, chỉ thấy `-D` khi nó đã xóa mất branch chưa merge.

**✅ ĐÚNG — đọc flag → bản an toàn → rồi mới force:** chạy `git branch --merged` để xem danh sách, dùng `-d` trước; chỉ `-D` khi chắc chắn commit đó không còn cần.

**Bài học:** `suggest` cho bạn lệnh, không cho bạn sự an toàn. Cái an toàn do bạn đọc flag và chạy bản thăm dò mà có. · 📄 [VS Code Docs: Check customization diagnostics](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#check-customization-diagnostics)

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| `gh: copilot is not installed` | Chưa cài extension | `gh extension install github/gh-copilot` (xem cảnh báo dưới) |
| Extension không còn cập nhật | `github/gh-copilot` đã archived; README đánh dấu deprecated từ 25/10/2025 | Dọc đường thay thế: [Copilot CLI](https://docs.github.com/en/copilot/concepts/copilot-surfaces/copilot-cli) |
| Gợi ý lệnh Linux trên máy Mac | Prompt không nói OS | Nêu OS + shell trong prompt |

> **Cách đọc bảng này:** cột Fix trộn hai chuyện — hàng 1–2 là "cài/ còn dùng được không", hàng 3 là "dùng cho đúng". Đọc hàng 2 trước khi bận tâm hàng 1. · 📄 [GitHub Docs: Troubleshoot common issues](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/troubleshoot-common-issues)

## So sánh với Claude Code

📄 [GitHub Docs: Use Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/overview)

| Việc cần làm | Copilot (`gh copilot suggest`) | Claude Code | Ghi chú |
|---|---|---|---|
| Lấy một lệnh shell | `gh copilot suggest "<việc>"` → bạn tự chạy | nói ý định, agent soạn và chạy lệnh | suggest tách "gợi ý" khỏi "chạy" → bạn kiểm soát hơn |
| Lệnh phá hủy | bắt đọc flag + tự chạy bản an toàn | thường xin quyền trước khi chạy | đừng tin 100% ở công cụ nào |
| Việc đa bước trên repo | không làm được — extension chỉ tra lệnh | mặc định làm việc đa bước | đây là lý do repo gh-copilot được thay bằng Copilot CLI |
## Best practices (kèm "vì sao")

- **Nêu rõ OS + shell trong prompt.** *Vì sao?* Cú pháp macOS/Linux/Windows khác nhau; thiếu OS là nguồn lỗi số một.
- **Đọc giải thích flag trước khi chạy.** *Vì sao?* Lệnh phá hủy trá hình thường chỉ khác nhau ở một chữ cái.
- **Chạy bản an toàn trước** (`-d` thay `-D`, `--dry-run`, in danh sách ra trước). *Vì sao?* Sai thì mất vài giây, không mất dữ liệu.
- **Đừng lẫn `gh copilot` với `copilot`.** *Vì sao?* Một cái tra lệnh, một cái là agent — gọi nhầm thì thấy "sao nó không sửa file". · 📄 [VS Code Docs: Suggestions tips & tricks](https://code.visualstudio.com/docs/editing/ai-powered-suggestions#tips-tricks)

## Bài tập nhỏ

1. **(5')** Hỏi một lệnh git bạn hay quên, đọc giải thích flag, chạy bản an toàn để xác nhận.
2. **(10')** Cố tình hỏi một lệnh phá hủy (`rm`, `--force`): tập dừng lại, giải thích từng flag rồi mới quyết định.
3. **(10')** Mở [Copilot CLI](https://docs.github.com/en/copilot/concepts/copilot-surfaces/copilot-cli) và thực hiện cùng task bằng đường mới — so cảm giác kiểm soát. · 📄 [GitHub Docs: Get code suggestions](https://docs.github.com/en/copilot/how-tos/copilot-in-your-ide/copilot-for-common-tasks/get-ide-code-suggestions)

## Tham khảo

- [Group index: System & kiến thức repo](../README.md) · [Tips CLI & web agent](../../../../../02-tips-thuc-chien/11-nang-cao-cli-web-coding-agent.md) · [Cheatsheet](../../../../../CHEATSHEET.md)
- [GitHub — About Copilot CLI](https://docs.github.com/en/copilot/concepts/copilot-surfaces/copilot-cli)
- [GitHub — Install Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli)
- Cùng tra lệnh: [cli-explain](../cli-explain/README.md) · Việc đa bước: [Agent mode](../../../copilot/model-agent/agent-mode/README.md)
