# Knowledge base — Hỏi tri thức team (docs/wiki/RAG)

> Nôm na: hỏi thủ thư — thay vì lục cả thư viện, hỏi người giữ mục lục.

## Lệnh làm gì (1 câu nôm na)

Nôm na: hỏi thủ thư — thay vì lục cả thư viện, hỏi người giữ mục lục. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Hỏi docs nội bộ, wiki, runbook team.
- Onboard: “quy trình deploy team mình là gì?”.
- Giảm hỏi đi hỏi lại trong Slack.

## Cách gọi (copy-paste)

```bash
Hỏi qua Chat/MCP docs nội bộ
“theo wiki team, deploy staging gồm mấy bước?”
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Knowledge base`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
“theo docs nội bộ, quy trình xin review PR gồm mấy bước?” (kèm nguồn)
```

**Kết quả mong đợi:** Câu trả lời kèm nguồn (file/wiki/section); không bịa khi docs không có.

**Cách verify:** Mở nguồn được trích — khớp là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Model bịa docs | Docs chưa index / hỏi vượt ngoài docs | Bắt “trích nguồn + section”; không có → nói không có |
| Docs cũ | Index lỗi thời | Reindex + ghi ngày update vào docs |
| Hỏi chung chung | Thiếu tên docs | Nêu rõ “theo wiki X, mục Y” |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
