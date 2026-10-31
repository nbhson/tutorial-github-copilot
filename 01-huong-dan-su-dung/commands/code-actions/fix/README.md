# /fix — Sửa lỗi/selection nhanh hơn gõ tay

> **Dành cho:** dev đã biết lỗi nằm ở đâu · **Đọc xong:** sửa gọn đúng chỗ đau, không lan sang logic khác (~2 phút)

## 1 câu nôm na

Khoanh chỗ đau rồi bảo "chữa chỗ này, đừng đụng chỗ khác". Bạn **bôi đen** đoạn lỗi rồi gọi `/fix` — vì selection đã được gắn sẵn vào prompt, bạn không phải mô tả lại "sửa ở đâu" như khi gõ tay.

## Vì sao dùng /fix (thay vì gõ prompt tay)?

Khi gõ prompt tay, bạn tốn 1–2 câu chỉ để nói *sửa file nào, đoạn nào*. `/fix` tự lấy phần bạn đang bôi đen làm scope, nên:

- **Ít tokens hơn** — không đưa cả file vào chỉ để sửa 3 dòng.
- **Ít sửa nhầm hơn** — model bám đúng selection, không lan ra hàm khác.
- **Nhanh hơn** — bôi đen + gọi là xong, không phải gõ lại ngữ cảnh.

**Nếu làm sai thì sao?** Hai lỗi thường gặp: (1) quên bôi đen → model tự đoán scope và sửa cả file; (2) mô tả thiếu câu "giữ nguyên..." → nó tiện tay refactor luôn phần không hỏng. Cả hai đều dẫn tới diff to hơn dự kiến — xem mục ❌/✅ bên dưới.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** lỗi nhỏ, khu trú — null check, type error, test fail đúng 1 chỗ, sửa message/log/typo theo chuẩn repo, và bạn **đã biết lỗi nằm ở đâu**.
- **ĐỪNG dùng khi:** bạn chưa biết lỗi ở đâu (dùng **Agent mode** để nó tự đi tìm), hoặc cần sửa nhiều file liên quan (dùng **Edit mode** với danh sách file bạn chọn).
- **Cho ai:** dev sửa lỗi nhỏ lẻ hằng ngày — người muốn sửa đúng chỗ mà không kéo cả file vào context.

## Cách gọi (copy-paste)

```bash
# Bôi đen đoạn lỗi trong editor, rồi:
/fix

# Hoặc gọi kèm chỉ dẫn cụ thể cho chỗ đau:
/fix thêm null check cho params, giữ nguyên API shape
# Kỳ vọng: diff nhỏ đúng chỗ đau, không lan logic khác
```

> Kiểm tra `/fix` có ở máy bạn không: gõ `/` trong ô Chat, tìm `/fix`. Không thấy → chạy `/status` + xem plan trước khi kết luận là lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: `login()` nhận email có dấu bị trả 500 vì `params` có thể là `undefined`.

```bash
# 1. Bôi đen đúng hàm validate() đang lỗi trong src/auth/login.ts
# 2. Gọi:
/fix "thêm null check cho params, giữ nguyên API shape"
# Verify: chạy test/build/lint cho file vừa sửa — xanh là đạt
```

**Kết quả mong đợi:** diff nhỏ đúng chỗ đau (vài dòng), không đụng export/kiểu trả về; test liên quan xanh.

**✅ Verify:** chạy test/build/lint cho file vừa sửa — `npm test -- auth` xanh là đạt; `git diff --stat` chỉ 1 file.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — mô tả quá cụt, không khóa scope:**

```bash
/fix sửa giúp tôi   # model tự đoán, có thể sửa lan sang hàm khác
```

**✅ ĐÚNG — gắn scope + câu "giữ nguyên":**

```bash
# (bôi đen hàm validate) rồi:
/fix "thêm null check cho params, giữ nguyên API shape, không refactor chỗ khác"
```

**Bài học:** luôn nói rõ *sửa gì* và *giữ nguyên gì*. Scope càng khóa, diff càng gọn.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Sửa lan sang logic khác | Mô tả thiếu "giữ nguyên ..." | Thêm "không đổi logic khác" vào prompt |
| Fix xong vẫn fail test | Lỗi sâu hơn 1 chỗ, không phải bug khu trú | Chuyển sang Edit/Agent mode để điều tra |
| Không bôi đen mà gọi `/fix` | Model tự đoán scope | Bôi đen chính xác rồi gọi lại |

## So sánh với Claude Code

| Việc | Copilot (`/fix`) | Claude Code | Ghi chú |
|---|---|---|---|
| Sửa nhanh trên selection | Slash command có sẵn `/fix` | Không có sẵn — bôi đen rồi gõ prompt, hoặc tự tạo slash command trong `.claude/commands/` | Copilot bấm-là-chạy; Claude Code linh hoạt hơn nhưng phải tự dựng |
| Lấy scope từ selection | Tự gắn selection khi bôi đen | Cũng hỗ trợ selection/`@file` | Cùng tư tưởng: đưa đúng chỗ đau, đừng đưa cả file |
| Kiểm chứng | Bạn tự chạy test/lint | Cùng vậy — agent đề xuất, bạn vẫn là người verify | Đừng tin lời "đã sửa xong" của bất kỳ agent nào |

## Best practices (kèm "vì sao")

- **Luôn bôi đen trước khi gọi `/fix`.** *Vì sao?* Selection chính là scope — không có nó, model phải đoán và dễ sửa thừa.
- **Thêm câu "giữ nguyên API shape / không đổi logic khác".** *Vì sao?* Model có xu hướng "tiện tay" dọn dẹp chỗ không hỏng, làm diff phình.
- **Sửa xong chạy test/lint ngay.** *Vì sao?* `/fix` chỉ sinh diff; tính đúng phải do lệnh verify quyết định.
- **Lỗi không khu trú thì đổi mode.** *Vì sao?* `/fix` giỏi sửa chỗ đã biết, kém ở việc *đi tìm* root cause — đó là việc của Agent mode.

## Bài tập nhỏ

1. **(5 phút)** Cố tình gọi `/fix` mà **không** bôi đen, xem nó sửa rộng tới đâu. So với lần bôi đen chính xác — ghi lại sự khác biệt về số dòng diff.
2. **(10 phút)** Lấy 1 bug nhỏ thật trong repo bạn: gọi `/fix` với chỉ dẫn "giữ nguyên API shape", sau đó chạy test để xác nhận không phá gì.
3. **(10 phút)** Thử 1 lỗi không khu trú (bug sâu 2 file): quan sát `/fix` làm được tới đâu rồi chuyển sang Agent mode, so sánh kết quả.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Chuyển mode lớn hơn khi lỗi không khu trú: [../../model-agent/agent-mode/README.md](../../model-agent/agent-mode/README.md) (Agent) và [../../model-agent/edit-mode/README.md](../../model-agent/edit-mode/README.md) (Edit).

> Chốt: `/fix` mạnh nhất khi bạn **đã biết chỗ đau** — bôi đen đúng, khóa scope, rồi để test nói "đạt" thay vì để model tự khen.
