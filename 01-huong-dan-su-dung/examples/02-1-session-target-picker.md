# 02-1 — Bài tập: chụp 2 trạng thái picker Session Target

> File này là **giấy làm bài** của bạn (bài 02 §3 + §7 bài tập 1), không phải mẫu nội dung.
> Mục đích: nhìn tận mắt picker trả lời 2 câu hỏi — "xe + tài xế nào" (harness) và "chạy ở đâu" (execution target).

## Cách lấy 2 trạng thái (60 giây)

1. Mở Chat view trong VS Code (repo thật), ô input có dropdown **Session Target** (cạnh picker model/agent).
2. **Trạng thái 1 — Copilot:** chọn `Copilot`; nếu panel hiện thêm **Local/Copilot + execution target** (máy bạn / cloud), chụp nguyên hàng picker.
3. **Trạng thái 2 — Local:** chuyển sang `Local` (extension host); chụp lại đúng vùng đó.
4. So sánh: tên harness khác nhau ở chỗ nào, execution target đổi theo ra sao.

## Khung giải thích (viết ≤ 3 câu vào chỗ trống)

- Câu 1 — khác nhau về **nơi chạy**: ______________________________________________
  (gợi ý: Copilot harness = Agent Host, session chạy nền, tiếp nối giữa surface; Local = extension host, đóng cửa sổ là agent dừng)
- Câu 2 — khác nhau về **file config đọc**: .mcp.json + ~/.copilot/mcp-config.json (Copilot) vs .vscode/mcp.json (Local)
  ______________________________________________________________________________
- Câu 3 — **cloud không phải harness**: ____________________________________________________________________
  (gợi ý: cloud là execution target chạy Copilot harness — feature `cloud-sessions`)

## Verify (30 giây)

- [ ] Hai ảnh chụp thấy rõ tên harness ở cùng một vị trí picker.
- [ ] Câu 2 của bạn nêu đúng **hai** đường dẫn file khác harness.
- [ ] Không có câu nào gọi Cloud là "harness thứ 5".
