# /summarize — Nén chat dài thành tóm tắt

> Nôm na: nhờ thư ký tóm tắt cuộc họp 2 tiếng thành 5 gạch đầu dòng.

## Lệnh làm gì (1 câu nôm na)

Nôm na: nhờ thư ký tóm tắt cuộc họp 2 tiếng thành 5 gạch đầu dòng. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Chat >20 turns, model bắt đầu quên.
- Bàn giao việc dở cho người/agent khác.
- Trước khi /new để giữ lại tinh túy chat cũ.

## Cách gọi (copy-paste)

```bash
/summarize
/summarize nén chat này thành 5 gạch + việc còn dở
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/summarize`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/summarize “nén chat này: đã làm gì, quyết định nào đã chốt, còn dở gì”
```

**Kết quả mong đợi:** Bản tóm tắt gọn: đã làm / đã chốt / còn dở + file liên quan; paste sang chat mới là tiếp tục được.

**Cách verify:** Mở chat mới, paste tóm tắt, hỏi tiếp — model theo được là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tóm tắt mất chi tiết quan trọng | Chat quá dài, model nén ẩu | Bảo nó giữ lại: file + quyết định + số liệu; check lại 1 lượt |
| Tóm tắt sai (ảo giác) | Tin 100% không đọc | Đọc lại tóm tắt, sửa tay trước khi share |
| Chat ngắn cũng summarize | Lãng phí 1 lượt gọi | Chat <10 turns thì khỏi cần |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
