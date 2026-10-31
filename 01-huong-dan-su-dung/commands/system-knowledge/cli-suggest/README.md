# gh copilot suggest — Gợi ý lệnh CLI trong terminal

> **Dành cho:** dev quên cú pháp git/docker/gh/kubectl · **Vấn đề:** muốn lệnh 1 dòng mà nhớ sai flag thì nguy hiểm · **Đọc xong:** ra lệnh + giải thích flag, chạy dry-run trước (~2 phút)

## 1 câu nôm na

`gh copilot suggest` giống như hỏi đường ngay trong terminal — "muốn làm việc này thì gõ lệnh gì?". Bạn mô tả bằng lời, nó trả về 1–2 lệnh cụ thể kèm giải thích flag. Nếu máy chưa có thì cài bằng `gh extension install github/gh-copilot`.

> Phân biệt rõ: `gh copilot` là **gh extension** (chỉ gợi ý/giải thích lệnh shell), **không phải** `copilot` — CLI agent riêng chạy task cả đoạn trong terminal. Hai thứ khác nhau, đừng lẫn.

## Vì sao dùng gh copilot suggest?

Vì cú pháp git/docker/gh/kubectl rất dễ nhớ nhầm flag — mà sai flag thì nguy hiểm thật (xóa nhầm, force nhầm). Hỏi trước rồi mới chạy, bạn vừa có lệnh đúng vừa hiểu từng flag nghĩa gì, thay vì copy từ mạng về chạy mù.

**Nếu làm sai thì sao?** Cái bẫy lớn nhất là tin 100% rồi chạy thẳng, đặc biệt với lệnh có tính phá hủy (`rm`, `--force`, `reset --hard`). Gợi ý sai OS cũng hay gặp: lệnh Linux đưa cho Mac/Windows. Nên luôn hiểu từng flag + dry-run trước.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** quên cú pháp git/docker/gh/kubectl; cần lệnh một dòng làm việc lạ; muốn học lệnh mới an toàn (hiểu rồi mới chạy).
- **Cho ai:** người sống trong terminal, người đang học lệnh mới.
- **ĐỪNG dùng khi:** bạn cần agent sửa code/đọc repo — đó là việc của `copilot` (CLI agent) hoặc Agent mode trong IDE, không phải `gh copilot`.

## Cách gọi (copy-paste)

```bash
# Cài nếu chưa có:
gh extension install github/gh-copilot

gh copilot suggest "tìm file >100MB trong git history"
# Kỳ vọng: 1–2 lệnh cụ thể + giải thích flag
# Verify: chạy lệnh được gợi ý ở chế độ an toàn (--dry-run) thành công
# Lưu ý: gh copilot ≠ copilot (gh copilot là extension CLI, không phải lệnh copilot riêng)
```

> Không thấy `gh copilot` thì kiểm tra bằng `gh extension list` trước khi kết luận là bug.

## Ví dụ thật

Nghiệp vụ: dọn dẹp máy — xóa các branch local đã merge vào main nhưng quên đúng cú pháp.

```bash
gh copilot suggest “xóa branch đã merge trừ main/develop”
# Đọc lệnh + giải thích flag → chạy thử bản an toàn trước:
#   git branch --merged | grep -v ... | xargs git branch -d   # -d (không -D) để không xóa branch chưa merge
```

**Kết quả mong đợi:** Được 1–2 lệnh cụ thể kèm giải thích flag; bạn chạy thử bản an toàn (ví dụ `-d` thay `-D`, hoặc `--dry-run`) trước.

**✅ Verify:** Chạy lệnh được gợi ý ở chế độ an toàn thành công là đạt. Không chắc thì hỏi lại flag trước khi chạy bản thật.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ SAI: copy lệnh gợi ý rồi Enter thẳng, nhất là lệnh có `rm -rf`, `--force`, `reset --hard`.

✅ ĐÚNG: đọc giải thích từng flag + chạy bản dry-run/an toàn trước (`git branch -d` thay `-D`, thêm `--dry-run`), xác nhận đúng mới chạy thật.

**Bài học:** `gh copilot suggest` cho bạn lệnh, không cho bạn sự an toàn. Cái an toàn do bạn đọc flag và dry-run mà có.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Chạy thẳng lệnh nguy hiểm | Tin 100% | Hiểu từng flag + dry-run trước; cấm `rm -rf`/force mù |
| `gh copilot: not found` | Chưa cài extension | `gh extension install github/gh-copilot` |
| Gợi ý sai OS | Lệnh Linux trên Mac/Win | Nêu rõ OS trong prompt |

## So sánh với Claude Code

| Việc | Copilot (`gh copilot suggest`) | Claude Code | Ghi chú |
|---|---|---|---|
| Gợi ý lệnh shell | gh extension, gợi ý + giải thích flag | Là agent đầy đủ trong terminal, không phải công cụ tra lệnh | Khác mục đích: một cái tra lệnh, một cái làm việc |
| Chạy lệnh | Bạn tự copy + chạy | Agent chạy trong terminal | Copilot tách "gợi ý" khỏi "chạy" → bạn kiểm soát hơn |
| Kiểm chứng | Bạn chạy dry-run | Bạn review lệnh agent đề xuất | Cả hai: bạn vẫn là người chịu trách nhiệm |

## Best practices (kèm "vì sao")

- **Nêu rõ OS trong prompt.** *Vì sao?* Cú pháp Mac/Linux/Windows khác nhau; thiếu OS là nguồn lỗi số một.
- **Đọc giải thích flag trước khi chạy.** *Vì sao?* Hiểu flag mới phát hiện được lệnh phá hủy trá hình.
- **Chạy bản an toàn trước (`--dry-run`, `-d` thay `-D`).** *Vì sao?* Sai thì chỉ mất vài giây, không mất dữ liệu.
- **Đừng lẫn `gh copilot` với `copilot`.** *Vì sao?* Cái này tra lệnh, cái kia là agent — gọi nhầm thì thấy "sao nó không sửa file".

## Bài tập nhỏ

1. **(5 phút)** Hỏi `gh copilot suggest` một lệnh git bạn hay quên, đọc giải thích flag, rồi chạy bản an toàn để xác nhận.
2. **(10 phút)** Cố tình hỏi một lệnh phá hủy (`rm`, `--force`); tập thói quen dừng lại, giải thích từng flag rồi mới quyết định chạy.

## Tham khảo

- Index nhóm: [../README.md](../README.md).
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Phân biệt `gh copilot` vs `copilot`: [../../../../02-tips-thuc-chien/11-nang-cao-cli-web-coding-agent.md](../../../../02-tips-thuc-chien/11-nang-cao-cli-web-coding-agent.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Chốt: `gh copilot suggest` giỏi nhất ở việc biến câu tiếng người thành lệnh shell — nhưng quyền quyết định bấm Enter vẫn nằm ở bạn, sau khi đã hiểu từng flag.
