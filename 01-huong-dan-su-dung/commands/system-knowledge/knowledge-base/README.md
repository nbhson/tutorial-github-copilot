# Knowledge base — Hỏi tri thức team (docs/wiki/RAG)

> **Dành cho:** người cần tra docs nội bộ, wiki, runbook · **Vấn đề:** hỏi Slack đi hỏi lại, hoặc model bịa khi docs không có · **Đọc xong:** hỏi đúng cách để câu trả lời kèm nguồn kiểm chứng được (~2 phút)

## 1 câu nôm na

Knowledge base giống như hỏi thủ thư thay vì tự lục cả thư viện — người giữ mục lục biết chỉ bạn đúng kệ sách. Bạn hỏi qua Chat (hoặc qua MCP trỏ tới docs nội bộ) và bắt buộc câu trả lời phải "trích nguồn + section". Nếu docs không có thông tin, model phải nói thẳng "không có", tuyệt đối không được bịa.

## Vì sao dùng Knowledge base?

Vì tri thức team nằm rải rác trong wiki, docs, runbook — hỏi đồng nghiệp từng lần là cách tốn kém nhất. Khi Copilot được nối vào nguồn docs đó, bạn hỏi một lần và nhận câu trả lời có dẫn nguồn để tự kiểm. Điều quan trọng không phải là câu trả lời nghe hay, mà là nó trỏ tới đúng file/section để bạn mở ra xác nhận.

**Nếu làm sai thì sao?** Hai cái bẫy: (1) docs chưa được index, model không thấy nên bịa; (2) bạn hỏi chung chung kiểu "quy trình deploy thế nào?" mà không nêu tên docs/mục, nên nó đoán. Cả hai đều dẫn tới câu trả lời tự tin nhưng sai.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** hỏi docs nội bộ, wiki, runbook team; onboard ("quy trình deploy team mình gồm mấy bước?"); muốn giảm việc hỏi đi hỏi lại trong Slack.
- **Cho ai:** người mới onboard, team muốn giảm tải câu hỏi lặp.
- **ĐỪNG tin ngay khi:** câu trả lời không kèm nguồn, hoặc nguồn không mở được. Khi đó coi như chưa có câu trả lời.

## Cách gọi (copy-paste)

```bash
Hỏi qua Chat/MCP docs nội bộ
“theo wiki team, deploy staging gồm mấy bước?”
# Kỳ vọng: câu trả lời kèm nguồn (file/wiki/section), không bịa
# Verify: mở nguồn được trích — khớp là đạt
```

> Đây là cách hỏi qua Chat/MCP chứ không phải một slash command riêng. Nếu bạn gõ `/` mà tìm "Knowledge base" thì nó không nằm ở đó — bạn gọi nó bằng câu hỏi trỏ tới nguồn docs.

## Ví dụ thật

Nghiệp vụ: bạn mới vào team, cần biết quy trình xin review PR mà không muốn hỏi Slack lần thứ ba.

```bash
“Theo docs nội bộ, quy trình xin review PR gồm mấy bước?
Trích rõ nguồn (file/section). Nếu docs không có thì nói là không có.”
```

**Kết quả mong đợi:** Câu trả lời kèm nguồn (file/wiki/section); nếu docs không có thì nó nói thẳng không có thay vì bịa.

**✅ Verify:** Mở nguồn được trích ra và đối chiếu — khớp là đạt. Không mở được hoặc nội dung lệch thì câu trả lời đó không dùng được.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ SAI: "Quy trình deploy team thế nào?" rồi tin ngay câu trả lời, không yêu cầu nguồn → dễ nhận thông tin bịa, nhất là khi docs chưa index.

✅ ĐÚNG: "Theo wiki X, mục Y, quy trình deploy staging gồm mấy bước? Trích nguồn; không có thì nói không có." → rồi tự mở nguồn kiểm.

**Bài học:** câu trả lời chỉ đáng tin khi mở được nguồn. Câu hỏi càng nêu rõ docs/mục thì càng ít chỗ cho model bịa.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Model bịa docs | Docs chưa index / hỏi vượt ngoài docs | Bắt "trích nguồn + section"; không có thì phải nói không có |
| Docs cũ | Index lỗi thời | Reindex + ghi ngày update vào docs |
| Hỏi chung chung | Thiếu tên docs | Nêu rõ "theo wiki X, mục Y" |

## So sánh với Claude Code

| Việc | Copilot (Knowledge base) | Claude Code | Ghi chú |
|---|---|---|---|
| Hỏi tri thức nội bộ | Qua Chat/MCP trỏ tới docs, bắt trích nguồn | Qua đọc file trong repo / MCP server | Cùng tư tưởng: phải trỏ tới nguồn thật, không bịa |
| Chống bịa | Yêu cầu nêu file/section + "không có thì nói không có" | Cùng yêu cầu khi hỏi | Không agent nào tự đảm bảo đúng/sai — bạn verify |
| Nguồn dữ liệu | Docs/wiki/RAG đã index + MCP | File trong repo + MCP | Copilot mạnh phần docs cấp org; Claude mạnh dò file tại chỗ (*cần verify từng setup*) |

## Best practices (kèm "vì sao")

- **Luôn yêu cầu trích nguồn + section.** *Vì sao?* Có nguồn thì bạn mới verify được; không có nguồn thì đó là phỏng đoán.
- **Nêu rõ tên docs và mục khi hỏi.** *Vì sao?* Càng cụ thể thì model càng ít "khoảng trống" để bịa.
- **Reindex và ghi ngày update cho docs.** *Vì sao?* Index lỗi thời trả lời theo tài liệu cũ — tai hại hơn là không trả lời.
- **Không mở được nguồn thì coi như chưa có câu trả lời.** *Vì sao?* Đây là hàng rào duy nhất chống model tự tin sai.

## Bài tập nhỏ

1. **(5 phút)** Hỏi một câu về quy trình team, bắt buộc kèm nguồn. Mở nguồn ra kiểm — khớp hay không?
2. **(10 phút)** Hỏi một câu mà bạn biết chắc docs KHÔNG có; xem model có nói "không có" hay bịa. Ghi lại hành vi.

## Tham khảo

- Index nhóm: [../README.md](../README.md).
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Nối nguồn ngoài qua MCP: [../mcp/README.md](../mcp/README.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Chốt: Knowledge base hữu ích đúng bằng chất lượng nguồn nó được nối vào — câu trả lời không mở được nguồn thì hãy đối xử với nó như một phỏng đoán, không phải sự thật.
