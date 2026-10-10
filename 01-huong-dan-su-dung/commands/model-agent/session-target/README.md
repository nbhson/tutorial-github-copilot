# Session Target — Chọn harness + nơi agent chạy (Local / Copilot / Cloud)

> **Dành cho:** người muốn agent chạy nền/nhiều phiên hoặc giao hẳn task lên cloud · **Vấn đề:** tưởng đổi model là đủ, không biết "nơi chạy" cũng đổi tool + quyền · **Đọc xong:** chọn đúng Local / Copilot / Cloud cho từng việc, biết handoff giữ context (~3 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: công tắc chọn "đội thợ + nhà xưởng" — Local làm ngay trong VS Code, Copilot chạy nền trên Agent Host, Cloud giao cho nhà máy ở xa mở PR. Ở đáy khung Chat → **Session Target** → chọn target (Local / Copilot / Cloud / Claude / Codex...).

## Khi nào dùng

Section này trả lời: việc nào để Local, việc nào đẩy Copilot (background), việc nào giao Cloud.

- **Cho ai:** người muốn chạy nhiều agent song song, hoặc giao task async nhận PR.
- Việc tay chân cần tool VS Code / extension / model cấu hình trong VS Code → **Local**.
- Việc coding chạy nền, nhiều phiên song song, mở lại ở cửa sổ khác → **Copilot**.
- Task gọn, giao hẳn để nhận PR cho team review → **Cloud**.
- Đã quen workflow Claude/Codex → chọn harness provider tương ứng.

## Cách gọi (copy-paste)

Cách gọi `Session Target` — làm đúng theo khối dưới đây, kèm câu kiểm tra có ở máy bạn hay không:

```bash
# VS Code: đáy khung Chat → Session Target → chọn target
# Local / Copilot / Cloud / Claude / Codex... + "Learn about harnesses..."
# Copilot session → /delegate  (đẩy task sang Cloud, mở PR)
# Kỳ vọng: session hiện đúng ở Agent Sessions sidebar; Cloud trả về 1 PR
# Verify: Local sửa ngay trong editor; Cloud xong thì có PR mới trên GitHub
```

> Kiểm tra có khả dụng ở máy bạn không: đáy khung Chat có thanh `Session Target`? Không thấy `Copilot`/`Cloud` → chưa đăng nhập GitHub, thiếu extension, hoặc org policy chặn — đọc `/status` + plan trước khi kết luận bug. Chi tiết: [bài 10 mục 3.3](../../../10-modes-permissions-availability.md).

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `Session Target` — đổi phần tên file/task cho đúng việc của bạn:

```bash
# Local: "sửa src/auth/login.ts, chạy npm test ngay trong editor"
# Copilot: "refactor module payments + chạy test" (chạy nền, mở lại ở cửa sổ khác)
# Cloud: "thêm endpoint /healthz + test" → chọn Cloud → agent mở PR
```

**Kết quả mong đợi:** Local sửa ngay trong workspace; Copilot chạy nền + xuất hiện ở Agent Sessions sidebar; Cloud trả về 1 PR trên GitHub.

**Cách verify:** session hiện đúng ở Agent Sessions sidebar đúng target; Cloud xong thì có PR mới là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy Copilot/Cloud trong list | Chưa đăng nhập / thiếu extension / policy | Đăng nhập GitHub, cài extension, hỏi admin xem policy `ChatEditorPreferCopilotHarness` |
| Đổi target xong mất ngữ cảnh | Tưởng là "new chat" | Dùng **Handoff** (chỉ khởi tạo từ session Local) để mang history + context |
| Cloud không thấy tool quen dùng | Cloud dùng tool/model của service | Task cần tool VS Code/extension → ở lại Local/Copilot; giao Cloud task gọn, độc lập |
| Tưởng đổi target = đổi model | Nhầm harness với model | Model đổi ở model picker; target đổi "nơi chạy + tay chân" |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Lý thuyết + so sánh harness: [10-modes-permissions-availability.md mục 3.3](../../../10-modes-permissions-availability.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _Local để làm tay, Copilot để chạy nền, Cloud để giao hẳn — nhớ Handoff để mang context theo._
