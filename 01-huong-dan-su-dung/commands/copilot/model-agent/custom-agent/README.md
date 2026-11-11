# Custom agent — Gọi agent riêng của repo

> **Dành cho:** người đã có agent riêng trong `.github/agents/` (explorer, tester, security-reviewer) · **Đọc xong:** gọi đúng chuyên gia và đẩy việc ồn ào sang sub-agent (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Agents window / Copilot CLI

## 1 câu nôm na

Gọi đúng người trong danh bạ: explorer đi trinh sát, tester đi kiểm tra, security-reviewer soi diff. Bạn gọi agent trong `.github/agents/` và nói rõ phạm vi ngay trong lời gọi — chỉ-đọc hay được phép sửa, file nào được đụng.

> **Nơi ở & cách quản lý:** agent là file `.github/agents/<TEN>.agent.md` (repo, commit cho team) hoặc `~/.copilot/agents/<TEN>.agent.md` (user, mọi repo). Ở **Copilot harness**, agent được quản lý bằng **Agent Customizations editor** — lệnh `Chat: Open Customizations` → tab **Agents** — chứ không bằng slash command; `/create-agent` chỉ tồn tại trong *local agent session*.

## Vì sao dùng Custom agent?

Chat chính nếu ôm cả việc trinh sát multi-file sẽ rất ồn: nó đọc mười mấy file, kết quả lẫn lộn, bạn khó theo dõi quyết định nào là chính. Đẩy việc ồn sang sub-agent thì chat chính chỉ còn lại các quyết định gọn gàng.

Ba việc điển hình nên giao cho chuyên gia:

- **Explorer** — trinh sát multi-file: "file nào chạm tới auth, ai gọi ai".
- **Tester** — sau mỗi thay đổi, chạy test focused và báo PASS/FAIL.
- **Security-reviewer** — khi diff chạm auth/payment, soi rủi ro trước khi merge.

**Nếu làm sai thì sao?** Hai lỗi hay gặp: (1) mô tả agent thiếu phạm vi → nó "chạy loạn" ngoài vùng được phép; (2) gọi sai chuyên gia cho việc, ví dụ nhờ tester đi trinh sát → kết quả không đúng thứ bạn cần.

> **Tóm gọn 1 câu:** Custom agent là danh bạ thợ chuyên việc — mô tả `description` + allowlist `tools` nằm ngay trong file `.agent.md`, còn delegate việc ồn là việc của sub-agent.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** việc ồn ào cần cô lập (trinh sát multi-file); muốn chạy test focused sau mỗi change; diff chạm auth/payment cần soi bảo mật.
- **ĐỪNG dùng khi:** việc quá nhỏ hoặc chưa cần tách vai — chat chính là đủ; agent chưa khai báo `tools` giới hạn thì gọi ra cũng không an toàn hơn.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Không thấy agent trong dropdown? Kiểm tra `.github/agents/` có file `.agent.md` tương ứng chưa, rồi mở `Chat: Open Customizations` xem agent được editor nhận diện hay bị gạch field nào.

## Ví dụ thật

Nghiệp vụ: bạn sắp refactor module auth, cần biết có những file nào dính tới nó trước khi sửa.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** một bản đồ gọn (danh sách file + quan hệ gọi nhau + test có/không); chat chính chỉ giữ lại quyết định refactor.

**✅ Verify:** kết quả của sub-agent dán thẳng được vào PR/wiki là đạt — nếu phải viết lại từ đầu thì nó chưa trả đúng thứ cần.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — gọi explorer mà không nói nó chỉ-đọc:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — nêu rõ vai + phạm vi ngay trong lời gọi:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** Custom agent mạnh vì quyền hẹp. Nêu rõ phạm vi trong lời gọi để nó làm đúng vai — sai vai thì chuyên gia thành rủi ro.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Agent "chạy loạn" ngoài phạm vi | Mô tả agent thiếu phạm vi | Ghi rõ chỉ-đọc + files được đụng trong `.agent.md` (`tools` allowlist) |
| Gọi sai agent cho việc | Chưa thuộc danh bạ | Đọc `templates/.github/agents/` 1 lần, ghi nhớ 3 con core |
| Chat chính vẫn ồn | Ôm việc trong chat chính | Giao tay: "dùng subagent khảo sát X, không đổi file" |
| Agent không thấy chat chính | Subagent chạy context riêng, không kế history | Lệnh giao phải tự chứa: goal + context + kết quả mong đợi |

## So sánh với Claude Code

| Việc | Copilot (Custom agent) | Claude Code | Ghi chú |
|---|---|---|---|
| Agent riêng của repo | `.github/agents/<tên>.agent.md` | Subagent trong `.claude/agents/` | Cùng ý tưởng: persona + tool giới hạn |
| Delegate sang sub-agent | Tool native `task` (Copilot harness) | Task/subagent tool | Local harness dùng `agent/runSubagent` — tên tool và args khác nhau |
| Giới hạn công cụ/quyền | Frontmatter `tools` (alias `read` `edit` `execute` `search` `agent` `web` `todo`) | Khai trong định nghĩa subagent | Cả hai đều cho phép thu hẹp quyền theo vai |

## Best practices (kèm "vì sao")

- **Ghi rõ phạm vi trong chính file `.agent.md`.** *Vì sao?* Phạm vi nằm ở định nghĩa thì mọi lời gọi đều được bảo vệ, không phụ thuộc bạn nhớ nhắc.
- **Thuộc 3 agent core trước khi tạo thêm.** *Vì sao?* Danh bạ quá dài thì chính bạn cũng gọi sai — ít mà đúng vai hơn nhiều mà mơ hồ.
- **Đẩy việc ồn sang sub-agent ngay từ đầu.** *Vì sao?* Để nó chạy trong chat chính thì kết quả trinh sát sẽ loãng mất các quyết định bạn cần giữ.
- **Dùng explorer cho chỉ-đọc, tester cho PASS/FAIL.** *Vì sao?* Đúng vai thì kết quả đồng nhất và dán được thẳng vào PR/wiki.

## Bài tập nhỏ

1. **(5 phút)** Gọi explorer vẽ bản đồ file của một module bạn chưa quen, rồi thử dán kết quả vào phần mô tả một PR nháp.
2. **(7 phút)** Mở `Chat: Open Customizations` → tab Agents, đọc `tools` của từng agent và tự hỏi: agent nào đang có quyền ghi không cần thiết? Sửa lại cho hẹp.

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Bài chủ về tạo agent & subagents: [06-custom-agents-parallel.md](../../../../06-custom-agents-parallel.md).
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Skill nạp vào agent: [../../system-knowledge/agent-skill/README.md](../../system-knowledge/agent-skill/README.md) · Task mở không cần danh bạ: [../agent-mode/README.md](../agent-mode/README.md).
- VS Code — [Custom agents](https://code.visualstudio.com/docs/agent-customization/custom-agents) · [Subagents](https://code.visualstudio.com/docs/agents/run/subagents) · GitHub — [Custom agents (CLI)](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-custom-agents).

> Đẩy việc ồn ào sang sub-agent là cách giữ chat chính sạch — chuyên gia trả kết quả, còn bạn giữ quyết định.
