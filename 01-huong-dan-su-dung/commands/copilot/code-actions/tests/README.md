# /tests — sinh unit tests cho hàm đang chọn theo mẫu của repo

> **Harness:** Copilot · **Surface:** Chat view (`/tests`, nhóm "editor" trong chat reference) · **Đọc:** ~2 phút

**Nôm na:** Bảo "viết bài kiểm tra cho bài này, theo đúng mẫu lớp mình" — bạn bôi đen hàm rồi gọi `/tests`, nó dựng khung test theo mẫu repo, bạn chỉ review và chỉnh case. Hợp khi vừa viết/sửa xong một hàm, lúc bạn còn nhớ rõ nhánh nào nguy hiểm nhất.

## Vì sao dùng?

Viết test tốn thời gian nhất ở khâu khung xương: import, `describe/it`, setup mock, teardown — `/tests` làm phần đó hộ. Lợi thật thứ hai là **cover đúng nhánh vừa sửa**, bởi viết tay hay bỏ sót nhánh biên (null, rỗng, lỗi mạng) mà bug lại hay nấp ở đó. Rủi ro lớn nhất là **test ảo**: chỉ assert đại, hoặc mock tới mức không còn kiểm tra gì thật — nó chạy xanh, CI báo đẹp, bug vẫn nguyên, và tệ hơn không có test vì bạn tưởng mình đã được bảo vệ.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Test sinh ra không chạy được | Sai import/framework so với repo | Nêu rõ framework + tên file test mẫu trong prompt |
| Test ảo, logic sai vẫn xanh | Mô tả quá chung ("viết test cho hàm này") | Bắt "mỗi test phải fail nếu logic sai" + review tay |
| Quên mock DB/API | Prompt thiếu | Thêm "mock DB/API theo mẫu X" |
| Cần *sửa code* cho test pass | Nhầm việc của `/tests` và `/fix` | Bug khu trú thì dùng [`/fix`](../fix/README.md) |

**Nếu làm sai:** đừng sửa test cho pass — test là bằng chứng, không phải thứ để chiều; và đừng tin chữ "đã viết xong", chỉ tin kết quả chạy test.

## Cách dùng

Bôi đen hàm trong editor, gõ trong Chat view, nêu framework + file mẫu + thứ cần mock:

```prompt
/tests "sinh 3 cases (thường, biên, null) theo mẫu order.test.ts, mock DB; mỗi test phải fail nếu logic sai"
```

- **Biến thể:** quy ước test riêng của team → đóng gói vào custom agent `.github/agents/*.agent.md` để khỏi nhắc lại; Copilot CLI gọi agent bằng `--agent=AGENT`.
- **✅ Verify:** chạy test mới — xanh và cover đúng nhánh; rồi cố tình sửa logic 1 dòng cho sai, test **phải đỏ**.

## Liên quan

- Repo chưa có framework thì dựng nền trước: [setup-tests](../setup-tests/README.md) · Đóng gói quy ước test: [custom-agent](../../model-agent/custom-agent/README.md) · Test cho luồng nhiều module: [agent-mode](../../model-agent/agent-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Generate tests](https://code.visualstudio.com/docs/editing/copilot-smart-actions#generate-tests) · [Review assertions & coverage](https://code.visualstudio.com/docs/agents/guides/test-code-with-ai#review-assertions-and-coverage)
