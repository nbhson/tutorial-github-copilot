# Refactor — dọn cấu trúc mà giữ nguyên behavior (inline chat + Code Actions; docs không có slash `/refactor`)

> **Harness:** Copilot · **Surface:** editor inline chat (`Ctrl+I`, macOS `⌘I`) và Code Actions (lightbulb); chat reference **không** liệt kê slash `/refactor` · **Đọc:** ~2 phút

**Nôm na:** Dọn nhà nhưng không vứt đồ — gọn hơn mà đồ đạc vẫn đủ. Việc hình thái (đổi tên, tách hàm) đi qua lightbulb/Code Actions vì language service đảm bảo không đổi behavior; việc "dọn tư duy" (gom code trùng, tách theo trách nhiệm) thì bôi đen + inline chat với ràng buộc nói ra rõ ràng. Hợp khi hàm/file phình to hoặc code trùng ở nhiều chỗ, và test đang xanh.

## Vì sao dùng?

Refactor là việc đúng nhưng dễ phá thứ đang chạy: đổi cấu trúc mà vô tình đổi hành vi thì bug len vào lặng lẽ. Prompt refactor buộc bạn **khai báo ràng buộc** "behavior không đổi", còn Code Actions cho những việc mà editor chứng minh được là an toàn. Hai mặt trái hay gặp: **refactor kèm đổi hành vi** — test đỏ mà bạn tưởng chỉ là "dọn dẹp"; và **tách quá vụn** — chuỗi hàm 1 dòng nối nhau, đọc còn mệt hơn bản gốc.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Chờ `/refactor` trong danh sách `/` | Docs không có slash này | Inline chat prompt refactor, hoặc Code Actions |
| Behavior đổi luôn khi dọn | Thiếu test bao + prompt thiếu "giữ nguyên" | Chạy test trước/sau; prompt ghi "giữ nguyên behavior" |
| Tách quá vụn, khó đọc hơn | Tham tách | Mỗi hàm 1 việc, tên tự nói được việc |
| Reviewer không biết bug từ đâu | Vừa refactor vừa thêm tính năng | Refactor riêng 1 commit, tính năng riêng 1 commit |

**Nếu làm sai:** đừng refactor đoạn code chưa có test bao — điều kiện tiên quyết là lưới an toàn đã xanh; và refactor xuyên nhiều file thì đưa [agent-mode](../../model-agent/agent-mode/README.md), inline chat chỉ mạnh trong phạm vi bôi đen.

## Cách dùng

Bôi đen đoạn cần dọn, mở inline chat (`Ctrl+I`, macOS `⌘I`) với prompt khóa ràng buộc; việc hình thái thì bấm lightbulb → **Refactor…**

```prompt
tách processCheckout() thành validate/process/save, giữ nguyên behavior, không thêm tính năng
```

- **Biến thể:** rename symbol / extract function → Code Actions của language service, không find-replace tay.
- **✅ Verify:** chạy full test liên quan (`npm test -- checkout`) — xanh **trước** và xanh **sau** là behavior còn nguyên.

## Liên quan

- Chưa có test bao thì viết trước: [tests](../tests/README.md) · Đổi tốc độ chứ không chỉ cấu trúc: [optimize](../optimize/README.md) · Refactor nhiều file: [agent-mode](../../model-agent/agent-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Quick fixes & refactorings](https://code.visualstudio.com/docs/editing/refactoring#code-actions-quick-fixes-and-refactorings) · [Refactor in reviewable steps](https://code.visualstudio.com/docs/agents/guides/refactor-safely#4-refactor-in-reviewable-steps)
