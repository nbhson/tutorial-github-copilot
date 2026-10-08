# Custom agent — Gọi agent riêng của repo

> **Dành cho:** người có agent riêng trong `.github/agents/` (explorer, tester, security-reviewer) · **Vấn đề:** giao sai agent, chat chính ồn ào vì ôm việc trinh sát · **Đọc xong:** gọi đúng chuyên gia và đẩy việc ồn sang sub-agent (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: gọi đúng chuyên gia trong danh bạ — explorer đi trinh sát, tester đi kiểm tra. Gọi agent từ `.github/agents/` và nêu phạm vi ngay trong lời gọi: chỉ-đọc hay được phép sửa, files nào được đụng.

## Khi nào dùng

Section này trả lời: việc nào nên đẩy sang sub-agent, và cách chọn agent đúng cho việc đó.

- **Cho ai:** người đã tạo custom agent cho team, người cần chạy trinh sát/test song song.
- Việc ồn ào: trinh sát multi-file (explorer).
- Sau mỗi change: chạy test focused (tester).
- Diff chạm auth/payment: gọi security-reviewer.

## Cách gọi (copy-paste)

Cách gọi `Custom agent` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Gọi agent trong .github/agents/
“nhờ explorer vẽ bản đồ file chạm tới auth”
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Custom agent`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `Custom agent` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
“nhờ explorer (chỉ-đọc): vẽ bản đồ 5 file chạm tới auth + ai gọi ai”
```

**Kết quả mong đợi:** Sub-agent trả kết quả gọn (bản đồ/test PASS-FAIL/review); chat chính chỉ giữ quyết định.

**Cách verify:** Kết quả sub-agent paste được vào PR/wiki là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Agent “chạy loạn” ngoài phạm vi | Mô tả agent thiếu phạm vi | Ghi rõ chỉ-đọc + files được đụng trong .agent.md |
| Gọi sai agent cho việc | Chưa thuộc danh bạ | Đọc templates/.github/agents/ 1 lần, ghi nhớ 3 con core |
| Chat chính vẫn ồn | Ôm việc trong chat chính | Đẩy việc ồn sang sub-agent ngay |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
