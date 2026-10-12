# /pr — PR title + body + checklist test

> **Dành cho:** dev mở PR cho nhánh vừa xong · **Vấn đề:** body chung chung khiến reviewer phải hỏi lại · **Đọc xong:** ra title + body có Đổi gì / Vì sao / Test, reviewer đọc 1 phút là hiểu (~2 phút)

## 1 câu nôm na

Nhờ viết "bìa hồ sơ" — tên, nội dung, đã kiểm tra những gì. `/pr` tóm tắt diff thành title + body + checklist test; nhưng nếu diff to thì phải **chia PR nhỏ trước**, vì không lời tóm tắt nào cứu được một PR ôm 40 file.

## Vì sao dùng /pr?

Body PR là nơi reviewer đọc **đầu tiên** — viết tốt thì được review nhanh, viết chung chung thì reviewer phải hỏi lại rồi ngồi chờ bạn trả lời. `/pr` dựng sẵn khung Đổi gì / Vì sao / Test nên không quên mục nào, và checklist test đã chạy giúp reviewer tin hơn. Với team cần chuẩn hóa format PR, đây là cách rẻ nhất để mọi PR trông giống nhau.

**Nếu làm sai thì sao?** Mặt trái là **PR quá to**: body có hay cỡ nào cũng không cứu được diff ôm nhiều mục đích — reviewer bối rối, comment lan man, merge chậm. Và body thiếu mục **rủi ro** khiến người merge không biết chỗ nào cần soi kỹ (xem mục ❌/✅).

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bạn mở PR cho nhánh vừa xong, cần body nêu rõ đổi gì + test gì, hoặc muốn chuẩn hóa PR cho team dễ review.
- **ĐỪNG dùng khi:** nhánh đang gộp nhiều việc không liên quan (hãy tách PR trước), hoặc bạn mới chỉ muốn xem diff để tự hiểu (`/diff` / `/review`).
- **Cho ai:** mọi người mở PR, đặc biệt team cần chuẩn hóa format PR.

## Cách gọi (copy-paste)

```bash
/pr

/pr tóm tắt diff thành title + body + checklist test
# Kỳ vọng: title conventional + body Đổi gì / Vì sao / Test
```

> `/pr` không xuất hiện khi gõ `/` trong Chat? Xem `/status` + plan trước khi kết luận lệnh lỗi.

## Ví dụ thật

Nghiệp vụ: nhánh `feat/login-rate-limit` vừa thêm giới hạn số lần đăng nhập + test, sắp mở PR.

```bash
# 1. Push branch lên remote
# 2. Gọi:
/pr "tóm tắt diff này: title conventional, body có Đổi gì / Vì sao / Test, checklist đã chạy"
# Verify: teammate đọc body 1 phút không cần hỏi thêm
```

**Kết quả mong đợi:** title conventional + body rõ (đổi gì, vì sao, test, rủi ro); reviewer đọc 1 phút là hiểu và biết chỗ nào cần soi.

**✅ Verify:** đưa body cho 1 teammate đọc — không phải hỏi lại câu nào là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — nhánh gộp nhiều việc, body chung chung:**

```bash
# nhánh gồm cả rate-limit + rename folder + upgrade dep
/pr   # -> "feat: improve login", reviewer không biết bắt đầu từ đâu
```

**✅ ĐÚNG — PR một mục đích, body có Test + Rủi ro:**

```bash
/pr "title conventional; body: Đổi gì / Vì sao / Test đã chạy / Rủi ro còn lại"
```

**Bài học:** PR nhỏ, một mục đích thì body mới rõ; mục **Test** và **Rủi ro** là bắt buộc, không phải tùy chọn.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Body chung chung | Diff quá to | Chia PR nhỏ; mỗi PR 1 mục đích |
| Thiếu phần test/rủi ro | Prompt thiếu | Bắt buộc có mục Test + Rủi ro |
| Title sai chuẩn team | Chưa nêu chuẩn | Nêu chuẩn title của team trong prompt |

## So sánh với Claude Code

| Việc | Copilot (`/pr`) | Claude Code | Ghi chú |
|---|---|---|---|
| Sinh PR title + body | Slash command có sẵn `/pr` | Không có lệnh riêng — yêu cầu bằng prompt hoặc tự tạo command | Cùng việc, Copilot có sẵn nút |
| Đọc diff của nhánh | Tóm tắt từ diff/branch hiện tại | Agent tự đọc `git diff` khi được yêu cầu | Cả hai đều cần bạn nêu đúng nhánh/base |
| Kiểm chứng | Bạn đọc lại body trước khi tạo PR | Bạn vẫn đọc lại | Tạo PR là hành động thật, bản nháp không tự đăng |

## Best practices (kèm "vì sao")

- **Giữ PR một mục đích, diff nhỏ.** *Vì sao?* Reviewer tốn ít thời gian hơn, comment tập trung, merge nhanh hơn.
- **Body luôn có mục Test đã chạy.** *Vì sao?* Reviewer cần biết bạn đã kiểm chứng gì để tin, thay vì tự đoán.
- **Nêu rõ "rủi ro còn lại".** *Vì sao?* Nói ra chỗ chưa chắc giúp người merge soi đúng chỗ và giảm bất ngờ sau deploy.
- **Luôn đọc lại body trước khi tạo PR.** *Vì sao?* `/pr` chỉ sinh nháp — PR là thứ đồng nghiệp nhìn thấy, bạn vẫn là người chịu trách nhiệm.

## Bài tập nhỏ

1. **(5 phút)** Chạy `/pr` không nêu chuẩn, rồi chạy lại có nêu chuẩn title của team. So sánh.
2. **(10 phút)** Viết body cho 1 PR với đủ mục Test + Rủi ro; nhờ 1 teammate đọc xem họ còn hỏi lại gì.
3. **(10 phút)** Lấy 1 nhánh "ôm" nhiều việc, tách thành 2 PR nhỏ — ghi lại PR nào review nhanh hơn.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Bước trước đó (commit message): `/commit` — [../commit-message/README.md](../commit-message/README.md).

> Chốt: PR là **lời đề nghị bạn gửi đồng nghiệp**, không phải bản báo cáo cho chính bạn — viết để reviewer hiểu trong 1 phút và biết chính xác chỗ nào cần soi.
