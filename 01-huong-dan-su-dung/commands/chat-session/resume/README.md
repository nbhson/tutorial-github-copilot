# /resume — Tiếp tục phiên chat đã lưu

> **Dành cho:** dev quay lại việc dở từ hôm qua hoặc sau khi IDE tắt/crash · **Vấn đề:** mất bối cảnh, phải giải thích lại từ đầu · **Đọc xong:** mở lại đúng phiên và hỏi tiếp không mất công (~2 phút)

## 1 câu nôm na

Mở lại vở cũ và viết tiếp, khỏi chép lại từ đầu. `/resume` mở lại một phiên chat đã lưu. Nếu không nhớ tên phiên thì đi vòng qua `/history` để tìm, rồi mới resume.

Một điều phải khắc cốt: history chỉ giữ **text**, không giữ nguyên trạng thái tool (file đã đọc, terminal đã chạy). Nên resume xong, đôi khi bạn vẫn phải nhắc lại vài dòng bối cảnh.

## Vì sao dùng /resume?

Không phải việc nào cũng xong trong một buổi. `/resume` giữ lại mạch làm việc để bạn không phải kể lại "task này là gì, đang ở đâu" mỗi sáng:

- **Tiếp mạch việc nhiều ngày** — mở đúng phiên, hỏi tiếp bước đang dở.
- **Cứu phiên bị đóng nhầm** — tắt IDE hoặc crash không làm mất việc.
- **Rẽ nhánh** — từ một chat cũ, mở ra hai hướng thử nghiệm khác nhau.

**Nếu làm sai thì sao?** Ngộ nhận phổ biến là resume về là model đọc lại được toàn bộ trạng thái cũ. Nó không. Thêm nữa, nếu phiên cũ mở lại sau khi code trên đĩa đã đổi, model có thể trả lời theo phiên bản cũ — phải `git diff` + test lại trước khi tin. Xem ❌/✅.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** việc dở hôm qua nay làm tiếp; chat bị đóng nhầm do tắt IDE/crash; muốn rẽ nhánh từ một chat cũ thành hai hướng.
- **ĐỪNG dùng khi:** bạn thực sự muốn một đầu bài sạch cho task mới — đó là `/new`, resume phiên cũ chỉ mang thêm nhiễu.
- **Cho ai:** người làm việc theo ngày, hoặc người bị tắt IDE/crash giữa chừng.

## Cách gọi (copy-paste)

```bash
/resume
# hoặc /history → chọn phiên → tiếp tục
# Kỳ vọng: phiên cũ mở lại đúng chỗ dừng
```

> Kiểm tra lệnh có ở máy bạn không: gõ `/` trong ô Chat, tìm `/resume`. Không thấy → đọc `/status` + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: hôm qua bạn dừng giữa task thêm rate-limit cho `/api/login`, mới xong bước 2 (viết middleware), bước 3 (gắn vào route) còn dở.

```bash
/resume
# Chon phien "them rate-limit cho /api/login" hom qua
# Verify: nhan "tiep tuc buoc 3" -> model lam dung buoc 3
```

**Kết quả mong đợi:** Phiên cũ mở lại đúng chỗ dừng; hỏi tiếp không cần giải thích lại từ đầu.

**✅ Verify:** Nhắn "tiếp tục bước 3 hôm qua" — model làm đúng bước 3 là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — resume xong hỏi tiếp luôn, giả định model còn nguyên trạng thái tool:**

```bash
# Mo lai phien roi: "tiep tuc di"
# -> model khong con nho da doc file nao, de doan mo
```

**✅ ĐÚNG — resume rồi nhắc lại bối cảnh + file liên quan, và kiểm tra code đĩa:**

```bash
# Sau khi resume:
"Nhắc lại: đang thêm rate-limit cho POST /login, đã viết middleware
 ở src/middleware/rateLimit.ts, còn gắn vào route. Code trên đĩa có thể đã đổi — check git diff trước."
```

**Bài học:** Resume khôi phục *cuộc trò chuyện*, không khôi phục *trạng thái hệ thống*. Bạn là người đồng bộ lại hai thứ đó.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Resume nhưng model quên tool state | History chỉ lưu text | Nhắc lại 3 dòng bối cảnh + file liên quan |
| Nhầm phiên cũ khác | Tên chat giống nhau | Đặt tên chat rõ + `/export` bản quan trọng |
| Phiên quá cũ, code đã đổi | Code trên đĩa khác lúc chat | Chạy `git diff` + test lại trước khi tin |

## So sánh với Claude Code

| Việc | Copilot (`/resume`) | Claude Code | Ghi chú |
|---|---|---|---|
| Mở lại phiên đã lưu | `/resume`, không nhớ tên thì qua `/history` | `claude --resume` chọn session | Cùng ý tưởng tiếp mạch phiên cũ |
| Khôi phục trạng thái tool | Không — chỉ text | Không — chỉ hội thoại | Không bên nào tự dựng lại file/terminal state |
| Rẽ nhánh từ phiên cũ | Mở lại rồi làm hướng mới | Resume rồi làm hướng mới | Cả hai đều không có "fork" tự động |

## Best practices (kèm "vì sao")

- **Đặt tên phiên rõ ngay từ đầu.** *Vì sao?* `/resume` dựa vào tên/ngày; tên mơ hồ làm bạn nhầm phiên.
- **Resume xong luôn `git diff` trước khi tin.** *Vì sao?* Code trên đĩa có thể đã thay đổi kể từ lúc chat — model không tự biết.
- **Nhắc lại 3 dòng bối cảnh.** *Vì sao?* History chỉ lưu text; nhắc lại giúp model bắt nhịp mà không tốn nhiều turn.
- **Việc sống còn thì `/export`.** *Vì sao?* Nếu phiên bị xóa hoặc đổi profile/máy, resume sẽ không còn gì để mở.

## Bài tập nhỏ

1. **(3 phút)** Resume một phiên cũ và nhắn "tiếp tục" mà không nhắc bối cảnh — ghi lại model quên gì.
2. **(5 phút)** Resume lại đúng phiên đó, lần này nhắc 3 dòng bối cảnh + tên file, so sánh kết quả.
3. **(5 phút)** Mở một phiên cũ đã lâu, chạy `git diff` và test lại — xác nhận code đĩa còn khớp với nội dung chat.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Tìm phiên trước khi resume: [../history/README.md](../history/README.md). Bắt đầu sạch: [../new-chat/README.md](../new-chat/README.md).

> `/resume` mở lại cuộc trò chuyện, nhưng việc đồng bộ nó với code hiện tại vẫn là của bạn — đừng để phiên cũ đánh lừa về trạng thái repo.
