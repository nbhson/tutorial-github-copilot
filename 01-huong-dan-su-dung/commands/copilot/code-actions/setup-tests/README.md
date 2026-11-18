# /setupTests — chọn & dựng khung test framework theo stack repo (Experimental)

> **Harness:** Copilot · **Surface:** Chat view — `/setupTests` gắn nhãn **Experimental** trong cheat sheet ("Get help choosing and setting up a test framework"); không có ở CLI · **Đọc:** ~2 phút

**Nôm na:** Gọi thợ điện đến xem nhà: lệnh đọc stack repo (ngôn ngữ, framework, cấu trúc thư mục) rồi đề xuất framework kèm config chạy được, và nếu bạn duyệt thì tự dựng khung. Hợp khi repo **chưa có test** — muốn chốt nền móng trước khi ai đó viết test case đầu tiên.

## Vì sao dùng?

Repo chưa test có một bài toán gài sẵn: **chọn framework sai ở bước 0 thì mọi test sau đều phải đập đi làm lại**. `/setupTests` biến quyết định đó thành cuộc đối thoại có bạn duyệt — nó đọc stack rồi hỏi lại, thay vì bạn tự mò; đọc đề xuất của nó còn là cách học nhanh những gì cần cân nhắc (hỗ trợ ngôn ngữ, phong cách test, toolchain sẵn có). Đừng coi nó như máy sinh code đã xong việc: bản setup chưa từng chạy thử trong repo của bạn, có thể kéo thêm transitive dependencies hoặc config đè lên file đang sửa.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy `/setupTests` trong list `/` | Experimental / surface không hỗ trợ | Gõ `/` trên máy thật, thử Chat view ở Copilot harness |
| Đề xuất framework lệch stack | Thiếu ngữ cảnh về repo | Gắn `#file` cấu hình build (hoặc `@workspace`) rồi gọi lại |
| Config đè file có sẵn | Accept mà không review diff | Mở từng file trong diff trước khi Accept |

**Nếu làm sai:** dùng lệnh này trên repo đã có framework chạy ổn chỉ sinh thêm config lạ — việc đó là của [`/tests`](../tests/README.md); và accept rồi commit mà chưa chạy test nào thì bạn vừa "có test" trên danh nghĩa.

## Cách dùng

Gõ trong Chat view ở repo chưa có test, nêu stack nếu bạn đã có sẵn câu hỏi:

```prompt
/setupTests chọn cho repo Node + TypeScript này, ưu tiên Jest hay Vitest?
```

- **Biến thể:** `/setupTests` trần — Copilot tự đọc stack, hỏi lại mức phủ mong muốn rồi đề xuất framework (vd pytest + cấu trúc `tests/` + `pytest.ini`) trước khi tạo file.
- **✅ Verify:** chạy đúng lệnh test nó cài, thấy **ít nhất 1 test pass**, và diff không đè file có sẵn.

## Liên quan

- Dựng xong nền thì xây tường: [tests](../tests/README.md) · Đóng gói quy ước test của team thành agent: [custom-agent](../../model-agent/custom-agent/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [Unit testing with Copilot](https://code.visualstudio.com/docs/agents/guides/unit-testing-with-copilot)
