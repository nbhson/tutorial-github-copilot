# Edit mode — Sửa file chỉ định, có kiểm soát

> **Dành cho:** người đã biết cần sửa file nào (1–5 file) · **Đọc xong:** giới hạn được đúng file nào bị chạm, diff gọn để review (~2 phút)

## 1 câu nôm na

Đưa thợ một danh sách phòng được sửa, ngoài danh sách thì cấm đụng. Vào Chat → mode **Edit** → tick đúng file, rồi ghi rõ "chỉ đụng những file đã tick".

Khác với Agent: ở Edit bạn giữ quyền chọn phạm vi ngay từ đầu, nên diff thường gọn và dễ review từng hunk.

## Vì sao dùng Edit mode?

Có những việc bạn biết chính xác chỗ cần sửa: đổi message lỗi, thêm một nhánh validation, refactor nhỏ 1–3 file. Giao cho Agent thì nó đi đọc cả chục file — vừa tốn credits vừa khó kiểm soát. Edit khóa phạm vi vào đúng file bạn tick.

Ba chế độ của Chat khác nhau ở mức quyền:

| Mode | Đặc điểm | Khi nào dùng |
|---|---|---|
| Ask | Chỉ đọc, không sửa file | Hỏi/khảo sát/so sánh phương án trước khi đụng code |
| Edit | Sửa đúng files bạn tick, có kiểm soát | Đã biết sửa 1–5 file, muốn review từng hunk |
| Agent | Tự tìm file, sửa, chạy terminal | Task mở nhiều bước, chưa biết chạm file nào |

> **Cách đọc bảng này:** ba dòng xếp theo độ tự chủ tăng dần — Edit ở giữa: đã biết phạm vi nên không cần Agent, nhưng cần sửa nên không đứng lại Ask.

**Nếu làm sai thì sao?** Hai mặt trái: (1) tick quá nhiều file → bạn ôm cả chục file, diff phình, review mệt; (2) không ghi rõ "chỉ file đã tick" → model tiện tay sửa lan. Giữ danh sách tick ngắn và nói rõ ranh giới thì Edit là mode dễ kiểm soát nhất.

> **Tóm gọn 1 câu:** Edit là "dán băng keo quanh khu vực được sửa" — danh sách tick càng ngắn, băng keo càng kín, diff càng dễ review.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** đã biết sửa file nào (1–5 file); sửa vừa (đổi message, thêm validation, refactor nhỏ); muốn kiểm soát chặt file nào được chạm.
- **ĐỪNG dùng khi:** chưa biết lỗi/file nằm ở đâu → dùng **Ask** để khảo sát trước, hoặc **Agent** để nó tự đi tìm; hoặc việc chỉ sửa một đoạn đang bôi đen → `/fix` nhanh hơn.
- **Cho ai:** người sửa có chủ đích, muốn review từng hunk trước khi Accept.

> **Tóm gọn 1 câu:** Biết chính xác 1–5 file cần sửa thì Edit là mode dễ kiểm soát nhất — chưa biết file nào thì hãy quay lại Ask hoặc để Agent tự tìm.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Không thấy mode **Edit** trong dropdown? Xem `/status` + plan trước khi kết luận lỗi — có IDE gộp nhóm mode khác, cứ chọn theo menu thực tế của bạn.

## Ví dụ thật

Nghiệp vụ: form đăng ký nhận email sai định dạng. Bạn đã biết cần sửa đúng 2 file: `src/validators/email.ts` và test của nó.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** Diff chỉ nằm trong 2 file đã tick; bạn review từng hunk, chạy test liên quan xanh rồi mới Accept.

**✅ Verify:** `git diff --stat` chỉ liệt kê đúng những file bạn đã tick là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — tick nhiều file rồi ra lệnh mơ hồ:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — tick ít, khóa phạm vi rõ:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** Ở Edit, danh sách tick chính là hàng rào. Càng ít file và càng nói rõ ranh giới, diff càng dễ review.

## Lỗi thường gặp

Diff phình hoặc sửa lan? Ba ca dưới đây là nguyên nhân thường gặp khi dùng Edit — tra theo Triệu chứng rồi áp Fix.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Sửa lan sang file chưa tick | Prompt thiếu "chỉ ..." | Ghi rõ "chỉ đụng files đã tick" |
| Tick quá nhiều file | Ôm cả chục file | Tick ≤5 file/lần, chia phase |
| Accept mù | Lười đọc diff | Đọc từng hunk + chạy test trước Accept |

> **Cách đọc bảng này:** đọc theo hàng từ Triệu chứng → Fix; hàng "Accept mù" đáng nhớ nhất vì nó là cách bug lọt qua mọi lớp bảo vệ mà không ai hay.

## So sánh với Claude Code

Cũng dùng Claude Code? Bảng này đối chiếu cách hai công cụ khóa phạm vi sửa — khác biệt thật sự nằm ở chỗ một bên khóa bằng UI, một bên khóa bằng lời.

| Việc | Copilot (Edit mode) | Claude Code | Ghi chú |
|---|---|---|---|
| Khóa phạm vi file | Tick file trong UI Edit | Không tick — agent tự xác định file, giới hạn bằng prompt/`@file` | Edit cho bạn "ván" cứng bằng UI; Claude Code dựa vào prompt |
| Review từng hunk | Diff hiện theo hunk để Accept/Reject | Duyệt thay đổi qua permission prompt | Cùng tinh thần: đọc diff trước khi nhận |
| Việc sửa 1–5 file | Hợp nhất | Hợp nhất | Cả hai đều nhanh với thay đổi nhỏ, khu trú |

> **Cách đọc bảng này:** đọc theo hàng so khớp tư duy; cột Ghi chú là chỗ khác bản chất — Copilot khóa phạm vi bằng thao tác tick, Claude Code khóa bằng câu chữ của bạn.

## Best practices (kèm "vì sao")

Bốn thói quen dưới đây giữ cho Edit đúng vai "sửa có kiểm soát" — mỗi thói quen kèm lý do để bạn biết khi nào được nới.

- **Tick ≤5 file mỗi lần.** *Vì sao?* Diff ngắn thì bạn review kỹ được; ôm cả chục file là tự chuốc nợ review.
- **Luôn thêm câu "chỉ đụng file đã tick".** *Vì sao?* Model có xu hướng tiện tay dọn chỗ không hỏng, làm diff phình.
- **Đọc từng hunk + chạy test trước khi Accept.** *Vì sao?* Accept mù là cách phổ biến nhất để mang bug vào repo mà không biết.
- **Việc chạm nhiều file thì chia phase.** *Vì sao?* Sửa xong 5 file, review, rồi mới sang 5 file tiếp — mỗi phase là một điểm kiểm soát.

## Bài tập nhỏ

1. **(3 phút)** Chọn 1 thay đổi nhỏ trong repo bạn (đổi message/typo), chạy Edit với đúng 1 file tick và xem `git diff --stat`.
2. **(5 phút)** Cố tình tick 6–7 file rồi yêu cầu một sửa đổi nhỏ; quan sát diff phình thế nào so với chỉ tick 2 file.
3. **(7 phút)** Làm một task chia 2 phase: phase 1 sửa 3 file → review → phase 2 sửa tiếp. Ghi lại cảm giác kiểm soát so với làm một lượt.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Chỉ hỏi trước khi sửa: [../ask-mode/README.md](../ask-mode/README.md). Task mở, nhiều bước: [../agent-mode/README.md](../agent-mode/README.md).

> Edit mạnh nhất khi bạn **đã biết chỗ đau** — tick đúng file rồi để diff tự kể câu chuyện bạn vừa sửa gì.
