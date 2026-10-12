# /agent (Agent mode) — Giao task mở cho agent tự làm

> **Dành cho:** người có task mở, chưa biết chạm file nào · **Đọc xong:** giao task nhiều bước mà vẫn có plan để duyệt (~2 phút)

## 1 câu nôm na

Giao chìa khóa cho đội thợ: tự tìm phòng hỏng, tự làm, còn bạn duyệt ở cuối. Vào Chat → mode **Agent**, rồi bắt nó "đề xuất plan, chờ duyệt" trước khi sửa code.

Vì Agent được phép sửa file và chạy terminal, thói quen an toàn là commit git tay trước khi giao — để nếu có sai thì bạn còn chỗ lùi.

> **UI mới (2026):** Agent tách 3 persona — **Interactive** (dừng hỏi mỗi thay đổi, ≈ Agent + `ask`), **Plan** (chỉ lập kế hoạch, không sửa code), **Autopilot** (tự chạy tới xong, ≈ Agent + `Allow all`). Autopilot chỉ dùng trong worktree riêng + đã bật sandbox. Chi tiết: [10-modes-permissions-availability.md mục 3.2](../../../10-modes-permissions-availability.md).

## Vì sao dùng /agent (Agent mode)?

Có những task mà bạn còn chưa biết file nào dính tới: "thêm rate-limit cho /api/login + test". Ở Ask chỉ có chữ, ở Edit bạn phải tự tick file — trong khi Agent tự đi tìm, sửa, chạy test, đọc lỗi rồi sửa tiếp cho tới khi xong.

Ba chế độ của Chat để bạn chọn đúng cỡ việc:

| Mode | Đặc điểm | Khi nào dùng |
|---|---|---|
| Ask | Chỉ đọc, không sửa file | Hỏi/khảo sát/so sánh phương án trước khi đụng code |
| Edit | Sửa đúng files bạn tick, có kiểm soát | Đã biết sửa 1–5 file, muốn review từng hunk |
| Agent | Tự tìm file, sửa, chạy terminal | Task mở nhiều bước, chưa biết chạm file nào |

**Nếu làm sai thì sao?** Giao một task quá to mà không có plan thì agent dễ sửa loạn, lan ra file ngoài phạm vi. Cách giữ nó trong chuồng rất đơn giản: bắt nó đề xuất plan chờ duyệt, chia phase, và chỉ allow các tool đọc.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** task mở nhiều bước ("thêm rate-limit cho /api/login + test"); chưa biết chạm file nào, cần agent tự tìm; việc multi-step: sửa + chạy lệnh + sửa tiếp.
- **ĐỪNG dùng khi:** việc chỉ sửa một đoạn đang bôi đen → `/fix`; hoặc biết rõ 1–5 file cần sửa → **Edit mode** nhanh và gọn hơn.
- **Cho ai:** người giao việc nhiều bước; chưa hợp người mới với task lớn — người mới nên bắt đầu ở Ask/Edit.

## Cách gọi (copy-paste)

```bash
Chat → mode Agent
"thêm rate-limit cho /api/login + test; duyệt plan trước khi code"
# Kỳ vọng: agent liệt kê file + plan trước, chờ duyệt, không code tự ý
# Verify: git log mới nhất là commit của bạn (checkpoint), diff agent gọn trong scope
```

> Không thấy **Agent** trong dropdown? Xem `/status` + plan trước khi kết luận lỗi; trên UI mới persona có thể mang tên Interactive / Plan / Autopilot.

## Ví dụ thật

Nghiệp vụ: `/api/login` đang không có giới hạn số lần thử, bạn muốn thêm rate-limit nhưng chưa biết middleware nằm ở đâu.

```bash
# 1. Commit git tay để có checkpoint
git add -A && git commit -m "checkpoint truoc khi giao agent"
# 2. Giao task có plan gate
(Agent) "thêm rate-limit cho /api/login: tìm code route + middleware hiện tại,
đề xuất plan (đổi file nào, dùng lib nào), chờ tôi duyệt rồi mới code + viết test"
# 3. Duyệt plan -> để agent code -> review diff cuối
```

**Kết quả mong đợi:** Agent liệt kê file đã đọc + plan để bạn duyệt; code + test theo từng phase; bạn review diff cuối trước khi nhận.

**✅ Verify:** Plan được duyệt trước + test xanh + diff gọn trong scope là đạt; `git log` có commit checkpoint của bạn ngay trước.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — thả một task mơ hồ, không plan, không checkpoint:**

```bash
(Agent) "làm login cho ngon hơn"
# -> sửa lung tung, không có commit để lùi
```

**✅ ĐÚNG — khóa scope + plan gate + checkpoint trước:**

```bash
git commit -m "checkpoint"
(Agent) "trong apps/api: thêm rate-limit cho POST /api/login (5 lần/phút theo IP).
Đề xuất plan chờ duyệt. Duyệt rồi mới code + test. Đừng đụng web/."
```

**Bài học:** Agent mạnh vì tự đi tìm việc, và đó cũng là lý do bạn phải vạch phạm vi + bắt duyệt plan trước. Không có "hàng rào" thì "tự làm" thành "tự tung".

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Agent chạy loạn, sửa lung tung | Giao task quá to không plan | Bắt "đề xuất plan, chờ duyệt" + chia phase |
| Approve tool mù | Mỏi tay bấm Allow | Để `ask` cho lệnh nguy hiểm; allow chỉ tools đọc |
| Không checkpoint trước | Sửa sai khó về | Commit git tay trước khi giao agent |

## So sánh với Claude Code

| Việc | Copilot (/agent) | Claude Code | Ghi chú |
|---|---|---|---|
| Mặc định agentic | Phải chọn mode Agent | Agent là mặc định | Copilot leo thang từng bước; Claude Code agentic sẵn |
| Duyệt trước khi làm | Plan gate / persona Interactive | Plan mode (duyệt kế hoạch trước) | Cùng tinh thần: xem plan rồi mới cho sửa |
| Chạy tự động tới xong | Persona Autopilot (cần sandbox + worktree) | Auto-accept edits / chạy liên tục | Cả hai đều rủi ro nếu repo chưa sạch |

## Best practices (kèm "vì sao")

- **Bắt agent đề xuất plan và chờ duyệt.** *Vì sao?* Xem plan là lúc bạn phát hiện nó hiểu sai scope — rẻ hơn nhiều so với sửa lại cả đống diff.
- **Commit git trước khi giao.** *Vì sao?* Agent sai thì bạn `git reset` về checkpoint, khỏi mò tay từng file.
- **Chỉ allow các tool đọc; để `ask` cho lệnh ghi/xóa.** *Vì sao?* Bấm Allow mù cho terminal là cách nhanh nhất để một lệnh nguy hiểm chạy mà bạn không hay.
- **Chia phase, review giữa các phase.** *Vì sao?* Task dài dễ trôi; điểm review giữa đường giúp bạn bắt hướng sai sớm.

## Bài tập nhỏ

1. **(5 phút)** Giao Agent một task mở nhưng **không** bắt plan, xem nó làm gì trước. Rồi giao lại lần nữa có "duyệt plan trước" và so sánh độ tập trung.
2. **(7 phút)** Làm đúng quy trình: commit checkpoint → giao task có scope → duyệt plan → review diff. Ghi lại cảm giác khi biết mình luôn có đường lùi.
3. **(7 phút)** Thử persona Plan cho một task lớn: để nó chỉ lập kế hoạch, đọc kỹ plan, rồi mới chuyển sang để nó thực thi.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Lý thuyết modes + persona: [10-modes-permissions-availability.md mục 3.2](../../../10-modes-permissions-availability.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Biết rõ file cần sửa: [../edit-mode/README.md](../edit-mode/README.md). Hỏi trước khi đụng: [../ask-mode/README.md](../ask-mode/README.md).

> Agent giỏi tự đi tìm việc, nhưng chỉ trong phạm vi bạn vạch. Plan trước, checkpoint trước, rồi mới thả.
