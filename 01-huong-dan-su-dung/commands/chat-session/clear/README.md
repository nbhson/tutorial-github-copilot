# /clear — Xóa turns hiện tại, giữ settings

> **Dành cho:** dev đang chat dồn 1 phiên dài · **Vấn đề:** model bắt đầu quên đầu bài nhưng bạn vẫn cần giữ instructions/MCP · **Đọc xong:** reset turns mà không mất cấu hình, kèm cách cứu việc đang dở (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: lau bảng đen cho sạch nhưng phấn, bảng, quy định lớp vẫn giữ nguyên. Lệnh chỉ xóa turns hiện tại; instructions và MCP servers vẫn còn. Gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

Section này trả lời: khi nào nên lau bảng, và làm sao để không mất việc đang dở trước khi lau.

- **Cho ai:** ai cũng dùng được — nhất là người mở chat một lần rồi hỏi dồn cả ngày.
- Chat dài quá, model bắt đầu quên đầu bài.
- Muốn giữ instructions/MCP connections nhưng bỏ turns cũ.
- Chuẩn bị paste task mới vào cùng repo.

## Cách gọi (copy-paste)

Cách gọi `/clear` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/clear
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/clear`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/clear` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/clear
```

**Kết quả mong đợi:** Turns cũ biến mất, instructions + MCP servers vẫn còn; chat nhẹ lại.

**Cách verify:** Hỏi “liệt kê quy tắc đang áp dụng” — vẫn trả lời được là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tưởng /clear xóa cả instructions | Nhầm với /new hoặc reset settings | Yên tâm: instructions load lại từ file, chỉ turns mất |
| Clear xong vẫn trả lời lan man | Scope chưa gọn (vẫn attach cả repo) | Gắn lại #file gọn rồi hỏi lại |
| Mất việc dở không cứu được | Quên export trước | /export trước khi /clear nếu cần giữ |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
