# Feedback & bug — Báo cho GitHub đủ context để họ tái hiện và sửa được

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI / GitHub.com · **Đọc:** ~2 phút

**Nôm na:** Kênh gửi ý kiến lên "ban quản lý" Copilot: vote tốt/xấu cho một câu trả lời, hoặc báo hỏng kèm mô tả + bước lặp + version. Hợp khi bạn gặp lỗi lặp lại đều đặn — hoặc câu trả lời quá tốt/quá dở đáng được ghi nhận.

## Vì sao dùng?

GitHub chỉ sửa được cái nó tái hiện được: "`/tests` sinh sai import, lặp lại bằng bôi đen hàm X rồi gọi `/tests`, extension 1.2.3" thì họ đóng bug hoặc fix; "Copilot dở" thì không giúp ích gì. Ba surface là ba kênh, không có một nút "báo bug" chung cho mọi nơi.

| Surface | Cách gửi | Dùng khi |
|---|---|---|
| VS Code Chat | `Chat: Provide Feedback` (F1), hoặc thumbs up/down trên message | góp ý cho câu trả lời/chat ngay trong editor |
| Copilot CLI | `/feedback`, `/bug` | bug của chính Copilot CLI |
| GitHub.com | issue ở `microsoft/vscode-copilot-release` hoặc `gh issue create` | bug cần thread để theo dõi, có ảnh/log |

**Nếu làm sai:** báo thiếu bước lặp → bị đóng là "không tái hiện được"; báo nhầm do scope/prompt của bạn → mất thời gian cả hai bên — gọn scope và thử lại trước; dán log chứa token → rò rỉ vĩnh viễn, luôn soát secrets trước khi gửi.

## Cách dùng

Gõ trong Copilot CLI (session); trong VS Code gõ `/` mà không thấy `/feedback` là đúng thiết kế — slash đó thuộc CLI, editor dùng lệnh palette.

```prompt
/bug /tests sinh sai import. Bước lặp: bôi đen hàm X → /tests. Kỳ vọng: test chạy được. Ext 1.2.3
/feedback câu trả lời đúng hướng nhưng thiếu ví dụ migrate
```

- **Biến thể:** vote nhanh đi kênh feedback; bug cần người sửa đi kênh issue; bug của CLI đi `/bug` — chọn đúng surface cho đúng loại chuyện.
- **✅ Verify:** nhận được confirm hoặc issue tham chiếu là đạt; bị hỏi lại "lặp thế nào" tức phần bước lặp của bạn chưa đủ rõ.

## Liên quan

- Kiểm tra trạng thái trước khi báo bug: [status](../status/README.md) · Lệnh hay gây bug: [tests](../../code-actions/tests/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Report an unresolved issue](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#report-an-unresolved-issue) · [GitHub Docs — CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
