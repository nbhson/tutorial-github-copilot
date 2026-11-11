# /prompts — gọi prompt file tái dùng (chỉ chạy ở Local harness)

> **Dành cho:** team có việc lặp lại (review PR, tạo migration, standup) · **Vấn đề:** mỗi người gõ prompt một kiểu, không chuẩn hóa được · **Đọc xong:** biết liệt kê + gọi prompt file và biết khi nào nên chuyển sang skill (~2 phút)
>
> **Harness:** Local · **Surface:** VS Code Chat (Local harness) — prompt file chạy ở session Local, không chạy trên Copilot harness, GitHub.com hay Copilot CLI

## 1 câu nôm na

Hộp công thức của team: việc nào nấu nhiều lần thì lôi công thức có sẵn ra, thay vì nhớ lại từng bước. Gõ `/review-pr` là chạy đúng form cả team đã thống nhất.

## Vì sao dùng /prompts?

Một việc lặp lại gõ tay 5 lần thì 3 lần bạn quên một bước, và hai người ra hai form khác nhau. Đóng checklist vào `.github/prompts/*.prompt.md` rồi commit thì form cố định, mọi người chạy giống nhau, bản mới được review như code. Giá trị của prompt file là **chuẩn hóa**, không phải gõ tắt.

Docs VS Code nói thẳng vị trí của nó: ["Prompt files run only in **Local** harness sessions in the Chat view."](https://code.visualstudio.com/docs/agent-customization/prompt-files) Vì vậy nếu session của bạn là **Copilot**, hoặc bạn làm trên GitHub.com/CLI, prompt file sẽ không hiện ra — vì thế mục "Khi nào đừng" bên dưới quan trọng hơn bình thường.

**Nếu làm sai thì sao?** Mỗi người giữ một prompt riêng trong máy → repo có 5 form review khác nhau, sửa checklist cũng chẳng lan tới ai.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** repo đã có `.github/prompts/`; bạn muốn **chủ động gọi tay** đúng form; session đang là **Local harness** trong Chat view.
- **ĐỪNG dùng khi:** bạn muốn model **tự nạp khi khớp ngữ cảnh** → đó là [agent skill](../../../copilot/system-knowledge/agent-skill/README.md); việc chỉ làm một lần; hoặc bạn ở harness Copilot/GitHub.com/CLI (prompt file không chạy).
- **Cho ai:** team muốn đóng tiêu chí review thành file dùng chung.

| Cách | File | Gọi thế nào | Hợp khi |
|---|---|---|---|
| Prompt file | `.github/prompts/<ten>.prompt.md` | `/prompts` để liệt kê, rồi gõ `/ten` | Bạn chủ động gọi, chạy ở Local harness |
| Agent skill | `.github/skills/<ten>/SKILL.md` | Model tự kích hoạt khi khớp mô tả | Việc mới, cần chạy được cả trên Copilot/GitHub.com/CLI |

> **Cách đọc bảng này:** hai dòng là hai thế hệ của cùng một nhu cầu — dòng trên vẫn dùng tốt cho việc cũ, nhưng đừng "trồng thêm" ở đó nếu bạn cần nó chạy ngoài Local.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

`/prompts` mở trình **Configure Prompt Files** (liệt kê prompt có trong `.github/prompts/`); tạo file mới thì chạy **`Chat: New Prompt File`** ở Command Palette, hoặc mở **`Chat: Open Customizations`** để xem cả mục Customizations.

## Ví dụ thật

Bạn có PR đang mở và muốn review theo đúng tiêu chí team (bug + test thiếu + migration an toàn) thay vì tự nhớ mỗi lần một kiểu.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** prompt chạy đúng form đã đóng gói, bạn không gõ lại cả đoạn tiêu chí.

**✅ Verify:** chạy trên 2 diff khác nhau — cùng một khung output, chỉ khác nội dung.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — mỗi người tự chế prompt trong máy:** bạn để `review-checklist.txt` ở Desktop, đồng nghiệp để bản khác trong Notes → mỗi người review một kiểu, sửa tiêu chí không ai được cập nhật.

**✅ ĐÚNG — commit vào repo:** `.github/prompts/review-pr.prompt.md` → cả team gọi `/review-pr`, sửa checklist thì mở PR review như code.

**Bài học:** prompt tái dùng phải sống **trong repo** mới chuẩn hóa được; nằm ở máy cá nhân thì chỉ mình bạn dùng và sinh drift.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ `/` không thấy prompt nào | Session đang là harness **Copilot** (prompt file chỉ chạy ở Local) | Đổi session sang **Local**, hoặc port sang skill |
| File có nhưng không liệt kê | Sai chỗ/thiếu đuôi `.prompt.md`, thiếu frontmatter | Đặt đúng `.github/prompts/`, đuôi `.prompt.md`, có `description` |
| Output mỗi lần một form | Prompt thiếu tiêu chí "thế nào là xong" | Thêm checklist xong-việc vào thân prompt |

> **Cách đọc bảng này:** hàng 1 là hàng dễ bị quy oan "lỗi công cụ" — trong 90% trường hợp bạn đang đứng ở harness sai, không phải file bị hỏng.

## So sánh với Claude Code

| Việc cần làm | Copilot Local (prompt file) | Claude Code | Ghi chú |
|---|---|---|---|
| Lệnh tái dùng gọi tay | `.github/prompts/*.prompt.md`, gõ `/ten` | `.claude/commands/*.md`, gõ `/ten` | Cùng ý tưởng, khác thư mục/đuôi file |
| Tự nạp khi khớp ngữ cảnh | Không — prompt file luôn phải gọi tay | **Agent Skills** (`SKILL.md`) | Copilot cũng có skills: [agent-skill](../../../copilot/system-knowledge/agent-skill/README.md) |
| Phạm vi chạy | Chỉ session **Local** trong Chat view | Chạy trong Claude Code | [Feature matrix](https://docs.github.com/en/copilot/reference/copilot-feature-matrix) đánh dấu ✗ prompt files cho GitHub.com và Copilot CLI |

## Best practices (kèm "vì sao")

- **Đóng prompt vào repo, đừng để trong máy.** *Vì sao?* Chỉ khi ở trong git thì cả team mới dùng chung và review được.
- **Một prompt = một việc, có tiêu chí "xong".** *Vì sao?* Prompt ôm nhiều việc cho output nửa vời; tiêu chí xong giúp kết quả kiểm chứng được.
- **Việc mới thì cân nhắc skill trước.** *Vì sao?* Prompt file chỉ chạy ở Local; skill khớp ngữ cảnh và chạy được ở nhiều surface hơn — cách port: [migrate customizations](https://code.visualstudio.com/docs/agent-customization/migrate-customizations).
- **Một việc một nơi.** *Vì sao?* Giữ song song prompt file + skill cho cùng một việc là tự tạo hai bản lệch nhau.

## Bài tập nhỏ

1. **(10')** Tạo `.github/prompts/standup-summary.prompt.md` tóm tắt diff hôm qua theo form cố định, commit, rồi gọi bằng `/standup-summary` trong session Local.
2. **(5')** Mở session **Copilot** và thử gọi lại prompt đó — ghi nhận nó không xuất hiện, giải thích vì sao.
3. **(15')** Port một prompt file sang `.github/skills/<ten>/SKILL.md` rồi test bằng câu nói tự nhiên (không gõ `/`).

## Tham khảo

- [Group index: System & kiến thức repo](../README.md) · [Bài 05 — Agent Skills](../../../../05-agent-skills-reusable-workflows.md) · [Cheatsheet](../../../../../CHEATSHEET.md)
- [VS Code — Prompt files (chỉ Local harness)](https://code.visualstudio.com/docs/agent-customization/prompt-files)
- [VS Code — Configure chat customization files](https://code.visualstudio.com/docs/agents/reference/custom-agent-file-reference)
- [GitHub — Copilot feature matrix](https://docs.github.com/en/copilot/reference/copilot-feature-matrix)
- Bản kế nhiệm: [agent-skill](../../../copilot/system-knowledge/agent-skill/README.md) · Cách migrate: [prompt-file → skill](https://code.visualstudio.com/docs/agent-customization/migrate-customizations)
