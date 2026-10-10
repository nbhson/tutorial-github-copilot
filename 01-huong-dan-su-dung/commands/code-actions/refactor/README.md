# /refactor — Refactor gọn mà giữ behavior

> **Dành cho:** dev cấu trúc lại code mà không đổi hành vi · **Vấn đề:** refactor kèm bug vì không có test bao · **Đọc xong:** code gọn hơn mà test cũ vẫn xanh (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: dọn nhà không vứt đồ — gọn hơn nhưng đồ đạc vẫn đủ. Bôi đen rồi `/refactor`; chạy test trước/sau và ghi rõ “giữ nguyên behavior”.

## Khi nào dùng

Section này trả lời: khi nào refactor riêng lẻ, và ranh giới giữa refactor với thêm tính năng.

- **Cho ai:** dev dọn code định kỳ, người tách hàm/file quá dài.
- Hàm/file quá dài, muốn tách nhỏ.
- Trùng code 3 chỗ, muốn gom 1.
- Đổi tên/tách module nhưng giữ behavior.

## Cách gọi (copy-paste)

Cách gọi `/refactor` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Bôi đen → /refactor
/refactor tách hàm này thành 3 hàm nhỏ, giữ nguyên behavior
# Kỳ vọng: code gọn hơn, tên rõ hơn, test cũ vẫn xanh
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/refactor`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/refactor` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen hàm 100 dòng) /refactor “tách thành validate/process/save, giữ nguyên behavior + có test bao”
# Verify: chạy full test liên quan — xanh hết là đạt
```

**Kết quả mong đợi:** Code gọn hơn, tên rõ hơn; toàn bộ test cũ vẫn xanh (behavior giữ nguyên).

**Cách verify:** Chạy full test liên quan — xanh hết là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Refactor đổi luôn behavior | Thiếu test bao + prompt thiếu “giữ nguyên” | Chạy test trước/sau; prompt ghi “giữ nguyên behavior” |
| Tách quá vụn khó đọc | Tham tách | Tách vừa đủ: mỗi hàm 1 việc, tên nói được việc |
| Refactor + thêm tính năng 1 lúc | Ôm 2 việc | Refactor riêng 1 commit, tính năng riêng 1 commit |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
