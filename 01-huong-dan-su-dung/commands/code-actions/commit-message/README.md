# /commit — Message chuẩn conventional từ diff

> Nôm na: nhìn đống hàng đã gói, viết phiếu gửi đúng mẫu bưu điện.

## Lệnh làm gì (1 câu nôm na)

Nôm na: nhìn đống hàng đã gói, viết phiếu gửi đúng mẫu bưu điện. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Vừa stage xong, cần message gọn đúng chuẩn.
- Team ép conventional commits.
- Muốn message nêu được “đổi gì + vì sao”.

## Cách gọi (copy-paste)

```bash
Stage changes → /commit
/commit theo conventional, tiếng Anh, <72 chars
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/commit`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/commit “viết message conventional từ staged diff, tiếng Anh, dòng đầu <72 chars”
```

**Kết quả mong đợi:** Message feat/fix(scope): ... + body ngắn; commit log sạch, CI parse được.

**Cách verify:** Đọc message 5 giây hiểu “đổi gì” là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Message chung chung (“update stuff”) | Diff stage quá to/lộn xộn | Stage gọn từng phần, commit từng phần |
| Sai scope conventional | Model đoán scope | Nêu scope đúng trong prompt |
| Quên bối cảnh “vì sao” | Chỉ liệt kê “đổi gì” | Thêm “vì sao” 1 dòng vào body |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
