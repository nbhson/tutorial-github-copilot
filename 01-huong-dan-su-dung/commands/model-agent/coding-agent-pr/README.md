# Coding agent PR — Flow issue → branch → PR → review

> Nôm na: băng chuyền từ phiếu việc tới thùng hàng — mỗi chặng đều có người kiểm.

## Lệnh làm gì (1 câu nôm na)

Nôm na: băng chuyền từ phiếu việc tới thùng hàng — mỗi chặng đều có người kiểm. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Review PR do coding agent mở.
- Tóm tắt diff thành mô tả PR.
- Quyết merge/revert PR agent.

## Cách gọi (copy-paste)

```bash
Mở PR agent → đọc tóm tắt + CI → review diff → merge/revert
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Coding agent PR`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Mở PR agent “rate-limit”: check CI xanh → đọc diff → comment “thiếu test nhánh null” → agent bổ sung → merge
```

**Kết quả mong đợi:** PR có tóm tắt rõ + CI xanh + review người; merge sạch hoặc revert gọn.

**Cách verify:** Merge xong staging chạy ổn + không nợ review là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Merge mù PR agent | Tin 100% tóm tắt | Đọc diff + CI, chạy thử staging trước merge |
| CI đỏ vẫn merge | Bỏ qua CI | Đỏ → bắt agent fix, xanh mới merge |
| PR quá to khó review | Issue ôm đồm | Giữ PR nhỏ; to quá → tách |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
