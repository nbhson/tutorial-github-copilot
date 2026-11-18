# Commit message — sinh draft conventional commits từ staged diff, ngay trong Source Control

> **Harness:** Copilot · **Surface:** Source Control view (`Ctrl+Shift+G`) — nút ở cạnh ô commit message; docs không có slash `/commit` · **Đọc:** ~2 phút

**Nôm na:** Nhìn đống hàng đã gói để viết phiếu gửi: nút sinh message đọc phần bạn đã **stage** rồi viết theo conventional commits (feat/fix + scope + mô tả) kèm body ngắn. Hợp khi vừa stage xong một mục đích và sắp commit; stage một cục lộn xộn thì message cũng lộn xộn.

## Vì sao dùng?

Message tốt nói được cả *đổi gì* lẫn *vì sao* — thứ mà lịch sử commit sẽ trả lời cho đồng nghiệp (và cho chính bạn) sáu tháng sau. Nút sinh message dựng sẵn dòng đầu theo chuẩn để CI/changelog parse được, biến việc "nghĩ message" từ 2 phút xuống 10 giây và giữ log của cả team nhất quán. Hai điều docs ghi mà ít người để ý: việc này chạy bằng **utility model** (`chat.utilitySmallModel`) chứ không phải model bạn chọn cho chat, và khai được instructions riêng cho commit message sinh tự động (Custom Instructions → Generated content).

| Tình huống | Kết quả nhận về | Cách xử lý |
|---|---|---|
| Stage một cục (refactor + fix + format lẫn lộn) | `chore: update files` — không nói được gì | Stage gọn theo từng mục đích, mỗi mục đích một commit |
| Chưa stage gì | Không có nguồn để sinh — nút chỉ thấy diff được đưa vào commit | Stage file liên quan trước khi bấm |
| Team có chuẩn scope riêng | Model đoán scope, hay lệch | Khai instructions cho generated content một lần |
| Body chỉ liệt kê "đổi gì" | Mất vế "vì sao" — thứ lịch sử không tự nói được | Thêm 1 dòng "vì sao" trước khi Commit |

**Nếu làm sai:** đây vẫn chỉ là *bản nháp* — commit là hành động thật, bạn là người duyệt cuối; muốn AI soi code trước khi commit thì Source Control có nút **Code Review** riêng, khác hẳn việc sinh message.

## Cách dùng

Stage trong Source Control view (`Ctrl+Shift+G`), rồi bấm nút sinh message cạnh ô commit.

```sh
git add src/auth/login.ts src/auth/login.test.ts   # một mục đích = một commit
# bấm nút sinh message -> "fix(auth): handle accented email in login"
# thêm body nêu vì sao (params undefined khi email chứa dấu -> 500) -> đọc lại -> Commit
```

- **Biến thể:** nhiều thay đổi khác mục đích → tách nhiều commit nhỏ, sinh message cho từng commit một.
- **Setting:** `chat.utilitySmallModel` — model phụ trách việc sinh message; đổi nó không làm đổi model phiên chat.
- **✅ Verify:** đọc lại message 5 giây mà hiểu "đổi gì + vì sao" là đạt; không thì sửa tay trước khi Commit.

## Liên quan

- Bước tiếp theo sau commit: [pr-desc](../pr-desc/README.md) · Sửa code trước khi chốt: [fix](../fix/README.md) · Model của phiên chat (không liên quan sinh message): [model-picker](../../model-agent/model-picker/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Generate a commit message and PR information](https://code.visualstudio.com/docs/editing/copilot-smart-actions#generate-a-commit-message-and-pr-information) · [Staging & committing](https://code.visualstudio.com/docs/sourcecontrol/staging-commits)
