# Đóng góp cho Khóa Học Muse

Cảm ơn bạn muốn đóng góp! Repo này là tài liệu tiếng Việt, mọi code block copy-paste được.
Đọc 5 phút file này trước khi mở PR để bài mới "khớp format, không phải sửa lại".

## Cách thêm bài mới đúng format

### Bài trong `01-huong-dan-su-dung/` (deep-dive `NN-ten-bai.md`)

- Đặt tên: số tiếp theo + slug tiếng Việt không dấu, vd `13-copilot-cli-tu-a-den-z.md`.
- Độ dài: 300–450 dòng. Bắt buộc có: mục lục, `##` theo mạch why → how → ví dụ copy-paste →
  walkthrough → pitfalls (bảng 3 cột) → bài tập (có thời gian từng bài) → link chéo.
- Code block phải chạy được (đã thử tay ít nhất 1 lần). Secrets luôn qua env, không hardcode.
- Link chéo: ít nhất 3 links tới bài/commands liên quan (đường dẫn tương đối).

### Bài trong `02-tips-thuc-chien/` (tips `NN-ten-tips.md`)

- Đặt tên: số tiếp theo, vd `11-toi-uu-premium-requests.md`. Độ dài 300–450 dòng.
- Bắt buộc: lý thuyết gọn + ≥3 ví dụ copy-paste + walkthrough theo phút + 1 bảng tra nhanh +
  pitfalls + bài tập + tham khảo chéo.
- Mỗi tính năng phải ghi: cần plan gì, bật ở đâu, rủi ro & giới hạn (1 dòng bảng).

### Lệnh mới trong `01-huong-dan-su-dung/commands/<slug>/README.md`

- 1 folder = 1 lệnh, chỉ 1 file `README.md`. Độ dài 120–200 dòng.
- Format 8 mục (bắt chước `commands/chat/fix/README.md`):
  1. Tiêu đề `# /ten-lenh — mô tả 1 dòng` + quote loại/nhóm/nguy hiểm + intro ví von.
  2. `## Cú pháp & tham số` (bảng 3 cột + ví dụ gọi từng dạng).
  3. `## Cách nó hoạt động` (cơ chế sâu + sơ đồ text + bảng "khác gì lệnh dễ nhầm" + quy tắc ngón tay cái).
  4. `## Ví dụ thực tế` (2 kịch bản copy-paste + kết quả).
  5. `## Rủi ro & lưu ý` (bảng + `Tốn premium requests?` + `Version / provider`).
  6. `## Kết hợp trong workflow` (bảng combo + workflow chuẩn 1 dòng).
  7. `## Lỗi hay gặp` (bảng triệu chứng → nguyên nhân → fix).
  8. `## Tham khảo` (lệnh liên quan + bài tổng quan + mẹo 1 dòng).
- Lệnh theo model/mode: ghi rõ model nào hỗ trợ, mode nào dùng được (Ask/Edit/Agent),
  cách kiểm tra bằng `/` và `@` trong Chat + workflow thay thế khi hết premium requests.

## Quy ước đặt tên & văn phong

- File/kebab-case không dấu: `NN-ten-tieng-viet.md`, folder lệnh 1 từ: `fix/`.
- Tiếng Việt, xưng "bạn", code comments tiếng Việt không dấu (tránh lỗi encoding CI).
- Tiêu đề bài 01: `# NN — Tên Bài (...)`. Tips 02: `# Tips NN — Tên (...)`.
- Không sửa nội dung file `.md` hiện có khi thêm bài mới (trừ link index ở lượt dọn riêng).

## PR checklist (tick hết mới merge)

- [ ] Tên file/số thứ tự đúng (không trùng, không nhảy số).
- [ ] Đủ số dòng: bài 300–450, lệnh 120–200 (`wc -l`).
- [ ] Code block đã chạy thử (ghi rõ đã verify ở đâu trong PR mô tả).
- [ ] Có pitfalls (bảng) + bài tập (có thời gian) + link chéo (≥3, không 404).
- [ ] Lệnh mới: đủ 8 mục + model/mode hỗ trợ + cách kiểm tra `/` và `@`.
- [ ] Workflow YAML mới: parse được (`python -c "import yaml..."`), secrets qua env,
      không hardcode token.
- [ ] Không sửa file `.md` cũ (diff chỉ chứa file mới, trừ khi PR ghi rõ lý do).
