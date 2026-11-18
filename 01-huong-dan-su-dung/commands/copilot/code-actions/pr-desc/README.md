# PR title + body — nút "Generate Description" trong Create Pull Request view tóm tắt diff của nhánh

> **Harness:** Copilot · **Surface:** GitHub Pull Requests and Issues extension — nút ở cạnh ô title trong Create Pull Request view; docs không có slash `/pr` · **Đọc:** ~2 phút

**Nôm na:** Nhờ viết bìa hồ sơ — tên, nội dung, đã kiểm tra những gì. Bấm nút sinh mô tả, Copilot tóm tắt diff của nhánh thành title + body; repo có **pull request template** thì extension tự điền template và nó viết vào đúng khung đó. Hợp khi vừa xong một nhánh một mục đích và sắp mở PR cho đồng nghiệp đọc.

## Vì sao dùng?

Body PR là thứ reviewer đọc **đầu tiên**: viết tốt thì được review nhanh, viết chung chung thì họ phải hỏi lại rồi ngồi chờ bạn trả lời. Nút sinh mô tả dựng sẵn khung Đổi gì / Vì sao nên không quên mục nào, và cũng giống commit message, việc này chạy bằng **utility model** (`chat.utilitySmallModel`) chứ không phải model của phiên chat. Cái hay nhầm là chờ slash `/pr` (docs không có) và nghĩ body hay cứu được PR xấu.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Body chung chung | Diff quá to, ôm nhiều mục đích | Chia PR nhỏ; mỗi PR một mục đích |
| Thiếu phần test / rủi ro | Nó chỉ viết từ diff — lịch sử chạy test không nằm trong diff | Tự bổ mục Test + Rủi ro trước khi Create |
| Không thấy nút sinh mô tả | Create view chưa mở đúng / thiếu extension | Cài và đăng nhập extension GitHub PRs, mở PR từ view hoặc Palette |
| Đi tìm `/pr`, `/diff`, `/review` trong Chat | Docs không liệt kê mấy slash đó | Dùng nút trong PR view; soi diff thì có nút Code Review |

**Nếu làm sai:** hồ sơ dày 40 trang thì bìa hay đến mấy reviewer cũng bỏ cuộc — tách PR nhỏ trước đã; và PR là thứ đồng nghiệp nhìn thấy, nên bạn vẫn đọc lại body trước khi bấm Create.

## Cách dùng

Pull Requests view → **Create Pull Request** (hoặc Palette `Ctrl+Shift+P` → "GitHub Pull Requests: Create Pull Request"), bấm nút sinh mô tả cạnh ô title rồi tự bổ hai mục mà diff không chứa:

```markdown
**Đổi gì / Vì sao** — nút sinh mô tả viết phần này từ diff của nhánh
**Test** — bạn bổ: npm test -- auth: 6/6 xanh; tay test 5 lần sai -> khóa 15 phút
**Rủi ro** — bạn bổ: chưa review môi trường sau proxy/NAT
```

- **Biến thể:** repo đã có pull request template thì nêu luôn "viết theo template của repo" để khỏi phải sửa khung.
- **Setting:** `chat.utilitySmallModel` — model phụ trách sinh title/body, tách khỏi model bạn chọn cho chat.
- **✅ Verify:** đưa body cho 1 teammate đọc — không phải hỏi lại câu nào là đạt.

## Liên quan

- Bước trước đó (commit message): [commit-message](../commit-message/README.md) · Nhờ agent mở PR và tổng kết việc: [agent-mode](../../model-agent/agent-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Use AI assistance for pull requests](https://code.visualstudio.com/docs/sourcecontrol/github#use-ai-assistance-for-pull-requests) · [Generate a commit message and PR information](https://code.visualstudio.com/docs/editing/copilot-smart-actions#generate-a-commit-message-and-pr-information)
