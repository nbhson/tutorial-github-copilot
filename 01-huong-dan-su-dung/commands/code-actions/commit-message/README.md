# /commit — Message chuẩn conventional từ diff

> **Dành cho:** dev vừa stage xong và sắp commit · **Vấn đề:** message “update stuff” không nói được đổi gì + vì sao · **Đọc xong:** ra message conventional dưới 72 ký tự từ staged diff (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: nhìn đống hàng đã gói, viết phiếu gửi đúng mẫu bưu điện. Lệnh đọc staged diff rồi viết message theo conventional commits; stage gọn từng phần thì message mới đúng.

## Khi nào dùng

Section này trả lời: lúc nào gọi `/commit`, và làm sao để message nói được cả “đổi gì” lẫn “vì sao”.

- **Cho ai:** dev commit hằng ngày, team đang ép conventional commits.
- Vừa stage xong, cần message gọn đúng chuẩn.
- Team ép conventional commits.
- Muốn message nêu được “đổi gì + vì sao”.

## Cách gọi (copy-paste)

Cách gọi `/commit` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Stage changes → /commit
/commit theo conventional, tiếng Anh, <72 chars
# Kỳ vọng: message feat/fix(scope): ... + body ngắn
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/commit`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/commit` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/commit “viết message conventional từ staged diff, tiếng Anh, dòng đầu <72 chars”
# Verify: đọc message 5 giây là hiểu đổi gì + vì sao
```

**Kết quả mong đợi:** Message feat/fix(scope): ... + body ngắn; commit log sạch, CI parse được.

**Cách verify:** Đọc message 5 giây hiểu “đổi gì” là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Message chung chung (“update stuff”) | Diff stage quá to/lộn xộn | Stage gọn từng phần, commit từng phần |
| Sai scope conventional | Model đoán scope | Nêu scope đúng trong prompt |
| Quên bối cảnh “vì sao” | Chỉ liệt kê “đổi gì” | Thêm “vì sao” 1 dòng vào body |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
