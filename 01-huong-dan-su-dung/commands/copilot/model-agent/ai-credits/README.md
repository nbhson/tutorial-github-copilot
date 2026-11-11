# AI Credits — Đã tiêu bao nhiêu, còn lại bao nhiêu

> **Dành cho:** người muốn biết mình đã tiêu bao nhiêu AI Credits · **Đọc xong:** đọc được đã dùng / còn lại / ngày reset để quyết tiết kiệm hay xả (~2 phút)
> **Harness:** Copilot · **Surface:** GitHub.com (dashboard) / Copilot CLI / VS Code Chat (Copilot harness)

## 1 câu nôm na

Xem công-tơ điện để biết mình đã xài bao nhiêu, khỏi bị "cúp" giữa tháng. Trang **Plan & usage** trên GitHub.com cho bạn con số đã dùng, còn lại và ngày reset; Copilot CLI thì báo mức tiêu theo từng model trong phiên.

Một fact cần nhớ: từ 01/06/2026 Copilot tính theo mô hình **AI Credits** — **1 credit = $0.01**, tính **per-token** theo bảng giá từng model. Code completion và next edit suggestions **không** trừ credit, không giới hạn trên các plan trả phí.

## Vì sao phải theo dõi AI Credits?

Hết credit giữa tháng thường không phải "xui" — nó là hệ quả của việc dùng model mạnh cho việc nhẹ trong nhiều ngày. Nhìn công-tơ định kỳ giúp bạn phát hiện thói quen tốn kém trước khi nó thành sự cố. Nó cũng giúp bạn phân biệt hai chuyện rất khác nhau: **hết credit** và **model đang lỗi** — hai thứ báo lỗi na ná nhau nhưng cách xử lý hoàn toàn khác.

| Nơi xem / siết | Surface | Dùng để |
|---|---|---|
| `github.com/settings/copilot` → Plan & usage | GitHub.com | số đã dùng / còn lại / ngày reset, budget của tổ chức |
| Bảng tổng kết phiên theo model | Copilot CLI | model nào đang ngốn credit trong phiên này |
| `--max-ai-credits` · `/limits` | Copilot CLI | soft cap cho **lượt trả lời tiếp theo** (cap cả phiên: `--max-session-credits`) |

> **Cấu trúc plan:** cá nhân có Free / Pro / Pro+ / **Max**; enterprise dùng **Bundled AI credits budget** kèm tuỳ chọn *"Stop usage when budget limit is reached"*. Code review tính theo **review effort** (Lite / Balanced / Max) chứ không còn hệ số trừ theo đơn vị gọi hàng như tài liệu cũ — đây là lý do mọi bảng "1 request = 1 đơn vị" trong các khoá cũ đều đã lỗi thời.

**Nếu làm sai thì sao?** Coi mọi báo lỗi là bug và mở issue thì bạn tốn thời gian cho một việc chỉ cần đổi model hoặc chờ reset. Ngược lại, coi "hết credit" là chuyện nhỏ rồi cứ đẩy task khó lên model mạnh thì hết tháng là tay trắng.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** đầu tuần muốn biết còn bao nhiêu; gặp báo quota exhausted; cuối tháng rút kinh nghiệm phân bổ; trước khi fan-out nhiều session agent.
- **ĐỪNG dùng như chẩn đoán lỗi:** thấy error mà chưa đọc kỹ message thì đừng kết luận là quota.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Không thấy số liệu? Đăng nhập đúng account GitHub đang dùng Copilot, rồi mở `github.com/settings/copilot` → Usage làm chuẩn; dashboard có độ trễ so với phiên vừa chạy.

## Ví dụ thật

Nghiệp vụ: bạn đang giữa sprint, tự trả tiền theo usage, và sắp giao một loạt task agent. Trước khi fan-out, kiểm tra công-tơ.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** biết con số đã dùng/còn lại + ngày reset, từ đó quyết được "tiết kiệm hay xả" cho phần còn lại của tháng.

**✅ Verify:** nói ra được một câu kiểu "còn X, đủ/không đủ tới ngày reset" là đạt — không phải chỉ "ừ chắc ổn".

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — thấy error là mở issue, không đọc message:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — đọc kỹ message rồi tra công-tơ trước:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** "Hết credit" và "model lỗi" là hai ca khác nhau. Tra công-tơ trước khi kết luận, khỏi mở ticket sai.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Hết credit giữa tháng | Dùng model mạnh cho việc nhẹ | Việc nhẹ → model rẻ; agent → mạnh; prune MCP tools thừa |
| Không biết ai xài nhiều (team) | Thiếu theo dõi org | Admin xem budget/seats + audit log trên GitHub.com |
| Nhầm credit với bug | Báo error là tưởng hỏng | Đọc message: quota exhausted vs model unavailable khác nhau |
| Nghĩ completion tốn tiền | Tin tài liệu cũ "mọi request trừ quota" | Docs: completion & next edit suggestions không billed by credits |

## So sánh với Claude Code

| Việc | Copilot (AI Credits) | Claude Code | Ghi chú |
|---|---|---|---|
| Xem đã tiêu | Dashboard `github.com/settings/copilot`; CLI `/limits` theo model trong phiên | Tiện ích báo chi phí theo phiên | Copilot dùng đơn vị credit dùng chung cho mọi surface |
| Đơn vị tính | AI Credits (1 credit = $0.01), per-token | Token / chi phí phiên | Cơ chế khác, cùng phải đo mới kiểm soát được |
| Completions miễn phí | Code completion không trừ credit (plan trả phí) | Không có autocomplete truyền thống như Copilot | Điểm Copilot lợi thế ở gõ code từng dòng |

## Best practices (kèm "vì sao")

- **Xem công-tơ đầu tuần và cuối tháng.** *Vì sao?* Thấy xu hướng sớm thì kịp chỉnh thói quen, thay vì cháy túi rồi mới tiếc.
- **Đặt mặc định là model rẻ.** *Vì sao?* Phần lớn lượt chat là việc nhẹ; chỉ một số ít cần model mạnh, mà giá chênh rất nhiều.
- **Giao task lớn thì đặt cap bằng `--max-ai-credits`/`/limits`.** *Vì sao?* Cap mềm theo lượt giúp một session chạy sai hướng không kéo hết credit của tháng.
- **Phân biệt quota vs model lỗi trước khi báo admin.** *Vì sao?* Đọc message mất 10 giây; mở ticket sai mất cả buổi của bạn và admin.

## Bài tập nhỏ

1. **(3 phút)** Mở `github.com/settings/copilot`, ghi lại con số hiện tại trước khi làm một task dài.
2. **(5 phút)** Làm một task agent dài rồi quay lại dashboard, xem nó tiêu tốn bao nhiêu và bằng model nào.

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Chọn model cho đỡ tốn: [../model-picker/README.md](../model-picker/README.md) · Tài khoản/plan: [../../system-knowledge/status/README.md](../../system-knowledge/status/README.md).
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Bài chi tiết chọn model & giá: [14-models-chon-model-dung.md](../../../../14-models-chon-model-dung.md).
- GitHub — [Models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) · [About Copilot plans](https://docs.github.com/en/copilot/get-started/plans).

> Đừng đợi hết credit mới nhìn công-tơ — biết mình còn bao nhiêu là cách rẻ nhất để không phải dừng giữa việc.
