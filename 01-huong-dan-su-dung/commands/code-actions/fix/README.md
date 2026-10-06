# /fix — Sửa lỗi/selection nhanh hơn gõ tay

> Nôm na: khoanh chỗ đau, bảo “chữa chỗ này, đừng đụng chỗ khác”.

## Lệnh làm gì (1 câu nôm na)

Nôm na: khoanh chỗ đau, bảo “chữa chỗ này, đừng đụng chỗ khác”. Nhanh hơn gõ prompt tay vì scope đã gắn sẵn vào selection.

## Khi nào dùng

- Lỗi nhỏ: null check, type error, test fail 1 chỗ.
- Đã biết lỗi ở đâu, chỉ cần sửa gọn.
- Sửa message/log/typo theo chuẩn repo.

## Cách gọi (copy-paste)

```bash
Bôi đen chỗ lỗi → /fix
/fix thêm null check cho params, giữ nguyên API shape
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/fix`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen dòng lỗi) /fix “thêm null check cho params, giữ nguyên API shape”
```

**Kết quả mong đợi:** Diff nhỏ đúng chỗ đau, không lan sang logic khác; test liên quan xanh.

**Cách verify:** Chạy test/build/lint cho file vừa sửa — xanh là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Sửa lan sang logic khác | Mô tả thiếu “giữ nguyên ...” | Thêm “không đổi logic khác” vào prompt |
| Fix xong vẫn fail test | Lỗi sâu hơn 1 chỗ | Chuyển sang Edit/Agent mode điều tra |
| Không bôi đen mà gọi /fix | Model đoán scope | Bôi đen chính xác rồi gọi lại |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
