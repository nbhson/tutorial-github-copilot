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

**Nếu làm sai thì sao?** Hai mặt trái: (1) tick quá nhiều file → bạn ôm cả chục file, diff phình, review mệt; (2) không ghi rõ "chỉ file đã tick" → model tiện tay sửa lan. Giữ danh sách tick ngắn và nói rõ ranh giới thì Edit là mode dễ kiểm soát nhất.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** đã biết sửa file nào (1–5 file); sửa vừa (đổi message, thêm validation, refactor nhỏ); muốn kiểm soát chặt file nào được chạm.
- **ĐỪNG dùng khi:** chưa biết lỗi/file nằm ở đâu → dùng **Ask** để khảo sát trước, hoặc **Agent** để nó tự đi tìm; hoặc việc chỉ sửa một đoạn đang bôi đen → `/fix` nhanh hơn.
- **Cho ai:** người sửa có chủ đích, muốn review từng hunk trước khi Accept.

## Cách gọi (copy-paste)

```bash
Chat → mode Edit → tick files
"đổi message lỗi sang tiếng Việt, chỉ 2 file đã tick"
# Kỳ vọng: diff chỉ nằm trong 2 file đã tick, không lan thêm
# Verify: git diff --stat chỉ hiện files đã tick
```

> Không thấy mode **Edit** trong dropdown? Xem `/status` + plan trước khi kết luận lỗi — có IDE gộp nhóm mode khác, cứ chọn theo menu thực tế của bạn.

## Ví dụ thật

Nghiệp vụ: form đăng ký nhận email sai định dạng. Bạn đã biết cần sửa đúng 2 file: `src/validators/email.ts` và test của nó.

```bash
# 1. Tick đúng 2 file trong khung Edit
# 2. Ra lệnh có khóa phạm vi
(Edit, tick src/validators/email.ts + src/validators/email.test.ts)
"thêm validation email dùng regex chuẩn + test cho trường hợp thiếu @, chỉ đụng 2 file này"
# Verify: git diff --stat -> chỉ 2 file trên
```

**Kết quả mong đợi:** Diff chỉ nằm trong 2 file đã tick; bạn review từng hunk, chạy test liên quan xanh rồi mới Accept.

**✅ Verify:** `git diff --stat` chỉ liệt kê đúng những file bạn đã tick là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — tick nhiều file rồi ra lệnh mơ hồ:**

```bash
# tick 10 file, rồi: "sửa validation giúp tôi"
# -> diff lan khắp nơi, review không xuể
```

**✅ ĐÚNG — tick ít, khóa phạm vi rõ:**

```bash
(Edit, tick 2 file)
"thêm validation email + test, chỉ đụng 2 file này, không refactor chỗ khác"
```

**Bài học:** Ở Edit, danh sách tick chính là hàng rào. Càng ít file và càng nói rõ ranh giới, diff càng dễ review.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Sửa lan sang file chưa tick | Prompt thiếu "chỉ ..." | Ghi rõ "chỉ đụng files đã tick" |
| Tick quá nhiều file | Ôm cả chục file | Tick ≤5 file/lần, chia phase |
| Accept mù | Lười đọc diff | Đọc từng hunk + chạy test trước Accept |

## So sánh với Claude Code

| Việc | Copilot (Edit mode) | Claude Code | Ghi chú |
|---|---|---|---|
| Khóa phạm vi file | Tick file trong UI Edit | Không tick — agent tự xác định file, giới hạn bằng prompt/`@file` | Edit cho bạn "ván" cứng bằng UI; Claude Code dựa vào prompt |
| Review từng hunk | Diff hiện theo hunk để Accept/Reject | Duyệt thay đổi qua permission prompt | Cùng tinh thần: đọc diff trước khi nhận |
| Việc sửa 1–5 file | Hợp nhất | Hợp nhất | Cả hai đều nhanh với thay đổi nhỏ, khu trú |

## Best practices (kèm "vì sao")

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
