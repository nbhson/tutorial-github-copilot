# /skills — Liệt kê Agent Skills khả dụng

> Nôm na: danh sách kỹ năng tự động — cần là model tự rút ra dùng, khỏi gọi tên.

## Lệnh làm gì (1 câu nôm na)

Nôm na: danh sách kỹ năng tự động — cần là model tự rút ra dùng, khỏi gọi tên. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Muốn model tự biết “review PR thì làm gì”.
- Chuẩn hóa kỹ năng team (không phụ thuộc nhớ tên).
- So sánh skill vs prompt/agent để chọn đúng.

## Cách gọi (copy-paste)

```bash
/skills
# rồi nhờ việc thường: “review PR giúp tôi” → model tự gọi skill
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/skills`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
“review PR giúp tôi” → model tự gọi Skill review-pr (không cần gõ /review-pr)
```

**Kết quả mong đợi:** Model tự kích hoạt đúng skill; output chuẩn skill; bạn không cần nhớ tên.

**Cách verify:** Nhờ 1 việc quen → model báo đã dùng skill X là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Skill không kích hoạt | Mô tả skill mờ / trigger sai | Viết description rõ “dùng khi ...” + test 3 câu |
| Nhầm skill vs prompt | Chưa rõ khác biệt | Prompt = gọi tay; Skill = model tự gọi; Agent = người làm |
| Skill quá to | Ôm cả quy trình | Mỗi skill 1 kỹ năng + ví dụ input/output |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
