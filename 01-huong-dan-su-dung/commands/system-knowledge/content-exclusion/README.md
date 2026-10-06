# Content exclusion — Xem files Copilot không được đọc

> Nôm na: két sắt — bỏ file nhạy cảm vào, AI không được mở.

## Lệnh làm gì (1 câu nôm na)

Nôm na: két sắt — bỏ file nhạy cảm vào, AI không được mở. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Có secrets/keys trong repo.
- “Chỗ có chỗ không gợi ý” (nghi exclusion).
- Audit bảo mật.

## Cách gọi (copy-paste)

```bash
settings.json → github.copilot.chat.exclusion
# hoặc org policy → Content exclusion
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Content exclusion`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Check “vì sao file secrets/ không gợi ý?” → thấy nó nằm trong exclusion → đúng ý đồ
```

**Kết quả mong đợi:** File nhạy cảm bị loại khỏi context; chỗ khác vẫn gợi ý bình thường.

**Cách verify:** Test file hello-world có gợi ý + file secrets không — đúng cả 2 là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tưởng bug khi mất gợi ý 1 chỗ | Không biết exclusion | So file lỗi vs file test để khoanh vùng |
| Exclusion sai glob | Pattern quá rộng | Thu hẹp glob, test lại từng path |
| Policy org đè local | Sửa local không ăn | Hỏi admin policy org |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
