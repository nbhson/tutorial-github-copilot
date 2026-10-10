# /help — Bản đồ lệnh khả dụng ở máy bạn

> **Dành cho:** người mới cài, hoặc người đang nghi lệnh nào đó không tồn tại · **Vấn đề:** không biết ở máy mình có lệnh gì, plan/version nào · **Đọc xong:** mở được bản đồ lệnh và đối chiếu với list thực tế (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: hỏi lễ tân “ở đây có những dịch vụ gì?” trước khi gọi món. Lệnh liệt kê slash command/participant/mode khả dụng theo đúng plan + version máy bạn.

## Khi nào dùng

Section này trả lời: khi nào cần tra bản đồ lệnh, và cách phân biệt “lệnh không có” với “lệnh lỗi”.

- **Cho ai:** người mới onboard nhanh, và tech lead đối chiếu máy mình với máy đồng nghiệp.
- Mới cài, chưa biết có lệnh gì.
- Nghi lệnh vắng mặt do plan/version (check nhanh).
- Onboard thành viên mới.

## Cách gọi (copy-paste)

Cách gọi `/help` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/help
# Kỳ vọng: list slash/participant/mode đúng plan + version máy bạn
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/help`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/help` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/help
# Kỳ vọng: danh sách lệnh khả dụng đúng plan + version máy bạn
```

**Kết quả mong đợi:** List slash/participant/mode khả dụng đúng plan + version máy bạn.

**Cách verify:** Gõ / so list trong /help với list thực tế — khớp là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| List trong /help khác máy đồng nghiệp | Khác plan/version | So /status 2 máy: plan + version extension |
| Đọc /help vẫn không hiểu lệnh nào | Thiếu ví dụ | Mở commands/ tra folder chi tiết từng lệnh |
| Lệnh có trong /help mà gõ không ăn | Nhầm cú pháp (thiếu scope) | Đọc mục Cách gọi của lệnh đó |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
