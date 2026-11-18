# `*.prompt.md` — File prompt tái dùng trong `.github/prompts/`, gọi theo tên ở Local harness

> **Harness:** Local · **Surface:** VS Code Chat — `/prompts` để liệt kê, `/<tên>` để gọi; docs nói thẳng prompt file **chỉ chạy ở session Local** · **Đọc:** ~2 phút

**Nôm na:** Hộp công thức của team: việc nào nấu nhiều lần thì lôi công thức đã chốt ra thay vì nhớ lại từng bước — gõ `/review-pr` là chạy đúng form cả team thống nhất. Hợp khi team có việc lặp lại (review PR, migration, standup) và session đang là Local harness.

## Vì sao dùng?

Gõ tay một việc 5 lần thì 3 lần quên một bước, hai người ra hai form khác nhau; đóng checklist vào `.github/prompts/<tên>.prompt.md` rồi commit thì form cố định, bản mới được review như code — giá trị là **chuẩn hóa**, không phải gõ tắt. Lỗi "gõ `/` không thấy prompt nào" 90% là đứng nhầm harness chứ không phải file hỏng: session Copilot, GitHub.com và Copilot CLI đều không chạy prompt file.

| | Prompt file | Agent skill |
|---|---|---|
| File | `.github/prompts/<tên>.prompt.md` | `.github/skills/<tên>/SKILL.md` |
| Cách gọi | `/prompts` liệt kê, rồi gõ `/<tên>` | model tự kích hoạt khi khớp mô tả |
| Hợp khi | bạn chủ động gọi, chỉ Local harness | việc mới, cần chạy cả trên Copilot/GitHub.com/CLI |

**Nếu làm sai:** mỗi người giữ một prompt riêng ở Desktop/Notes thì repo có 5 form review khác nhau, sửa checklist chẳng lan tới ai — prompt tái dùng phải sống **trong repo**; nhóm đánh dấu prompt file là **legacy**, việc mới cân nhắc [agent-skill](../../../copilot/system-knowledge/agent-skill/README.md) và đừng giữ song song cả hai.

## Cách dùng

Gõ trong Chat view khi session đang là **Local**; tạo file mới qua Command Palette → `Chat: New Prompt File`:

```prompt
/prompts
/review-pr "review diff hiện tại: nêu 3 lỗi lớn nhất + test còn thiếu"
```

- **Biến thể:** file phải đúng chỗ `.github/prompts/`, đuôi `.prompt.md`, frontmatter có `description`; một prompt = một việc, kèm tiêu chí "thế nào là xong".
- **Setting:** `chat.promptFiles` + `/prompts` vẫn sống ở Local; [feature matrix](https://docs.github.com/en/copilot/reference/copilot-feature-matrix) đánh dấu ✗ prompt files cho GitHub.com và Copilot CLI.
- **✅ Verify:** chạy trên 2 diff khác nhau — khung output giống nhau, chỉ khác nội dung, nghĩa là form đã chốt.

## Liên quan

- Bản kế nhiệm: [agent-skill](../../../copilot/system-knowledge/agent-skill/README.md) · file config Local khác: [vscode-mcp-json](../vscode-mcp-json/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Prompt files](https://code.visualstudio.com/docs/agent-customization/prompt-files)
