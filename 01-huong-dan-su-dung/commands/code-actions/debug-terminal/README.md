# @terminal — Biến log đỏ thành task fix

> Nôm na: chụp ảnh màn hình lỗi đưa cho thợ — “xe kêu thế này, sửa giúp”.

## Lệnh làm gì (1 câu nôm na)

Nôm na: chụp ảnh màn hình lỗi đưa cho thợ — “xe kêu thế này, sửa giúp”. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Terminal báo lỗi đỏ chưa hiểu.
- Test fail với stack trace dài.
- Lệnh build/deploy fail.

## Cách gọi (copy-paste)

```bash
@terminal
@terminal giải thích lỗi vừa rồi + gợi ý 2 cách fix
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `@terminal`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
@terminal “đọc 30 dòng log cuối, nói nguyên nhân top-1 + gợi ý fix ít rủi ro nhất”
```

**Kết quả mong đợi:** Nguyên nhân top-1 đúng + 1–2 cách fix xếp theo rủi ro; chọn 1 cách làm tiếp.

**Cách verify:** Áp fix xong chạy lại lệnh — hết đỏ là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Log quá dài, model đọc sót | Paste cả 500 dòng | Chỉ lấy 30–50 dòng quanh lỗi + lệnh đã chạy |
| Fix đoán mò | Thiếu context lệnh/môi trường | Nêu lệnh đã chạy + OS + branch |
| Fix mạo hiểm (xóa/force) | Tin luôn không review | Cấm lệnh destructive; review trước khi chạy |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
