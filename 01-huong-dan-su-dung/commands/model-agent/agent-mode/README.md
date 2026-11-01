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

> **Cách đọc bảng này:** ba dòng xếp theo độ tự chủ tăng dần — đọc từ trên xuống và dừng ở dòng đầu tiên còn đủ dùng cho việc của bạn; càng xuống dưới, càng cần hàng rào (plan, checkpoint).

**Nếu làm sai thì sao?** Giao một task quá to mà không có plan thì agent dễ sửa loạn, lan ra file ngoài phạm vi. Cách giữ nó trong chuồng rất đơn giản: bắt nó đề xuất plan chờ duyệt, chia phase, và chỉ allow các tool đọc.

> **Tóm gọn 1 câu:** Agent là đội thợ tự đi tìm việc — giao task càng mơ hồ thì thợ càng sửa lung tung, nên vạch phạm vi + bắt duyệt plan trước khi thả.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** task mở nhiều bước ("thêm rate-limit cho /api/login + test"); chưa biết chạm file nào, cần agent tự tìm; việc multi-step: sửa + chạy lệnh + sửa tiếp.
- **ĐỪNG dùng khi:** việc chỉ sửa một đoạn đang bôi đen → `/fix`; hoặc biết rõ 1–5 file cần sửa → **Edit mode** nhanh và gọn hơn.
- **Cho ai:** người giao việc nhiều bước; chưa hợp người mới với task lớn — người mới nên bắt đầu ở Ask/Edit.

> **Tóm gọn 1 câu:** Task mở, chưa biết chạm file nào → Agent; đã biết đúng chỗ → Edit hay `/fix` rẻ và an toàn hơn.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Không thấy **Agent** trong dropdown? Xem `/status` + plan trước khi kết luận lỗi; trên UI mới persona có thể mang tên Interactive / Plan / Autopilot.

## Ví dụ thật

Nghiệp vụ: `/api/login` đang không có giới hạn số lần thử, bạn muốn thêm rate-limit nhưng chưa biết middleware nằm ở đâu.

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

Agent chạy "trôi" ngoài dự kiến? Ba ca dưới đây là những lần thả rông thường gặp — tra theo Triệu chứng rồi áp Fix.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Agent chạy loạn, sửa lung tung | Giao task quá to không plan | Bắt "đề xuất plan, chờ duyệt" + chia phase |
| Approve tool mù | Mỏi tay bấm Allow | Để `ask` cho lệnh nguy hiểm; allow chỉ tools đọc |
| Không checkpoint trước | Sửa sai khó về | Commit git tay trước khi giao agent |

> **Cách đọc bảng này:** đọc theo hàng từ Triệu chứng → Fix; cả ba Fix đều là "hàng rào dựng trước khi giao việc" — sửa sau khi agent đã chạy thì đã muộn.

## So sánh với Claude Code

Cũng dùng Claude Code? Bảng này đối chiếu cách hai công cụ chia mức tự chủ — chỗ khác bản chất nằm ở cột Ghi chú.

| Việc | Copilot (/agent) | Claude Code | Ghi chú |
|---|---|---|---|
| Mặc định agentic | Phải chọn mode Agent | Agent là mặc định | Copilot leo thang từng bước; Claude Code agentic sẵn |
| Duyệt trước khi làm | Plan gate / persona Interactive | Plan mode (duyệt kế hoạch trước) | Cùng tinh thần: xem plan rồi mới cho sửa |
| Chạy tự động tới xong | Persona Autopilot (cần sandbox + worktree) | Auto-accept edits / chạy liên tục | Cả hai đều rủi ro nếu repo chưa sạch |

> **Cách đọc bảng này:** đọc theo hàng so khớp tư duy; hàng cuối đáng nhớ nhất — chạy tự động tới xong nào cũng cần repo sạch + lối thoát, không phân biệt công cụ.

## Best practices (kèm "vì sao")

Bốn thói quen dưới đây là dây cương cho agent — mỗi thói quen kèm lý do để bạn biết khi nào được nới.

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
