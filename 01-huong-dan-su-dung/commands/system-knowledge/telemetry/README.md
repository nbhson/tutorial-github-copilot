# Telemetry — Xem/sửa code-telemetry consent

> **Dành cho:** người onboard máy mới và người làm audit quyền riêng tư · **Vấn đề:** nhầm telemetry với việc code bị dùng để train model · **Đọc xong:** đọc được trạng thái consent và đối chiếu policy team (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: công tắc “có cho thu thập dữ liệu dùng để cải thiện hay không”. Vào Settings, search “telemetry” / “copilot data” để xem và bật/tắt theo policy team; telemetry khác train, cũng khác duplication.

## Khi nào dùng

Section này trả lời: khi nào cần kiểm tra công tắc này, và ranh giới telemetry với train nằm ở đâu.

- **Cho ai:** admin/onboard máy công ty, người phải trả lời câu audit quyền riêng tư.
- Onboard máy mới / máy công ty.
- Audit quyền riêng tư.
- Thắc mắc “code có bị dùng train không”.

> Phân biệt nhanh các khái niệm hay bị lẫn:

| Khái niệm | Là gì | Khi nào dùng |
|---|---|---|
| Telemetry | Consent thu thập dữ liệu để cải thiện sản phẩm | Onboard máy, audit quyền riêng tư |
| Train (training) | Code của bạn có bị dùng để huấn luyện model hay không | Trả lời “code có bị train không” |
| Duplication | Kiểm tra trùng với code public | Lo license/copyright khi code trùng |
| `/status` | Trạng thái account/plan/model (không phải consent) | Cần biết máy đang ở plan/model nào |

## Cách gọi (copy-paste)

Cách gọi `Telemetry` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Settings → “telemetry” / “copilot data”
# xem trạng thái + bật/tắt theo policy team
# Kỳ vọng: biết trạng thái on/off + ai quản (cá nhân/org)
# Verify: đối chiếu settings với policy team — khớp
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Telemetry`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `Telemetry` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Mở settings, search “telemetry”, chụp lại trạng thái hiện tại gửi audit
```

**Kết quả mong đợi:** Biết trạng thái on/off + ai quản (cá nhân/org); khớp policy team.

**Cách verify:** Đối chiếu settings với policy team — khớp là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Nhầm telemetry với training | 2 khái niệm khác nhau | Đọc bài 09: telemetry vs train vs duplication |
| Org đè setting cá nhân | Đổi local không ăn | Hỏi admin org policy |
| Không ghi lại trạng thái | Audit hỏi không trả lời được | Chụp settings lưu vào docs onboard |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
