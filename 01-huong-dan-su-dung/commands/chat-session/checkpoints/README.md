# Restore checkpoint — Quay về trước khi agent sửa sai

> Nôm na: nút Undo cho cả phiên agent — đi sai thì quay xe về ngã ba cũ.

## Lệnh làm gì (1 câu nôm na)

Nôm na: nút Undo cho cả phiên agent — đi sai thì quay xe về ngã ba cũ. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Agent sửa lan man, càng sửa càng rối.
- Muốn thử 2 hướng khác nhau từ cùng 1 điểm.
- Trước khi giao task mạo hiểm cho agent.

## Cách gọi (copy-paste)

```bash
Chat view → timeline/checkpoints → Restore
# hoặc Undo từng edit (Ctrl+Z) nếu mới sửa ít
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Restore checkpoint`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Agent sửa sai 5 file → Restore checkpoint “trước khi chạy agent sáng nay”
```

**Kết quả mong đợi:** Code về đúng trạng thái checkpoint; git diff sạch lại; thử hướng mới từ điểm an toàn.

**Cách verify:** Chạy git status + test nhanh — sạch và xanh là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không có checkpoint để restore | Session quá ngắn / tính năng tắt | Trước task lớn: commit git tay 1 cái làm “checkpoint thủ công” |
| Restore mất cả phần đúng | Checkpoint quá xa | Chia task nhỏ, checkpoint/commit thường xuyên |
| Nhầm checkpoint | Tên checkpoint giống nhau | Commit message rõ + ghi chú trước khi cho agent chạy |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
