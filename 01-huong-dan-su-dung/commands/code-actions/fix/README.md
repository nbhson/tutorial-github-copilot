# /fix — Sửa lỗi/selection nhanh hơn gõ tay

> **Dành cho:** dev đã biết lỗi ở đâu · **Vấn đề:** gõ prompt tay mất công mô tả lại scope · **Đọc xong:** sửa gọn đúng chỗ đau, không lan sang logic khác (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: khoanh chỗ đau, bảo “chữa chỗ này, đừng đụng chỗ khác”. Bôi đen chỗ lỗi rồi `/fix` — nhanh hơn prompt tay vì selection đã gắn sẵn vào scope.

## Khi nào dùng

Section này trả lời: lỗi nào hợp `/fix`, lỗi nào phải chuyển Edit/Agent mode.

- **Cho ai:** dev sửa lỗi nhỏ lẻ hằng ngày: null check, type error, test fail một chỗ.
- Lỗi nhỏ: null check, type error, test fail 1 chỗ.
- Đã biết lỗi ở đâu, chỉ cần sửa gọn.
- Sửa message/log/typo theo chuẩn repo.

## Cách gọi (copy-paste)

Cách gọi `/fix` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Bôi đen chỗ lỗi → /fix
/fix thêm null check cho params, giữ nguyên API shape
# Kỳ vọng: diff nhỏ đúng chỗ đau, không lan logic khác
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/fix`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/fix` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen dòng lỗi) /fix “thêm null check cho params, giữ nguyên API shape”
# Verify: chạy test/build/lint cho file vừa sửa — xanh là đạt
```

**Kết quả mong đợi:** Diff nhỏ đúng chỗ đau, không lan sang logic khác; test liên quan xanh.

**Cách verify:** Chạy test/build/lint cho file vừa sửa — xanh là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Sửa lan sang logic khác | Mô tả thiếu “giữ nguyên ...” | Thêm “không đổi logic khác” vào prompt |
| Fix xong vẫn fail test | Lỗi sâu hơn 1 chỗ | Chuyển sang Edit/Agent mode điều tra |
| Không bôi đen mà gọi /fix | Model đoán scope | Bôi đen chính xác rồi gọi lại |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
