# Đóng góp cho Khóa Học GitHub Copilot

Cảm ơn bạn muốn đóng góp! Repo này là tài liệu tiếng Việt, mọi code block đều copy-paste được.
Đọc 5 phút file này trước khi mở PR để bài mới "khớp format, không phải sửa lại".

## Cách thêm bài mới đúng format

### Bài trong `01-huong-dan-su-dung/` (deep-dive `NN-ten-bai.md`)

- Đặt tên: số tiếp theo + slug tiếng Việt không dấu, vd `13-copilot-cli-tu-a-den-z.md`.
- Độ dài: 300–450 dòng. Bắt buộc có: mục lục, `##` theo mạch why → how → ví dụ copy-paste →
  walkthrough → pitfalls (bảng 3 cột) → bài tập (có thời gian từng bài) → link chéo.
- Code block phải chạy được (đã thử tay ít nhất 1 lần). Secrets luôn qua env, không hardcode.
- Link chéo: ít nhất 3 links tới bài/commands liên quan (đường dẫn tương đối).

### Bài trong `03-cau-hoi-thuong-gap/` (FAQ `NN-ten-faq.md`)

- Mỗi câu hỏi bắt buộc theo cấu trúc 5 phần: **Hỏi ngắn gọn** (quote) → **Trả lời 1 câu** (đọc 10 giây) → **Giải thích chi tiết + ví dụ** → **Làm thế nào (steps copy-paste)** → **Nếu vẫn lỗi thì...**. Không trả lời cộc lốc 2–3 dòng.
- Mỗi file FAQ phải có ít nhất 1 `mermaid` hoặc code ví dụ bổ sung (sơ đồ tư duy nhanh đầu file).

### Bài trong `02-tips-thuc-chien/` (tips `NN-ten-tips.md`)

- Đặt tên: số tiếp theo, vd `11-toi-uu-premium-requests.md`. Độ dài 300–450 dòng.
- Bắt buộc: lý thuyết gọn + ≥3 ví dụ copy-paste + walkthrough theo phút + 1 bảng tra nhanh +
  pitfalls + bài tập + tham khảo chéo.
- Mỗi tính năng phải ghi: cần plan gì, bật ở đâu, rủi ro & giới hạn (1 dòng bảng).

### Lệnh mới trong `01-huong-dan-su-dung/commands/<nhóm>/<slug>/README.md`

- 1 folder = 1 lệnh, chỉ 1 file `README.md`. Độ dài 30–200 dòng (tối thiểu 30–50 dòng súc tích, tối đa ~200).
- Format chuẩn 6 phần (bắt chước `commands/code-actions/fix/README.md` bản mới):
  1. `# /tên-lệnh — mô tả 1 dòng` + 1 câu nôm na "lệnh làm gì".
  2. `## Khi nào dùng` (3–5 gạch đầu dòng: dùng khi nào / không dùng khi nào).
  3. `## Cách gọi` (code block phím tắt/slash + kèm scope `#file`/`@workspace`).
  4. `## Ví dụ prompt thật + kết quả mong đợi` (≥1 prompt copy-paste được + mô tả kết quả + cách verify).
  5. `## Lỗi thường gặp` (bảng triệu chứng → nguyên nhân → fix).
  6. `## Tham khảo` (link index nhóm + bài tổng quan liên quan).
- Ví dụ phải riêng cho từng lệnh (cấm copy-paste ví dụ chung cho mọi lệnh). Ghi rõ mode nào dùng được (Ask/Edit/Agent) và cách kiểm tra bằng `/` trong Chat.

## Quy ước đặt tên & văn phong

- File/kebab-case không dấu: `NN-ten-tieng-viet.md`, folder lệnh 1 từ: `fix/`.
- Tiếng Việt, xưng "bạn", code comments tiếng Việt không dấu (tránh lỗi encoding CI).
- Tiêu đề bài 01: `# NN — Tên Bài (...)`. Tips 02: `# Tips NN — Tên (...)`.
- Không sửa nội dung file `.md` hiện có khi thêm bài mới (trừ link index ở lượt dọn riêng).

## PR checklist (tick hết mới merge)

- [ ] Tên file/số thứ tự đúng (không trùng, không nhảy số).
- [ ] Đủ số dòng: bài 300–450, lệnh 30–200 (`wc -l`).
- [ ] Code block đã chạy thử (ghi rõ đã verify ở đâu trong PR mô tả).
- [ ] Có pitfalls (bảng) + bài tập (có thời gian) + link chéo (≥3, không 404).
- [ ] Lệnh mới: đủ 6 phần + ví dụ riêng từng lệnh + mode hỗ trợ + cách kiểm tra `/`.
- [ ] Workflow YAML mới: parse được (`python -c "import yaml..."`), secrets qua env,
      không hardcode token.
- [ ] Không sửa file `.md` cũ (diff chỉ chứa file mới, trừ khi PR ghi rõ lý do).
