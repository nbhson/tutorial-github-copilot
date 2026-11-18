# /hooks — Cánh cửa mở hộp cầu dao: xem hook nào đang nạp, cái nào đang vấp

> **Harness:** Copilot · **Surface:** Chat view (VS Code); hook file chạy ở Copilot CLI + Copilot in the cloud · **Đọc:** ~2 phút

**Nôm na:** Cầu dao (hook) nằm trong file JSON, còn `/hooks` là cánh cửa mở hộp ra — thấy mạch nào bật, cái nào vấp, nhưng muốn đi dây lại thì vẫn phải sửa file. Hợp khi tool call bị deny mà bạn không hiểu vì sao, hoặc vừa nhận repo có hook.

## Vì sao dùng?

Hook là cấu hình dạng file — "gọi lệnh" chỉ là cách mở ngăn kéo: card `/hooks` **chỉ tồn tại ở Chat view VS Code** (CLI và cloud không có slash này) và chỉ để xem. Nơi ở thật của hook là `.github/hooks/*.json` (repo, commit cho cả team, chạy cả trên cloud) hoặc `~/.copilot/hooks/` (máy bạn). Docs VS Code: trong nhóm customization, Copilot harness CHỈ có `/prompts` và `/hooks` trong Chat view — các thứ khác phải qua Agent Customizations editor.

| Event / cơ chế | Chặn được ở | Ghi chú từ docs |
|---|---|---|
| `preToolUse` | CLI, VS Code, cloud | exit 2 = deny — chỗ đáng tin nhất để đặt quyết định |
| `permissionRequest` | CLI, VS Code | **vô hiệu trên Copilot in the cloud** (cloud coi `ask` = deny) |
| `notification` | CLI, VS Code | không fire trên cloud — cloud chỉ chạy subset event |
| `timeoutSec` | mọi event | timeout là **fail-open** — hook chậm không chặn âm thầm việc của ai |

**Nếu làm sai:** nghĩ `/hooks` là nơi TẠO hook → mò UI vô ích; entry lọc bằng `matcher` (regex), **không có field `if`**; file sai schema, thiếu `chmod +x` hoặc đặt sai thư mục thì hook lặng lẽ không chạy.

## Cách dùng

Gõ `/hooks` trong Chat view để xem list; khai báo và sửa hành vi bằng file JSON:

```json
{ "version": 1, "hooks": { "preToolUse": [
    { "type": "command", "command": "./.github/hooks/guard.sh", "matcher": "Bash", "timeoutSec": 10 } ] } }
```

- **Biến thể:** script đọc payload JSON từ stdin, exit 0 cho qua / exit 2 chặn; event tên PascalCase hay camelCase đều được — một file nên dùng một kiểu cho dễ grep.
- **Setting:** hook do org policy cài thì dev không gỡ được; giữ `timeoutSec` ngắn cho lệnh nhanh, dài cho lệnh nặng.
- **✅ Verify:** `jq . .github/hooks/*.json` pass (CLI gặp file sai schema in `! Invalid hook configuration in FILE: REASON`), `/hooks` thấy guard nằm list, và agent thử `rm` bị chặn kèm lý do.

## Liên quan

- Policy & guardrail tổng: [07-policies-guardrails-tu-dong-hoa.md](../../../../07-policies-guardrails-tu-dong-hoa.md) · Sandbox & approvals: [sandbox-policy](../../model-agent/sandbox-policy/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Hooks](https://code.visualstudio.com/docs/agent-customization/hooks) · [GitHub Docs — Hooks reference](https://docs.github.com/en/copilot/reference/hooks-reference)
