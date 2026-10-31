# Telemetry — Xem/sửa code-telemetry consent

> **Dành cho:** người onboard máy mới và người phải trả lời câu hỏi audit quyền riêng tư · **Đọc xong:** đọc được trạng thái consent và đối chiếu policy team (~2 phút)

## 1 câu nôm na

Telemetry là công tắc "máy này có được phép gửi dữ liệu dùng để cải thiện sản phẩm hay không". Bạn vào Settings, search "telemetry" hoặc "copilot data" để xem trạng thái và bật/tắt theo policy team. Điểm cần khắc cốt: telemetry **khác** train (code có bị dùng huấn luyện model không) và **khác** duplication (kiểm tra trùng code public) — ba công tắc riêng biệt, đừng gộp làm một.

## Vì sao phải quan tâm Telemetry?

Vì đây là thứ đầu tiên bị hỏi khi onboarding máy công ty hoặc khi làm audit quyền riêng tư. Nếu bạn nhầm telemetry với train, bạn sẽ trả lời sai câu audit — hoặc tệ hơn, tắt telemetry rồi tưởng mình đã chặn được việc code bị dùng để train. Telemetry chỉ là *đồng ý gửi dữ liệu cải thiện sản phẩm*; chặn train là một setting khác nằm ở chỗ khác.

**Nếu làm sai thì sao?** Hai hậu quả: (1) audit hỏi "máy này gửi những gì?" mà bạn không có câu trả lời; (2) bạn đổi setting local trong khi org đã đè policy — đổi xong tưởng xong, thực tế không ăn.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** onboard máy mới / máy công ty; audit quyền riêng tư; cần trả lời "máy này đang gửi dữ liệu gì".
- **ĐỪNG nhầm với:** câu "code có bị train không" (đó là setting **train/opt-out**, xem [FAQ bảo mật – quyền riêng tư](../../../../03-cau-hoi-thuong-gap/09-bao-mat-quyen-rieng-tu.md)); câu trùng code public (đó là **duplication filter**); câu máy đang ở plan/model nào (dùng [`/status`](../status/README.md)).

> Phân biệt nhanh bốn khái niệm hay bị lẫn:

| Khái niệm | Là gì | Khi nào dùng |
|---|---|---|
| Telemetry | Consent thu thập dữ liệu để cải thiện sản phẩm | Onboard máy, audit quyền riêng tư |
| Train (training) | Code của bạn có bị dùng để huấn luyện model hay không | Trả lời "code có bị train không" |
| Duplication | Kiểm tra trùng với code public | Lo license/copyright khi code trùng |
| `/status` | Trạng thái account/plan/model (không phải consent) | Cần biết máy đang ở plan/model nào |

## Cách gọi (copy-paste)

Telemetry không phải slash command trong Chat — nó là mục trong Settings. Đường đi:

```bash
Settings → search “telemetry” / “copilot data”
# xem trạng thái + bật/tắt theo policy team
# Kỳ vọng: biết trạng thái on/off + ai quản (cá nhân/org)
# Verify: đối chiếu settings với policy team — khớp
```

> Đây là mục Settings chứ không nằm trong list `/` của Chat. Nếu bạn gõ `/` mà tìm "Telemetry" thì đừng kết luận là thiếu tính năng — nó ở đúng chỗ khác.

## Ví dụ thật

Nghiệp vụ: onboard một máy dev mới cho nhân viên, cần lưu bằng chứng trạng thái consent để nộp audit.

```bash
# 1. Mở Settings, search “copilot data”
# 2. Chụp màn hình trạng thái telemetry hiện tại
# 3. Lưu ảnh vào docs onboard của team, ghi rõ ngày chụp
```

**Kết quả mong đợi:** Bạn biết máy đang on hay off, và ai quản (tài khoản cá nhân hay policy org).

**✅ Verify:** Mở lại policy team, đối chiếu — trạng thái khớp là đạt. Lệch thì hỏi admin org trước khi kết luận.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ SAI: "Tôi tắt telemetry rồi, thế là code không bị train nữa." → Sai hoàn toàn; đây là hai setting khác nhau.

✅ ĐÚNG: Kiểm tra riêng từng cái — telemetry (mục data cải thiện sản phẩm), train/opt-out (mục snippet training), duplication (filter license) — rồi ghi lại từng trạng thái.

**Bài học:** telemetry / train / duplication là ba công tắc độc lập. Trả lời audit phải nói rõ bạn đang nói về công tắc nào.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Nhầm telemetry với training | Hai khái niệm khác nhau | Đọc [FAQ bảo mật](../../../../03-cau-hoi-thuong-gap/09-bao-mat-quyen-rieng-tu.md) để phân biệt telemetry vs train vs duplication |
| Đổi setting local không ăn | Org đè setting cá nhân | Hỏi admin org policy |
| Audit hỏi không trả lời được | Không ghi lại trạng thái | Chụp settings lưu vào docs onboard |

## So sánh với Claude Code

| Việc | Copilot (Telemetry) | Claude Code | Ghi chú |
|---|---|---|---|
| Thu thập số liệu sử dụng | Có telemetry + OpenTelemetry export cho org | Có usage data thuộc Anthropic | Cả hai đều có "lớp quan sát"; cách quản trị khác nhau — tự verify theo docs từng bên |
| Công tắc consent cấp org | Có (policy org đè local) | Không có tương đương trực tiếp kiểu policy org | Đừng giả định hai bên bật/tắt giống nhau |
| Train trên code | Tùy plan: Individual mặc định có thể, Business/Enterprise không | Dữ liệu API/Claude Code mặc định không dùng train (*tự verify*) | Luôn đối chiếu data controls thay vì đoán |

> Đọc bảng này thế nào: cả hai đều có lớp nhìn thấy số liệu, nhưng chỉ Copilot có công tắc consent do org đè. Đừng bê nguyên câu trả lời của công cụ này sang công cụ kia.

## Best practices (kèm "vì sao")

- **Ghi lại trạng thái consent vào docs onboard.** *Vì sao?* Audit hỏi bất chợt; có ảnh chụp + ngày là trả lời được ngay.
- **Phân biệt ba khái niệm trước khi tắt bất cứ thứ gì.** *Vì sao?* Tắt nhầm công tắc rồi tưởng đã chặn train là hiểu nhầm tốn kém nhất.
- **Với máy công ty, kiểm tra policy org trước khi đổi local.** *Vì sao?* Policy org thường đè setting cá nhân — đổi local xong vẫn không thay đổi gì.

## Bài tập nhỏ

1. **(5 phút)** Mở Settings, tìm và ghi lại 3 trạng thái: telemetry, train/opt-out, duplication. Ghi rõ cái nào do org quản.
2. **(10 phút)** Đối chiếu với policy team, lưu ảnh chụp + ngày vào docs onboard; nếu lệch, ghi câu hỏi gửi admin.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh System & Knowledge.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Đào sâu quyền riêng tư: [FAQ bảo mật – quyền riêng tư](../../../../03-cau-hoi-thuong-gap/09-bao-mat-quyen-rieng-tu.md).

> Chốt: telemetry là công tắc "gửi dữ liệu cải thiện sản phẩm", không phải công tắc "code bị train" — muốn trả lời audit cho đúng thì phải gọi đúng tên từng công tắc.
