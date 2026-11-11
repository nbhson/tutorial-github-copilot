# Agent Skills — Sổ tay nghề model tự rút ra dùng

> **Dành cho:** team muốn model tự làm đúng chuẩn mà không phải nhớ tên lệnh · **Vấn đề:** hay nhầm skill với prompt/agent nên gọi sai cách · **Đọc xong:** biết skill sống ở đâu, ai kích hoạt, và khi nào model tự nạp (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI / GitHub.com

## 1 câu nôm na

Skill là "sổ tay nghề" cất trong repo: khi bạn nói đúng việc, model tự rút đúng trang ra dùng thay vì bạn phải gọi tên. Phân biệt nhanh cho khỏi lẫn: **Prompt = bạn gọi tay; Skill = model tự gọi; Agent = một người làm việc riêng.** · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Vì sao dùng skill?

Skill nằm trong `.github/skills/<ten>/SKILL.md`, có `description` liệt kê từ khóa trigger. Khi câu nói của bạn khớp, model tự nạp đúng quy trình — bạn không cần nhớ tên lệnh, và kết quả ổn định hơn. So với gõ prompt tay mỗi lần: skill gọn hơn (không phải nhét lại checklist), và nhẹ hơn instructions vì áp dụng **progressive loading** — đầu session chỉ nạp `name` + `description`, thân `SKILL.md` chỉ nạp khi khớp, file tham chiếu chỉ nạp khi body nhắc tới.

| Cách | Ai gọi | Khi nào dùng |
|---|---|---|
| Prompt file (`*.prompt.md`) | Bạn gõ tay — **chỉ Local harness** ([prompt-file](../../../local/system-knowledge/prompt-file/README.md)) | Việc lặp lại muốn chủ động gọi, kiểm soát từng lần |
| Skill (`SKILL.md`) | Model tự kích hoạt theo `description`, hoặc bạn gọi tay `/<ten-skill>` | Muốn model tự chọn cách làm chuẩn, không cần nhớ tên |
| Agent | Bạn chạy như một "đồng nghiệp" riêng ([custom-agent](../../model-agent/custom-agent/README.md)) | Việc dài, cần persona/permission riêng |

**Nếu làm sai thì sao?** Đóng quy trình vào skill nhưng `description` viết chung chung ("hỗ trợ deploy") thì skill **không bao giờ tự kích hoạt** — bạn tưởng model đã biết, thực ra nó chưa từng thấy skill. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** muốn model tự biết "review PR thì làm gì"; chuẩn hóa kỹ năng team; cân nhắc skill vs prompt/agent để chọn đúng cách đóng gói.
- **ĐỪNG dùng khi:** cần **persona/quyền riêng** cho một vai (đó là custom agent); cần luật áp **mọi chat** (đó là [instructions](../instructions/README.md)); cần nối hệ thống ngoài (đó là [mcp](../mcp/README.md)). · 📄 [VS Code Docs: Choose a customization scope](https://code.visualstudio.com/docs/agent-customization/overview#choose-a-customization-scope)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

| Muốn gì | Copilot harness (VS Code) | Copilot CLI |
|---|---|---|
| Xem / bật-tắt skill | `Chat: Open Customizations` → tab **Skills** | `/skills`, `/skills list`, `/skills info <TEN>` |
| Cài skill mới | Customizations editor → Browse (kể cả GitHub Feed, experimental) | `/skills add [--project] <FILE\|URL\|DIR>` |
| Gọi tay một skill | gõ `/<ten-skill>` trong ô chat | như nhau |

> Skill không hiện trong menu? Kiểm `name` có **trùng tên thư mục cha** và chỉ dùng `a-z 0-9 -` (VS Code: sai là *silently fail to load*), và file phải đặt ở đường dẫn harness đó đọc: `.github/skills/` (project) hoặc `~/.copilot/skills/` (user). · 📄 [VS Code Docs: SKILL.md file format](https://code.visualstudio.com/docs/agent-customization/agent-skills#skillmd-file-format)

## Ví dụ thật

Nghiệp vụ: team đã có skill `review-pr` (chỉ đọc diff, nêu bug + test thiếu, không sửa code). Bạn muốn nó tự chạy khi chỉ nói như người thường.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Create project instructions](https://code.visualstudio.com/docs/agents/guides/customize-copilot-guide#step-1-create-project-instructions)

**Kết quả mong đợi:** model tự kích hoạt đúng skill, output đúng form; bạn không cần nhớ tên.

**✅ Verify:** nhờ 1 việc quen → model báo đã dùng skill X là đạt. Không báo → `description` thiếu từ khóa.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

```markdown
# SAI:  description: 'Hỗ trợ deploy'        -> model không biết khi nào load, skill chết
# DUNG: description: 'Deploy staging/prod kèm migrate + smoke test.
#         Dùng khi user nói deploy, release, ship, xuất bản.'
```

**Bài học:** `description` là **trigger**, không phải khẩu hiệu — câu đầu phải chứa đúng những từ bạn sẽ nói thật. · 📄 [VS Code Docs: Troubleshoot customization issues](https://code.visualstudio.com/docs/agent-customization/overview#troubleshoot-customization-issues)

## Lỗi thường gặp

📄 [VS Code Docs: Skill common issues](https://code.visualstudio.com/docs/agent-customization/agent-skills#common-issues)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Skill không kích hoạt | `description` mờ / trigger sai | Viết rõ "dùng khi …" + test 3 câu khác nhau |
| Gõ `${workspaceFolder}` trong SKILL.md | Skill **không** có nội suy biến | Viết đường dẫn tương đối tới `SKILL.md`, hoặc truyền thêm chữ sau `/<skill>` |
| Skill quá to, hay bỏ bước | Ôm cả quy trình dài | Mỗi skill 1 kỹ năng; body ngắn, chi tiết đẩy sang file reference được nhắc tới |
## So sánh với Claude Code

📄 [VS Code Docs: Skills vs custom instructions](https://code.visualstudio.com/docs/agent-customization/agent-skills#agent-skills-vs-custom-instructions)

| Việc | Copilot (Agent Skills) | Claude Code | Ghi chú |
|---|---|---|---|
| Chuẩn skill | `SKILL.md` + frontmatter (`name`, `description`, …) | `SKILL.md` (Anthropic khởi xướng chuẩn mở) | Cùng chuẩn mở — viết 1 lần chạy nhiều agent |
| Đường dò thêm | `.agents/skills`, `.claude/skills` (Local đọc cả hai) | `.claude/skills` | Portable, nhưng **user-level `~/.claude/skills` không có trong load-order của docs GitHub** |
## Best practices (kèm "vì sao")

- **Câu đầu `description` = từ khóa user sẽ nói.** *Vì sao?* Đây là cơ chế trigger; thiếu từ khóa thì skill hay cỡ nào cũng không bao giờ load.
- **Giữ body `SKILL.md` gọn, chi tiết dài đẩy sang file reference.** *Vì sao?* Mức 3 (resources) chỉ nạp khi body nhắc tới file — nhắc sai thì tài liệu chết.
- **Không để secret trong skill.** *Vì sao?* Skill nằm trong git và được agent host đọc; secret trong đó là lộ. Ghi "lấy từ 1Password <tên>". · 📄 [VS Code Docs: Skill best practices](https://code.visualstudio.com/docs/agent-customization/agent-skills#best-practices)

## Bài tập nhỏ

1. **(15 phút)** Tạo `.github/skills/tom-tat-pr/SKILL.md` với `description` chứa từ "tóm tắt PR", rồi nói tự nhiên xem model có tự dùng không.
2. **(10 phút)** Xóa 1 từ khóa trigger trong `description`, chạy lại, ghi khác biệt; sau đó đổi lại cho đúng. · 📄 [VS Code Docs: SKILL.md file format](https://code.visualstudio.com/docs/agent-customization/agent-skills#skillmd-file-format)

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh System & Knowledge · Bài chủ: [05-agent-skills-reusable-workflows.md](../../../../05-agent-skills-reusable-workflows.md).
- Skill nạp vào agent: [../../model-agent/custom-agent/README.md](../../model-agent/custom-agent/README.md) · Bản legacy `*.prompt.md` (Local): [prompt-file](../../../local/system-knowledge/prompt-file/README.md).
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- VS Code — [Agent Skills](https://code.visualstudio.com/docs/agent-customization/agent-skills) · GitHub — [Adding agent skills](https://docs.github.com/en/copilot/concepts/customizations/agent-skills).

> **Chốt:** skill mạnh nhất ở câu `description` — viết skill thì nên dồn 80% công sức vào phần trigger, chứ không phải phần thân.
