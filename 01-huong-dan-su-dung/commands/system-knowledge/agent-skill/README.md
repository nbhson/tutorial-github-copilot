# /skills — Liệt kê Agent Skills khả dụng

> **Dành cho:** team muốn model tự làm việc chuẩn mà không cần nhớ lệnh · **Vấn đề:** nhầm skill với prompt/agent nên gọi sai cách · **Đọc xong:** biết `/skills` liệt kê gì và khi nào model tự kích hoạt (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: danh sách kỹ năng tự động — cần là model tự rút ra dùng, khỏi gọi tên. `/skills` liệt kê Agent Skills (folder có `SKILL.md`). Prompt = gọi tay; Skill = model tự gọi; Agent = người làm việc riêng.

## Khi nào dùng

Section này trả lời: khi nào cần skill thay vì prompt file, và làm sao để skill tự kích hoạt đúng.

- **Cho ai:** người thiết lập skill cho team, người muốn model tự chọn cách làm chuẩn.
- Muốn model tự biết “review PR thì làm gì”.
- Chuẩn hóa kỹ năng team (không phụ thuộc nhớ tên).
- So sánh skill vs prompt/agent để chọn đúng.

## Cách gọi (copy-paste)

Cách gọi `/skills` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/skills
# rồi nhờ việc thường: “review PR giúp tôi” → model tự gọi skill
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/skills`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/skills` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
“review PR giúp tôi” → model tự gọi Skill review-pr (không cần gõ /review-pr)
```

**Kết quả mong đợi:** Model tự kích hoạt đúng skill; output chuẩn skill; bạn không cần nhớ tên.

**Cách verify:** Nhờ 1 việc quen → model báo đã dùng skill X là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Skill không kích hoạt | Mô tả skill mờ / trigger sai | Viết description rõ “dùng khi ...” + test 3 câu |
| Nhầm skill vs prompt | Chưa rõ khác biệt | Prompt = gọi tay; Skill = model tự gọi; Agent = người làm |
| Skill quá to | Ôm cả quy trình | Mỗi skill 1 kỹ năng + ví dụ input/output |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
