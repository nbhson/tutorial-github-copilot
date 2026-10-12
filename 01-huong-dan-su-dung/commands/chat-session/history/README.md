# /history — Xem và quay lại chat cũ

> **Dành cho:** dev muốn tìm lại chat cũ · **Vấn đề:** không nhớ đã nói gì hôm qua, cần so sánh 2 cách làm ở 2 phiên · **Đọc xong:** tìm và mở lại đúng phiên trong vài giây (~2 phút)

## 1 câu nôm na

Mở sổ đầu bài cũ ra xem lại rồi viết tiếp từ chỗ hôm qua dừng. `/history` liệt kê các chat cũ theo thời gian để bạn mở lại. Đây cũng là bước đệm cho `/resume` khi bạn chưa nhớ tên phiên cần mở.

Khác với tự lục trong đống tab/terminal: `/history` gom về một danh sách có thứ tự thời gian, nên tìm nhanh hơn nhiều.

## Vì sao dùng /history?

Trí nhớ của bạn không phải nơi lưu tốt nhất cho hàng chục phiên chat. `/history` cho bạn:

- **Tìm lại bối cảnh cũ** — không phải kể lại từ đầu.
- **So sánh hai phiên** — bạn đã thử cách A ở chat này, cách B ở chat kia; mở lại để đối chiếu.
- **Thu hoạch lại prompt hay** — những prompt hiệu quả nằm trong history, lôi ra làm template.

**Nếu làm sai thì sao?** Ngộ nhận lớn nhất là tin rằng mở lại chat cũ là model "nhớ hết". Thực tế history chỉ lưu **text hội thoại**, không lưu nguyên trạng thái tool của phiên (file đã đọc, lệnh đã chạy). Mở lại có thể thấy model "quên" chi tiết tool — xem ❌/✅.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** muốn tiếp tục việc hôm qua làm dở; so sánh hai cách giải quyết ở hai chat khác nhau; tìm lại prompt hay để lưu thành template.
- **ĐỪNG dùng khi:** bạn chỉ muốn có một đầu bài sạch để bắt task mới — đó là `/new`, dùng history làm gì cho thêm nhiễu.
- **Cho ai:** người làm việc multi-day, hay so sánh solution giữa các phiên khác nhau.

## Cách gọi (copy-paste)

```bash
/history
# hoặc Ctrl+Shift+P → "Chat: Show History"
# Kỳ vọng: danh sách chat cũ theo thời gian hiện ra
```

> Kiểm tra lệnh có ở máy bạn không: gõ `/` trong ô Chat, tìm `/history`. Không thấy → đọc `/status` + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: tuần trước bạn thử hai hướng fix bug timezone — một ở chat "tz-utc-offset", một ở chat "tz-library". Giờ cần mở lại chat dùng thư viện để so với hướng còn lại.

```bash
/history
# Tim chat "tz-library" (thu huong dung thu vien) -> mo lai
# Verify: nhan 1 cau follow-up -> model nho context cu cua phien do
```

**Kết quả mong đợi:** Thấy list chats cũ theo thời gian; mở lại đúng phiên, tiếp tục không cần giải thích lại.

**✅ Verify:** Nhắn 1 câu follow-up, model nhớ context cũ là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — mở lại chat cũ rồi giao việc mới y như cũ, không tóm tắt:**

```bash
# Mo chat "tz-library" roi hoi tiep nhu the tool state con nguyen
# -> model quen file nao da doc, phai doan mo
```

**✅ ĐÚNG — mở lại rồi tóm tắt 3 dòng bối cảnh trước khi hỏi tiếp:**

```bash
# Sau khi mo lai chat cu:
"Tóm tắt lại giúp: hướng đang làm là dùng thư viện timezone Z,
 đã sửa file src/time.ts, còn dở phần test. Rồi ta làm tiếp."
```

**Bài học:** history giữ text, không giữ tool state. Mở lại thì nhắc lại bối cảnh bằng lời.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy chat hôm qua | Chat ở máy/profile khác hoặc đã xóa | Check đúng VS Code profile + máy |
| Mở lại nhưng model quên | History chỉ lưu text, không lưu full tool state | Tóm tắt lại 3 dòng rồi hỏi tiếp |
| List quá dài khó tìm | Đặt tên chat xấu | `/export` chat hay ra file để lần sau khỏi mò |

## So sánh với Claude Code

| Việc | Copilot (`/history`) | Claude Code | Ghi chú |
|---|---|---|---|
| Xem lại phiên cũ | `/history` (hoặc Command Palette "Chat: Show History") | `claude --resume` chọn session, hoặc `/resume` trong phiên | Cùng ý tưởng: liệt kê phiên để mở lại |
| So sánh hai phiên | Mở từng phiên trong list | Mở từng session | Không bên nào "diff" hai phiên tự động |
| Tìm lại nội dung | Đọc trực tiếp trong list | Đọc lại session | Cả hai đều dựa vào tên/ngày để tìm |

## Best practices (kèm "vì sao")

- **Đặt tên chat có nghĩa, đừng để mặc định.** *Vì sao?* List dài cỡ nào cũng tìm được nếu tên gợi đúng việc.
- **Export chat giá trị cao ngay khi xong.** *Vì sao?* History có thể bị xóa hoặc nằm ở profile khác — file export thì không.
- **Mở lại chat cũ thì nhắc lại bối cảnh.** *Vì sao?* History không lưu tool state; nhắc lại giúp model bắt nhịp nhanh.
- **Dùng history để so sánh, không để gộp.** *Vì sao?* Gộp nhiều phiên vào một chỗ dễ làm lẫn context; giữ tách phiên rõ ràng dễ đối chiếu hơn.

## Bài tập nhỏ

1. **(3 phút)** Mở `/history`, đếm xem bạn có bao nhiêu phiên chưa đặt tên. Đặt lại tên cho 3 phiên quan trọng nhất.
2. **(5 phút)** Tìm một chat cũ, mở lại, nhắn follow-up mà **không** nhắc bối cảnh — ghi lại model quên gì; rồi nhắc bối cảnh và hỏi lại.
3. **(5 phút)** Lấy một prompt hay trong history, `/export` nó ra file làm template dùng lại.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Tiếp tục phiên đã lưu: [../resume/README.md](../resume/README.md). Lưu chat ra file: [../export/README.md](../export/README.md).

> `/history` là bước tìm trước khi mở — nhớ tên phiên thì `/resume` thẳng, chưa nhớ thì đi qua list này.
