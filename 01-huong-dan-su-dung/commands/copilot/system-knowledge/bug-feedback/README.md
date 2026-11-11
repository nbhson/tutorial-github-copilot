# Feedback & bug — Báo cho GitHub đủ context để sửa

> **Dành cho:** người gặp bug lặp lại được hoặc có góp ý cho GitHub · **Vấn đề:** báo "nó dở" chung chung thì GitHub không xử lý được · **Đọc xong:** gửi bug/feedback đủ context: prompt + version + bước lặp (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI / GitHub.com

## 1 câu nôm na

Kênh gửi ý kiến lên "ban quản lý" Copilot: vote tốt/xấu cho một câu trả lời, hoặc báo hỏng kèm mô tả + bước lặp + version. **Ba đường vào theo ba surface** — không có một nút "báo bug" chung cho mọi nơi:

| Surface | Cách gửi | Dùng khi |
|---|---|---|
| VS Code Chat (Copilot harness) | lệnh palette **`Chat: Provide Feedback`**, hoặc thumbs up/down trên message | góp ý cho câu trả lời/chat ngay trong editor |
| Copilot CLI | `/feedback`, `/bug` (docs CLI: "Provide feedback about the CLI") | bug của chính Copilot CLI |
| GitHub.com | mở issue ở repo liên quan (`microsoft/vscode-copilot-release` cho Copilot trong VS Code) hoặc `gh issue create` | bug cần thread để theo dõi, có ảnh/log |

Một điều bắt buộc trước khi gửi: soát secrets, đừng để lộ token trong log bạn dán vào.

## Vì sao phải báo đúng cách?

Vì GitHub chỉ sửa được cái nó tái hiện được. Một câu "Copilot dở" không giúp ích gì; còn "`/tests` sinh import sai, lặp lại bằng cách bôi đen hàm X rồi gọi `/tests`, extension 1.2.3" thì họ có thể đóng bug hoặc fix. Vote/góp ý nhanh đi kênh feedback; bug cần tái hiện chính xác đi kênh issue.

> **Tóm gọn 1 câu:** Báo lỗi kiểu "bệnh nhân đến khám" — kèm triệu chứng, cách gây lại bệnh và hồ sơ (version), bác sĩ mới chữa được.

**Nếu làm sai thì sao?** Báo thiếu bước lặp → bị đóng là "không tái hiện được". Báo nhầm do lỗi scope của bạn → mất thời gian cả hai bên. Dán log có secrets → rò rỉ thông tin. Cả ba đều tránh được bằng vài thao tác nhỏ.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** thấy câu trả lời hay/dở muốn vote; gặp bug lặp lại được; muốn đề xuất cải thiện tính năng.
- **ĐỪNG báo bug khi:** nguyên nhân là scope/prompt của bạn chưa đúng. Gọn scope và thử lại trước; nếu vẫn lỗi một cách lặp lại được thì mới báo.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Gõ `/` trong Chat view mà không thấy `/feedback`/`/bug`? Đúng rồi đấy — hai slash đó thuộc **Copilot CLI**. Trong VS Code hãy dùng `Chat: Provide Feedback` (F1 → gõ "feedback").

## Ví dụ thật

Nghiệp vụ: `/tests` sinh ra import sai mỗi lần bạn bôi đen hàm X, và bạn lặp lại được đều đặn.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** bug có đủ context (prompt + version + bước lặp) để GitHub tái hiện; bạn nhận được xác nhận/issue tham chiếu.

**✅ Verify:** nhận được confirm hoặc issue tham chiếu là đạt. Nếu bị hỏi lại "lặp thế nào" thì phần bước lặp của bạn chưa đủ rõ.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ SAI: "Copilot dở quá" → không mô tả, không bước lặp, không version; GitHub không thể làm gì.

✅ ĐÚNG: "mô tả ngắn: `/tests` sai import; bước lặp: bôi đen hàm X → `/tests`; kỳ vọng/thực tế; version extension + VS Code".

**Bài học:** càng tái hiện được thì bug càng mau được xử lý. Bước lặp + version là hai phần không được thiếu.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Bug bị đóng "không tái hiện được" | Thiếu bước lặp | Kèm prompt + file + version + ảnh/log |
| Báo nhầm do scope mình sai | Chưa kiểm tra scope | Gọn scope + thử lại trước khi báo |
| Gửi feedback có secrets | Dán log chứa token | Soát secrets trước khi gửi |
| Gửi xong không ai trả lời | Sai surface, sai repo | BUG CLI → `/bug`; Copilot VS Code → `microsoft/vscode-copilot-release` |

## So sánh với Claude Code

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Báo bug / góp ý trong sản phẩm | `Chat: Provide Feedback` (VS Code) · `/feedback` + `/bug` (CLI) · issue trên GitHub.com | `/bug` + `/feedback` trong CLI | Cùng ý tưởng "gửi từ trong công cụ", khác tên lệnh theo surface |
| Gửi kèm context | Form/issue yêu cầu mô tả + bước lặp + version | Tự soạn mô tả | Cùng nguyên tắc "tái hiện được mới xử được" |
| Soát secrets | Bạn tự soát log trước khi gửi | Bạn tự soát | Không công cụ nào tự bảo vệ secret của bạn |

## Best practices (kèm "vì sao")

- **Luôn kèm bước lặp + version.** *Vì sao?* Không có chúng thì bug dễ bị đóng là "không tái hiện được".
- **Chọn đúng surface cho đúng loại chuyện.** *Vì sao?* Vote chất lượng câu trả lời thì gửi feedback; bug cần người sửa thì mở issue — nhầm kênh là mất công cả hai bên.
- **Soát secrets trước khi dán log.** *Vì sao?* Log dễ chứa token; gửi đi là rò rỉ vĩnh viễn.
- **Chưa chắc là bug thì thử lại với scope gọn.** *Vì sao?* Phần lớn "bug" là do scope/prompt — loại trừ trước khi phiền GitHub.

## Bài tập nhỏ

1. **(5 phút)** Viết một bản báo cáo bug giả cho lỗi bạn từng gặp, đủ 3 phần: mô tả, bước lặp, version. Đọc lại xem người khác có tái hiện được không.
2. **(10 phút)** Lấy một câu trả lời gần đây, gửi feedback kèm lý do cụ thể (đúng chỗ nào / thiếu chỗ nào).

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Kiểm tra trạng thái/trước khi báo bug: [../status/README.md](../status/README.md) · Lệnh gây bug hay gặp: [../../code-actions/tests/README.md](../../code-actions/tests/README.md).
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- GitHub — [Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference) · VS Code — [Troubleshooting Copilot](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting).

> Bug mạnh ở chỗ tái hiện được, feedback mạnh ở chỗ nêu lý do — báo thiếu bước lặp thì bạn chỉ đang kể lể, không phải đang giúp ai sửa.
