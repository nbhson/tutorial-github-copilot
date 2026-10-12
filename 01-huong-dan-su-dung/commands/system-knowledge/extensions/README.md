# /extensions — Quản lý Copilot Extensions đã cài

> **Dành cho:** dev cài/dọn Copilot Extensions · **Vấn đề:** hai extension đè nhau, hoặc extension cũ sau khi update IDE · **Đọc xong:** biết đã cài gì, cái nào active, gỡ đúng cái thừa (~2 phút)

## 1 câu nôm na

`/extensions` như mở kho ứng dụng trên máy: xem đã cài gì, cái nào đang chạy, cái nào thừa thì gỡ. Bạn có thể gọi `/extensions`, hoặc mở `Ctrl+Shift+X` rồi search “Copilot” để thấy danh sách ngay trong editor.

## Vì sao dùng /extensions?

Extension là thứ dễ “mọc thêm” mà không ai nhớ: cài theo docs team, rồi update IDE, rồi thử một cái lạ — để lại hai cái cùng chức năng tranh nhau. `/extensions` giúp bạn nhìn lại đúng những gì đang có để dọn, tránh xung đột và tránh giữ thứ không rõ nguồn.

**Nếu bỏ qua thì sao?** Hai extension cùng vai sẽ đè nhau (chat/inline hành xử thất thường), bạn lại đi nghi model, trong khi thủ phạm là cái extension cũ chưa gỡ sau khi update IDE.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** cài extension mới theo docs team; nghi hai extension xung đột; dọn extension cũ sau khi update IDE.
- **ĐỪNG dùng khi:** vấn đề của bạn là MCP server (dùng `/mcp`) hay quyền/plan (`/status`) — extension không liên quan tới hai việc đó.

## Cách gọi (copy-paste)

```bash
/extensions
# hoặc: Ctrl+Shift+X → search "Copilot"
# Kỳ vọng: list đã cài/active rõ ràng, không còn extension thừa
# Verify: chat/inline chạy ổn sau khi dọn
```

> Không thấy `/extensions` trong list khi gõ `/`? Kiểm `/status` + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: sau khi update IDE, chat Copilot bỗng hành xử lạ. Bạn nghi có hai extension cùng chức năng đang tranh nhau.

```bash
/extensions "liệt kê extensions Copilot đã cài + cái nào đang active"

# Đọc kết quả: thấy 2 mục Copilot Chat (một cái là tàn dư của bản cũ).
# → Giữ 1, disable cái còn lại → reload window → thử lại chat.
```

**Kết quả mong đợi:** biết list đã cài/active; gỡ hoặc bật đúng cái cần; hết xung đột.

**✅ Verify:** chat/inline chạy ổn sau khi dọn là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — cài chồng extension cùng chức năng rồi để nguyên:**

```text
Vừa có bản Copilot mới vừa còn bản cũ → 2 extension tranh nhau
→ chat trả lời thất thường, bạn đổ lỗi cho model.
```

**✅ ĐÚNG — giữ một, disable phần còn lại rồi test:**

```text
/extensions → thấy trùng → disable cái cũ → reload → test lại chat.
```

**Bài học:** khi Copilot hành xử lạ ngay sau khi bạn cài/update, nghi **môi trường (extension)** trước khi nghi model.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| 2 extensions đè nhau | Cài trùng chức năng | Giữ 1, disable cái kia rồi test lại |
| Extension cũ sau update IDE | Quên update theo | Update IDE → update extensions → reload |
| Cài extension lạ không rõ nguồn | Nghe đồn hay | Chỉ cài từ Marketplace/docs chính thức; kiểm tra trước |

## So sánh với Claude Code

| Việc | Copilot (`/extensions`) | Claude Code | Ghi chú |
|---|---|---|---|
| Copilot Extensions (GitHub App, gọi qua `@`) | Có — cài/quản lý qua GitHub + VS Code | Tương đương gần nhất là plugin/marketplace | Cùng tư tưởng “1 gói dùng chung”; khác cơ chế phân phối |
| VS Code extension (đồ nghề editor) | Có (`Ctrl+Shift+X`) | Không có tương đương trực tiếp (terminal-first) | Copilot gắn chặt editor; Claude Code không quản extension editor |
| Đóng gói share team | Extension pack + `.vscode/extensions.json` | Plugin (`.claude-plugin/` + marketplace) | Cả hai đều có cơ chế đóng gói để share |

## Best practices (kèm "vì sao")

- **Chỉ cài từ Marketplace/docs chính thức.** *Vì sao?* Extension không rõ nguồn là rủi ro bảo mật và dễ gây hành vi lạ mà bạn tưởng là lỗi model.
- **Update IDE xong thì update extension rồi reload.** *Vì sao?* Lệch phiên bản giữa IDE và extension là nguồn lỗi im lặng.
- **Một vai một extension.** *Vì sao?* Hai cái cùng vai sẽ tranh nhau, làm hành vi thất thường.
- **Ghi extension team cần vào `.vscode/extensions.json`.** *Vì sao?* Onboarding chỉ còn “Install Recommended”, không phải nhớ từng cái.
- **Dọn định kỳ.** *Vì sao?* Extension thừa vừa làm chậm editor vừa tăng bề mặt lỗi.

## Bài tập nhỏ

1. **(5 phút)** Liệt kê extension Copilot đã cài; ghi lại con số và cái nào đang `active`.
2. **(10 phút)** Tìm một cặp trùng chức năng (nếu có), disable một cái rồi test lại chat/inline.
3. **(10 phút)** Thêm 3 extension team thật sự cần vào `.vscode/extensions.json` để người sau cài một phát.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh System & Knowledge.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Phân biệt 2 loại extension và khi nào cần đóng gói: [bài 09 — Extensions & Marketplaces](../../../09-extensions-marketplaces.md).

> **Chốt:** trước khi đổ lỗi cho model, dành 30 giây xem `/extensions` — phần lớn “Copilot dở” sau khi cài/update là do extension cũ chưa được dọn.
