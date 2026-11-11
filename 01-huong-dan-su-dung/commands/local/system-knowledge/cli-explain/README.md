# gh copilot explain — hiểu một lệnh shell TRƯỚC khi bấm Enter

> **Dành cho:** người hay copy lệnh từ docs/script rồi chạy · **Vấn đề:** một flag vô hại có thể xóa dữ liệu · **Đọc xong:** biết cách bắt `explain` dịch từng flag + chỉ ra rủi ro (~2 phút)
>
> **Harness:** Local · **Surface:** terminal (`gh copilot` extension) — chạy ở máy bạn, không phải harness Chat/agent nào

## 1 câu nôm na

Nhờ một người hiểu Unix đọc cho bạn nghe từng chữ trong lệnh: "cái `-delete` kia là XÓA thật đấy" — bạn dán lệnh vào, nó dịch từng flag rồi bạn mới quyết định có Enter hay không.

## Vì sao dùng gh copilot explain?

Vì lệnh copy từ mạng về rất hay giấu hành vi phá hủy trong một flag ngắn: `-delete`, `--hard`, `-a`, `--prune`. Bạn đọc lướt qua thấy vô hại, bấm Enter, mất dữ liệu không hoàn tác được. `explain` cưỡng lại thói quen đó: nó bắt bạn đọc bản dịch trước.

| Lệnh copy từ mạng | Flag "vô hại" | Thật ra làm gì |
|---|---|---|
| `find . -name '*.log' -delete` | `-delete` | Xóa file tìm được, không hỏi lại |
| `git reset --hard HEAD~2` | `--hard` | Bỏ thay đổi trong working tree, không undo dễ |
| `docker system prune -a` | `-a` | Xóa ảnh/containers đang không chạy |

> **Cách đọc bảng này:** cột cuối là thứ bạn chỉ biết *sau khi* chạy nếu không hỏi trước — `explain` đổi vài giây đọc lấy cột cuối đó.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** gặp lệnh lạ trong docs/blog/script của người khác; sắp chạy lệnh có `-delete`/`--force`/`reset --hard`; muốn học flag mới.
- **ĐỪNG dùng khi:** bạn cần AI sửa code hoặc đọc repo — `gh copilot` chỉ dịch/gợi ý lệnh shell, nó không phải agent.
- **Cho ai:** mọi người hay copy-paste lệnh; đặc biệt ai làm việc trên máy có dữ liệu thật.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Lệnh không chạy được? `gh extension list` để kiểm tra đã cài chưa — nhưng xem cảnh báo ở mục "Lỗi thường gặp" trước đã.

## Ví dụ thật

Bạn gặp lệnh dọn log trong script tải về và chưa chắc nó làm gì với file.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** bản dịch chỉ rõ lệnh **xóa file** (`-delete`), bạn chạy thử trên bản copy trước.

**✅ Verify:** bạn nói lại được "lệnh này làm gì + rủi ro gì". Không nói lại được nghĩa là chưa đủ hiểu để Enter.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — chạy trước, hỏi sau:** bạn Enter lệnh `find ... -delete` rồi mới thấy mất log, lúc ấy mới đi hỏi "nó làm gì" — lúc này bản dịch chỉ là cáo trạng, dữ liệu đã mất.

**✅ ĐÚNG — dịch → thử trên bản copy → rồi mới chạy:** `gh copilot explain "<lệnh>"` → đọc từng flag + rủi ro → chạy trên thư mục test/copy → xác nhận đúng như bản dịch mới chạy nơi thật.

**Bài học:** thứ tự là tất cả. Explain trước thì rủi ro hiện ra trước; hỏi sau thì bạn chỉ đang đọc cáo trạng.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| `gh: copilot is not installed` | Chưa cài extension | `gh extension install github/gh-copilot` (xem cảnh báo dưới) |
| Extension ngừng được cập nhật | `github/gh-copilot` đã chuyển sang chế độ archived, README đánh dấu deprecated từ 25/10/2025 | Dọc đường thay thế: [Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli) (`copilot`) |
| Hỏi xong vẫn chạy mù | Không đọc bản dịch | Buộc nó liệt kê từng flag + rủi ro, thử trên bản copy |

> **Cách đọc bảng này:** hai hàng đầu là chuyện "chạy được hay không", hàng ba mới là chuyện an toàn — đừng bận tâm cài đặt mà bỏ quên bước đọc bản dịch.

## So sánh với Claude Code

| Việc cần làm | Copilot (`gh copilot explain`) | Claude Code | Ghi chú |
|---|---|---|---|
| Dịch một lệnh shell | `gh copilot explain "<lệnh>"`, từng flag + rủi ro | hỏi agent ngay trong terminal | Extension sinh ra để tra lệnh, gọn; Ask mode cũng dịch được nhưng phải bật IDE |
| Chạy lệnh đó | bạn tự copy và chạy — extension chỉ giải thích | agent tự chạy (kèm bước duyệt) | "hiểu" tách khỏi "chạy" là chủ ý, không phải thiếu tính năng |
| Việc đa bước trên repo | không làm được: dùng [Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli) hoặc [Agent](../../../copilot/model-agent/agent-mode/README.md) mode (Local) | mặc định là agent, tự đọc–sửa–chạy | Đừng giao việc của agent cho extension tra lệnh |

## Best practices (kèm "vì sao")

- **Explain trước, chạy sau — không đảo.** *Vì sao?* Lệnh phá hủy không cho bạn cơ hội làm lại; hiểu trước là lá chắn duy nhất.
- **Lệnh dài thì bắt giải thích từng flag.** *Vì sao?* Hành vi nguy hiểm nằm trong một flag nhỏ giữa dòng dài.
- **Thử trên copy/thư mục test.** *Vì sao?* Muốn chắc chắn mà không đánh cược dữ liệu thật thì phải có bản thử.
- **Đừng lẫn `gh copilot` với `copilot`.** *Vì sao?* Một cái dịch lệnh, một cái là agent — gọi nhầm thì thấy "sao nó không làm việc".

## Bài tập nhỏ

1. **(5')** Lấy một lệnh bạn từng copy trên mạng, chạy `gh copilot explain`, nói lại "làm gì + rủi ro gì".
2. **(10')** Chọn lệnh có `-delete` hoặc `--force`: explain → thử trên thư mục test → so kết quả với bản dịch.

## Tham khảo

- [Group index: System & kiến thức repo](../README.md) · [Tips CLI & web agent](../../../../../02-tips-thuc-chien/11-nang-cao-cli-web-coding-agent.md) · [Cheatsheet](../../../../../CHEATSHEET.md)
- [GitHub — About Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli)
- [GitHub — Install Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli)
- Cùng tra lệnh: [cli-suggest](../cli-suggest/README.md) · Lỗi thường gặp ở IDE: [troubleshoot](../../../copilot/chat-session/troubleshoot/README.md)
