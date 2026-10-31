# /logout — Đăng xuất, xóa credentials

> **Dành cho:** người dùng máy chung / máy mượn · **Vấn đề:** credentials kẹt lại trên máy lạ sau khi trả · **Đọc xong:** xóa sạch credentials local và tự verify đã signed-out (~2 phút)

## 1 câu nôm na

`/logout` giống như trả thẻ nhân viên và lau sạch dấu vân tay khỏi máy lạ trước khi rời đi. Lệnh này xóa credentials local; khi cần dùng lại thì `/login` sau. Nhớ kỹ: tắt extension **không phải** là logout — tắt chỉ ẩn đi, credentials vẫn nằm trên máy.

## Vì sao dùng /logout?

Vì credentials đăng nhập của bạn là thứ phải dọn sạch khi bạn không còn là người dùng hợp lệ của máy đó nữa. Trên máy chung, máy mượn, hay máy để lại cho người khác, quên `/logout` đồng nghĩa với việc người kế tiếp có thể dùng account của bạn.

**Nếu làm sai thì sao?** Người tiếp theo mở VS Code là vào thẳng account của bạn, dùng quota/policy của bạn. Nếu chỉ tắt extension để "che", credentials vẫn ở OS keychain — bất kỳ ai bật lại extension đều dùng được.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** dùng máy chung/máy mượn; đổi account; nghi credentials kẹt hoặc lỗi.
- **Cho ai:** ai xài máy chung/mượn, người đổi account công ty ↔ cá nhân.
- **ĐỪNG nhầm với:** tắt extension (không xóa credentials). Muốn sạch hẳn thì phải `/logout`; muốn dùng lại thì `/login`.

## Cách gọi (copy-paste)

```bash
/logout
# xong /login lại nếu cần
# Kỳ vọng: credentials local sạch, máy không còn vào được account bạn
# Verify: /status báo signed-out
```

> Gõ `/` trong Chat để kiểm tra `/logout` có trong list không. Không thấy thì xem plan/model trước khi kết luận là bug.

## Ví dụ thật

Nghiệp vụ: bạn mượn laptop của đồng nghiệp để demo, xong việc phải trả lại sạch sẽ.

```bash
# 1. /logout trên máy mượn
# 2. /status → xác nhận máy báo chưa login
# 3. Xóa thêm token trong biến môi trường nếu có, rồi trả máy
```

**Kết quả mong đợi:** Credentials local sạch; máy không còn vào được account của bạn.

**✅ Verify:** `/status` báo signed-out là đạt. Nếu vẫn còn login thì xóa credentials trong OS keychain rồi kiểm lại.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ SAI: "Tôi tắt extension rồi, coi như logout." → Không; credentials vẫn nằm trong OS keychain, bật lại là vào được.

✅ ĐÚNG: `/logout` → `/status` xác nhận signed-out → nếu cần thì xóa token env + credentials keychain → trả máy.

**Bài học:** "không thấy thông báo đăng nhập" khác với "đã đăng xuất". Chỉ `/status` báo signed-out mới chứng minh là sạch.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Quên logout máy chung | Vội trả máy | Checklist trả máy: `/logout` + xóa token env |
| Logout rồi login vẫn lỗi | Cache token kẹt | Xóa credentials trong OS keychain + login lại |
| Nhầm logout với tắt extension | Tắt extension ≠ logout | Muốn sạch hẳn thì `/logout` |

## So sánh với Claude Code

| Việc | Copilot (`/logout`) | Claude Code | Ghi chú |
|---|---|---|---|
| Đăng xuất / xóa credentials | Slash `/logout` xóa credentials local | Xóa API key/account trong config hoặc biến môi trường | Cùng mục đích dọn sạch; cách gọi khác nhau |
| Xác nhận đã đăng xuất | `/status` báo signed-out | Chạy thử một prompt để thấy bị chặn | Bạn vẫn phải tự verify |
| Dùng trên máy chung | `/logout` trước khi trả máy | Xóa key/account trước khi trả | Cùng nguyên tắc: dọn sạch trước khi rời |

## Best practices (kèm "vì sao")

- **Đưa `/logout` vào checklist trả máy.** *Vì sao?* Lúc vội nhất là lúc dễ quên nhất — có checklist thì không sót.
- **Verify bằng `/status` sau khi logout.** *Vì sao?* "Đã bấm logout" chưa chứng minh là credentials đã sạch; đọc trạng thái mới chắc.
- **Nghi keychain kẹt thì xóa cả credentials OS.** *Vì sao?* Token còn cache làm login lại vẫn dính account cũ.
- **Đừng chỉ tắt extension rồi coi là xong.** *Vì sao?* Tắt chỉ ẩn; credentials vẫn nằm trên máy cho người sau dùng.

## Bài tập nhỏ

1. **(5 phút)** Trên máy bạn đang dùng, chạy `/logout` rồi `/status` xem trạng thái; sau đó `/login` lại và so sánh.
2. **(10 phút)** Lập checklist 3 bước "trả máy" cho team (logout + xác nhận signed-out + xóa token env) và thử áp dụng một lần.

## Tham khảo

- Index nhóm: [../README.md](../README.md).
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Đăng nhập lại sau khi logout: [../login/README.md](../login/README.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Chốt: `/logout` là nghi thức bắt buộc khi rời máy không phải của bạn — tắt extension không thay được nó, chỉ `/status` báo signed-out mới là bằng chứng.
