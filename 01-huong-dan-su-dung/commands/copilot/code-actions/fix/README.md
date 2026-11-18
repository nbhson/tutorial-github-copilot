# /fix — sửa đúng đoạn đang bôi đen, nhanh hơn gõ tay mô tả "sửa ở đâu"

> **Harness:** Copilot · **Surface:** Chat view (`/fix`, nhóm "editor" trong chat reference) · **Đọc:** ~2 phút

**Nôm na:** Khoanh chỗ đau rồi bảo "chữa chỗ này, đừng đụng chỗ khác" — selection đã được gắn sẵn vào prompt nên bạn không phải mô tả lại "sửa file nào, đoạn nào". Hợp khi lỗi nhỏ, khu trú và bạn **đã biết lỗi nằm ở dòng nào**; chưa biết thì đừng dùng lệnh này.

## Vì sao dùng?

Gõ prompt tay, bạn tốn 1–2 câu chỉ để nói *sửa ở đâu*, và thường phải đưa cả file vào ngữ cảnh; `/fix` lấy đúng phần bôi đen làm scope nên ít token hơn, bám đúng chỗ, không lan ra hàm khác. Hai lỗi kinh điển của người mới: quên bôi đen → model tự đoán scope và sửa cả file; mô tả thiếu câu "giữ nguyên..." → nó tiện tay refactor luôn phần không hỏng. Cả hai đều cho diff to hơn dự kiến, mà diff to thì review chậm và dễ sót bug.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không bôi đen mà gọi `/fix` | Model tự đoán scope | Bôi đen chính xác rồi gọi lại |
| Sửa lan sang logic khác | Mô tả thiếu "giữ nguyên ..." | Thêm "không đổi logic khác" vào prompt |
| Fix xong vẫn fail test | Lỗi sâu hơn 1 chỗ, không phải bug khu trú | Chuyển sang Agent mode để điều tra |

**Nếu làm sai:** `/fix` giỏi sửa chỗ đã biết nhưng kém ở việc *đi tìm* root cause — lỗi lan nhiều file hoặc chưa khoanh vùng được thì đưa cho Agent mode, đừng cố vài ba lượt `/fix`.

## Cách dùng

Bôi đen đoạn lỗi trong editor, gõ trong Chat view:

```prompt
/fix "thêm null check cho params, giữ nguyên API shape, không refactor chỗ khác"
```

- **Biến thể:** `/fix` trần khi lỗi đã rõ ràng; thêm chỉ dẫn khi có thứ không được phép đổi (API shape, format log, tên hàm public).
- **✅ Verify:** chạy test/lint cho file vừa sửa — `npm test -- auth` xanh, `git diff --stat` chỉ đúng 1 file là đạt.

## Liên quan

- Chưa biết lỗi ở đâu, cần điều tra nhiều file: [agent-mode](../../model-agent/agent-mode/README.md) · Test bao lại sau khi sửa: [tests](../tests/README.md) · Đọc log đỏ trong terminal: [debug-terminal](../debug-terminal/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Fix coding errors](https://code.visualstudio.com/docs/editing/copilot-smart-actions#fix-coding-errors) · [Add a failing regression test](https://code.visualstudio.com/docs/agents/guides/fix-a-bug-with-agents#add-a-failing-regression-test)
