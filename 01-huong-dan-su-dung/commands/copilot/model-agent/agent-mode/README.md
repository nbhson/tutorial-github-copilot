# Agent mode — Giao task mở cho agent tự làm

> **Dành cho:** người có task mở, chưa biết chạm file nào · **Đọc xong:** giao task nhiều bước mà vẫn có plan để duyệt (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Agents window / Copilot CLI

## 1 câu nôm na

Giao chìa khóa cho đội thợ: tự tìm phòng hỏng, tự làm, còn bạn duyệt ở cuối. Trong Chat → chọn agent **Agent**, rồi bắt nó "đề xuất plan, chờ duyệt" trước khi sửa code.

Vì Agent được phép sửa file và chạy terminal, thói quen an toàn là commit git tay trước khi giao — để nếu có sai thì bạn còn chỗ lùi.

> **Built-in agents:** Copilot harness có ba agent dựng sẵn — **Ask** (chỉ đọc, trả lời), **Plan** (lập kế hoạch, chưa code), **Agent** (sửa + chạy terminal). **Autopilot** là một *agent mode* ("tự chạy tới xong"), không phải permission level; còn **Edit** là mode của Local harness. Chi tiết: [10-modes-permissions-availability.md mục 3.2](../../../../10-modes-permissions-availability.md).

## Vì sao dùng Agent mode?

Có những task mà bạn còn chưa biết file nào dính tới: "thêm rate-limit cho /api/login + test". Ở Ask chỉ có chữ, trong khi Agent tự đi tìm, sửa, chạy test, đọc lỗi rồi sửa tiếp cho tới khi xong. Ba mức can thiệp, chọn đúng cỡ việc:

| Built-in agent | Đặc điểm | Khi nào dùng |
|---|---|---|
| Ask | Chỉ đọc, không sửa file | Hỏi/khảo sát/so sánh phương án trước khi đụng code |
| Plan | Nghiên cứu + lập plan, chưa thực thi | Task đủ lớn để cần xem hình hài trước khi chạy |
| Agent | Tự tìm file, sửa, chạy terminal | Task mở nhiều bước, chưa biết chạm file nào |

> **Cách đọc bảng này:** xếp theo độ tự chủ tăng dần — đọc từ trên xuống và dừng ở dòng đầu tiên còn đủ dùng; càng xuống dưới càng cần hàng rào (plan, checkpoint). Mode **Edit** (tick từng file) chỉ có ở Local harness — xem [edit-mode](../../../local/model-agent/edit-mode/README.md).

**Nếu làm sai thì sao?** Giao một task quá to mà không có plan thì agent dễ sửa loạn, lan ra file ngoài phạm vi. Cách giữ nó trong chuồng rất đơn giản: bắt nó đề xuất plan chờ duyệt, chia phase, chỉ allow các tool đọc, và để permission level ở **Manual** (mặc định). Tóm gọn: Agent là đội thợ tự đi tìm việc — giao task càng mơ hồ thì thợ càng sửa lung tung, nên vạch phạm vi trước khi thả.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** task mở nhiều bước; chưa biết chạm file nào, cần agent tự tìm; việc cần sửa + chạy lệnh + sửa tiếp liên hoàn.
- **ĐỪNG dùng khi:** chỉ sửa một đoạn đang bôi đen → inline chat `/fix`; chỉ cần đọc → Ask; chưa bật sandbox mà repo đang bẩn → dựng hàng rào trước ([sandbox-policy](../sandbox-policy/README.md)).

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

## Ví dụ thật

Nghiệp vụ: `/api/login` đang không có giới hạn số lần thử; bạn muốn thêm rate-limit nhưng chưa biết middleware nằm ở đâu.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** Agent liệt kê file đã đọc + plan để bạn duyệt; code + test theo từng phase; bạn review diff cuối trước khi nhận.

**✅ Verify:** Plan được duyệt trước + test xanh + diff gọn trong scope là đạt; `git log` có commit checkpoint của bạn ngay trước.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — thả một task mơ hồ, không plan, không checkpoint:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — khóa scope + plan gate + checkpoint trước:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** Agent mạnh vì tự đi tìm việc, và đó cũng là lý do bạn phải vạch phạm vi + bắt duyệt plan trước. Không có "hàng rào" thì "tự làm" thành "tự tung".

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Agent chạy loạn, sửa lung tung | Giao task quá to không plan | Bắt "đề xuất plan, chờ duyệt" + chia phase |
| Approve tool mù | Mỏi tay bấm Allow | Để `ask` cho lệnh nguy hiểm; allow chỉ tools đọc |
| Không checkpoint trước | Sửa sai khó về | Commit git tay trước khi giao agent |

## So sánh với Claude Code

| Việc | Copilot (Agent) | Claude Code | Ghi chú |
|---|---|---|---|
| Mặc định agentic | Phải chọn built-in agent Agent | Agent là mặc định | Copilot leo thang từng bước; Claude Code agentic sẵn |
| Duyệt trước khi làm | Plan agent / bắt "plan chờ duyệt" | Plan mode (duyệt kế hoạch trước) | Cùng tinh thần: xem plan rồi mới cho sửa |
| Chạy tự động tới xong | Autopilot (agent mode, cần sandbox + repo sạch) | Auto-accept edits / chạy liên tục | Cả hai đều rủi ro nếu repo chưa sạch |

## Best practices (kèm "vì sao")

- **Bắt agent đề xuất plan và chờ duyệt.** *Vì sao?* Xem plan là lúc bạn phát hiện nó hiểu sai scope — rẻ hơn nhiều so với sửa lại cả đống diff.
- **Commit git trước khi giao.** *Vì sao?* Agent sai thì bạn `git reset` về checkpoint, khỏi mò tay từng file.
- **Chỉ allow các tool đọc; để `ask` cho lệnh ghi/xóa.** *Vì sao?* Bấm Allow mù cho terminal là cách nhanh nhất để một lệnh nguy hiểm chạy mà bạn không hay.

## Bài tập nhỏ

1. **(5 phút)** Giao Agent một task mở nhưng **không** bắt plan, xem nó làm gì trước. Rồi giao lại lần nữa có "duyệt plan trước" và so sánh độ tập trung.
2. **(7 phút)** Làm đúng quy trình: commit checkpoint → giao task có scope → duyệt plan → review diff. Ghi lại cảm giác khi biết mình luôn có đường lùi.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent · Modes & permission levels: [10-modes-permissions-availability.md](../../../../10-modes-permissions-availability.md).
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Biết rõ file cần sửa (Local harness): [edit-mode](../../../local/model-agent/edit-mode/README.md). Hỏi trước khi đụng: [../ask-mode/README.md](../ask-mode/README.md).
- VS Code — [Approvals & permission levels](https://code.visualstudio.com/docs/agents/run/approvals) · [Agent harnesses](https://code.visualstudio.com/docs/agents/concepts/agent-harnesses).

> Agent giỏi tự đi tìm việc, nhưng chỉ trong phạm vi bạn vạch. Plan trước, checkpoint trước, rồi mới thả.
