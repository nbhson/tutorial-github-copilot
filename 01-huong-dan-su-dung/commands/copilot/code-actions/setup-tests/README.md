# /setupTests — Hỏi Copilot chọn & cài test framework (Experimental)

> **Dành cho:** dev mới vào repo chưa có test, muốn dựng khung test đúng chuẩn dự án · **Vấn đề:** không biết chọn framework nào, tự cài sai config, test chạy không nổi · **Đọc xong:** để Copilot đề xuất và thiết lập test framework phù hợp cho repo hiện tại (~2 phút)
> **Harness:** Copilot · **Surface:** Chat view — `/setupTests` gắn nhãn **Experimental** trong cheat sheet ("Get help choosing and setting up a test framework"); không có ở CLI

## 1 câu nôm na

Gọi thợ điện đến xem nhà: `/setupTests` đọc stack repo (ngôn ngữ, framework, cấu trúc thư mục) rồi đề xuất — và nếu bạn duyệt — tự cài test framework kèm config chạy được ngay. Khác với [../tests/README.md](../tests/README.md) (sinh test cho code đang chọn), lệnh này lo phần *nền móng*: chọn framework + dựng khung, chứ không phải viết từng test case. · 📄 [VS Code Docs: AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

## Vì sao dùng /setupTests?

Repo mới hoặc repo thiếu test có một bài toán gài sẵn: **chọn framework sai ở bước 0 thì mọi test sau đều phải đập đi làm lại**. `/setupTests` đưa quyết định này thành cuộc đối thoại — nó đọc stack rồi hỏi bạn xác nhận, thay vì bạn tự đoán. Đây cũng là cách học nhanh: prompt của nó cho thấy những gì cần cân nhắc khi chọn framework (hỗ trợ ngôn ngữ, phong cách, toolchain sẵn có).

**Nếu làm sai thì sao?** Coi nó như *sinh code tự động* thì no. Bản setup nó sinh ra chưa được chạy thử trong repo của bạn — test kéo vào transitive dependencies, config đè lên file bạn đang sửa. Luôn review diff và **chạy thử ít nhất một test** trước khi tin (xem Verify).

> **Tóm gọn 1 câu:** `/setupTests` dựng *nền móng* test (chọn + khung config), còn [`/tests`](../tests/README.md) mới là người *xây tường* (viết case cho code) — dùng đúng giai đoạn, đỡ sửa lại. · 📄 [VS Code Docs: AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** repo mới khởi động, chưa có bất kỳ test nào; repo có test nhưng framework lỗi thời và bạn muốn lời khuyên đổi mới; muốn Copilot đề xuất dựa trên stack thay vì tự mò.
- **ĐỪNG dùng khi:** repo đã có test framework chạy ổn — `/setupTests` chỉ thêm nhiễu; bạn chỉ muốn sinh vài test cho đoạn code cụ thể — đó là [tests](../tests/README.md). · 📄 [VS Code Docs: Pick the right tool](https://code.visualstudio.com/docs/agents/best-practices#pick-the-right-tool-for-the-task)
## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> `/setupTests` · 📄 [VS Code Docs: AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

Lệnh không nhận tham số bắt buộc; nếu bạn đã biết mình muốn gì, thêm ngữ cảnh:

> `/setupTests chọn cho repo Node + TypeScript này, ưu tiên Jest hay Vitest?`

## Ví dụ thật

Repo Python + FastAPI chưa có test nào. Gõ `/setupTests` → Copilot đề xuất **pytest**, đề nghị cấu trúc `tests/` + `pytest.ini`, hỏi mức độ phủ trước khi tạo file.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Prompt examples](https://code.visualstudio.com/docs/agents/guides/prompt-examples)

**✅ Verify:** chạy command test do nó cài và thấy ít nhất **1 test pass**, rồi mở diff review config không đè nhầm file có sẵn.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — Accept mọi thứ rồi tin là "đã có test":**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — duyệt đề xuất, review diff, rồi chạy thử 1 test:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

**Bài học:** `/setupTests` đưa đề xuất và khung — chất lượng là trách nhiệm của bạn.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy `/setupTests` trong list `/` | Experimental / surface không hỗ trợ | Gõ `/` trên máy thật; thử Chat view Copilot harness |
| Đề xuất framework lệch stack | Thiếu ngữ cảnh về repo | Include `@workspace` / `#file` cấu hình build hiện có |
| Config đè file có sẵn | Không review diff | Review từng file trong diff trước Accept |

## So sánh với Claude Code

| Việc | Copilot (`/setupTests`) | Claude Code | Ghi chú |
|---|---|---|---|
| Chọn & cài test framework | Slash Experimental, đề xuất theo stack | Không có built-in | Cả hai đều cần bạn duyệt diff |
| Sinh test cho code cụ thể | [tests](../tests/README.md) | Không có built-in | Đừng nhầm hai lệnh này |

## Best practices (kèm "vì sao")

- **Dùng đúng giai đoạn "chưa có nền móng" mới gọi.** *Vì sao?* Gọi trên repo đã có setup ổn sẽ sinh thêm config lạ.
- **Cho nó biết stack qua `#file` / `@workspace`.** *Vì sao?* Đề xuất chỉ đúng khi nó thấy được toolchain thật của repo.
- **Luôn chạy 1 test trước khi commit config.** *Vì sao?* Bản "setup" chưa qua kiểm chứng trên máy bạn. · 📄 [VS Code Docs: Crafting effective prompts](https://code.visualstudio.com/docs/agents/guides/prompt-examples#tips-for-crafting-effective-prompts)

## Bài tập nhỏ

1. **(5 phút)** Trên repo chưa có test, gõ `/setupTests` và so sánh lý do nó chọn với lựa chọn của bạn.
2. **(5 phút)** Review diff nó tạo: file nào mới, file nào đè, có an toàn không.
3. **(3 phút)** Chạy lệnh test 1 lần, ghi kết quả pass/fail. · 📄 [VS Code Docs: AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Sinh test cho code: [tests](../tests/README.md)
- Cheatsheet: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md) · FAQ: [../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md)
- Docs: [AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [Unit testing with Copilot](https://code.visualstudio.com/docs/agents/guides/unit-testing-with-copilot)

> Chốt: `/setupTests` lo *nền*, `/tests` lo *tường* — đừng gọi người xây tường khi nền còn chưa có.

