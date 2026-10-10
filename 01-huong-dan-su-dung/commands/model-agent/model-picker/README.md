# /model — Đổi model giữa chat

> **Dành cho:** người muốn cân giữa chất lượng trả lời và AI Credits tốn · **Vấn đề:** model mạnh cho việc nhẹ làm tốn credit, model yếu cho việc khó thì trả lời dở · **Đọc xong:** đổi model đúng lúc, biết khi nào cần model mạnh (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: đổi đầu bếp giữa bữa — món khó thì nhờ bếp trưởng, món dễ thì bếp phụ. `/model` mở list model để chọn giữa chừng; việc nhẹ chọn model nhẹ để tiết kiệm AI Credits, việc khó mới chọn model mạnh.

## Khi nào dùng

Section này trả lời: khi nào đổi model, và vì sao đổi model không cứu được prompt thiếu scope.

- **Cho ai:** mọi người dùng Chat — nhất là người tự trả tiền theo usage (AI Credits).
- Việc nhẹ (explain/doc) → model rẻ cho đỡ tốn quota.
- Việc khó (agent/kiến trúc) → model mạnh.
- Model hiện tại trả lời dở → đổi thử.

## Cách gọi (copy-paste)

Cách gọi `/model` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/model
# chọn trong list: rẻ cho việc nhẹ, mạnh cho việc khó
# Kỳ vọng: câu trả lời khớp độ khó của task, quota không phí
# Verify: so 2 câu trả lời rẻ vs mạnh cho cùng prompt
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/model`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/model` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/model → đổi sang model mạnh rồi hỏi lại câu kiến trúc vừa fail
```

**Kết quả mong đợi:** Model mới trả lời hợp việc hơn; quota tốn đúng chỗ (rẻ cho nhẹ, mạnh cho khó).

**Cách verify:** So 2 câu trả lời rẻ vs mạnh cho cùng prompt — biết khi nào cần mạnh là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Đổi model mà vẫn dở | Vấn đề ở scope, không phải model | Gọn scope (#file) trước, đổi model sau |
| Model cần không có trong list | Plan/BYOK gating | Hỏi admin plan + BYOK list |
| Dùng model mạnh cho mọi việc | Tốn quota | Rẻ mặc định; mạnh chỉ khi khó |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
