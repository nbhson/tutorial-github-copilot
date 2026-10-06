# /refactor — Refactor gọn mà giữ behavior

> Nôm na: dọn nhà không vứt đồ — gọn hơn nhưng đồ đạc vẫn đủ.

## Lệnh làm gì (1 câu nôm na)

Nôm na: dọn nhà không vứt đồ — gọn hơn nhưng đồ đạc vẫn đủ. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Hàm/file quá dài, muốn tách nhỏ.
- Trùng code 3 chỗ, muốn gom 1.
- Đổi tên/tách module nhưng giữ behavior.

## Cách gọi (copy-paste)

```bash
Bôi đen → /refactor
/refactor tách hàm này thành 3 hàm nhỏ, giữ nguyên behavior
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/refactor`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen hàm 100 dòng) /refactor “tách thành validate/process/save, giữ nguyên behavior + có test bao”
```

**Kết quả mong đợi:** Code gọn hơn, tên rõ hơn; toàn bộ test cũ vẫn xanh (behavior giữ nguyên).

**Cách verify:** Chạy full test liên quan — xanh hết là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Refactor đổi luôn behavior | Thiếu test bao + prompt thiếu “giữ nguyên” | Chạy test trước/sau; prompt ghi “giữ nguyên behavior” |
| Tách quá vụn khó đọc | Tham tách | Tách vừa đủ: mỗi hàm 1 việc, tên nói được việc |
| Refactor + thêm tính năng 1 lúc | Ôm 2 việc | Refactor riêng 1 commit, tính năng riêng 1 commit |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
