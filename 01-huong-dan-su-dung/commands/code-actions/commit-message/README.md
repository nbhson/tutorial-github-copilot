# /commit — Message chuẩn conventional từ diff

> **Dành cho:** dev vừa stage xong và sắp commit · **Vấn đề:** message "update stuff" không nói được đổi gì + vì sao · **Đọc xong:** ra message conventional dưới 72 ký tự từ staged diff (~2 phút)

## 1 câu nôm na

Nhìn đống hàng đã gói, viết phiếu gửi đúng mẫu bưu điện. `/commit` đọc **staged diff** rồi viết message theo conventional commits (feat/fix + scope + mô tả); nó chỉ nhìn phần bạn đã stage, nên stage gọn từng phần thì message mới đúng.

## Vì sao dùng /commit?

Message tốt là message nói được cả **đổi gì** lẫn **vì sao** — thứ mà `git log` sẽ trả lời cho đồng nghiệp (và cho chính bạn) sáu tháng sau. `/commit` dựng sẵn dòng đầu theo chuẩn conventional (để CI/changelog parse được) kèm một body ngắn. Nó biến việc "nghĩ message" từ 2 phút xuống 10 giây, và quan trọng hơn: giữ log của cả team nhất quán.

**Nếu làm sai thì sao?** Cạm bẫy là **stage quá to rồi commit một cục**: diff lộn xộn thì message sinh ra cũng chung chung (`chore: update files`) — đúng cái bạn muốn tránh. Và nhớ `/commit` chỉ *gợi ý*: commit là hành động thật, bạn vẫn phải đọc lại message trước khi Enter (xem mục ❌/✅).

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bạn vừa stage xong và cần message gọn đúng chuẩn, team ép conventional commits, hoặc muốn message nêu được "đổi gì + vì sao".
- **ĐỪNG dùng khi:** bạn chưa stage gì (nó chỉ nhìn staged diff), hoặc thay đổi gộp nhiều mục đích — hãy tách thành nhiều commit trước.
- **Cho ai:** dev commit hằng ngày, team đang ép conventional commits.

## Cách gọi (copy-paste)

```bash
# Stage changes, rồi:
/commit

/commit theo conventional, tiếng Anh, <72 chars
# Kỳ vọng: message feat/fix(scope): ... + body ngắn
```

> `/commit` không xuất hiện khi gõ `/` trong Chat? Chạy `/status` + xem plan trước khi kết luận lệnh hỏng.

## Ví dụ thật

Nghiệp vụ: vừa thêm null check cho email có dấu trong luồng login (fix bug 500), đã `git add` đúng 2 file.

```bash
# 1. git add src/auth/login.ts src/auth/login.test.ts
# 2. Gọi:
/commit "viết message conventional từ staged diff, tiếng Anh, dòng đầu <72 chars"
# Verify: đọc message 5 giây là hiểu đổi gì + vì sao
```

**Kết quả mong đợi:** `fix(auth): handle accented email in login` kèm body ngắn nêu nguyên nhân — log sạch, CI parse được.

**✅ Verify:** đọc lại message trong 5 giây mà hiểu "đổi gì + vì sao" là đạt; không thì sửa tay trước khi commit.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — stage một cục lộn xộn rồi commit luôn message gợi ý:**

```bash
git add .            # gộp cả refactor + fix + format
/commit              # -> "chore: update files", chẳng nói được gì
```

**✅ ĐÚNG — stage gọn theo mục đích, đọc lại message:**

```bash
git add src/auth/login.ts src/auth/login.test.ts
/commit "conventional, tiếng Anh, <72 chars, body nêu vì sao fix"
# đọc lại, sửa nếu cần, rồi mới commit
```

**Bài học:** message tốt bắt đầu từ **diff gọn**; và `/commit` chỉ sinh nháp — commit là hành động thật, bạn duyệt cuối.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Message chung chung ("update stuff") | Diff stage quá to/lộn xộn | Stage gọn từng phần, commit từng phần |
| Sai scope conventional | Model đoán scope | Nêu scope đúng trong prompt |
| Quên bối cảnh "vì sao" | Chỉ liệt kê "đổi gì" | Thêm 1 dòng "vì sao" vào body |

## So sánh với Claude Code

| Việc | Copilot (`/commit`) | Claude Code | Ghi chú |
|---|---|---|---|
| Sinh commit message | Slash command có sẵn `/commit` | Không có lệnh riêng — yêu cầu bằng prompt hoặc tự tạo command | Cùng việc, Copilot có sẵn nút |
| Đọc staged diff | Lấy diff đã stage làm nguồn | Cũng đọc `git diff --staged` khi được yêu cầu | Cả hai chỉ thấy phần đã stage |
| Kiểm chứng | Bạn đọc lại message trước khi commit | Bạn vẫn đọc lại | Commit là hành động thật, không tin mù bản nháp |

## Best practices (kèm "vì sao")

- **Stage gọn theo một mục đích trước khi gọi `/commit`.** *Vì sao?* Message chỉ tốt bằng diff nó nhìn thấy — diff lộn xộn thì message cũng lộn xộn.
- **Nêu rõ ngôn ngữ + giới hạn ký tự + chuẩn.** *Vì sao?* Mỗi team một chuẩn; nói ra để message dùng được ngay, khỏi sửa tay.
- **Bắt body nêu "vì sao", không chỉ "đổi gì".** *Vì sao?* Diff đã cho biết "đổi gì"; thứ log không tự nói được là lý do.
- **Luôn đọc lại trước khi commit.** *Vì sao?* `/commit` sinh nháp; commit sai phải viết lại lịch sử — phiền hơn nhiều.

## Bài tập nhỏ

1. **(5 phút)** `git add .` rồi `/commit`, xem message ra sao; sau đó stage gọn 1 file và làm lại. So sánh.
2. **(10 phút)** Chạy `/commit` cho 1 fix thật, bắt body phải có 1 dòng "vì sao". Đọc lại xem 6 tháng sau bạn có hiểu không.
3. **(10 phút)** Soạn 1 commit với message `update stuff` do chính bạn viết tay, rồi để `/commit` viết lại — ghi lại chênh lệch.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Bước tiếp theo sau commit (mở PR): `/pr` — [../pr-desc/README.md](../pr-desc/README.md).

> Chốt: log của bạn là cuốn nhật ký đọc lại lúc 2 giờ sáng đang sửa sự cố — viết message sao cho tương lai thấy được **đổi gì và vì sao**, chứ không phải "update stuff".
