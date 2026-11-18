# Policy approval — cổng duyệt lệnh nhạy cảm: permission level của session + quy tắc per-tool

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI / GitHub.com (org policy) · **Đọc:** ~2 phút

**Nôm na:** Cổng bảo vệ trước máy bạn: popup **Allow/Deny** hiện ra khi agent xin chạy lệnh terminal/MCP, còn team set baseline **allow/ask/deny** theo từng tool trong settings. Hợp khi bạn mỏi tay bấm Allow, hoặc là admin muốn chính sách ngấm xuống máy thật.

## Vì sao dùng?

Cổng có hai tầng đừng nhầm: tầng 1 là permission level của **cả session**, tầng 2 là quy tắc **per-tool**; và ba luật thuộc lòng — `deny > ask > allow`, org > team > personal, allowlist nhiều nguồn là **giao** (intersection) chứ không phải phép hợp.

| Tầng / luật | Quản gì | Chỉnh ở đâu |
|---|---|---|
| Permission level của session | **Manual** (mặc định, hỏi trước mỗi tool cần duyệt) · **Assisted** (experimental, LLM chấm rủi ro từng tool call) · **Allow all** (gần như đừng bật) | VS Code; CLI: `/permissions [default\|assisted\|allow-all\|show]` |
| Quy tắc per-tool | `permissions.allow` / `ask` / `deny` cho terminal, tools, URL; `tools:` allowlist của agent | `.vscode/settings.json` (team commit), `managed-settings.json` (enterprise), org policy |
| Thứ tự thắng | `deny > ask > allow`; org > team > personal — deny ở đâu cũng thắng allow ở nơi khác | không lách được bằng personal setting |
| `tools: []` | lockdown — agent không còn tool nào | frontmatter file agent |

**Nếu làm sai:** allow hết để "cho nhanh" là mở toang cửa; ngược lại deny cả lệnh đọc lặp lại thì bạn mỏi tay rồi bấm cho xong — vô hiệu hóa chính cái gate mình dựng.

## Cách dùng

Đọc hết lệnh trước khi bấm khi popup Allow/Deny hiện ra (Copilot harness); baseline chung của team đặt trong settings commit vào repo:

```json
// team baseline — .vscode/settings.json
"permissions": {
  "allow": ["đọc file", "grep", "list"],
  "ask": ["npm run migrate --up"],
  "deny": ["rm", "force-push", "migration prod"]
}
```

- **Biến thể:** Allow cho tool chỉ-đọc; `ask`/`deny` cho lệnh ghi/xóa và MCP chưa chắc — `Allow all` không thay được sandbox ([sandbox-policy](../sandbox-policy/README.md)).
- **Setting:** CLI siết thêm bằng `--available-tools`, `--allow-tool` / `--deny-tool <tên>`; org policy chỉ áp khi session chạy bằng account thuộc org đó.
- **✅ Verify:** thử một lệnh nhạy cảm (có `rm`) và một lệnh lành (đọc file) — cái đầu bị hỏi/chặn, cái sau chạy thẳng, đúng baseline là đạt.

## Liên quan

- sandbox quyết định *đi tới đâu*, approvals quyết định *ai được bấm*: [sandbox-policy](../sandbox-policy/README.md) · theory modes & permission levels: [10-modes-permissions-availability.md](../../../../10-modes-permissions-availability.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Manage tool approvals](https://code.visualstudio.com/docs/agents/run/approvals#manage-tool-approvals) · [GitHub Docs — CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
