# gh copilot explain — Giải thích lệnh CLI vừa gặp

> **Dành cho:** người gặp lệnh lạ trong docs/script của người khác · **Vấn đề:** copy lệnh mạng về chạy mù, rủi ro xóa/force · **Đọc xong:** hiểu từng flag + rủi ro trước khi bấm Enter (~2 phút)

## 1 câu nôm na

`gh copilot explain` giống như phiên dịch biển báo — thấy lệnh lạ thì hỏi "biển này nghĩa gì?". Bạn dán lệnh vào, nó giải thích từng phần và rủi ro. Nguyên tắc bất di bất dịch: explain **TRƯỚC**, chạy **SAU**. Lệnh càng dài càng phải đòi giải thích từng flag.

> Phân biệt rõ: `gh copilot` là **gh extension** (chỉ gợi ý/giải thích lệnh shell), **không phải** `copilot` — CLI agent riêng chạy task cả đoạn. Đừng lẫn hai thứ.

## Vì sao dùng gh copilot explain?

Vì lệnh copy từ mạng về rất hay giấu hành vi phá hủy trong một flag trông vô hại. `find ... -delete`, `git reset --hard`, `docker system prune -a` — đọc qua tưởng bình thường, chạy xong mới biết mất dữ liệu. Explain giúp bạn thấy rủi ro *trước* khi bấm Enter, và hiểu luôn từng flag để lần sau tự đọc được.

**Nếu làm sai thì sao?** Thứ tự bị đảo là lỗi nặng nhất: chạy trước rồi mới hỏi nghĩa là gì. Lỗi thứ hai là lười đọc với lệnh dài — nhìn dài quá rồi chạy mù. Cả hai đều có thể trả giá bằng dữ liệu.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** gặp lệnh lạ trong docs/script người khác; trước khi chạy lệnh nguy hiểm copy trên mạng; muốn học flag mới.
- **Cho ai:** mọi người copy lệnh từ mạng/docs, đặc biệt lệnh có tính phá hủy.
- **ĐỪNG dùng khi:** bạn cần agent sửa code/đọc repo — đó là việc của `copilot` (CLI agent) hoặc Agent mode, không phải `gh copilot`.

## Cách gọi (copy-paste)

```bash
# Cài nếu chưa có:
gh extension install github/gh-copilot

gh copilot explain "docker run -p 5432:5432 postgres"
# Kỳ vọng: giải thích từng flag + rủi ro trước khi Enter
# Verify: nói lại được "lệnh này làm gì + rủi ro gì"
# Lưu ý: gh copilot ≠ copilot (gh copilot là extension CLI, không phải lệnh copilot riêng)
```

> Không thấy `gh copilot` thì kiểm tra bằng `gh extension list` trước khi kết luận là bug.

## Ví dụ thật

Nghiệp vụ: bạn copy một lệnh dọn log từ một script trên mạng, muốn biết nó thực sự làm gì trước khi chạy.

```bash
gh copilot explain "find . -type f -name '*.log' -mtime +7 -delete"
# Giải thích: tìm file .log cũ hơn 7 ngày rồi XÓA (-delete) — đây là lệnh phá hủy!
# → thử trên thư mục copy/test trước khi chạy nơi thật.
```

**Kết quả mong đợi:** Hiểu từng flag + rủi ro (lệnh này **xóa file**); bạn quyết định chạy hay không *có cơ sở*.

**✅ Verify:** Nói lại được "lệnh này làm gì + rủi ro gì" là đạt. Nếu không nói lại được thì chưa đủ hiểu để chạy.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ SAI: Chạy lệnh trước, thấy hỏng rồi mới `gh copilot explain` để tìm hiểu — sai thứ tự, dữ liệu đã mất.

✅ ĐÚNG: `gh copilot explain "..."` → hiểu từng flag + rủi ro → thử trên copy/thư mục test → xác nhận mới chạy thật.

**Bài học:** explain TRƯỚC, chạy SAU. Đây không phải mẹo nhỏ — với lệnh phá hủy, đó là ranh giới giữa an toàn và mất dữ liệu.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Hỏi sau khi đã chạy | Sai thứ tự | explain TRƯỚC, chạy SAU |
| Lệnh dài vẫn chạy mù | Lười đọc | Bắt giải thích từng flag + thử trên copy/thư mục test |
| Copy lệnh mạng về chạy | Không verify | explain + tra docs chính thức trước |

## So sánh với Claude Code

| Việc | Copilot (`gh copilot explain`) | Claude Code | Ghi chú |
|---|---|---|---|
| Giải thích lệnh shell | gh extension, giải thích từng flag + rủi ro | Là agent đầy đủ trong terminal | Khác mục đích: một cái dịch lệnh, một cái làm việc |
| Chạy lệnh | Bạn tự chạy sau khi hiểu | Agent chạy trong terminal | Copilot tách "hiểu" khỏi "chạy" → bạn kiểm soát hơn |
| Kiểm chứng | Bạn thử trên copy/test rồi nói lại rủi ro | Bạn review lệnh agent đề xuất | Cả hai: bạn vẫn là người chịu trách nhiệm cuối |

## Best practices (kèm "vì sao")

- **Explain trước, chạy sau — không đảo.** *Vì sao?* Lệnh phá hủy không cho bạn cơ hội làm lại; hiểu trước là lá chắn duy nhất.
- **Lệnh dài thì bắt giải thích từng flag.** *Vì sao?* Hành vi nguy hiểm thường nằm trong một flag nhỏ giữa dòng dài.
- **Thử trên copy hoặc thư mục test.** *Vì sao?* Muốn chắc chắn mà không đánh cược dữ liệu thật thì phải có bản thử.
- **Đừng lẫn `gh copilot` với `copilot`.** *Vì sao?* Cái này để dịch lệnh; cái kia là agent — gọi nhầm thì thấy "sao nó không làm việc".

## Bài tập nhỏ

1. **(5 phút)** Lấy một lệnh bạn từng copy trên mạng, chạy `gh copilot explain`, rồi nói lại "làm gì + rủi ro gì".
2. **(10 phút)** Chọn một lệnh có `-delete`/`--force`, thử trên thư mục test an toàn rồi so sánh với kỳ vọng từ explain.

## Tham khảo

- Index nhóm: [../README.md](../README.md).
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Phân biệt `gh copilot` vs `copilot`: [../../../../02-tips-thuc-chien/11-nang-cao-cli-web-coding-agent.md](../../../../02-tips-thuc-chien/11-nang-cao-cli-web-coding-agent.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Chốt: `gh copilot explain` không làm bạn chậm lại — nó đổi vài giây đọc hiểu lấy sự an toàn của cả một thao tác không thể hoàn tác.
