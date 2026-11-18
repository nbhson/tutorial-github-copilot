# Đóng góp cho Khóa Học GitHub Copilot

Cảm ơn bạn muốn đóng góp! Repo này là tài liệu tiếng Việt, mọi code block đều copy-paste được.
Đọc 5 phút file này trước khi mở PR để bài mới "khớp format, không phải sửa lại".

> **Quan trọng — khuôn "dễ hiểu":** mọi file `.md` phải viết theo [`STYLE.md`](./STYLE.md) (khái niệm đi kèm "vì sao quan trọng" + "nếu làm sai thì sao", pitfall ❌ SAI/✅ ĐÚNG, best practices kèm "vì sao", bảng so sánh Claude Code). STYLE.md cũng liệt kê **danh sách câu cấm** — tránh lặp lại văn template kiểu "Section này trả lời..." hay "Mẹo 1 dòng" giống nhau ở mọi file.

## Cách thêm bài mới đúng format

Mục này là bản đồ cho việc "thêm bài": trước hết xác định bài của bạn thuộc loại nào (bài học, FAQ, tips hay lệnh), rồi chỉ đọc đúng phần đó — mỗi loại một khuôn, đừng trộn lẫn.

### Bài trong `01-huong-dan-su-dung/` (deep-dive `NN-ten-bai.md`)

- Đặt tên: số tiếp theo + slug tiếng Việt không dấu, vd `13-copilot-cli-tu-a-den-z.md`.
- Độ dài: **150–200 dòng, hard cap 220** (vượt cap = bài lẫn chủ đề — cắt hoặc dời về bài chủ sở hữu theo `plan-update/03`). Bắt buộc có: `## Mục tiêu bài học` (2–4 gạch kiểm chứng được), `##` theo mạch why → how → ví dụ copy-paste →
  walkthrough → pitfalls (bảng 3 cột) → bài tập (có thời gian từng bài) → link chéo. **Không dùng `## Mục lục`** — 18/18 bài hiện tại không có.
- Code block phải chạy được (đã thử tay ít nhất 1 lần) và **mặc định chạy trong Copilot harness**; ví dụ Local harness chỉ được xuất hiện trong block "⚠️ khác biệt Local harness" ≤6 dòng, ở các bài overview (00/02/10/17). Secrets luôn qua env, không hardcode.
- Nguồn: mọi khẳng định về hành vi Copilot phải dẫn được URL `code.visualstudio.com/docs` hoặc `docs.github.com` (bảng đối chiếu ở `plan-update/02`); không có nguồn thì cắt hoặc ghi rõ "kinh nghiệm thực hành".
- Link chéo: ít nhất 3 links tới bài/commands liên quan (đường dẫn tương đối).

### Bài trong `03-cau-hoi-thuong-gap/` (FAQ `NN-ten-faq.md`)

- Mỗi câu hỏi bắt buộc theo cấu trúc 5 phần: **Hỏi ngắn gọn** (quote) → **Trả lời 1 câu** (đọc 10 giây) → **Giải thích chi tiết + ví dụ** → **Làm thế nào (steps copy-paste)** → **Nếu vẫn lỗi thì...**. Không trả lời cộc lốc 2–3 dòng.
- Mỗi file FAQ phải có ít nhất 1 `mermaid` hoặc code ví dụ bổ sung (sơ đồ tư duy nhanh đầu file).

### Bài trong `02-tips-thuc-chien/` (tips `NN-ten-tips.md`)

- Đặt tên: số tiếp theo, vd `11-toi-uu-ai-credits.md`. Độ dài 150–250 dòng.
- Bắt buộc: lý thuyết gọn + ≥3 ví dụ copy-paste + walkthrough theo phút + 1 bảng tra nhanh +
  pitfalls + bài tập + tham khảo chéo.
- Mỗi tính năng phải ghi: cần plan gì, bật ở đâu, rủi ro & giới hạn (1 dòng bảng).

### Lệnh mới trong `01-huong-dan-su-dung/commands/<harness>/<nhóm>/<slug>/README.md`

- `<harness>` = `copilot` (lệnh chạy được trong Copilot harness session — mặc định của khoá), `local` (cần Local harness), `cloud` (đặt lệnh trên GitHub.com). Xem tiêu chí ở `plan-update/04` §1.
- 1 folder = 1 lệnh, chỉ 1 file `README.md`. Độ dài **25–50 dòng**, khuôn 6 khối (mẫu vàng: `commands/copilot/chat-session/compact/README.md`).
- Format chuẩn theo [`STYLE.md`](./STYLE.md) mục 4: `# <lệnh> — <mục đích 1 dòng>` → dòng `> **Harness:** … · **Surface:** … · **Đọc:** ~2 phút` → `**Nôm na:**` (kèm "Hợp khi …") → `## Vì sao dùng?` (2–4 câu + 1 bảng khi có tư liệu + `**Nếu làm sai:**`) → `## Cách dùng` (code fence có language tag + `**Biến thể:**` / `**Setting:**` / `**✅ Verify:**`) → `## Liên quan` (link nội bộ + `examples/` + URL docs).
- KHÔNG viết lại các section dài kiểu cũ trong README lệnh: `## Lỗi thường gặp`, `## So sánh với Claude Code`, `## Best practices`, `## Bài tập nhỏ`, `## Tham khảo` — ý nào đắt thì nén vào `## Vì sao dùng?`, phần còn lại để ở README nhóm và bài tổng.
- Ví dụ phải riêng cho từng lệnh (cấm copy-paste ví dụ chung cho mọi lệnh). Ghi rõ mode nào dùng được (Ask/Edit/Agent) và cách kiểm tra bằng `/` trong Chat.

> **Tóm gọn 1 câu:** Thêm bài giống nấu theo công thức có sẵn — chọn đúng khuôn cho đúng món, việc còn lại là đổ nội dung riêng của bạn vào.

## Quy ước đặt tên & văn phong

Mục này chốt cách đặt tên file và giọng viết — giữ đúng quy ước là người khác tìm được bài của bạn mà không cần hỏi.

- File/kebab-case không dấu: `NN-ten-tieng-viet.md`, folder lệnh 1 từ: `fix/`.
- Tiếng Việt, xưng "bạn", code comments tiếng Việt không dấu (tránh lỗi encoding CI).
- Tiêu đề bài 01: `# NN — Tên Bài (...)`. Tips 02: `# Tips NN — Tên (...)`.
- Không sửa nội dung file `.md` hiện có khi thêm bài mới (trừ link index ở lượt dọn riêng, hoặc đợt viết lại có ghi rõ trong PR + CHANGELOG).

## PR checklist (tick hết mới merge)

- [ ] Tên file/số thứ tự đúng (không trùng, không nhảy số).
- [ ] Đủ số dòng: bài 150–200 (cap 220), README lệnh 25–50 (`wc -l`).
- [ ] Code block đã chạy thử (ghi rõ đã verify ở đâu trong PR mô tả).
- [ ] Có pitfalls (bảng) + bài tập (có thời gian) + link chéo (≥3, không 404) — áp cho **bài học**; README lệnh chỉ cần `**Nếu làm sai:**` + `**✅ Verify:**`.
- [ ] Lệnh mới: đủ 6 khối (meta → Nôm na → Vì sao dùng? → Cách dùng → Liên quan) + ví dụ riêng từng lệnh + mode hỗ trợ + cách kiểm tra `/`.
- [ ] Workflow YAML mới: parse được (`python -c "import yaml..."`), secrets qua env,
      không hardcode token.
- [ ] Không sửa file `.md` cũ (diff chỉ chứa file mới, trừ đợt viết lại có ghi rõ lý do).

> **Tóm gọn 1 câu:** PR checklist là cửa soát vé cuối — tick đủ 7 ô thì PR mới qua cổng, thiếu một ô là bị trả về ngay.
