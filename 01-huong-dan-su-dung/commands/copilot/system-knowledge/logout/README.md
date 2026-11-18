# /logout — Đăng xuất, xóa credentials local khỏi máy

> **Harness:** Copilot · **Surface:** Copilot CLI / VS Code Chat (Copilot harness) · **Đọc:** ~2 phút

**Nôm na:** Trả thẻ nhân viên và lau dấu vân tay khỏi máy lạ trước khi rời đi: lệnh xóa credentials local, khi cần thì login lại. Hợp khi dùng máy chung/máy mượn — người kế tiếp không được phép dùng account của bạn.

## Vì sao dùng?

Credentials của bạn là thứ phải dọn sạch khi bạn không còn là người dùng hợp lệ của máy đó: trên máy chung, quên logout đồng nghĩa người kế tiếp chạy việc bằng quota và policy của bạn. Hai phân biệt sống còn: **tắt extension không phải logout** — nó chỉ ẩn Copilot đi, credentials vẫn nằm nguyên trong OS keychain, bật lại là vào được; và "không thấy thông báo đăng nhập" khác "đã đăng xuất" — chỉ trạng thái báo signed-out mới chứng minh máy đã sạch.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tắt extension rồi, tưởng đã logout | extension chỉ ẩn UI | logout thật → verify trạng thái signed-out |
| Logout rồi login vẫn ra account cũ | cache token kẹt | xóa credentials trong OS keychain + token env, login lại |
| Trả máy vội, quên logout | không có checklist | checklist 3 bước: logout → xác nhận signed-out → xóa token env |

**Nếu làm sai:** credentials kẹt lại trên máy lạ là cửa sau cho người tiếp theo — lúc vội nhất là lúc dễ quên nhất, nên logout phải nằm trong checklist trả máy, không phải trong trí nhớ.

## Cách dùng

Gõ trong Copilot CLI; ở VS Code dùng menu Account / icon Copilot → **Sign out**:

```prompt
/logout
/user show   # kiểm lại: máy phải báo chưa đăng nhập
```

- **Biến thể:** đổi account giữa đường thì logout trước rồi [login](../login/README.md) lại — đừng login chồng lên cache cũ.
- **✅ Verify:** `/user show` (CLI) hoặc status dashboard (VS Code) báo chưa đăng nhập là đạt — vẫn còn login thì xóa thêm credentials keychain rồi kiểm lại.

## Liên quan

- Login lại: [login](../login/README.md) · Trạng thái: [status](../status/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Remove AI features from VS Code](https://code.visualstudio.com/docs/setup/copilot#remove-ai-features-from-vs-code) · [GitHub Docs — CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
