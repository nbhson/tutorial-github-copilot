# 00 — Bộ plan tái cấu trúc `01-huong-dan-su-dung/` (11/2026)

**Mục tiêu của bộ plan:** khoá học chỉ dạy **Copilot harness**; mỗi chủ đề có **một chủ sở hữu duy nhất**; mọi khẳng định **đối chiếu được với docs chính thức**; độ dài về **150–200 dòng/bài**; `commands/` tách thành **`copilot/` · `local/` · `cloud/`**.

> Bộ plan này **chưa sửa file khoá học nào**. Toàn bộ `plan-update/` là untracked. Bước đầu tiên của thi công là W0 trong file `05`.

## Đọc theo thứ tự nào

| File | Trả lời câu hỏi | Khi nào cần |
|---|---|---|
| `01-hien-trang-va-benh.md` | Hiện trạng đo được ra sao, bệnh gì, trùng lặp ở đâu, **ai sở hữu khối nào** | trước khi sửa bất cứ gì |
| `02-chuan-doi-chieu-docs.md` | **Luật biên tập**: docs VS Code + docs GitHub nói gì (slash commands, phím, customization × harness, permissions, migrate, billing) | mọi lúc — đây là căn cứ khi file `03`/`04` bảo "cắt" |
| `03-ke-hoach-tung-bai.md` | README + 18 bài: **GIỮ / CẮT-DỜI / SỬA / NỘP**, đích số dòng từng bài | khi làm W4 |
| `04-ke-hoach-commands.md` | 47 slug → 3 bucket, slug mới, **quy tắc rewrite link + script move** | khi làm W2/W5 |
| `05-trinh-tu-va-kiem-chung.md` | 8 wave, 3 script QA, acceptance criteria, rollback | khi bắt đầu & khi đóng PR |
| `06-doi-chieu-docs-github.md` | Phụ lục: 10 chủ đề × (khẳng định ⟂ docs GitHub × URL × cờ rủi ro) | tra cứu khi sửa bài 05/07/09/12/14/16 |

## Ba con số nền (đo ngày 10/11/2026)

- **Bài học:** 5.460 dòng / 18 bài + README (TB **303**), 5 bài >340 dòng → đích **3.300 dòng** (cắt 39,6%, TB **180**). **Đã mở đường: bài 05 rewrite 320 → 200 dòng + rename `05-agent-skills-reusable-workflows.md`** (xem `03` §05).
- **Lệnh:** 4.619 dòng / 47 slug (TB **98**) → **55 slug** (thêm 9 có nguồn docs, xoá 1 đã retired, đổi tên 2).
- **Link:** 225 link tương đối bên trong `commands/` + 47 link trỏ vào slug `commands/` từ ngoài (+5 chỗ text) → **0 gãy** (`09:57` đã sửa 2026-11-11), 99 link phải +1 cấp khi move.

## Sáu quyết định đã chốt (10/11/2026)

1. **Không xoá để chữa cháy, mà dời.** 19 khối trùng lặp có chủ sở hữu duy nhất (bảng ownership, file `01` mục 3); nơi khác tối đa 3 dòng + link.
2. **5 bài được quyền so sánh harness** (00, 02, 10, 17 + `commands/local`/`cloud` indexes) — nhưng vẫn phải nén; 13 bài còn lại **không** nhắc Local/Cloud quá 6 dòng.
3. **Tiêu chí bucket** ✅: `copilot/` = *lệnh chạy được trong Copilot harness session* (kể cả harness-agnostic) → **copilot 42 · local 8 · cloud 5** (từ 47 slug: xoá 1, thêm 9, đổi tên 2). 5 slug vùng xám giữ nguyên theo tiêu chí này.
4. **Thêm đủ 9 slug mới** ✅ (P1 + P2), dù `commands/` tăng ~1.200 dòng — net toàn repo vẫn −960 và course dạy đúng bộ lệnh mà docs thật sự có.
5. **Format "Mục tiêu bài học" giữ nguyên 18/18**, chỉ siết số gạch; khuôn 13 mục README lệnh giữ nguyên; **sửa rule "300–450 dòng" trong `CONTRIBUTING.md`** (gốc bệnh phình).
6. **Việc duy nhất còn mở:** 5 câu verify trong session thật — `05` §0b (export / Quick Chat / `/rename` / checkpoints / slash CLI).

## Việc dài nhất & rủi ro nhất

- Dài nhất: **W4** (rewrite 18 bài) — nhưng cơ học vì mọi lệnh đã ghi theo từng §.
- Rủi ro nhất: **W2** (move + rewrite link) — một bước sai là **225 link gãy** cùng lúc → gate `linkcheck.js = 0`, làm trên branch riêng, move theo `bucket.tsv` để có thể reset.
- Chưa biết trước: 5 câu verify (§0 file `05`) — docs VS Code **không** công bố bảng harness-support cho checkpoints/export/rename, nên phải mở session thật 15 phút.
