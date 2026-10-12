# Restore checkpoint — Quay về trước khi agent sửa sai

> **Dành cho:** dev giao task mạo hiểm cho Agent mode · **Vấn đề:** agent sửa lan man, càng sửa càng rối, khó về lại điểm an toàn · **Đọc xong:** restore về checkpoint và biết cách chuẩn bị checkpoint thủ công (~2 phút)

## 1 câu nôm na

Nút Undo cho cả phiên agent — đi sai thì quay xe về ngã ba cũ. Restore checkpoint đưa workspace + chat history về trạng thái trước đó. Nếu phiên quá ngắn hoặc tính năng bị tắt, hãy tự commit git để làm một "checkpoint thủ công".

Cần phân biệt: checkpoint mạnh hơn `Ctrl+Z` vì nó quay **cả phiên**, không chỉ vài edit lẻ.

## Vì sao dùng Restore checkpoint?

Giao cho agent sửa nhiều file là con dao hai lưỡi: nhanh, nhưng một turn sai có thể làm rối cả loạt file. Restore checkpoint cho bạn một lối thoát:

- **Quay lui an toàn** — về đúng mốc trước khi agent bắt đầu.
- **Thử hai hướng** — từ cùng một điểm an toàn, thử cách A, restore, rồi thử cách B.
- **Giảm rủi ro task lớn** — biết mình luôn có chỗ để về.

**Nếu làm sai thì sao?** Ngộ nhận nguy hiểm nhất là tưởng agent sửa gì cũng "không sao, undo được". Không phải: nếu không có checkpoint (phiên quá ngắn, tính năng tắt), hoặc checkpoint quá xa, restore có thể xóa luôn cả phần đúng. Xem ❌/✅ và bảng chọn cách quay lui.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** agent sửa lan man và càng sửa càng rối; muốn thử hai hướng khác nhau từ cùng một điểm; chuẩn bị giao task mạo hiểm.
- **ĐỪNG dùng khi:** bạn chỉ mới sửa vài edit ở bước cuối — `Ctrl+Z` gọn hơn nhiều.
- **Cho ai:** người để agent sửa nhiều file — trước task lớn càng nên nắm phần này.

> Chọn nhanh cách quay lui:

| Cách | Quay được gì | Khi nào dùng |
|---|---|---|
| Restore checkpoint | Cả workspace + chat history về mốc đã lưu | Agent sửa lan nhiều file, muốn thử hướng khác từ điểm an toàn |
| Undo từng edit (`Ctrl+Z`) | Vài edit vừa thực hiện | Mới sửa ít, lỗi ngay ở bước cuối |
| Commit git tay | Mốc do bạn tự tạo | Session quá ngắn / tính năng checkpoint tắt, cần mốc chắc |

## Cách gọi (copy-paste)

```bash
Chat view → timeline/checkpoints → Restore
# hoặc Undo từng edit (Ctrl+Z) nếu mới sửa ít
# Verify: git diff sạch trở lại sau restore
```

> Không thấy mục checkpoint? Kiểm tra phiên có đủ dài / tính năng có bật không; nếu không, chuyển sang commit git thủ công.

## Ví dụ thật

Nghiệp vụ: bạn giao agent "đổi toàn bộ API layer sang fetch có retry". Agent chạy xong nhưng sửa lan 5 file, có file không liên quan, và làm hỏng một import. Bạn muốn về lại đúng lúc trước khi bắt đầu.

```bash
# Truoc khi giao task (chuan bi):
git commit -am "checkpoint: truoc khi cho agent doi API layer"

# Agent sua lan -> quay lui:
# Chat view -> chon moc "truoc khi chay agent sang nay" -> Restore
# Verify: git status + git diff -> sach, test nhanh xanh
```

**Kết quả mong đợi:** Code về đúng trạng thái checkpoint; `git diff` sạch lại; thử hướng mới từ điểm an toàn.

**✅ Verify:** Chạy `git status` + test nhanh — sạch và xanh là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — để agent chạy mạo hiểm mà không có mốc nào để về:**

```bash
# Cho agent sua 8 file, khong commit, khong checkpoint
# -> roi loan, muon quay lui thi khong con moc nao sach
```

**✅ ĐÚNG — commit thủ công làm checkpoint trước task lớn, rồi mới giao agent:**

```bash
git commit -am "checkpoint: truoc khi cho agent refactor auth"
# Giao task -> neu sai thi restore / git reset ve commit nay
```

**Bài học:** Không phải lúc nào checkpoint tự động cũng có. Trước việc mạo hiểm, tự tạo mốc bằng git.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không có checkpoint để restore | Session quá ngắn / tính năng tắt | Trước task lớn: commit git tay một cái làm "checkpoint thủ công" |
| Restore mất cả phần đúng | Checkpoint quá xa | Chia task nhỏ, checkpoint/commit thường xuyên |
| Nhầm checkpoint | Tên checkpoint giống nhau | Commit message rõ + ghi chú trước khi cho agent chạy |

## So sánh với Claude Code

| Việc | Copilot (`Restore checkpoint`) | Claude Code | Ghi chú |
|---|---|---|---|
| Quay lui cả phiên agent | Checkpoint quay workspace + chat history | Checkpoint tự động khi agent sửa, có thể rewind | Cả hai đều cho "undo cả phiên" |
| Undo vài edit | `Ctrl+Z` | Undo/rewind | Mức nhỏ tương đương |
| Mốc thủ công | Commit git | Commit git | Không bên nào thay thế được git làm mốc chắc |

## Best practices (kèm "vì sao")

- **Commit trước mọi task agent mạo hiểm.** *Vì sao?* Checkpoint tự động có thể không có; git là mốc chắc chắn nhất.
- **Chia task nhỏ, checkpoint thường xuyên.** *Vì sao?* Checkpoint càng gần lỗi thì restore càng ít mất phần đúng.
- **Đặt commit message mô tả rõ.** *Vì sao?* Nhiều mốc gần nhau dễ nhầm nếu tên không phân biệt được.
- **Restore xong chạy test ngay.** *Vì sao?* Workspace quay về mốc cũ, nhưng bạn cần xác nhận trạng thái đó thực sự tốt.

## Bài tập nhỏ

1. **(5 phút)** Trước khi cho agent một task nhỏ, commit một "checkpoint thủ công"; làm hỏng có chủ đích rồi restore để thấy cả quy trình.
2. **(5 phút)** Thử hai hướng khác nhau từ cùng một checkpoint: chạy agent cách A, restore, chạy cách B, so sánh kết quả.
3. **(5 phút)** So sánh `Ctrl+Z` và restore checkpoint sau khi agent sửa 1 file — xác định ngưỡng nào thì restore đáng dùng hơn.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Bắt đầu sạch sau restore: [../new-chat/README.md](../new-chat/README.md). Lưu lại phiên trước khi bỏ: [../export/README.md](../export/README.md).

> Restore checkpoint là lưới an toàn của Agent mode — nhưng lưới chỉ có khi bạn giăng trước, nên hãy commit trước khi để agent chạy mạo hiểm.
