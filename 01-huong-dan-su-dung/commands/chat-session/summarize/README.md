# /summarize — Nén chat dài thành tóm tắt

> **Dành cho:** dev đang chat dài (>20 turns) sắp mất dấu · **Vấn đề:** model quên đầu bài, khó bàn giao việc dở · **Đọc xong:** nén chat thành bản gọn vẫn giữ file + quyết định, chuyển chat mới trơn (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: nhờ thư ký tóm tắt cuộc họp 2 tiếng thành 5 gạch đầu dòng. Lệnh gom chat dài thành bản tóm tắt “đã làm / đã chốt / còn dở”; chat dưới 10 turns thì không cần dùng.

## Khi nào dùng

Section này trả lời: khi nào nên tóm tắt, và làm sao để bản tóm tắt không mất chi tiết quan trọng.

- **Cho ai:** người bàn giao việc dở, hoặc ai chuẩn bị `/new` mà vẫn muốn giữ tinh túy chat cũ.
- Chat >20 turns, model bắt đầu quên.
- Bàn giao việc dở cho người/agent khác.
- Trước khi /new để giữ lại tinh túy chat cũ.

## Cách gọi (copy-paste)

Cách gọi `/summarize` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/summarize
/summarize nén chat này thành 5 gạch + việc còn dở
# Kỳ vọng: bản tóm tắt gọn: đã làm / đã chốt / còn dở
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/summarize`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/summarize` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/summarize “nén chat này: đã làm gì, quyết định nào đã chốt, còn dở gì”
# Verify: paste tóm tắt sang chat mới, hỏi tiếp được
```

**Kết quả mong đợi:** Bản tóm tắt gọn: đã làm / đã chốt / còn dở + file liên quan; paste sang chat mới là tiếp tục được.

**Cách verify:** Mở chat mới, paste tóm tắt, hỏi tiếp — model theo được là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tóm tắt mất chi tiết quan trọng | Chat quá dài, model nén ẩu | Bảo nó giữ lại: file + quyết định + số liệu; check lại 1 lượt |
| Tóm tắt sai (ảo giác) | Tin 100% không đọc | Đọc lại tóm tắt, sửa tay trước khi share |
| Chat ngắn cũng summarize | Lãng phí 1 lượt gọi | Chat <10 turns thì khỏi cần |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
