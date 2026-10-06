# Telemetry — Xem/sửa code-telemetry consent

> Nôm na: công tắc “có cho thu thập dữ liệu dùng để cải thiện hay không”.

## Lệnh làm gì (1 câu nôm na)

Nôm na: công tắc “có cho thu thập dữ liệu dùng để cải thiện hay không”. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Onboard máy mới / máy công ty.
- Audit quyền riêng tư.
- Thắc mắc “code có bị dùng train không”.

## Cách gọi (copy-paste)

```bash
Settings → “telemetry” / “copilot data”
# xem trạng thái + bật/tắt theo policy team
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Telemetry`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Mở settings, search “telemetry”, chụp lại trạng thái hiện tại gửi audit
```

**Kết quả mong đợi:** Biết trạng thái on/off + ai quản (cá nhân/org); khớp policy team.

**Cách verify:** Đối chiếu settings với policy team — khớp là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Nhầm telemetry với training | 2 khái niệm khác nhau | Đọc bài 09: telemetry vs train vs duplication |
| Org đè setting cá nhân | Đổi local không ăn | Hỏi admin org policy |
| Không ghi lại trạng thái | Audit hỏi không trả lời được | Chụp settings lưu vào docs onboard |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
