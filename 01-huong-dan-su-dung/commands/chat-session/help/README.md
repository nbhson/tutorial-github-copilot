# /help — Bản đồ lệnh khả dụng ở máy bạn

> Nôm na: hỏi lễ tân “ở đây có những dịch vụ gì?” trước khi gọi món.

## Lệnh làm gì (1 câu nôm na)

Nôm na: hỏi lễ tân “ở đây có những dịch vụ gì?” trước khi gọi món. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Mới cài, chưa biết có lệnh gì.
- Nghi lệnh vắng mặt do plan/version (check nhanh).
- Onboard thành viên mới.

## Cách gọi (copy-paste)

```bash
/help
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/help`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/help
```

**Kết quả mong đợi:** List slash/participant/mode khả dụng đúng plan + version máy bạn.

**Cách verify:** Gõ / so list trong /help với list thực tế — khớp là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| List trong /help khác máy đồng nghiệp | Khác plan/version | So /status 2 máy: plan + version extension |
| Đọc /help vẫn không hiểu lệnh nào | Thiếu ví dụ | Mở commands/ tra folder chi tiết từng lệnh |
| Lệnh có trong /help mà gõ không ăn | Nhầm cú pháp (thiếu scope) | Đọc mục Cách gọi của lệnh đó |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
