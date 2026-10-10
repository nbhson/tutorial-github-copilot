# Restore checkpoint — Quay về trước khi agent sửa sai

> **Dành cho:** dev giao task mạo hiểm cho Agent mode · **Vấn đề:** agent sửa lan man, càng sửa càng rối, khó về lại điểm an toàn · **Đọc xong:** restore về checkpoint và biết cách chuẩn bị checkpoint thủ công (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: nút Undo cho cả phiên agent — đi sai thì quay xe về ngã ba cũ. Checkpoint trả workspace + chat history về trạng thái trước; session quá ngắn hoặc tính năng tắt thì commit git tay làm checkpoint thủ công.

## Khi nào dùng

Section này trả lời: khi nào nên bấm Undo cho cả phiên, và làm sao để luôn có chỗ mà về.

- **Cho ai:** người để agent sửa nhiều file — trước task lớn thì càng nên đọc section này.
- Agent sửa lan man, càng sửa càng rối.
- Muốn thử 2 hướng khác nhau từ cùng 1 điểm.
- Trước khi giao task mạo hiểm cho agent.

## Cách gọi (copy-paste)

Cách gọi `Restore checkpoint` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Chat view → timeline/checkpoints → Restore
# hoặc Undo từng edit (Ctrl+Z) nếu mới sửa ít
# Verify: git diff sạch trở lại sau restore
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Restore checkpoint`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `Restore checkpoint` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Agent sửa sai 5 file → Restore checkpoint “trước khi chạy agent sáng nay”
# Kỳ vọng: code về đúng trạng thái trước, git diff sạch
```

**Kết quả mong đợi:** Code về đúng trạng thái checkpoint; git diff sạch lại; thử hướng mới từ điểm an toàn.

**Cách verify:** Chạy git status + test nhanh — sạch và xanh là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không có checkpoint để restore | Session quá ngắn / tính năng tắt | Trước task lớn: commit git tay 1 cái làm “checkpoint thủ công” |
| Restore mất cả phần đúng | Checkpoint quá xa | Chia task nhỏ, checkpoint/commit thường xuyên |
| Nhầm checkpoint | Tên checkpoint giống nhau | Commit message rõ + ghi chú trước khi cho agent chạy |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
