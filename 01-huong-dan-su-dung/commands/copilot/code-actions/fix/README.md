# /fix — Sửa lỗi/selection nhanh hơn gõ tay

> **Dành cho:** dev đã biết lỗi nằm ở đâu · **Vấn đề:** sửa 3 dòng mà phải mô tả lại "sửa ở đâu" mất 2 câu · **Đọc xong:** sửa gọn đúng chỗ đau, không lan sang logic khác (~2 phút)
> **Harness:** Copilot · **Surface:** Chat view — `/fix` thuộc nhóm "editor" trong chat reference; docs chốt availability theo surface/harness/role, gõ `/` để thấy lệnh khả dụng thật

## 1 câu nôm na

Khoanh chỗ đau rồi bảo "chữa chỗ này, đừng đụng chỗ khác". Bạn **bôi đen** đoạn lỗi rồi gọi `/fix` — vì selection đã được gắn sẵn vào prompt, bạn không phải mô tả lại "sửa ở đâu" như khi gõ tay. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Vì sao dùng /fix (thay vì gõ prompt tay)?

Khi gõ prompt tay, bạn tốn 1–2 câu chỉ để nói *sửa file nào, đoạn nào*. `/fix` tự lấy phần bạn đang bôi đen làm scope, nên:

- **Ít tokens hơn** — không đưa cả file vào chỉ để sửa 3 dòng.
- **Ít sửa nhầm hơn** — model bám đúng selection, không lan ra hàm khác.
- **Nhanh hơn** — bôi đen + gọi là xong, không phải gõ lại ngữ cảnh.

**Nếu làm sai thì sao?** Hai lỗi thường gặp: (1) quên bôi đen → model tự đoán scope và sửa cả file; (2) mô tả thiếu câu "giữ nguyên..." → nó tiện tay refactor luôn phần không hỏng. Cả hai đều dẫn tới diff to hơn dự kiến — xem mục ❌/✅ bên dưới.

> **Tóm gọn 1 câu:** `/fix` là bác sĩ tiểu phẫu — chỉ mổ đúng chỗ bạn chỉ tay vào, còn bạn phải dặn "đừng cắt lân cận" thì đường may mới gọn. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** lỗi nhỏ, khu trú — null check, type error, test fail đúng 1 chỗ, sửa message/log/typo theo chuẩn repo, và bạn **đã biết lỗi nằm ở đâu**.
- **ĐỪNG dùng khi:** bạn chưa biết lỗi ở đâu, hoặc cần sửa nhiều file liên quan — đưa task đó cho **Agent mode** để nó tự dò và sửa có điều phối. · 📄 [VS Code Docs: Choose a feature](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet#choose-a-feature)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Kiểm tra `/fix` có ở máy bạn không: gõ `/` trong ô Chat, tìm `/fix`. Không thấy → kiểm tra loại phiên/surface đang mở (docs: availability phụ thuộc harness, role, tính năng) trước khi kết luận là lỗi công cụ. · 📄 [VS Code Docs: Fix coding errors](https://code.visualstudio.com/docs/editing/copilot-smart-actions#fix-coding-errors)

## Ví dụ thật

Nghiệp vụ: `login()` nhận email có dấu bị trả 500 vì `params` có thể là `undefined`.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Code generation & editing](https://code.visualstudio.com/docs/agents/guides/prompt-examples#code-generation-and-editing)

**Kết quả mong đợi:** diff nhỏ đúng chỗ đau (vài dòng), không đụng export/kiểu trả về; test liên quan xanh.

**✅ Verify:** chạy test/build/lint cho file vừa sửa — `npm test -- auth` xanh là đạt; `git diff --stat` chỉ 1 file.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — mô tả quá cụt, không khóa scope:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — gắn scope + câu "giữ nguyên":**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

**Bài học:** luôn nói rõ *sửa gì* và *giữ nguyên gì*. Scope càng khóa, diff càng gọn.

## Lỗi thường gặp

📄 [VS Code Docs: Add a failing regression test](https://code.visualstudio.com/docs/agents/guides/fix-a-bug-with-agents#add-a-failing-regression-test)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Sửa lan sang logic khác | Mô tả thiếu "giữ nguyên ..." | Thêm "không đổi logic khác" vào prompt |
| Fix xong vẫn fail test | Lỗi sâu hơn 1 chỗ, không phải bug khu trú | Chuyển sang Agent mode để điều tra |
| Không bôi đen mà gọi `/fix` | Model tự đoán scope | Bôi đen chính xác rồi gọi lại |
## So sánh với Claude Code

📄 [GitHub Docs: Third-party coding agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-third-party-coding-agents)

| Việc | Copilot (`/fix`) | Claude Code | Ghi chú |
|---|---|---|---|
| Sửa nhanh trên selection | Slash command có sẵn `/fix` | Không có sẵn — bôi đen rồi gõ prompt, hoặc tự tạo slash command trong `.claude/commands/` | Copilot bấm-là-chạy; Claude Code linh hoạt hơn nhưng phải tự dựng |
| Lấy scope từ selection | Tự gắn selection khi bôi đen | Cũng hỗ trợ selection/`@file` | Cùng tư tưởng: đưa đúng chỗ đau, đừng đưa cả file |
| Kiểm chứng | Bạn tự chạy test/lint | Cùng vậy — agent đề xuất, bạn vẫn là người verify | Đừng tin lời "đã sửa xong" của bất kỳ agent nào |
## Best practices (kèm "vì sao")

- **Luôn bôi đen trước khi gọi `/fix`.** *Vì sao?* Selection chính là scope — không có nó, model phải đoán và dễ sửa thừa.
- **Thêm câu "giữ nguyên API shape / không đổi logic khác".** *Vì sao?* Model có xu hướng "tiện tay" dọn dẹp chỗ không hỏng, làm diff phình.
- **Sửa xong chạy test/lint ngay.** *Vì sao?* `/fix` chỉ sinh diff; tính đúng phải do lệnh verify quyết định.
- **Lỗi không khu trú thì đổi mode.** *Vì sao?* `/fix` giỏi sửa chỗ đã biết, kém ở việc *đi tìm* root cause — đó là việc của Agent mode. · 📄 [VS Code Docs: Implement and test the fix](https://code.visualstudio.com/docs/agents/guides/fix-a-bug-with-agents#implement-and-test-the-fix)

## Bài tập nhỏ

1. **(5 phút)** Cố tình gọi `/fix` mà **không** bôi đen, xem nó sửa rộng tới đâu. So với lần bôi đen chính xác — ghi lại sự khác biệt về số dòng diff.
2. **(10 phút)** Lấy 1 bug nhỏ thật trong repo bạn: gọi `/fix` với chỉ dẫn "giữ nguyên API shape", sau đó chạy test để xác nhận không phá gì.
3. **(10 phút)** Thử 1 lỗi không khu trú (bug sâu 2 file): quan sát `/fix` làm được tới đâu rồi chuyển sang Agent mode, so sánh kết quả. · 📄 [VS Code Docs: Fix coding errors](https://code.visualstudio.com/docs/editing/copilot-smart-actions#fix-coding-errors)

## Tham khảo

- Docs: [AI features cheat sheet (chat reference)](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [Review & revert agent edits](https://code.visualstudio.com/docs/agents/run/review-code-edits)
- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Chuyển mode lớn hơn khi lỗi không khu trú: [../../model-agent/agent-mode/README.md](../../model-agent/agent-mode/README.md) (Agent) và [../../model-agent/edit-mode/README.md](../../../local/model-agent/edit-mode/README.md) (Edit).

> Chốt: `/fix` mạnh nhất khi bạn **đã biết chỗ đau** — bôi đen đúng, khóa scope, rồi để test nói "đạt" thay vì để model tự khen.
