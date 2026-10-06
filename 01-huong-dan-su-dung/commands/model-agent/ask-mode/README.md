# Ask mode — Chế độ chỉ hỏi, không sửa

> Nôm na: chế độ “chỉ nhìn không chạm” — hỏi thoải mái, code không mất cọng nào.

## Lệnh làm gì (1 câu nôm na)

Nôm na: chế độ “chỉ nhìn không chạm” — hỏi thoải mái, code không mất cọng nào. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Tìm hiểu code/kiến trúc trước khi đụng.
- So sánh phương án, chưa muốn sửa.
- Review: hỏi “đoạn này làm gì, rủi ro gì?”.

## Cách gọi (copy-paste)

```bash
Chat → dropdown mode → Ask
“so sánh 2 cách cache, chưa cần sửa code”
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Ask mode`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(Ask mode) “đọc module auth, vẽ flow login bằng chữ + chỉ 3 rủi ro lớn nhất”
```

**Kết quả mong đợi:** Câu trả lời phân tích, không file nào bị sửa; hiểu đủ để quyết bước tiếp.

**Cách verify:** git status sạch sau khi hỏi là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Hỏi trong Ask mà code vẫn đổi | Nhầm mode (đang Edit/Agent) | Nhìn lại dropdown mode trước khi Enter |
| Ask trả lời thiếu vì không đọc file | Quên gắn scope | Gắn #file/@workspace ngay cả trong Ask |
| Ở mãi Ask khi cần sửa | Sợ agent | Hiểu rồi → leo thang Edit/Agent |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
