# /usage — Xem quota AI Credits đã dùng

> **Dành cho:** người muốn biết mình đã tiêu bao nhiêu AI Credits · **Đọc xong:** đọc được đã dùng / còn lại / ngày reset để quyết tiết kiệm hay xả (~2 phút)

## 1 câu nôm na

Xem công-tơ điện để biết mình đã xài bao nhiêu, khỏi bị "cúp" giữa tháng. `/usage` (hoặc dashboard) cho bạn con số đã dùng, còn lại và ngày reset.

Một fact cần nhớ: từ 01/06/2026 Copilot tính theo mô hình **AI Credits** (1 credit = $0.01, usage-based) — đây là cách gọi mới thay cho "premium requests" cũ. Điểm dễ chịu: gợi ý code (code completion) vẫn **không** trừ credit trên các plan trả phí.

## Vì sao dùng /usage?

Hết credit giữa tháng thường không phải "xui" — nó là hệ quả của việc dùng model mạnh cho việc nhẹ trong nhiều ngày. Nhìn công-tơ định kỳ giúp bạn phát hiện thói quen tốn kém trước khi nó thành sự cố.

Nó cũng giúp bạn phân biệt hai chuyện rất khác nhau: **hết quota** và **model đang lỗi**. Hai thứ này hiện ra dưới dạng "báo error" na ná nhau, nhưng cách xử lý hoàn toàn khác.

**Nếu làm sai thì sao?** Nếu bạn coi mọi báo lỗi là bug và mở issue, bạn tốn thời gian cho một việc chỉ cần đổi model hoặc chờ reset. Ngược lại, coi "hết quota" là chuyện nhỏ rồi cứ đẩy task khó lên model mạnh thì hết tháng là tay trắng.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** đầu tuần muốn biết còn bao nhiêu; gặp báo quota exhausted; cuối tháng rút kinh nghiệm phân bổ.
- **ĐỪNG dùng như chẩn đoán lỗi:** nếu thấy error mà chưa đọc kỹ message, đừng kết luận là quota trước khi xem nó nói gì.
- **Cho ai:** người dùng plan cá nhân trả phí, admin theo dõi credit của team.

## Cách gọi (copy-paste)

```bash
/usage
# hoặc github.com/settings/copilot → quota
# Kỳ vọng: biết con số đã dùng/còn lại + ngày reset
# Verify: nói được "còn X, đủ/không đủ tới reset"
```

> Không thấy số liệu? Đăng nhập đúng account GitHub đang dùng Copilot, rồi mở `github.com/settings/copilot` → Usage làm chuẩn.

## Ví dụ thật

Nghiệp vụ: bạn đang giữa sprint, tự trả tiền theo usage, và sắp giao một loạt task agent. Trước khi fan-out nhiều session, kiểm tra công-tơ.

```bash
/usage "cho biết đã dùng bao nhiêu, còn lại bao nhiêu, reset ngày nào"
# Hoặc mở dashboard để chắc chắn:
# github.com/settings/copilot → Usage (theo ngày/user)
# Quyết định: còn dư nhiều -> chạy agent song song thoải mái;
#            còn ít -> chuyển sang model rẻ cho các việc explain/doc
```

**Kết quả mong đợi:** Biết con số đã dùng/còn lại + ngày reset, từ đó quyết được "tiết kiệm hay xả" cho phần còn lại của tháng.

**✅ Verify:** Nói ra được một câu kiểu "còn X, đủ/không đủ tới ngày reset" là đạt — không phải chỉ "ừ chắc ổn".

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — thấy error là mở issue, không đọc message:**

```bash
# "Copilot báo lỗi, chắc hỏng rồi" -> mở issue
# Thực ra message ghi rõ: quota exhausted
```

**✅ ĐÚNG — đọc kỹ message rồi tra công-tơ trước:**

```bash
/usage   # xác nhận quota
# Nếu quota exhausted: giảm model / chờ reset
# Nếu là model unavailable: đổi model khác -> báo admin nếu vẫn lỗi
```

**Bài học:** "Hết quota" và "model lỗi" là hai ca khác nhau. Tra công-tơ trước khi kết luận, khỏi mở ticket sai.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Hết quota giữa tháng | Dùng model mạnh cho việc nhẹ | Việc nhẹ → model rẻ; agent → mạnh; prune MCP |
| Không biết ai xài nhiều (team) | Thiếu theo dõi org | Admin xem billing/seats + audit log |
| Nhầm quota với bug | Báo error là tưởng hỏng | Đọc kỹ message: quota vs model unavailable khác nhau |

## So sánh với Claude Code

| Việc | Copilot (/usage) | Claude Code | Ghi chú |
|---|---|---|---|
| Xem đã tiêu | Dashboard `github.com/settings/copilot` + `/usage` | `/cost` xem chi phí phiên | Copilot là AI Credits theo usage; Claude Code hay gắn gói subscription |
| Đơn vị tính | AI Credits (1 credit = $0.01) | Token / chi phí phiên | Cơ chế khác, cùng phải đo mới kiểm soát được |
| Completions miễn phí | Code completion không trừ credit (plan trả phí) | Không có autocomplete truyền thống như Copilot | Điểm Copilot lợi thế ở gõ code từng dòng |

## Best practices (kèm "vì sao")

- **Xem công-tơ đầu tuần và cuối tháng.** *Vì sao?* Thấy xu hướng sớm thì kịp chỉnh thói quen, thay vì cháy túi rồi mới tiếc.
- **Đặt mặc định là model rẻ.** *Vì sao?* Phần lớn lượt chat là việc nhẹ; chỉ một số ít cần model mạnh, mà giá chênh rất nhiều.
- **Prune MCP/extension khi không dùng.** *Vì sao?* Mỗi tool thừa là một cách để model chọn nhầm, và các lượt "chọn nhầm" đều tính credit.
- **Phân biệt quota vs model lỗi trước khi báo admin.** *Vì sao?* Đọc message mất 10 giây; mở ticket sai mất cả buổi của bạn và admin.

## Bài tập nhỏ

1. **(3 phút)** Mở `github.com/settings/copilot`, ghi lại con số hiện tại trước khi làm một task dài.
2. **(5 phút)** Làm một task agent dài rồi quay lại dashboard, xem nó tiêu tốn bao nhiêu và bằng model nào.
3. **(5 phút)** Tìm một câu "báo lỗi" bất kỳ trong `github.com/settings/copilot` hoặc chat, phân loại xem là quota hay model unavailable, rồi quyết định hành động.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Chọn model cho đỡ tốn: [../model-picker/README.md](../model-picker/README.md).

> Đừng đợi hết credit mới nhìn công-tơ — biết mình còn bao nhiêu là cách rẻ nhất để không phải dừng giữa việc.
