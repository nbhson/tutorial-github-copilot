# Copilot Spaces — kho tài liệu của team, hỏi là có nguồn

> **Harness:** Copilot in the cloud · **Surface:** `github.com/copilot/spaces` (Space tạo trên GitHub.com; gọi lại từ IDE qua GitHub MCP server) · **Đọc:** ~2 phút

**Nôm na:** Space là "túi tài liệu" bạn gom cho Copilot — repo, file/folder, PR/issue, ảnh, file upload, ghi chú — hỏi trong space thì câu trả lời bám đúng túi đó và tự cập nhật khi nguồn trên GitHub thay đổi; docs cũ gọi là *knowledge base*, trang đó hôm nay trả về **Copilot Spaces** — tên mới, cùng một việc. Hợp khi phải tra docs/wiki/runbook nội bộ mỗi ngày và muốn giảm câu hỏi lặp trong Slack.

## Vì sao dùng?

Tri thức team nằm rải; hỏi người thì phiền, hỏi model trần thì nó đoán. Space cho hai thứ: **Instructions** (nói Copilot nên tập trung gì, tránh gì) và **Sources** (nguồn thật để nó trả lời dựa vào) — nguồn là GitHub file/PR/issue thì tự đồng bộ, không có bản index cũ hỏng. Điểm hay nhầm nhất nằm ở chỗ repo và file được nạp **khác nhau**:

| Loại nguồn | Đưa vào space kiểu gì | Hệ quả khi hỏi |
|---|---|---|
| Repository | Attach repo | Copilot **không** nạp cả repo — tìm và lấy phần liên quan; hợp cho "hỏi xuyên suốt docs" |
| File/folder cụ thể | Attach file/folder | Nạp **toàn bộ nội dung** file — hợp cho schema, runbook ngắn |
| PR/issue/link | Dán URL | Trích đúng thread làm ngữ cảnh |
| Upload / text | Upload từ máy, paste ghi chú | Chụp/scan tài liệu cũng vào được — **chỉ dùng được trên web, không qua IDE** |

**Nếu làm sai:** chọn sai kiểu nguồn thì hoặc thiếu ngữ cảnh (muốn đọc trọn schema mà attach repo) hoặc loãng câu trả lời (attach cả repo cho một runbook nhỏ); và đừng coi space là quyền sửa code — nó là context, không phải quyền ghi.

## Cách dùng

Tạo: `github.com/copilot/spaces` → **Create space** → đặt tên → chọn sở hữu (cá nhân hoặc organization) → thêm Instructions + Sources; rồi hỏi:

```prompt
Theo các tài liệu trong space "Team Runbook", deploy staging gồm mấy bước?
Trích nguồn cụ thể (file/section). Nếu không có trong tài liệu thì nói rõ không có.
```

- **Biến thể:** gọi từ IDE qua GitHub MCP — bật toolset Spaces bằng header `X-MCP-Toolsets: default,copilot_spaces`, kiểm `list_copilot_spaces` / `get_copilot_space` có trong danh sách tool.
- **Giới hạn:** từ IDE **không** thấy repo context và uploaded files của space — hai thứ đó chỉ mở được trên web; câu hỏi trong space tính như Chat request, **tiêu AI credits** theo model + tokens.
- **✅ Verify:** mở đúng nguồn được trích và đối chiếu — không mở được nguồn thì coi như chưa có câu trả lời; hỏi một câu chắc chắn **không** có trong tài liệu để xem nó nói "không có" hay bịa.

## Liên quan

- Nối tài liệu ngoài GitHub (space tự nó không thấy): [connector](../../../copilot/system-knowledge/connector/README.md) · Repo bị exclusion thì không vào được context: [content-exclusion](../content-exclusion/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [GitHub Docs — About Copilot Spaces](https://docs.github.com/en/copilot/concepts/prompting-and-context/spaces) · [GitHub Docs — Using Copilot Spaces in your IDE](https://docs.github.com/en/copilot/how-tos/copilot-in-your-ide/customize-copilot/extend-copilot-with-tools-and-context/use-copilot-spaces)
