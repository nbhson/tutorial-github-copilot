# /prompts — Liệt kê prompt files tái dùng (**legacy**)

> **Dành cho:** team có việc lặp lại (review, deploy, tạo bảng) · **Vấn đề:** mỗi người tự gõ prompt một kiểu, không chuẩn hóa được · **Đọc xong:** gọi prompt file tái dùng đúng form trong 1 lệnh (~2 phút)
>
> **Lưu ý 2026:** `/prompts` (`.github/prompts/*.prompt.md`) **deprecated cho Agent Host** (Copilot/Cloud). Ưu tiên **`/skills`** (`.github/skills/<ten>/SKILL.md`, chuẩn mở, chạy mọi harness) — xem [agent-skill](../agent-skill/README.md) + bài 05 mục 3.3 (port prompt → skill).

## Lệnh làm gì (1 câu nôm na)

Nôm na: mở hộp công thức — món nào nấu nhiều thì lấy công thức có sẵn. `/prompts` liệt kê file trong `.github/prompts/`; gõ tên prompt (vd `/review-pr`) thay vì gõ lại cả đoạn dài.

## Khi nào dùng

Section này trả lời: việc nào nên dồn vào prompt file, và vì sao team nên gom prompt vào repo.

- **Cho ai:** team muốn chuẩn hóa cách ra lệnh, người lặp lại 1 prompt mỗi tuần.
- Việc lặp lại: review, deploy, tạo bảng.
- Muốn chuẩn hóa cách cả team ra lệnh.
- Tạo prompt mới từ prompt hay cũ.

## Cách gọi (copy-paste)

Cách gọi `/prompts` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/prompts
# gọi prompt file theo tên, vd /review-pr (legacy — deprecated cho Agent Host)
# Kỳ vọng: prompt chạy đúng form team, không cần gõ lại cả đoạn
# Verify: chạy 2 lần cho 2 diff khác nhau — cùng form output
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/prompts`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/prompts` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/review-pr “review diff hiện tại: nêu 3 lỗi lớn nhất + gợi ý test thiếu”
```

**Kết quả mong đợi:** Prompt chuẩn chạy đúng form team; không cần gõ lại cả đoạn dài.

**Cách verify:** Chạy 2 lần cho 2 diff khác nhau — cùng form output là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Prompt file không hiện | Sai chỗ/frontmatter | File phải ở .github/prompts/ + frontmatter đúng |
| Prompt chung chung | Thiếu tiêu chí xong | Thêm checklist xong-việc vào prompt |
| Ai cũng tự chế prompt riêng | Thiếu chuẩn team | Gom prompt hay vào repo, xóa bản lẻ |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
