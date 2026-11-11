# Edit mode — giới hạn phạm vi sửa file

> **Dành cho:** người mới dùng VS Code Chat, đã biết mình cần sửa file nào · **Đọc xong:** biết cách gọi Edit và giới hạn đúng file bị sửa (~2 phút)
>
> **Harness:** Local · **Surface:** VS Code Chat (Local harness) — dùng ở máy bạn, không phải Copilot trên GitHub.com

## 1 câu nôm na

Mượn thợ sửa nhà mà chỉ dán băng keo quanh đúng những phòng được phép đụng: vào Chat, chọn **Edit**, tick các file cần sửa, rồi mô tả thay đổi.

Edit nằm giữa Ask (chỉ trả lời, không sửa) và Agent (tự đi tìm file, tự sửa, tự chạy lệnh): bạn vẫn giữ quyền chọn phạm vi.

## Vì sao dùng Edit mode?

Vì bạn biết chính xác chỗ cần sửa và không muốn AI "tiện tay" refactor cả repo. Tick file là ranh giới cứng nhất: diff gọn, review nhanh, dễ Accept/Reject từng hunk. Agent giao việc mở thì phải tin nó chọn file — có lúc nó chọn sai.

VS Code mô tả ba mode built-in như sau:

| Mode | Được làm gì | Khi nào dùng |
|---|---|---|
| Ask | Trả lời, đọc code, **không** sửa file | Cần hiểu trước khi quyết định sửa gì |
| Edit | Sửa **đúng các file bạn tick** | Đã biết 1–5 file cần thay đổi |
| Agent | Tự quyết định file để sửa, chạy lệnh | Task nhiều bước, chưa biết sẽ chạm file nào |

> **Cách đọc bảng này:** độ tự chủ tăng dần từ Ask → Edit → Agent; quyền kiểm soát phạm vi thì giảm dần — chọn dòng có mức tự chủ đúng bằng mức bạn muốn buông tay.

## Khi nào dùng / khi nào đừng

- **Dùng Edit khi:** đã xác định được file (đổi message lỗi, vá validation, refactor nhỏ 1–5 file); muốn đọc diff từng hunk trước khi nhận; sửa nhanh không cần AI tự khám phá repo.
- **ĐỪNG dùng Edit khi:** chưa biết lỗi nằm ở file nào (dùng **Ask** để khảo sát, hoặc **Agent** để nó tự tìm); việc trải ra quá nhiều file → chia phase.
- **Chú ý bản đồ mode:** theo [Copilot feature matrix](https://docs.github.com/en/copilot/reference/copilot-feature-matrix), Edit mode có trong VS Code và JetBrains; Copilot trên GitHub.com **không** có Edit mode — trên đó bạn làm việc với cloud agent. Trong VS Code, [trang chat in IDE](https://docs.github.com/en/copilot/how-tos/copilot-in-your-ide/chat-with-copilot/chat-in-ide) hôm nay chỉ liệt kê ba built-in agents **Ask / Agent / Plan** cho cả hai harness; muốn sửa có kiểm soát trên Copilot thì tạo session **Plan** hoặc **Agent** rồi siết [tool permissions](../../../copilot/model-agent/policy-approval/README.md) + [working set](../../../copilot/chat-session/attachments/README.md) và dùng **Keep/Undo** cho từng lượt.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

## Ví dụ thật

**Tình huống:** form đăng ký nhận email sai định dạng, và bạn biết chắc lỗi nằm ở `src/validators/email.ts` cùng file test của nó — chỉ 2 file.

**Các bước:**

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** diff chỉ xuất hiện trong 2 file đã tick; bạn duyệt từng hunk, chạy test xanh rồi mới Keep.

**✅ Verify:** `git diff --stat` chỉ liệt kê 2 file đó, không có file thứ ba.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — ôm nhiều file, lệnh mơ hồ:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — ít file, phạm vi khóa chặt:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** danh sách file đã tick là hàng rào — càng ngắn và càng nói rõ ranh giới thì diff càng dễ đọc.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Sửa lan sang file chưa chọn | Prompt thiếu "chỉ đụng file đã tick" | Thêm đúng câu đó vào cuối prompt |
| Tick 8–10 file một lúc | Ôm đồm, không review nổi | ≤5 file/lượt, xong thì review rồi sang phase tiếp |
| Accept không đọc diff | Tin tưởng mù quáng | Duyệt từng hunk + chạy test rồi mới Keep |

## So sánh với Claude Code

| Việc cần làm | Copilot Local | Claude Code | Ghi chú |
|---|---|---|---|
| Giới hạn file được sửa | Tick file ở working set, prompt "chỉ ..." | **Không có tick tương đương**: giới hạn bằng prompt và permission (`Edit(...)` allow/ask) | Copilot cho hàng rào nhìn thấy được; Claude Code tin lời + lời xin phép |
| Duyệt thay đổi | Keep/Undo từng block, mở diff 2 cột | Review trong terminal rồi accept từng edit | Cùng tư tưởng: đọc diff trước khi nhận |
| Muốn AI tự đi tìm file | Sang [Agent](../../../copilot/model-agent/agent-mode/README.md) mode (Local) hoặc Copilot Agent | Mặc định agent tự chọn, giới hạn bằng allowlist | Claude Code không có chế độ "chỉ đọc" kiểu Ask |
| Đổi mode giữa chừng | Dropdown mode trên session Local (Ask/Edit/Agent) | Đổi bằng plan mode / permission mode | [Feature matrix](https://docs.github.com/en/copilot/reference/copilot-feature-matrix) ghi Edit chỉ có ở IDE, không có trên GitHub.com |

## Best practices (kèm "vì sao")

- **≤5 file mỗi lượt.** *Vì sao?* Diff đủ ngắn để bạn thật sự đọc — phần lớn tai nạn đến từ "Accept nhanh cho xong".
- **Chốt commit sạch trước khi sửa.** *Vì sao?* [Checkpoint](../../../copilot/chat-session/checkpoints/README.md)/undo tin cậy hơn khi git diff phản ánh đúng phần AI làm.
- **Đọc từng hunk, chạy test rồi mới Keep.** *Vì sao?* Keep mù là con đường ngắn nhất đưa bug vào repo.
- **Commit ngay sau khi Keep.** *Vì sao?* Tách được phần AI sửa khỏi phần bạn sửa về sau.

## Bài tập nhỏ

1. **(3')** Tick đúng 1 file, sửa một message lỗi; chạy `git diff --stat` xem có file khác bị đụng không.
2. **(5')** Lặp lại thí nghiệm với 6–7 file được tick cho cùng một yêu cầu nhỏ; so độ dài diff.
3. **(7')** Làm một task chia 2 phase (3 file → review → 3 file tiếp); ghi lại chỗ nào bạn thấy mất kiểm soát.

## Tham khảo

- [Group index: Model & Agent](../README.md) · [Modes & built-in agents](../../../../10-modes-permissions-availability.md) · [Cheatsheet](../../../../../CHEATSHEET.md)
- docs: [VS Code — Copilot features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [GitHub — feature matrix (cột Edit mode)](https://docs.github.com/en/copilot/reference/copilot-feature-matrix) · [Chat with Copilot in your IDE](https://docs.github.com/en/copilot/how-tos/copilot-in-your-ide/chat-with-copilot/chat-in-ide) · [Sandbox & tool approval](../../../copilot/model-agent/sandbox-policy/README.md)
