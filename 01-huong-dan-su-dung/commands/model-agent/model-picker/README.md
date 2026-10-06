# /model — Đổi model giữa chat

> Nôm na: đổi đầu bếp giữa bữa — món khó thì nhờ bếp trưởng, món dễ thì bếp phụ.

## Lệnh làm gì (1 câu nôm na)

Nôm na: đổi đầu bếp giữa bữa — món khó thì nhờ bếp trưởng, món dễ thì bếp phụ. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Việc nhẹ (explain/doc) → model rẻ cho đỡ tốn quota.
- Việc khó (agent/kiến trúc) → model mạnh.
- Model hiện tại trả lời dở → đổi thử.

## Cách gọi (copy-paste)

```bash
/model
# chọn trong list: rẻ cho việc nhẹ, mạnh cho việc khó
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/model`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/model → đổi sang model mạnh rồi hỏi lại câu kiến trúc vừa fail
```

**Kết quả mong đợi:** Model mới trả lời hợp việc hơn; quota tốn đúng chỗ (rẻ cho nhẹ, mạnh cho khó).

**Cách verify:** So 2 câu trả lời rẻ vs mạnh cho cùng prompt — biết khi nào cần mạnh là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Đổi model mà vẫn dở | Vấn đề ở scope, không phải model | Gọn scope (#file) trước, đổi model sau |
| Model cần không có trong list | Plan/BYOK gating | Hỏi admin plan + BYOK list |
| Dùng model mạnh cho mọi việc | Tốn quota | Rẻ mặc định; mạnh chỉ khi khó |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
