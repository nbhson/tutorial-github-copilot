# Telemetry (`settings.json` + env CLI) — Hai công tắc đừng lẫn: consent dữ liệu và OTel export

> **Harness:** Copilot · **Surface:** VS Code Settings / `settings.json` / Copilot CLI (env) · **Đọc:** ~3 phút

**Nôm na:** "Telemetry" ở Copilot có hai tầng: **consent** (máy này có được gửi dữ liệu giúp cải thiện sản phẩm không — GitHub hỏi bạn một lần trong Settings) và **OTel export** (bạn tự bật để phiên agent đổ trace/metric về backend giám sát của *chính mình*). Hợp khi onboard máy công ty, trả lời audit quyền riêng tư, hoặc admin muốn soi từng phiên agent.

## Vì sao dùng?

Tầng consent là câu hỏi đầu tiên khi onboard máy công ty và khi làm audit; nhầm nó với train là trả lời sai audit. Tầng OTel là câu hỏi của admin: "model nào đang ngốn token, tool nào chạy lúc nào?" — không có export thì chỉ thấy dashboard chung. OTel chạy cho **cả** Local lẫn Copilot harness; org policy có thể đè setting cá nhân, nên đổi local trên máy công ty rồi tưởng đã đổi là bẫy phổ biến.

| Khái niệm hay bị lẫn | Là gì | Khi nào đụng tới |
|---|---|---|
| Telemetry (consent) | đồng ý gửi dữ liệu để cải thiện sản phẩm | onboard máy, audit quyền riêng tư |
| Train (training) | code của bạn có bị dùng huấn luyện model không | câu "code có bị train không" |
| Duplication | kiểm tra trùng với code public | lo license/copyright khi code trùng |
| OTel export | tự đổ trace/metric phiên agent về backend của bạn | admin muốn soi từng phiên, từng model |

**Nếu làm sai:** "tắt telemetry rồi, thế là code không bị train" là sai hoàn toàn — đó là hai setting khác nhau; và bật `captureContent: true` đổ cả prompt/response về collector công cộng là tự mở thêm đường rò rỉ — camera chiếu về đâu còn quan trọng hơn việc nó bật hay tắt.

## Cách dùng

Không phải slash command — consent xem trong Settings (search "telemetry" / "copilot data"); OTel cấu hình trong `settings.json` (6 tham số `github.copilot.chat.otel.*`):

```jsonc
"github.copilot.chat.otel.enabled": true,
"github.copilot.chat.otel.exporterType": "console",  // otlp-http | otlp-grpc | console | file
"github.copilot.chat.otel.captureContent": false     // BẬT = cả prompt/response về backend
```

- **Biến thể:** CLI không cần collector — env `COPILOT_OTEL_ENABLED=true` + `COPILOT_OTEL_FILE_EXPORTER_PATH=<đường-dẫn-file>`; chưa có collector thì dùng `console`/`file` trước.
- **Setting:** còn `otlpEndpoint`, `captureIdentity`, `maxAttributeSizeChars`; máy công ty hỏi admin về policy org trước khi đổi local — policy thường đè, đổi xong không ăn.
- **✅ Verify:** chụp trạng thái consent kèm ngày nộp audit; tắt `enabled` (hoặc unset env) rồi chạy lại một phiên — file export **không tăng thêm** là đúng "công tắc".

## Liên quan

- Máy đang ở plan/model nào (không phải telemetry): [status](../status/README.md) · Credits: [ai-credits](../../model-agent/ai-credits/README.md) · Bài chủ: [13-code-intelligence-indexing-telemetry.md](../../../../13-code-intelligence-indexing-telemetry.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Telemetry in VS Code](https://code.visualstudio.com/docs/configure/telemetry) · [VS Code Docs — Enable OTel monitoring](https://code.visualstudio.com/docs/agents/guides/monitoring-agents#enable-otel-monitoring)
