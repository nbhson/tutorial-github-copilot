# Shift+Alt+I (quick chat) — Hỏi nhanh phủ trên editor

> **Dành cho:** dev cần hỏi nhanh trong 30 giây · **Vấn đề:** câu hỏi ngắn mà mở Chat view thì thừa · **Đọc xong:** hỏi xong đóng ngay, không rời editor, biết việc nào phải chuyển Chat view (~2 phút)

## 1 câu nôm na

Giơ tay hỏi nhanh một câu rồi hạ xuống code tiếp, khỏi rời editor. Bấm `Shift+Alt+I` → nhập câu hỏi → Enter → Esc đóng; một popup trả lời ngắn hiện ngay trên editor.

Khác inline chat ở chỗ: quick chat **chỉ hỏi**, không sửa file. Đây là kênh hỏi đáp nhanh phủ trên editor, không phải chỗ để tạo diff.

## Vì sao dùng Shift+Alt+I?

Có những câu hỏi không xứng đáng để mở cả một Chat view: "hàm này dùng để làm gì?", "cú pháp destructuring trong Python ra sao?". Quick chat cho bạn câu trả lời tức thì mà không loãng mạch code vì:

- **Nhanh** — hỏi, đọc, Esc, tiếp tục.
- **Không lưu lịch sử dài** — phù hợp câu hỏi vặt, không cần tra lại sau.
- **Không rời editor** — popup nằm trên code đang đọc.

**Nếu làm sai thì sao?** Hai lỗi thường gặp: (1) hỏi câu phức tạp cần context nhiều file — quick chat trả lời cộc, phải chuyển Chat view; (2) câu trả lời hay nhưng quên lưu vì quick chat không giữ lịch sử kỹ. Xem ❌/✅.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** hỏi định nghĩa, cú pháp, "hàm này làm gì?" trong 30 giây; đang code dở và không muốn mở hẳn Chat view; câu hỏi xong không cần lưu lịch sử.
- **ĐỪNG dùng khi:** việc phức tạp cần context nhiều file hoặc tool ngoài — chuyển sang Chat view / Agent mode.
- **Cho ai:** người hỏi lẻ về cú pháp/định nghĩa, không cần lưu lịch sử dài.

## Cách gọi (copy-paste)

```bash
Shift+Alt+I → nhập câu hỏi → Enter → Esc đóng
# Kỳ vọng: popup trả lời ngắn ngay trên editor
```

> Phím không ăn? Vào Keyboard Shortcuts search "quick chat" để kiểm tra/gán lại — đôi khi layout hoặc extension khác chiếm phím.

## Ví dụ thật

Nghiệp vụ: bạn đang viết một component React và không chắc nên debounce ô search bao nhiêu ms để vừa mượt vừa đỡ gọi API.

```bash
# Dang o trong file SearchBox.tsx
Shift+Alt+I → "debounce o tim kiem goi API nen dat bao nhieu ms la hop ly?"
# Doc popup -> chon 300ms -> Esc -> tiep tuc code
# Verify: ap dung duoc cau tra loi trong 1 phut
```

**Kết quả mong đợi:** Popup trả lời ngắn gọn ngay trên editor; đóng là về code tiếp.

**✅ Verify:** Áp dụng được câu trả lời trong 1 phút là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — dùng quick chat cho việc cần context nhiều file, rồi than nó trả lời cộc:**

```bash
Shift+Alt+I → "sua bug login xuyen 3 file nay giup toi"
# -> popup tra loi coc, khong du context
```

**✅ ĐÚNG — quick chat cho câu hỏi vặt; việc lớn chuyển Chat view:**

```bash
# Cau hoi vat:
Shift+Alt+I → "cach destructure nested object trong TS?"
# Viec lon:
# -> mo Chat view / Agent mode, gan scope #file
```

**Bài học:** Quick chat là kênh hỏi nhanh, không phải kênh giao việc. Chọn đúng kênh cho đúng cỡ câu hỏi.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Phím tắt không ăn | Xung đột keybinding / layout khác | Vào Keyboard Shortcuts search "quick chat" gán lại |
| Hỏi phức tạp bị trả lời cộc | Quick chat hợp câu ngắn | Việc phức tạp → mở Chat view hoặc Agent mode |
| Quên mất câu trả lời hay | Quick chat không lưu kỹ | Câu nào hay → hỏi lại trong Chat view rồi `/export` |

## So sánh với Claude Code

| Việc | Copilot (`Shift+Alt+I`) | Claude Code | Ghi chú |
|---|---|---|---|
| Hỏi nhanh phủ trên editor | Popup quick chat | Không có tương đương trực tiếp (terminal-first) | Copilot có lớp hỏi nhanh trong IDE |
| Lưu lịch sử câu hỏi | Không lưu kỹ | Hội thoại nằm trong session | Muốn lưu thì chuyển Chat view + `/export` |
| Sửa file | Không — chỉ trả lời | Agent có thể sửa nếu yêu cầu | Quick chat cố ý không tạo diff |

## Best practices (kèm "vì sao")

- **Chỉ dùng cho câu hỏi ngắn, có đáp án đọc nhanh.** *Vì sao?* Quick chat không có context sâu; hỏi lớn sẽ nhận câu cộc.
- **Câu trả lời hay thì hỏi lại ở Chat view rồi `/export`.** *Vì sao?* Quick chat không giữ lịch sử kỹ, đóng là khó tra lại.
- **Kiểm tra keybinding nếu phím không ăn.** *Vì sao?* Xung đột phím thường bị nhầm là lỗi công cụ.
- **Đừng dùng quick chat để giao task sửa code.** *Vì sao?* Nó không tạo diff — bạn sẽ tưởng "không làm được" trong khi thực ra sai kênh.

## Bài tập nhỏ

1. **(2 phút)** `Shift+Alt+I` hỏi cú pháp một thứ bạn hay quên, đóng bằng Esc, cảm nhận tốc độ.
2. **(5 phút)** Hỏi một câu cần context 2 file bằng quick chat — ghi lại khi nào nó cộc; rồi chuyển Chat view và hỏi lại.
3. **(5 phút)** Kiểm tra Keyboard Shortcuts xem `Shift+Alt+I` có bị xung đột không; nếu có, gán lại và ghi chú.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Sửa tại chỗ có diff: [../inline-chat/README.md](../inline-chat/README.md). Việc lớn cần context: [../new-chat/README.md](../new-chat/README.md).

> Quick chat là để hỏi và quên — nếu câu trả lời đáng nhớ, nó xứng đáng được hỏi lại ở một nơi lưu được.
