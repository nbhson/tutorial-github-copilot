# Agent Skills (`.github/skills/`) — Sổ tay nghề model tự rút ra dùng khi câu nói của bạn khớp `description`

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI · **Đọc:** ~2 phút

**Nôm na:** Skill là "sổ tay nghề" cất trong repo: khi bạn nói đúng việc, model tự rút đúng trang ra dùng thay vì bạn phải gọi tên. Hợp khi muốn chuẩn của team áp ổn định mà tay không phải nhắc lại checklist mỗi lần.

## Vì sao dùng?

Skill nằm trong `.github/skills/<ten>/SKILL.md` và rất nhẹ nhờ progressive loading: đầu session chỉ nạp `name` + `description`, thân `SKILL.md` chỉ nạp khi khớp, file tham chiếu chỉ nạp khi body nhắc tới. So với gõ prompt tay mỗi lần, skill gọn hơn; so với instructions, skill chỉ nạp đúng lúc việc khớp.

| Cách đóng gói | Ai gọi | Khi nào dùng |
|---|---|---|
| Prompt file (`*.prompt.md`) | Bạn gõ tay — chỉ Local harness ([prompt-file](../../../local/system-knowledge/prompt-file/README.md)) | Việc lặp lại muốn chủ động gọi, kiểm soát từng lần |
| Skill (`SKILL.md`) | Model tự kích hoạt theo `description`, hoặc bạn gọi tay `/<ten-skill>` | Muốn model tự chọn cách làm chuẩn, không cần nhớ tên |
| Custom agent | Bạn chạy như một "đồng nghiệp" riêng ([custom-agent](../../model-agent/custom-agent/README.md)) | Việc dài, cần persona/quyền riêng |

**Nếu làm sai:** `description` viết chung chung ("hỗ trợ deploy") thì skill **không bao giờ tự kích hoạt** — bạn tưởng model đã biết, thực ra nó chưa từng thấy; `name` phải trùng tên thư mục cha và chỉ dùng `a-z 0-9 -` — sai là VS Code *silently fail to load*.

## Cách dùng

Khai báo file trong repo, model tự nạp khi task khớp — hoặc kiểm/bật-tắt qua `Chat: Open Customizations` → tab **Skills** (VS Code) và `/skills` (CLI).

```markdown
---                                # .github/skills/review-pr/SKILL.md
name: review-pr                    # bắt buộc trùng tên thư mục cha
description: Review PR — đọc diff, nêu bug + test thiếu, không sửa code.
  Dùng khi user nói review, xem PR, tóm tắt PR.   # đây là TRIGGER, không phải khẩu hiệu
---
```

- **Biến thể:** CLI: `/skills list` · `/skills info <TEN>` · `/skills add [--project] <FILE\|URL\|DIR>`; gọi tay bằng `/<ten-skill>` trong Chat.
- **Chỗ đặt:** `.github/skills/` (project, commit cho team) hoặc `~/.copilot/skills/` (user); skill không nội suy biến — viết đường dẫn tương đối tới `SKILL.md`, đừng gõ `${workspaceFolder}`.
- **✅ Verify:** nói tự nhiên "review PR 123 giúp tôi" — model báo đang dùng `review-pr` là đạt; không báo là `description` thiếu từ khóa.

## Liên quan

- Luật áp mọi chat thì dùng [instructions](../instructions/README.md); nối hệ thống ngoài dùng [mcp](../mcp/README.md); plugin đóng gói cả bộ skill: [plugins](../plugins/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/) · Bài chủ: [05-agent-skills-reusable-workflows.md](../../../../05-agent-skills-reusable-workflows.md)
- Nguồn: [VS Code Docs — Agent Skills](https://code.visualstudio.com/docs/agent-customization/agent-skills) · [GitHub Docs — Adding agent skills](https://docs.github.com/en/copilot/concepts/customizations/agent-skills)
