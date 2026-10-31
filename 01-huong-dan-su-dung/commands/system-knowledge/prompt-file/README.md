# /prompts — Liệt kê và gọi prompt files tái dùng (legacy)

> **Dành cho:** team có việc lặp lại (review, deploy, tạo bảng) · **Vấn đề:** mỗi người gõ prompt một kiểu, không chuẩn hóa được · **Đọc xong:** gọi prompt file tái dùng đúng form bằng một lệnh (~2 phút)
>
> **Lưu ý 2026:** `/prompts` (`.github/prompts/*.prompt.md`) đã **legacy/deprecated cho Agent Host** (Copilot/Cloud). Việc mới nên làm bằng **`/skills`** (`.github/skills/<ten>/SKILL.md`, chuẩn mở, chạy mọi harness) — xem [../agent-skill/README.md](../agent-skill/README.md) và cách port ở [bài 05 mục 3.3](../../../05-prompt-files-custom-instructions.md).

## 1 câu nôm na

`/prompts` mở hộp công thức nấu ăn của team: món nào nấu nhiều lần thì lôi công thức có sẵn ra thay vì nhớ lại từng bước. Gõ `/review-pr` là chạy đúng form cả team đã thống nhất, không phải paste lại cả đoạn dài mỗi lần.

## Vì sao dùng /prompts?

Một việc lặp lại gõ tay 5 lần thì 3 lần bạn sẽ quên một bước, và hai người sẽ ra hai form khác nhau. Đóng checklist vào một prompt file rồi commit vào repo thì: form cố định, mọi người chạy giống nhau, và bản mới nhất được review như code. Giá trị thật của `/prompts` là **chuẩn hóa**, không phải gõ tắt.

**Nếu làm sai thì sao?** Nếu mỗi người giữ một bản prompt riêng trong máy, repo có 5 form review khác nhau, không ai biết bản nào đúng; và khi bạn sửa checklist xong nó cũng chẳng lan tới ai.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** có việc lặp lại (review PR, deploy, sinh bảng/migration) và bạn muốn **chủ động gọi tay** đúng form team; repo cũ đã có sẵn `.github/prompts/`.
- **ĐỪNG dùng khi:** bạn muốn agent **tự nạp khi đúng ngữ cảnh** (chọn skill — [../agent-skill/README.md](../agent-skill/README.md)); việc chỉ làm một lần (gõ prompt tự nhiên là đủ); hay cần chạy trên Cloud/Copilot harness (prompt file không chạy ở đó).

> `/prompts` vs `/skills` (2026):

| Cách | File | Khi nào dùng |
|---|---|---|
| `/prompts` (legacy) | `.github/prompts/*.prompt.md` | Repo cũ còn dùng, bạn chủ động gõ tên prompt |
| `/skills` (ưu tiên) | `.github/skills/<ten>/SKILL.md` | Muốn model tự kích hoạt, chạy mọi harness |

## Cách gọi (copy-paste)

```bash
/prompts
# liệt kê prompt files có trong .github/prompts/ rồi gọi theo tên, vd /review-pr
# Kỳ vọng: prompt chạy đúng form team, không phải gõ lại cả đoạn
# Verify: chạy 2 lần cho 2 diff khác nhau — ra cùng form output
```

> Không thấy `/prompts` trong list khi gõ `/`? Kiểm `/status` + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: bạn có PR đang mở và muốn review theo đúng tiêu chí team (bug + test thiếu + migration an toàn), thay vì mỗi lần tự nhớ một kiểu.

```bash
# Team đã commit .github/prompts/review-pr.prompt.md với checklist cố định.
/review-pr "review diff hiện tại: nêu 3 lỗi lớn nhất + gợi ý test còn thiếu"

# So sánh 2 lần chạy:
#  - Lần 1: PR feat/refund
#  - Lần 2: PR fix/login-email
# → cả 2 phải ra CÙNG khung output (3 lỗi + phần test thiếu), chỉ khác nội dung.
```

**Kết quả mong đợi:** prompt chạy đúng form team đã đóng gói; bạn không phải gõ lại cả đoạn tiêu chí.

**✅ Verify:** chạy cho 2 diff khác nhau — cùng form output là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — mỗi người tự chế prompt trong máy:**

```text
Bạn lưu review-checklist.txt ở Desktop, đồng nghiệp lưu bản khác ở Notes
→ mỗi người review một kiểu, sửa tiêu chí thì không ai được cập nhật.
```

**✅ ĐÚNG — đóng thành prompt file trong repo rồi commit:**

```text
.github/prompts/review-pr.prompt.md → commit → cả team gọi /review-pr
→ form giống nhau, sửa checklist là mở PR review như code.
```

**Bài học:** prompt tái dùng phải sống **trong repo** mới chuẩn hóa được; để trong máy cá nhân thì chỉ mình bạn dùng, còn sinh ra drift.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Prompt file không hiện | Sai chỗ hoặc thiếu frontmatter | File phải ở `.github/prompts/` và có frontmatter đúng |
| Prompt trả lời chung chung | Thiếu tiêu chí “thế nào là xong” | Thêm checklist xong-việc vào thân prompt |
| Ai cũng tự chế prompt riêng | Chưa có chuẩn team | Gom prompt hay vào repo, xóa bản lẻ |

## So sánh với Claude Code

| Việc | Copilot (`/prompts`, legacy) | Claude Code | Ghi chú |
|---|---|---|---|
| Lệnh tái dùng gọi tay | Prompt file `.github/prompts/*.prompt.md`, gõ `/ten` | Slash command `.claude/commands/*.md`, gõ `/ten` | Cùng ý tưởng; khác thư mục và đuôi file |
| Tự nạp khi khớp ngữ cảnh | Không (phải gõ tên) | Có — Agent Skills `SKILL.md` | Đây là lý do 2026 Copilot chuyển sang `/skills` |
| Trạng thái 2026 | Legacy — deprecated cho Agent Host | `.claude/commands/` vẫn là cách chính | Việc mới nên port sang `SKILL.md` |

## Best practices (kèm "vì sao")

- **Đóng prompt vào repo, đừng để trong máy.** *Vì sao?* Chỉ khi ở trong git thì cả team mới dùng chung và review được — đó là toàn bộ giá trị của prompt tái dùng.
- **Một prompt = một việc, có tiêu chí “xong”.** *Vì sao?* Prompt ôm nhiều việc sẽ ra output nửa vời; tiêu chí xong giúp kết quả kiểm chứng được.
- **Việc mới thì port sang skill.** *Vì sao?* Prompt file deprecated cho Agent Host; skill chạy Local + Cloud + CLI + app.
- **Một việc một nơi.** *Vì sao?* Giữ song song prompt file và skill cùng một việc sẽ tạo hai bản lệch nhau (drift) rồi không ai biết bản nào đúng.

## Bài tập nhỏ

1. **(10 phút)** Mở `.github/prompts/` (hoặc tạo mới), viết 1 prompt `standup-summary.prompt.md` tóm tắt diff hôm qua theo form cố định, rồi commit.
2. **(10 phút)** Gọi prompt đó cho 2 ngày khác nhau; so output xem có cùng khung không.
3. **(15 phút)** Port một prompt file cũ sang `.github/skills/<ten>/SKILL.md` theo [bài 05 mục 3.3](../../../05-prompt-files-custom-instructions.md), rồi test bằng cách nói từ khóa tự nhiên (không gõ `/`).

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh System & Knowledge.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Bản kế nhiệm (nên dùng cho việc mới): [../agent-skill/README.md](../agent-skill/README.md) · [bài 05](../../../05-prompt-files-custom-instructions.md).

> **Chốt:** `/prompts` vẫn dùng tốt cho việc cũ trên Local, nhưng đừng trồng thêm mới — việc lặp lại từ 2026 nên sống trong `SKILL.md` để agent tự mở và chạy được ở mọi nơi.
