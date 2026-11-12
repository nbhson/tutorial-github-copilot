# Instructions — Xem và sửa bộ luật đang áp cho repo

> **Dành cho:** người mới onboard repo và tech lead giữ luật team · **Vấn đề:** nghi instructions không được nạp, hoặc sửa rule xong mà model vẫn làm theo cách cũ · **Đọc xong:** thấy đúng những rule đang có hiệu lực cho file bạn mở, sửa ngay tại chỗ (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI / GitHub.com

## 1 câu nôm na

Instructions là bảng nội quy lớp đang dán trên tường: `copilot-instructions.md` (hoặc `AGENTS.md`) áp cho mọi chat, còn `.github/instructions/*.instructions.md` chỉ áp khi file bạn đang mở khớp `applyTo`. Muốn xem **rule nào đang được nạp**, ở Copilot harness dùng **Agent Customizations editor** (`Chat: Open Customizations` → tab Instructions); ở Copilot CLI có `/instructions` để xem và bật/tắt từng file. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Vì sao phải kiểm tra luật đang nạp?

Gõ prompt tay, bạn không kiểm chứng được điều quan trọng nhất: **model đang thấy luật gì**. Bạn sửa `copilot-instructions.md`, nhưng rất có thể một `.instructions.md` của thư mục khác đang nói khác; hoặc rule viết đúng mà glob `applyTo` sai nên chưa từng được nạp.

**Thứ tự nạp (đừng hiểu sai):** docs GitHub nói Personal > Repository > Org, **nhưng** nguyên văn là *"all sets of relevant instructions are provided to Copilot"* — cả ba đều vào context, thứ tự chỉ dùng để **phân xử khi mâu thuẫn**. Docs VS Code ghi thêm *"combination rules differ by harness"* → không có một bảng "file cao nhất thắng" universal.

**Nếu bỏ qua bước này thì sao?** Bạn đoán già đoán non: sửa rule mà không hiểu vì sao model vẫn làm cũ, rồi kết luận "Copilot dở" trong khi lỗi nằm ở glob, hoặc ở luật trùng lặp giữa personal và repo. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** nghi instructions không được nạp; muốn sửa luật team ngay; mới onboard muốn biết repo có quy tắc gì; đang debug ca "model làm trái hẳn quy ước".
- **ĐỪNG dùng khi:** việc cần là **workflow lặp lại** (đóng thành skill, hoặc prompt file cho Local — [agent-skill](../agent-skill/README.md) · [prompt-file](../../../local/system-knowledge/prompt-file/README.md)); cần **persona riêng** (custom agent); cần áp **cả tổ chức** (org policy + instructions trên GitHub.com, không chỉ file trong repo). · 📄 [VS Code Docs: Choose a customization scope](https://code.visualstudio.com/docs/agent-customization/overview#choose-a-customization-scope)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

| Muốn gì | Copilot harness (VS Code) | Copilot CLI |
|---|---|---|
| Xem luật đang áp | `Chat: Open Customizations` → tab **Instructions** | `/instructions` (xem + bật/tắt file) |
| Liệt kê source ngay trong terminal | — | `copilot instruction` (dò sources cho thư mục hiện tại) |
| Luật cá nhân mọi repo | `~/.copilot/instructions` | như nhau |

> Không thấy rule nào trong editor? Kiểm file nằm đúng đường dẫn harness đó đọc, và `name`/glob hợp lệ; sau đó mở **chat mới** (phím `Ctrl+N`) để luật được nạp lại. · 📄 [VS Code Docs: Create project instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions#create-project-instructions)

> **Liên quan — `/init` (Local agent session):** `/init` sinh/cập nhật workspace instructions (`copilot-instructions.md`) cho repo — docs gắn nhãn "in a local agent session". Khác mục này (mục đích *xem/sửa luật đang nạp*), `/init` lo *khởi tạo* bộ luật ban đầu. · 📄 [VS Code Docs: AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)


## Ví dụ thật

Nghiệp vụ: team quy định "route không được query DB trực tiếp", nhưng một bạn vừa thêm `db.query()` thẳng trong route. Bạn muốn xem luật này có đang được nạp cho file đó không.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Create project instructions](https://code.visualstudio.com/docs/agents/guides/customize-copilot-guide#step-1-create-project-instructions)

**Kết quả mong đợi:** danh sách rule đang áp, có cả repo-wide lẫn `*.instructions.md` khớp file đang mở; chỗ sai thì sửa được ngay.

**✅ Verify:** sửa một rule → mở chat mới → hỏi lại đúng câu vừa rồi → model làm theo rule mới là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

```text
SAI :  sua .github/copilot-instructions.md -> hoi lai TRONG chat dang mo
       -> model van lam theo rule cu -> tuong file khong co tac dung.
DUNG : sua rule -> Ctrl+N (chat moi) -> hoi lai -> model lam theo rule moi.
```

**Bài học:** rule trong repo chỉ có hiệu lực **ở lượt nạp kế tiếp**; chat cũ vẫn ôm context cũ. Test rule mới thì phải test trên chat mới. · 📄 [VS Code Docs: Troubleshoot customization issues](https://code.visualstudio.com/docs/agent-customization/overview#troubleshoot-customization-issues)

## Lỗi thường gặp

📄 [VS Code Docs: Troubleshoot instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions#troubleshoot-instructions)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Rule không ăn | `applyTo` sai hoặc file quá dài | Kiểm glob `applyTo`; giữ file gọn |
| Model làm theo luật trái ngược | Personal + repo + org **đều được nạp**, không có "file cao nhất thắng" | Gọt luật trùng/mâu thuẫn; để luật cá nhân nhất quán với luật team |
| Code review không theo rule mới | Code review đọc instructions **từ head branch** | Commit + push rule lên head branch rồi mới review |
| Rule áp cho cả agent không muốn | Chưa đặt `excludeAgent` | Thêm `excludeAgent: "code-review"` hoặc `"cloud-agent"` vào rule |
## So sánh với Claude Code

📄 [VS Code Docs: Formats & locations](https://code.visualstudio.com/docs/agents/reference/custom-instructions-reference#supported-formats-and-locations)

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Xem luật đang nạp | Customizations editor (VS Code) · `/instructions` (CLI) | Không có lệnh tương đương — mở `CLAUDE.md`/`.claude/` để đọc | Copilot có cách *hỏi* luật |
| File luật trong repo | `.github/copilot-instructions.md` **hoặc `AGENTS.md`** + `.github/instructions/*.instructions.md` | `CLAUDE.md` + `.claude/` | `AGENTS.md` đặt bất kỳ đâu trong repo, nearest wins; `CLAUDE.md`/`GEMINI.md` là thay thế hợp lệ cho 1 file ở root |
| Luật theo thư mục | `applyTo` glob trong `*.instructions.md` | Chia nhỏ trong `.claude/` | Cùng mục tiêu, khác cơ chế khai báo |
## Best practices (kèm "vì sao")

- **Kiểm danh sách rule đang nạp trước khi tin "rule đã nạp".** *Vì sao?* Nạp rule là chuyện của glob + vị trí file, không phải chuyện bạn *đã viết* rule đó ra.
- **Một luật chỉ nằm một nơi.** *Vì sao?* Vì mọi nguồn đều được nạp cùng lúc, hai bản cùng luật sẽ lệch nhau và bạn không biết bản nào phân xử.
- **Luật chung để repo-wide, luật hẹp dùng `applyTo`.** *Vì sao?* Luật hẹp mà áp cho mọi chat là lãng phí context; luật chung nhét vào một thư mục thì chỗ khác không thấy.
- **Test rule mới bằng chat mới.** *Vì sao?* Cách duy nhất để chắc rule được nạp lại là bắt đầu một lượt hội thoại sạch.
- **Checklist dài đẩy sang skill, đừng nhồi vào instructions.** *Vì sao?* Instructions nạp cho mọi lượt; skill chỉ nạp khi `description` khớp. · 📄 [VS Code Docs: Write effective instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions#write-effective-instructions)

## Bài tập nhỏ

1. **(5 phút)** Mở `Chat: Open Customizations` → tab Instructions trên repo đang làm; đếm có bao nhiêu rule repo-wide và bao nhiêu file `*.instructions.md`.
2. **(10 phút)** Thêm 1 rule nhỏ (ví dụ "log luôn dùng `logger`, không `console.log`"), rồi test bằng **chat mới** xem model có tuân không.
3. **(10 phút)** Cố tình đổi `applyTo` sang sai thư mục, kiểm rule còn hiện cho file cũ không — rồi sửa lại. Ghi 2 dòng vì sao glob quan trọng. · 📄 [VS Code Docs: Create project instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions#create-project-instructions)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Bài chủ về luật & memory: [03-instructions-memory-rules.md](../../../../03-instructions-memory-rules.md) · Tách checklist dài: [05-agent-skills-reusable-workflows.md](../../../../05-agent-skills-reusable-workflows.md).
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- VS Code — [Custom instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions) · GitHub — [Adding repository instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions) · [Custom instructions support](https://docs.github.com/en/copilot/reference/custom-instructions-support).

> **Chốt:** đừng tin "rule đã có" chỉ vì bạn đã viết — hãy xem editor/CLI liệt kê cái gì đang được nạp, rồi mới test trên chat mới.
