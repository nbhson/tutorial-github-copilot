# Policy approval — Duyệt lệnh nhạy cảm & set policy cho team

> **Dành cho:** người thấy popup Allow/Deny, và admin set policy cho team · **Đọc xong:** set baseline allow/ask/deny đúng chỗ, không bấm Allow mù (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI / GitHub.com (org policy)

## 1 câu nôm na

Cổng bảo vệ trước máy bạn: lệnh lành cho qua, lệnh nguy hiểm phải "xuất trình". Khi agent xin chạy một lệnh (terminal/MCP), popup **Allow/Deny** hiện ra; còn team thì set baseline **allow/ask/deny** theo từng tool trong settings.

## Hai tầng cổng, đừng nhầm

**Tầng 1 — permission level của cả session** (nguồn VS Code `agents/run/approvals`): **Manual permissions** (mặc định, hỏi trước mỗi tool cần duyệt) · **Assisted permissions** (experimental, LLM chấm rủi ro từng tool call) · **Allow all** (tự duyệt hết — gần như đừng bật). Ở Copilot CLI tương ứng là `/permissions [default|assisted|allow-all|show]`.

**Tầng 2 — quy tắc per-tool** apply cho cả hai harness: `permissions.allow` / `permissions.ask` / `permissions.deny` (terminal, tools, URL) và `tools:` allowlist của agent.

| Mức | Ý nghĩa | Khi nào dùng |
|---|---|---|
| Allow | Cho chạy luôn, không hỏi lại | Tool chỉ-đọc (đọc file/grep/list) hoặc lệnh lành đã tin |
| Ask | Hỏi bạn trước mỗi lần chạy | Lệnh ghi/xóa/MCP chưa chắc — mặc định an toàn |
| Deny | Chặn hẳn, không cho chạy | Lệnh destructive: `rm`, force-push, migration prod |

> **Ba luật thuộc lòng:** (1) thứ tự thắng `deny > ask > allow`, org > team > personal — deny ở đâu cũng thắng allow ở nơi khác; (2) allowlist thực tế là **giao (intersection)** các nguồn, không phải phép hợp; (3) `tools: []` = **lockdown**, agent không còn tool nào. CLI siết thêm bằng `--available-tools`, `--allow-tool`/`--deny-tool`.

**Nếu làm sai thì sao?** Allow hết để "cho nhanh" là mở toang cửa. Ngược lại, deny cả những lệnh đọc lặp lại khiến bạn mỏi tay rồi bấm cho xong — bạn vô hiệu hóa chính cái gate mình dựng công phu.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** agent xin Allow chạy lệnh (terminal/MCP tool); muốn set baseline allow/ask/deny cho team; nghi policy org đang chặn một việc bạn cần.
- **ĐỪNG dùng như chỗ "đổi cho xong":** đừng Allow một lệnh bạn chưa hiểu chỉ để nó chạy tiếp; đừng bật Allow all thay cho sandbox.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Không thấy policy của org áp xuống máy bạn? Check bạn đã sign-in đúng account org (xem [../../system-knowledge/status/README.md](../../system-knowledge/status/README.md)) — policy chỉ áp khi session chạy bằng account thuộc org đó.

## Ví dụ thật

Nghiệp vụ: agent đang làm task migration và xin chạy lệnh migration lên database.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** lệnh nguy hiểm bị chặn và hiện ra để bạn xem trước; các lệnh lành (đọc file, chạy test đọc) vẫn chạy trơn.

**✅ Verify:** thử một lệnh nhạy cảm và một lệnh lành — cái đầu bị hỏi/chặn, cái sau chạy thẳng, đúng theo baseline là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — bấm Allow mù cho một lệnh chưa đọc:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — đọc lệnh, Deny mặc định cho thao tác ghi/xóa:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** Deny là mặc định an toàn cho lệnh ghi/xóa. Chỉ Allow cho những tool đọc mà bạn thật sự tin.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Bấm Allow mù cho qua | Mỏi tay | Deny mặc định cho lệnh ghi/xóa; chỉ allow tools đọc |
| Không biết ai chặn | Nhầm policy vs bug | Xem audit log + policy org, rồi hỏi admin |
| Mỗi máy 1 kiểu approval | Thiếu baseline team | Commit baseline vào repo + viết docs |
| Nới personal mà vẫn bị chặn | Org deny thắng (intersection) | Xin admin nới ở managed policy, không lách local |

## So sánh với Claude Code

| Việc | Copilot (policy approval) | Claude Code | Ghi chú |
|---|---|---|---|
| Duyệt lệnh trước khi chạy | Popup Allow/Deny; baseline allow/ask/deny theo tool | Permission prompt + allowlist trong `settings.json` | Cùng mô hình: đọc thì nới, ghi/xóa thì siết |
| Núm ga tự duyệt | Manual / Assisted / Allow all | Permission modes + `--dangerously-skip-permissions` | Hai bên đều có cửa "tự hết", và hai bên đều khuyên đừng dùng |
| Nơi đặt luật | Settings VS Code (team commit) + `managed-settings.json` (enterprise) + org policy trên GitHub.com | `settings.json` + managed settings của org | Cùng ý nghĩa: luật càng cao càng thắng |

## Best practices (kèm "vì sao")

- **Allow cho tool chỉ-đọc, `ask`/`deny` cho phần còn lại.** *Vì sao?* Việc đọc lặp lại rất nhiều; thao tác ghi/xóa mới là chỗ rủi ro.
- **Đừng lách deny bằng personal setting.** *Vì sao?* allowlist là intersection và `deny > ask > allow` — bạn chỉ làm mình hiểu sai trạng thái thật.
- **Commit baseline của team vào repo.** *Vì sao?* Mỗi máy một kiểu approval thì review chung sẽ loạn; baseline chung giúp hành xử thống nhất.
- **Thấy bị chặn thì xem policy/audit trước khi đoán bug.** *Vì sao?* Phần lớn ca "sao nó không cho chạy" là policy, không phải lỗi công cụ.

## Bài tập nhỏ

1. **(3 phút)** Chạy một lệnh chỉ-đọc qua agent (ví dụ `git diff --stat`), xem nó có hỏi bạn không — nếu không, đó là allow đang hoạt động.
2. **(5 phút)** Thử một lệnh nhạy cảm (ví dụ có `rm`) và chủ động Deny; xác nhận agent dừng lại thay vì lách.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Lý thuyết permission levels & sandbox: [10-modes-permissions-availability.md mục 4](../../../../10-modes-permissions-availability.md) · Sandbox thật sự enforce: [../sandbox-policy/README.md](../sandbox-policy/README.md).
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- VS Code — [Approvals & permission levels](https://code.visualstudio.com/docs/agents/run/approvals) · GitHub — [CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference).

> Approval tốt không phải để chặn cho oai — nó bảo đảm mọi lệnh nguy hiểm đều đi qua mắt người trước khi chạy.
