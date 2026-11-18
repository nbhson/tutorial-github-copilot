# Edit mode — Giới hạn phạm vi sửa đúng vào các file bạn tick

> **Harness:** Local · **Surface:** dropdown mode trên ô nhập Chat view (Session Target = Local) — không phải slash command; Copilot trên GitHub.com không có Edit mode · **Đọc:** ~2 phút

**Nôm na:** Mượn thợ sửa nhà mà chỉ dán băng keo quanh đúng những phòng được phép đụng: chọn **Edit**, tick các file cần sửa, rồi mô tả thay đổi — diff bị khóa bởi danh sách bạn tick. Hợp khi đã biết chắc 1–5 file cần đổi và không muốn AI "tiện tay" refactor cả repo.

## Vì sao dùng?

Danh sách file đã tick là hàng rào cứng nhất: diff gọn, review nhanh, dễ Accept/Reject từng hunk — trong khi giao việc mở cho Agent là tin nó chọn file, có lúc nó chọn sai. Ba mode built-in xếp theo độ tự chủ tăng dần — chọn dòng có mức tự chủ đúng bằng mức bạn muốn buông tay:

| Mode | Được làm gì | Khi nào dùng |
|---|---|---|
| Ask | trả lời, đọc code, **không** sửa file | cần hiểu trước khi quyết sửa gì |
| Edit | sửa **đúng file bạn tick** | đã biết chắc 1–5 file |
| Agent | tự quyết file để sửa, chạy lệnh | task nhiều bước, chưa biết sẽ chạm file nào |

**Nếu làm sai:** tick 8–10 file một lúc cộng lệnh mơ hồ ("sửa validation giúp tôi") khiến diff lan khắp repo, không xuể duyệt; sửa lan sang file chưa chọn thường vì prompt thiếu câu "chỉ đụng file đã tick"; còn Keep mà không đọc diff, không chạy test là con đường ngắn nhất đưa bug vào repo.

## Cách dùng

Chọn **Edit** ở dropdown mode (harness Local), tick `@file` vào working set rồi mô tả thay đổi:

```prompt
(Edit, tick 2 file) "thêm validation email dùng regex chuẩn + test cho trường hợp thiếu @;
chỉ đụng 2 file đã tick, không refactor chỗ khác"
```

- **Biến thể:** ≤5 file mỗi lượt, xong review rồi sang phase tiếp; chốt commit sạch trước khi sửa để `git diff` phản ánh đúng phần AI làm.
- **Setting:** `chat.editSessions.enabled` — bảng tra nhanh của bucket `local/` ghi muốn đi đường Local cũ thì qua setting này; trên Copilot harness muốn sửa có kiểm soát thì mở session Plan/Agent rồi siết tool permissions + working set, dùng Keep/Undo từng lượt.
- **✅ Verify:** `git diff --stat` chỉ liệt kê đúng các file đã tick, không có file thứ ba.

## Liên quan

- Chưa biết lỗi ở file nào: [ask-mode](../../../copilot/model-agent/ask-mode/README.md) để khảo sát · để AI tự tìm file: [agent-mode](../../../copilot/model-agent/agent-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [GitHub Docs — Copilot feature matrix](https://docs.github.com/en/copilot/reference/copilot-feature-matrix) · [VS Code Docs — Review code edits](https://code.visualstudio.com/docs/agents/run/review-code-edits#review-pending-edits-with-the-working-set)
