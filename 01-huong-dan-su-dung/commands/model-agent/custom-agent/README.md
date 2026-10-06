# Custom agent — Gọi agent riêng của repo

> Nôm na: gọi đúng chuyên gia trong danh bạ — explorer đi trinh sát, tester đi kiểm tra.

## Lệnh làm gì (1 câu nôm na)

Nôm na: gọi đúng chuyên gia trong danh bạ — explorer đi trinh sát, tester đi kiểm tra. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Việc ồn ào: trinh sát multi-file (explorer).
- Sau mỗi change: chạy test focused (tester).
- Diff chạm auth/payment: gọi security-reviewer.

## Cách gọi (copy-paste)

```bash
Gọi agent trong .github/agents/
“nhờ explorer vẽ bản đồ file chạm tới auth”
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Custom agent`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
“nhờ explorer (chỉ-đọc): vẽ bản đồ 5 file chạm tới auth + ai gọi ai”
```

**Kết quả mong đợi:** Sub-agent trả kết quả gọn (bản đồ/test PASS-FAIL/review); chat chính chỉ giữ quyết định.

**Cách verify:** Kết quả sub-agent paste được vào PR/wiki là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Agent “chạy loạn” ngoài phạm vi | Mô tả agent thiếu phạm vi | Ghi rõ chỉ-đọc + files được đụng trong .agent.md |
| Gọi sai agent cho việc | Chưa thuộc danh bạ | Đọc templates/.github/agents/ 1 lần, ghi nhớ 3 con core |
| Chat chính vẫn ồn | Ôm việc trong chat chính | Đẩy việc ồn sang sub-agent ngay |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
