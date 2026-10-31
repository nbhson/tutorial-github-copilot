# /feedback + /bug — Gửi feedback/bug cho GitHub

> **Dành cho:** người gặp bug lặp lại được hoặc có góp ý cho GitHub · **Vấn đề:** báo "nó dở" chung chung thì GitHub không xử lý được · **Đọc xong:** gửi bug/feedback đủ context: prompt + version + bước lặp (~2 phút)

## 1 câu nôm na

Hai lệnh này là kênh gửi ý kiến lên "ban quản lý" Copilot. `/feedback` để bạn bỏ phiếu tốt/xấu kèm lý do cho một câu trả lời; `/bug` để báo hỏng hóc kèm mô tả + bước lặp + version. Một điều bắt buộc trước khi gửi: soát secrets, đừng để lộ token trong log bạn dán vào.

## Vì sao dùng /feedback + /bug?

Vì GitHub chỉ sửa được cái nó tái hiện được. Một câu "Copilot dở" không giúp ích gì; còn "`/tests` sinh import sai, lặp lại bằng cách bôi đen hàm X rồi gọi `/tests`, extension 1.2.3" thì họ có thể đóng bug hoặc fix. `/feedback` nhanh, dùng cho việc nhẹ (vote + lý do); `/bug` dùng khi cần người ta tái hiện chính xác.

**Nếu làm sai thì sao?** Báo thiếu bước lặp → bị đóng là "không tái hiện được". Báo nhầm do lỗi scope của bạn → mất thời gian cả hai bên. Dán log có secrets → rò rỉ thông tin. Cả ba đều tránh được bằng vài thao tác nhỏ.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** thấy câu trả lời hay/dở muốn vote (`/feedback`); gặp bug lặp lại được (`/bug`); muốn đề xuất cải thiện tính năng.
- **Cho ai:** mọi người dùng Copilot, nhất là người đang test tính năng mới.
- **ĐỪNG báo bug khi:** nguyên nhân là scope/prompt của bạn chưa đúng. Gọn scope và thử lại trước; nếu vẫn lỗi một cách lặp lại được thì mới báo.

> `/feedback` khác `/bug` ở chỗ gửi gì:

| Lệnh | Gửi gì | Khi nào dùng |
|---|---|---|
| `/feedback` | Vote tốt/xấu + lý do | Câu trả lời hay/dở, muốn góp ý nhanh |
| `/bug` | Mô tả + bước lặp + version | Bug lặp lại được, cần GitHub tái hiện |

## Cách gọi (copy-paste)

```bash
/feedback tốt/xấu + lý do
/bug “mô tả + bước lặp + version”
# Kỳ vọng: GitHub nhận đủ context để tái hiện bug
# Verify: nhận được confirm/tham chiếu issue
```

> Gõ `/` trong Chat để kiểm tra `/feedback` và `/bug` có trong list không. Không thấy thì xem plan/model trước khi kết luận là bug.

## Ví dụ thật

Nghiệp vụ: `/tests` sinh ra import sai mỗi lần bạn bôi đen hàm X, và bạn lặp lại được đều đặn.

```bash
/bug “/tests sinh sai import. Bước lặp: bôi đen hàm X → gọi /tests.
Kỳ vọng: import đúng theo mẫu repo. Thực tế: import sai path.
Version: ext 1.2.3, VS Code 1.8x”
```

**Kết quả mong đợi:** Bug có đủ context (prompt + version + bước lặp) để GitHub tái hiện; bạn nhận được xác nhận/issue tham chiếu.

**✅ Verify:** Nhận được confirm hoặc issue tham chiếu là đạt. Nếu bị hỏi lại "lặp thế nào" thì phần bước lặp của bạn chưa đủ rõ.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ SAI: `/bug "Copilot dở quá"` → không mô tả, không bước lặp, không version; GitHub không thể làm gì.

✅ ĐÚNG: `/bug "mô tả ngắn: /tests sai import; bước lặp: bôi đen hàm X → /tests; kỳ vọng/ thực tế; version ext + VS Code"`.

**Bài học:** càng tái hiện được thì bug càng mau được xử lý. Bước lặp + version là hai phần không được thiếu.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Bug bị đóng "không tái hiện được" | Thiếu bước lặp | Kèm prompt + file + version + ảnh/log |
| Báo nhầm do scope mình sai | Chưa kiểm tra scope | Gọn scope + thử lại trước khi báo |
| Gửi feedback có secrets | Dán log chứa token | Soát secrets trước khi gửi |

## So sánh với Claude Code

| Việc | Copilot (`/feedback` + `/bug`) | Claude Code | Ghi chú |
|---|---|---|---|
| Báo bug / góp ý trong sản phẩm | Slash command có sẵn `/feedback` và `/bug` | Báo qua kênh GitHub/issue của Anthropic, không có slash riêng | Cùng mục đích, khác đường vào |
| Gửi kèm context | Form bắt mô tả + bước lặp + version | Tùy kênh, thường bạn tự soạn issue | Cùng nguyên tắc "tái hiện được mới xử được" |
| Soát secrets | Bạn tự soát log trước khi gửi | Bạn tự soát | Không công cụ nào tự bảo vệ secret của bạn |

## Best practices (kèm "vì sao")

- **Luôn kèm bước lặp + version.** *Vì sao?* Không có chúng thì bug dễ bị đóng là "không tái hiện được".
- **Dùng `/feedback` cho việc nhẹ, `/bug` cho việc cần tái hiện.** *Vì sao?* Đúng kênh thì đúng người xử lý, không tốn công cả hai bên.
- **Soát secrets trước khi dán log.** *Vì sao?* Log dễ chứa token; gửi đi là rò rỉ vĩnh viễn.
- **Chưa chắc là bug thì thử lại với scope gọn.** *Vì sao?* Phần lớn "bug" là do scope/prompt — loại trừ trước khi phiền GitHub.

## Bài tập nhỏ

1. **(5 phút)** Viết một `/bug` giả cho lỗi bạn từng gặp, đủ 3 phần: mô tả, bước lặp, version. Đọc lại xem người khác có tái hiện được không.
2. **(10 phút)** Lấy một câu trả lời gần đây, gửi `/feedback` kèm lý do cụ thể (đúng chỗ nào / thiếu chỗ nào).

## Tham khảo

- Index nhóm: [../README.md](../README.md).
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kiểm tra trạng thái trước khi báo bug: [../status/README.md](../status/README.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Chốt: `/bug` mạnh ở chỗ tái hiện được, `/feedback` mạnh ở chỗ nêu lý do — báo thiếu bước lặp thì bạn chỉ đang kể lể, không phải đang giúp ai sửa.
