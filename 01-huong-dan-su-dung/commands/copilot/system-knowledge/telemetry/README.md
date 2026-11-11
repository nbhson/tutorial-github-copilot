# Telemetry — Consent dữ liệu + OpenTelemetry export

> **Dành cho:** người onboard máy mới, người trả lời audit quyền riêng tư, admin muốn tự đo phiên agent · **Vấn đề:** nhầm telemetry với train, hoặc bật OTel mà lộ cả prompt · **Đọc xong:** đọc được trạng thái consent, cấu hình được 6 tham số OTel, biết OTel chạy cho cả hai harness (~3 phút)
> **Harness:** Copilot · **Surface:** VS Code Settings / `settings.json` / Copilot CLI (env)

## 1 câu nôm na

"Telemetry" ở Copilot có hai tầng đừng lẫn: **consent** (máy này có được gửi dữ liệu giúp cải thiện sản phẩm không — một mục trong Settings) và **OTel export** (bạn tự bật để phiên agent đổ trace/metric về backend giám sát của *chính mình*). Consent là công tắc GitHub hỏi bạn; OTel là cái camera bạn tự lắp cho team. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Vì sao phải quan tâm Telemetry?

Tầng consent là câu hỏi đầu tiên khi onboard máy công ty và khi làm audit quyền riêng tư; nhầm nó với train (code có bị dùng huấn luyện model không) hay duplication (lọc trùng code public) là trả lời sai audit. Tầng OTel là câu hỏi của admin: "model nào đang ngốn token, tool nào chạy lúc nào?" — không có export thì chỉ thấy dashboard chung, không truy được từng phiên. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** onboard máy mới/máy công ty; audit quyền riêng tư; team muốn tự giám sát phiên agent bằng backend riêng.
- **ĐỪNG nhầm với:** câu "code có bị train không" (đó là setting **train/opt-out**, xem [FAQ bảo mật – quyền riêng tư](../../../../../03-cau-hoi-thuong-gap/09-bao-mat-quyen-rieng-tu.md)); câu trùng code public (đó là **duplication filter**); câu máy đang ở plan/model nào (đó là **Copilot status dashboard**, xem [status](../status/README.md)).

> Phân biệt nhanh bốn khái niệm hay bị lẫn: · 📄 [VS Code Docs: Choose a customization scope](https://code.visualstudio.com/docs/agent-customization/overview#choose-a-customization-scope)

| Khái niệm | Là gì | Khi nào dùng |
|---|---|---|
| Telemetry (consent) | Đồng ý gửi dữ liệu để cải thiện sản phẩm | Onboard máy, audit quyền riêng tư |
| Train (training) | Code của bạn có bị dùng để huấn luyện model không | Trả lời "code có bị train không" |
| Duplication | Kiểm tra trùng với code public | Lo license/copyright khi code trùng |
| OTel export | Tự đổ trace/metric phiên agent về backend của bạn | Admin muốn soi từng phiên, từng model |

## Cách gọi (copy-paste)

Telemetry không phải slash command trong Chat — consent nằm trong Settings, OTel nằm trong `settings.json` (VS Code) hoặc env (CLI):

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh) · [`examples/02-cach-goi-copy-paste.jsonc`](examples/02-cach-goi-copy-paste.jsonc)

| Đường | Việc |
|---|---|
| VS Code Settings | Search "telemetry" / "copilot data" → xem consent on/off và ai quản (cá nhân hay policy org) |
| `settings.json` | 6 tham số `github.copilot.chat.otel.*`: `enabled`, `exporterType` (`otlp-http`/`otlp-grpc`/`console`/`file`), `otlpEndpoint`, `captureContent`, `captureIdentity`, `maxAttributeSizeChars` |
| Copilot CLI | env `COPILOT_OTEL_ENABLED=true` + `COPILOT_OTEL_FILE_EXPORTER_PATH=<đường-dẫn-file>` — export không cần collector |

> OTel chạy cho **cả** Local lẫn Copilot harness. Chưa có collector thì dùng `console`/`file` trước — đừng cất prompt vào backend công cộng chỉ để "thử cho nhanh". · 📄 [VS Code Docs: Telemetry in VS Code](https://code.visualstudio.com/docs/configure/telemetry)

## Ví dụ thật

Nghiệp vụ: team chưa dựng OTel collector nhưng muốn xem phiên agent đã gọi tool gì — export ra file local để tự đọc, kèm chụp trạng thái consent nộp audit.

> 📄 **Code ví dụ:** [`examples/03-vi-du-that.sh`](examples/03-vi-du-that.sh) · 📄 [VS Code Docs: Create project instructions](https://code.visualstudio.com/docs/agents/guides/customize-copilot-guide#step-1-create-project-instructions)

**Kết quả mong đợi:** file export có dữ liệu sau một phiên agent; trạng thái consent được chụp lại kèm ngày.

**✅ Verify:** tắt `enabled` (hoặc unset env) rồi chạy lại một phiên — file **không tăng thêm** là đúng "công tắc".

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ **Sai:** "Tôi tắt telemetry rồi, thế là code không bị train." — Sai hoàn toàn: đó là hai setting khác nhau. Và bật `captureContent: true` đổ cả prompt/response về collector công cộng là tự mở thêm đường rò rỉ.
✅ **Đúng:** Kiểm riêng từng công tắc (telemetry / train / duplication) và ghi lại từng trạng thái; chỉ bật `captureContent` khi backend nằm trong công ty, có retention policy rõ.

**Bài học:** consent là công tắc của GitHub, OTel là camera của bạn — trả lời audit phải nói rõ đang nói về công tắc nào, và camera chiếu về đâu còn quan trọng hơn việc nó bật hay tắt. · 📄 [VS Code Docs: Troubleshoot customization issues](https://code.visualstudio.com/docs/agent-customization/overview#troubleshoot-customization-issues)

## Lỗi thường gặp

📄 [VS Code Docs: What gets collected](https://code.visualstudio.com/docs/agents/guides/monitoring-agents#what-gets-collected)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Nhầm telemetry với training | Hai khái niệm khác nhau | Đọc [FAQ bảo mật](../../../../../03-cau-hoi-thuong-gap/09-bao-mat-quyen-rieng-tu.md) để phân biệt telemetry vs train vs duplication |
| Bật OTel mà backend không nhận | `enabled` chưa bật, hoặc `exporterType`/`otlpEndpoint` sai | Thử `exporterType: "console"` trước khi trỏ collector |
| Backend nhận nguyên prompt nhạy cảm | `captureContent: true` | Tắt, hoặc đặt `maxAttributeSizeChars` để cắt độ dài attribute |
| Đổi setting local không ăn | Org đè setting cá nhân | Hỏi admin org policy trước khi kết luận |
## So sánh với Claude Code

📄 [GitHub Docs: Comparing customizations](https://docs.github.com/en/copilot/concepts/customizations/comparing-customizations)

| Việc | Copilot (Telemetry) | Claude Code | Ghi chú |
|---|---|---|---|
| Tự xuất số liệu | `github.copilot.chat.otel.*` (settings) + env CLI | OpenTelemetry qua env riêng | Cả hai đều "tự lắp camera"; tên biến khác nhau — đối chiếu docs từng bên |
| Công tắc consent cấp org | Có (policy org đè local) | Không có tương đương trực tiếp kiểu policy org | Đừng giả định hai bên bật/tắt giống nhau |
| Train trên code | Tùy plan — xem data controls | Dữ liệu API mặc định không dùng train (*tự verify*) | Luôn đối chiếu data controls thay vì đoán |
## Best practices (kèm "vì sao")

- **Ghi lại trạng thái consent kèm ngày chụp vào docs onboard.** *Vì sao?* Audit hỏi bất chợt; bằng chứng có ngày trả lời được ngay.
- **Thử OTel bằng `exporterType: "console"` trước khi trỏ collector.** *Vì sao?* Bạn thấy dữ liệu gì sẽ đi, trước khi nó chảy vào hệ thống chung.
- **Mặc định giữ `captureContent: false`.** *Vì sao?* Bật lên là toàn bộ prompt/response về backend của bạn — nhân đôi rủi ro rò rỉ.
- **Máy công ty: kiểm policy org trước khi đổi local.** *Vì sao?* Policy org thường đè setting cá nhân — đổi xong tưởng xong, thực tế không ăn. · 📄 [VS Code Docs: Enable OTel monitoring](https://code.visualstudio.com/docs/agents/guides/monitoring-agents#enable-otel-monitoring)

## Bài tập nhỏ

1. **(5 phút)** Mở Settings, ghi lại 3 trạng thái: telemetry, train/opt-out, duplication — cái nào do cá nhân, cái nào do org quản.
2. **(10 phút)** Bật OTel với `exporterType: "file"`, chạy một phiên agent, mở file export xem có span/tool call; sau đó tắt `enabled` và chạy lại để thấy file đứng yên. · 📄 [VS Code Docs: Telemetry in VS Code](https://code.visualstudio.com/docs/configure/telemetry)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Status dashboard: [../status/README.md](../status/README.md) · hạn mức credits: [ai-credits](../../model-agent/ai-credits/README.md).
- Bài chủ: [13-code-intelligence-indexing-telemetry.md](../../../../13-code-intelligence-indexing-telemetry.md) · Cheatsheet: [CHEATSHEET.md](../../../../../CHEATSHEET.md).
- FAQ: [troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md) · [bảo mật – quyền riêng tư](../../../../../03-cau-hoi-thuong-gap/09-bao-mat-quyen-rieng-tu.md).

> Chốt: consent là công tắc GitHub hỏi bạn, OTel là camera bạn tự lắp — gọi đúng tên từng công tắc khi trả lời audit, và luôn biết camera đang chiếu về đâu trước khi bật. · 📄 [VS Code Docs: Telemetry in VS Code](https://code.visualstudio.com/docs/configure/telemetry)
