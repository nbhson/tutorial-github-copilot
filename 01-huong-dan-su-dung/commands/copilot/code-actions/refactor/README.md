# Refactor code — dọn mà giữ behavior (lightbulb + inline chat)

> **Dành cho:** dev cấu trúc lại code mà không đổi hành vi · **Vấn đề:** refactor kèm bug vì không có test bao · **Đọc xong:** code gọn hơn mà test cũ vẫn xanh (~2 phút)
> **Harness:** Copilot · **Surface:** Editor — Code Actions (lightbulb 💡) cho rename/extract, inline chat `Ctrl+I` cho refactor bằng prompt; docs cheat-sheet **không** liệt kê slash `/refactor` trong chat reference

## 1 câu nôm na

Dọn nhà nhưng không vứt đồ — gọn hơn mà đồ đạc vẫn đủ. Việc này có **đúng hai cửa**: việc hình thái (đổi tên, tách hàm) đi qua lightbulb/Code Actions vì editor ngôn ngữ đảm bảo không đổi behavior; việc "dọn tư duy" (gom code trùng, tách theo ý) thì bôi đen đoạn code, mở inline chat (`Ctrl+I`, macOS `⌘I`) và nói rõ "refactor, giữ nguyên behavior". · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Vì sao refactor qua AI/Code Actions?

Refactor là việc đúng nhưng dễ phá thứ đang chạy: đổi cấu trúc mà vô tình đổi hành vi thì bug len vào lặng lẽ. Inline chat giúp **tách hàm, gom code trùng, đặt tên rõ** nhanh hơn gõ tay, và điều quan trọng là nó buộc bạn khai báo ràng buộc "behavior không đổi". Điều kiện tiên quyết luôn là: **có test bao trước khi refactor** — không có lưới an toàn thì đừng leo.

**Nếu làm sai thì sao?** Hai mặt trái. Một là **refactor kèm đổi hành vi**: test đỏ mà bạn tưởng chỉ là "dọn dẹp", thực ra đã phá logic. Hai là **tách quá vụn**: chuỗi hàm 1 dòng nối nhau, đọc còn mệt hơn bản gốc. Và đừng bao giờ vừa refactor vừa thêm tính năng — trộn 2 việc thì không review nổi cái nào (xem mục ❌/✅).

> **Tóm gọn 1 câu:** Refactor là người sắp lại đồ trong nhà mà không vứt món nào — test xanh trước và sau chính là biên bản kiểm kê. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** hàm/file quá dài muốn tách nhỏ, code trùng ở 3 chỗ muốn gom 1, hoặc đổi tên/tách module nhưng giữ behavior.
- **ĐỪNG dùng khi:** bạn muốn *thêm tính năng* (làm riêng 1 commit), hoặc đoạn code chưa có test bao — viết test trước (`/tests`) rồi hãy refactor.
- **Rename/extract đơn thuần?** Ưu tiên Code Actions (💡 → Refactor…) hoặc [Agent mode](../../model-agent/agent-mode/README.md) cho refactor xuyên nhiều file — docs ghi rõ: tác vụ cần điều phối nhiều file thì dùng agent. · 📄 [VS Code Docs: Choose a feature](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet#choose-a-feature)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Đi tìm slash `/refactor` trong Chat? Gõ `/` sẽ không thấy nó — docs không liệt kê. Cửa thật: inline chat prompt refactor, hoặc Code Actions. · 📄 [VS Code Docs: Quick fixes & refactorings](https://code.visualstudio.com/docs/editing/refactoring#code-actions-quick-fixes-and-refactorings)

## Ví dụ thật

Nghiệp vụ: `processCheckout()` đã phình lên 100 dòng, khó đọc, nhưng đang chạy tốt.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Code generation & editing](https://code.visualstudio.com/docs/agents/guides/prompt-examples#code-generation-and-editing)

**Kết quả mong đợi:** code gọn hơn, tên hàm rõ hơn; toàn bộ test cũ vẫn xanh (behavior giữ nguyên).

**✅ Verify:** chạy full test liên quan (`npm test -- checkout`) — xanh hết là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — tin có slash `/refactor` + refactor không test, gộp thêm tính năng:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — Code Actions cho rename, inline chat cho tách hàm, có test bao:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

**Bài học:** refactor và thêm tính năng là 2 commit khác nhau; và test phải xanh **trước** lẫn **sau**.

## Lỗi thường gặp

📄 [VS Code Docs: Establish regression coverage](https://code.visualstudio.com/docs/agents/guides/refactor-safely#2-establish-regression-coverage)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Refactor đổi luôn behavior | Thiếu test bao + prompt thiếu "giữ nguyên" | Chạy test trước/sau; prompt ghi "giữ nguyên behavior" |
| Tách quá vụn khó đọc | Tham tách | Tách vừa đủ: mỗi hàm 1 việc, tên nói được việc |
| Refactor + thêm tính năng 1 lúc | Ôm 2 việc | Refactor riêng 1 commit, tính năng riêng 1 commit |
| Chờ mãi `/refactor` không hiện trong `/` | Docs không có slash này | Dùng inline chat / Code Actions như trên |
## So sánh với Claude Code

📄 [GitHub Docs: Third-party coding agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-third-party-coding-agents)

| Việc | Copilot (refactor) | Claude Code | Ghi chú |
|---|---|---|---|
| Tách/gom code giữ behavior | Prompt trong inline chat + Code Actions | Không có lệnh riêng — yêu cầu bằng prompt hoặc tự tạo command | Hai bên đều "prompt là chính" |
| Ràng buộc "không đổi behavior" | Bạn phải nói trong prompt | Bạn cũng phải nói rõ | Không agent nào tự hiểu đây là refactor thuần |
| Kiểm chứng | Bạn chạy test trước/sau | Bạn vẫn là người chạy | Test xanh là lưới an toàn duy nhất |
## Best practices (kèm "vì sao")

- **Có test bao trước khi refactor.** *Vì sao?* Không có test thì bạn không có cách nào biết mình vừa phá gì.
- **Ghi rõ "giữ nguyên behavior" trong prompt.** *Vì sao?* Nếu không, model dễ "tiện tay" cải thiện logic — thứ bạn không hề yêu cầu.
- **Việc hình thái thì Code Actions, việc tư duy thì inline chat.** *Vì sao?* Rename/extract bằng language service an toàn tuyệt đối về behavior; prompt AI mạnh ở quyết định cấu trúc.
- **Refactor riêng 1 commit, tính năng riêng 1 commit.** *Vì sao?* Trộn 2 việc thì reviewer không thể tách "thay đổi cấu trúc" khỏi "thay đổi hành vi". · 📄 [VS Code Docs: Refactor in reviewable steps](https://code.visualstudio.com/docs/agents/guides/refactor-safely#4-refactor-in-reviewable-steps)

## Bài tập nhỏ

1. **(5 phút)** Refactor 1 hàm *chưa* có test bao qua inline chat, rồi chạy lại sau khi thêm test (`/tests`). Ghi lại mức độ tự tin mỗi lần.
2. **(10 phút)** Tách 1 hàm dài thành 3 hàm nhỏ, chạy full test trước/sau để chứng minh behavior không đổi.
3. **(10 phút)** Thử rename 1 symbol bằng Code Actions (💡) thay vì tìm-and-replace — so rủi ro sót usage. · 📄 [VS Code Docs: Quick fixes & refactorings](https://code.visualstudio.com/docs/editing/refactoring#code-actions-quick-fixes-and-refactorings)

## Tham khảo

- Docs: [Refactoring in VS Code](https://code.visualstudio.com/docs/editing/refactoring) · [AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)
- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Viết test bao trước khi refactor: `/tests` — [../tests/README.md](../tests/README.md).

> Chốt: refactor giỏi không phải là đổi nhiều, mà là **đổi cấu trúc mà không ai phát hiện ra hành vi đã thay đổi** — test xanh trước và sau chính là bằng chứng đó.
