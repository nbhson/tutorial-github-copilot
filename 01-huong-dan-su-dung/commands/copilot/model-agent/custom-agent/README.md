# Custom agent — gọi đội chuyên gia của repo bằng `@`: explorer, tester, security-reviewer

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Agents window / Copilot CLI · **Đọc:** ~2 phút

**Nôm na:** Gọi đúng người trong danh bạ: `@explorer` đi trinh sát, `@tester` chạy test focused, `@security-reviewer` soi diff — mỗi agent là file `.github/agents/<TÊN>.agent.md` với phạm vi và `tools` khai báo sẵn. Hợp khi việc ồn ào (đọc mười mấy file) cần đẩy ra khỏi chat chính để chỗ đó chỉ còn quyết định của bạn.

## Vì sao dùng?

Chat chính tự ôm trinh sát multi-file thì kết quả lẫn lộn, bạn khó thấy quyết định nào là chính; đẩy việc sang sub-agent thì nó trả về bản đồ gọn. Custom agent mạnh vì quyền hẹp: `description` + allowlist `tools` nằm ngay trong file nên phạm vi được bảo vệ ở mọi lời gọi. Một điểm dễ quên: sub-agent chạy **context riêng**, không kế history chat — lệnh giao phải tự chứa goal + context + kết quả mong đợi.

| Agent | Vai | Kết quả điển hình |
|---|---|---|
| explorer | trinh sát chỉ-đọc: file nào chạm tới auth, ai gọi ai | bản đồ file dán thẳng vào PR/wiki |
| tester | chạy test focused sau mỗi thay đổi | verdict PASS/FAIL |
| security-reviewer | soi diff chạm auth/payment trước khi merge | danh sách rủi ro trước merge |

**Nếu làm sai:** gọi sai chuyên gia — nhờ explorer "dọn lại code auth" là giao việc sửa cho agent sinh ra để trinh sát; và gọi agent chưa khai báo `tools` giới hạn thì cũng chẳng an toàn hơn chat chính.

## Cách dùng

Gõ `@` trong Chat view để chọn agent (Copilot CLI cũng có custom agent), nêu rõ phạm vi ngay trong lời gọi:

```prompt
@explorer (chỉ-đọc): vẽ bản đồ 5 file chạm tới auth + ai gọi ai, file nào có test
và file nào không — không sửa gì.
```

- **Biến thể:** muốn agent dùng riêng mọi repo thì để ở `~/.copilot/agents/<TÊN>.agent.md`; file trong `.github/agents/` commit được cho cả team.
- **Setting:** ở Copilot harness, agent quản lý bằng `Chat: Open Customizations` → tab Agents, không bằng slash command — `/create-agent` chỉ tồn tại trong local agent session.
- **✅ Verify:** kết quả sub-agent dán thẳng vào mô tả PR không phải viết lại — phải viết từ đầu là nó chưa trả đúng thứ cần.

## Liên quan

- Task mở không cần danh bạ: [agent-mode](../agent-mode/README.md) · skill nạp vào agent: [agent-skill](../../system-knowledge/agent-skill/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — When to use a custom agent](https://code.visualstudio.com/docs/agent-customization/custom-agents#when-to-use-a-custom-agent) · [VS Code Docs — When to use subagents](https://code.visualstudio.com/docs/agents/run/subagents#when-to-use-subagents)
