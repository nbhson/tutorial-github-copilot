# Knowledge base — Hỏi tri thức team (docs/wiki/RAG)

> **Dành cho:** người cần tra docs nội bộ, wiki, runbook · **Vấn đề:** hỏi Slack đi hỏi lại, hoặc model bịa khi docs không có · **Đọc xong:** hỏi đúng cách để câu trả lời kèm nguồn kiểm chứng được (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: hỏi thủ thư — thay vì lục cả thư viện, hỏi người giữ mục lục. Hỏi qua Chat/MCP trỏ tới docs nội bộ và bắt buộc “trích nguồn + section”; docs không có thì phải nói không có.

## Khi nào dùng

Section này trả lời: khi nào hỏi knowledge base thay vì hỏi đồng nghiệp, và cách chống model bịa.

- **Cho ai:** người mới onboard, team muốn giảm hỏi lặp trong Slack.
- Hỏi docs nội bộ, wiki, runbook team.
- Onboard: “quy trình deploy team mình là gì?”.
- Giảm hỏi đi hỏi lại trong Slack.

## Cách gọi (copy-paste)

Cách gọi `Knowledge base` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Hỏi qua Chat/MCP docs nội bộ
“theo wiki team, deploy staging gồm mấy bước?”
# Kỳ vọng: câu trả lời kèm nguồn (file/wiki/section), không bịa
# Verify: mở nguồn được trích — khớp là đạt
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Knowledge base`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `Knowledge base` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
“theo docs nội bộ, quy trình xin review PR gồm mấy bước?” (kèm nguồn)
```

**Kết quả mong đợi:** Câu trả lời kèm nguồn (file/wiki/section); không bịa khi docs không có.

**Cách verify:** Mở nguồn được trích — khớp là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Model bịa docs | Docs chưa index / hỏi vượt ngoài docs | Bắt “trích nguồn + section”; không có → nói không có |
| Docs cũ | Index lỗi thời | Reindex + ghi ngày update vào docs |
| Hỏi chung chung | Thiếu tên docs | Nêu rõ “theo wiki X, mục Y” |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
