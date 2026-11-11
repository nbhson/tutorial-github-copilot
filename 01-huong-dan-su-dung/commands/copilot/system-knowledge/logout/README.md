# /logout — Đăng xuất, xóa credentials

> **Dành cho:** người dùng máy chung / máy mượn · **Vấn đề:** credentials kẹt lại trên máy lạ sau khi trả · **Đọc xong:** xóa sạch credentials local và verify đã signed-out (~2 phút)
> **Harness:** Copilot · **Surface:** Copilot CLI / VS Code Chat (Copilot harness)

## 1 câu nôm na

`/logout` (Copilot CLI) giống trả thẻ nhân viên và lau dấu vân tay khỏi máy lạ trước khi rời đi: lệnh xóa credentials local, khi cần thì login lại. Ở VS Code, thoát tài khoản bằng mục Account / icon Copilot → **Sign out**.

> **Nhớ kỹ:** tắt extension **không phải** logout — tắt chỉ ẩn đi, credentials vẫn nằm trong OS keychain.

## Vì sao phải logout?

Vì credentials của bạn là thứ phải dọn sạch khi bạn không còn là người dùng hợp lệ của máy đó: trên máy chung/máy mượn, quên logout đồng nghĩa người kế tiếp dùng được account của bạn — quota và policy của bạn.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** dùng máy chung/máy mượn; đổi account; nghi credentials kẹt.
- **ĐỪNG nhầm với:** tắt extension — nó không xóa credentials.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

## Ví dụ thật

Nghiệp vụ: bạn mượn laptop đồng nghiệp để demo, xong việc phải trả lại sạch sẽ.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**✅ Verify:** `/user show` (CLI) hoặc Copilot status dashboard (VS Code) báo chưa đăng nhập là đạt. Vẫn còn login → xóa credentials trong OS keychain rồi kiểm lại.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ SAI: "Tôi tắt extension rồi, coi như logout." → Không; credentials vẫn trong keychain, bật lại là vào được.

✅ ĐÚNG: logout → kiểm trạng thái báo signed-out → nếu cần xóa token env + credentials keychain → trả máy.

**Bài học:** "không thấy thông báo đăng nhập" khác với "đã đăng xuất". Chỉ trạng thái báo signed-out mới chứng minh là sạch.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Quên logout máy chung | Vội trả máy | Checklist trả máy: logout + xóa token env |
| Logout rồi login vẫn lỗi | Cache token kẹt | Xóa credentials trong OS keychain + login lại |

## So sánh với Claude Code

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Đăng xuất / xóa credentials | `/logout` (CLI) · Sign out (VS Code) | Xóa API key/account trong config hoặc biến môi trường | Cùng mục đích dọn sạch, khác đường vào |

## Best practices (kèm "vì sao")

- **Đưa logout vào checklist trả máy.** *Vì sao?* Lúc vội nhất là lúc dễ quên nhất — có checklist thì không sót.
- **Verify trạng thái + nghi keychain kẹt thì xóa cả credentials OS.** *Vì sao?* "Đã bấm logout" chưa chứng minh credentials đã sạch; token còn cache làm login lại dính account cũ.

## Bài tập nhỏ

1. **(5 phút)** Trên máy đang dùng: logout → kiểm trạng thái → login lại, ghi lại khác biệt.
2. **(10 phút)** Lập checklist 3 bước "trả máy" cho team: logout + xác nhận signed-out + xóa token env.

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Login lại: [../login/README.md](../login/README.md) · Trạng thái: [../status/README.md](../status/README.md).
- Cheatsheet: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- GitHub — [CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference) · VS Code — [Set up Copilot](https://code.visualstudio.com/docs/setup/copilot).

> Trả máy mà không logout thì như trả phòng khách sạn mà quên rút thẻ khỏi két — người kế tiếp mở được mọi thứ của bạn.
