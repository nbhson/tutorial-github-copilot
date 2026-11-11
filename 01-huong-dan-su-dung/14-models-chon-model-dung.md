# 14. Models — chọn model nào cho việc nào

> **Cần có:** [bài 00](./00-tong-quan-copilot.md) (modes + bảng chọn nhanh + effort) · [bài 01](./01-cai-dat-va-xac-thuc.md) (Copilot đã chạy ở ít nhất một surface).
> **Thời gian:** ~22 phút

## Mục tiêu bài học

- Giải thích được **1 AI credit = bao nhiêu tiền**, tính được chi phí một request từ số tokens theo công thức §4.
- Chọn đúng model + effort cho các cỡ việc ở bảng §2, và nói được **vì sao** không phải việc gì cũng chọn model mạnh nhất (§3).
- Cấu hình được BYOK và budget để model thử nghiệm **không tiêu tốn** credits của gói (§6, file 14-3).

> **Tóm gọn 1 câu:** chọn model là so bài toán với thế mạnh của model — chọn effort và quản lý context mới là chọn hóa đơn.

---

## 1. Model trong Copilot là gì — bốn dòng

Nguồn: [docs — About Copilot models](https://docs.github.com/en/copilot/concepts/models/overview).

- Model available = model gói của bạn **được phép gọi**; picker mỗi surface liệt kê theo plan, không phải theo thị trường model.
- Bạn chọn được 3 thứ quanh model: **model nào**, **effort bao nhiêu** (bài 00 dạy 5 mode), **context đưa vào bao nhiêu** (bài 13 — index giúp hỏi cả repo đúng cách thay vì nhồi tay).
- Không chọn gì = `auto`: GitHub tự bắt cầu nối theo 3 tầng *Efficiency / Balance / Intelligence* — chi tiết §5.
- Model trong Copilot **không tự quyết chi tiêu**: hóa đơn do effort và context của bạn quyết phần lớn; model chỉ nhân thêm với đơn giá.

---

## 2. Bảng chọn model theo task

Bài 00 đã phủ các việc thông dụng (hỏi repo / rename / bug nhanh / feature / refactor); bảng dưới chỉ thêm **cặp cỡ việc × model chưa có ở bài 00**. Cột AI Credits là ước lượng theo công thức §4 — dùng so sánh *bậc độ lớn*, không phải số trả hóa đơn.

| Cỡ việc | Prompt mẫu | Model gợi ý | Effort | Vì sao | AI Credits ≈ |
|---|---|---|---|---|---|
| Tách regex / parse log định dạng sẵn | "Viết regex bắt dòng `level=ERROR` trong log mẫu dưới, kèm 3 test case:" | Gemini 3 Flash | low | việc nhỏ cần chính xác, không cần suy luận dài; dòng giá rẻ nhất bảng | ~15 |
| Tóm tắt / chuyển hóa tài liệu dài (hàng chục trang) | "Tóm tài liệu sau còn 10 gạch đầu dòng, giữ nguyên con số và tên riêng:" | Gemini 3.1 Pro | low | sở trường của Gemini là context cực dài; tóm tắt thì effort thấp đủ dùng | ~120 |
| Thiết kế API mới, nhiều tradeoffs phải cân | "Thiết kế API đồng bộ offline-first cho app ghi chú. Liệt kê tradeoffs trước khi chốt:" | o1 | medium | o1 sinh ra cho suy luận từng bước — nhưng đắt, chỉ dùng khi tradeoffs thật sự tồn tại | ~400 |
| Phân tích khó: regression perf, race condition | "Hai flamegraph của 2 version đây. Tìm vì sao version mới chậm hơn 20%:" | GPT-5.4 | medium | model hệ thinking; medium là điểm ngọt "đủ nghĩ" cho phân tích có dữ liệu rõ | ~210 |
| Tác vụ agent chạy dài hạn, không muốn model bị đổi giữa chừng | "Implement OAuth2 cho repo này, kèm test. Dừng khi test pass hết." | GPT-5.3-Codex (base/LTS) | low | base model tồn tại lâu hơn model "tên + version"; hợp tác vụ tuần-tháng | ~90 |

Nguồn tên model + availability: [docs — supported models](https://docs.github.com/en/copilot/reference/ai-models/supported-models).

---

## 3. Cách đọc bảng — ba định luật

1. **Effort và context xê dịch giá mạnh hơn đổi model.** Lên 1 bậc effort thường tốn hơn lên 1 bậc class model — và ngược lại, chẳng việc gì trả effort cao cho các dòng "low" ở bảng trên. Nhồi cả repo 10.000 files vào session là trả tiền cho nó *mỗi lượt*; hỏi scoped qua index (bài 13) rẻ hơn nhiều.
2. **Model to không thắng mọi việc.** Khớp *tính chất* việc với *thế mạnh* model: context dài → Gemini; suy luận từng bước → o1. Giao việc 15 credit cho model 400 credit không làm kết quả "xịn hơn", chỉ đắt hơn.
3. **Model mới không mặc định đắt hơn.** Dòng base/LTS giá thường thấp hơn dòng "tên + version" cùng nhà, và `auto` còn được giảm giá so với đích danh (§5) — bảng này lỗi thời theo quý, công thức §4 thì không.

---

## 4. AI Credits — bản đồ chi phí

Nguồn: [docs — usage-based billing](https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing) (kiểm tra theo ngày).

- **1 credit = $0,01**; chi phí tính **per-token**, không per-request: `USD = 0,01 × credits`, `credits = (tokens vào × giá vào + tokens ra × giá ra) ÷ 0,01`, mỗi model một bảng giá riêng.
- Mốc tham chiếu từ bài 00: request ~3k tokens vào + 500 ra với GPT-5.2 ≈ **195 credits** (~$1,95).
- **Thêm model vào picker không làm tăng chi phí**: bạn chỉ trả khi gọi, theo tokens thật dùng — model BYOK còn tiêu tốn 0 credits của gói (§6).
- Tên cũ: premium requests — nay là `ai_credits` — verify bằng `copilot config list`.
- Inline **completions không trừ credits** — chỉ chat/agent request vào bảng chi phí.
- Tại thời điểm viết, picker list ~18 model từ 2 nhà cung cấp — đó là ảnh chụp của *Copilot*, không phải của *thị trường model*; muốn vượt ảnh chụp, dùng BYOK (§6).
- Mọi con số ở đây (kể cả §2) chỉ là snapshot theo quý — giá thật đọc từ bảng giá link ở Reference, đừng tin blog.

Hạn mức theo plan: bảng đầy đủ ở [14-2](./examples/14-models-chon-model-dung/plan-nen-chon-nao.md). Ba dòng cần nhớ: gói cá nhân có hạn mức credits/tháng; hết thì **`auto` vẫn chạy**, model đích danh cần budget (§6); Business/Enterprise tính per-seat.

---

## 5. Auto, fallback và deprecation

- **Auto không phải "model rẻ nhất"** — là cầu nối chọn theo 3 tầng (Efficiency / Balance / Intelligence) và **được giảm ~10% giá** so với đích danh cùng hàng (docs [auto-model-selection](https://docs.github.com/en/copilot/concepts/models/auto-model-selection)). Việc không rõ thuộc tầng nào → mặc auto, rồi chỉnh theo §8.
- **Fallback:** model bạn pin có thể biến mất khỏi danh sách; khi đó request rơi về `auto` — code không vỡ, nhưng *chất lượng và chi phí đổi mà không ai bấm nút*. Cần bền cho tác vụ dài → base/LTS (GPT-5.3-Codex, GPT-5.1-Codex-Max — chỉ Business/Enterprise).
- **Deprecation:** GitHub thường báo trước đợt model nghỉ (~30 ngày, xem changelog). Trước khi pin model tên + version vào CI/config team, kiểm tra trạng thái retirement trên trang model list; model mang nhãn `exp` / `preview` **không dùng cho production chạy dài**.

---

## 6. BYOK và additional usage

**BYOK** = dán API key của thẳng nhà cung cấp (OpenAI, Anthropic, Groq, Ollama local...). Request đi **thẳng tới provider, không qua Copilot API** — không có GitHub auth ở giữa đường đi, và **không tiêu tốn AI credits** của gói; bạn trả provider theo bảng giá của họ ([docs](https://docs.github.com/en/copilot/concepts/models/bring-your-own-key)).

- Azure OpenAI **Foundry** hiện không nằm trong danh sách BYOK hỗ trợ — kiểm tra lại trước khi thiết kế cho org.
- Org có thể chặn BYOK bằng policy — key hợp lệ vẫn không lên picker.
- VS Code bật BYOK: Settings → mục models/API key — [Custom models trong VS Code](https://code.visualstudio.com/docs/agent-customization/language-models).

**additional_usage** là trần tiền *nối sau* hạn mức credits, đơn vị **USD**. Đặt cạnh `optional_calls` cho khỏi nhầm (file [14-3](./examples/14-models-chon-model-dung/byok-additional-usage.json)):

```jsonc
"optional_calls":   { "budget": 20, "over_limit_behavior": "pause" },
"additional_usage": { "limit": 12,  "over_limit_behavior": "pause" }
```

Hai khóa **cùng đơn vị USD** — đọc `12` thành 12 credits là nhầm sang $0,12, lệch 100 lần; `"pause"` nghĩa là chạm trần thì đứng, không tự vẽ thêm hóa đơn.

---

## 7. Thêm model riêng vào picker

Với **Copilot CLI**, docs dùng hai khóa trong `~/.copilot/config.json`:

```jsonc
{
  "models": {
    "custom": [ "ollama/qwen3-coder" ],        // model ngoai danh sach mac dinh
    "alias":  { "local": "ollama/qwen3-coder" } // ten viet tat trong /model
  }
}
```

- Schema đổi theo phiên bản CLI — đối chiếu trang CLI reference (Reference) và chạy `copilot config list` sau khi thêm; restart session nếu model chưa hiện.
- Máy có Ollama chạy local: model thường **tự hiện diện** trong `/model`, không cần khai — gõ `/model` kiểm tra trước khi sửa config.
- Custom provider nâng cao còn có `~/.copilot/providers.json`; thêm model trên VS Code / web / cloud agent làm khác nhau ở đâu — xem [14-5](./examples/14-models-chon-model-dung/mcp-add-vscode-cli-cloud.md).

---

## 8. Ba quyết định nhanh

1. **Không biết chọn gì** → `auto` + effort medium — mặc định tốt, lại rẻ hơn đích danh ~10% (§5).
2. **Việc khớp thế mạnh một model cụ thể** (bảng §2) → gọi đích danh, trả giá niêm yết, đổi lấy kết quả đúng dạng.
3. **Cần kết quả "gần như đúng ngay lần đầu"** — merge blocker, phân tích ngược — → model mạnh + effort high, chấp nhận credits bằng 3–4 lần dòng trung bình của §2; xong việc quay về 1.

---

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | ✅ ĐÚNG | Nguồn |
|---|---|---|
| Pin model tên + version vào CI không kiểm tra gì | Pin base/LTS, hoặc kiểm tra trạng thái retirement mỗi lần cập cấu hình | §5 |
| Tin `auto` là "đống model rẻ" | Auto là 3 tầng có chủ đích + giá ưu đãi; việc khó vẫn được đẩy lên Intelligence | §5 |
| Để effort max cho mọi request cho "chắc" | Effort là biến chi phí lớn nhất; nâng theo triệu chứng, không nâng theo thói quen | §3 |
| Lo BYOK "vẫn bị trừ credits của gói" | BYOK đi thẳng provider — 0 credits GitHub; trả tiền theo bảng giá của họ | §6 |
| Đọc `additional_usage: {limit: 12}` là 12 credits | Cả hai khóa budget đều USD; 12 credits chỉ là $0,12 | §6 |
| Mặc định model mới = đắt hơn | Base/LTS và auto có thể rẻ hơn model tên + version cùng nhà; so bằng công thức §4 | §4 |

---

## Best practices

1. Mặc định effort medium — chỉ nâng khi model "đúng hướng nhưng thiếu bước trung gian".
2. Đổi việc = reset session; lịch sử cũ là phí gửi kèm mọi request sau.
3. Chạy một tuần với `auto`, đọc số credits thực tế ở portal, rồi mới pin model cho team.
4. Thử model lạ → BYOK; việc sản xuất chính → model trong gói cho hóa đơn gọn một chỗ.
5. Đầu mỗi quý: mở trang model list tìm chữ *retirement* — pin nào sắp bay thì đổi trước khi nó tự rơi về auto.

---

## Bài tập

> **Ô cần điền:** `credits = 0,01 × ?`

1. **(3 phút)** Viết lại ô trên cho *chiều đúng* (gợi ý: vế nào là tiền?), rồi tính: một ngày chạy 40 request nhỏ ≈ 30 credits/request → bao nhiêu $?
2. **(2 phút)** Mở `/model` (CLI) hoặc dropdown model (VS Code), đếm số model bạn thấy; so với "18 model / 2 nhà cung cấp" ở §4 — cái nào là snapshot, cái nào cần kiểm tra lại mỗi tuần?
3. **(5 phút)** Viết 3 dòng cho team từ ba định luật §3 — khi nào auto / khi nào đích danh / khi nào nâng effort — dán vào `CONTRIBUTING.md`; kiểm: mỗi dòng phải chạm *tokens hoặc giá*.

---

## Link qua

- [README model-picker](commands/copilot/model-agent/model-picker/README.md) — lệnh gọi picker trên CLI
- [README ai-credits](commands/copilot/model-agent/ai-credits/README.md) — lệnh kiểm tra credits
- [14-2 — Bảng plan & hạn mức](./examples/14-models-chon-model-dung/plan-nen-chon-nao.md) · [14-3 — BYOK & budget](./examples/14-models-chon-model-dung/byok-additional-usage.json) · [14-5 — thêm model từng surface](./examples/14-models-chon-model-dung/mcp-add-vscode-cli-cloud.md) · [14-6 — mẹo kiệm credits](./examples/14-models-chon-model-dung/meo-kiem-credits.md)
- [Bài 00 — chọn model 3 giây](./00-tong-quan-copilot.md) · [Bài 13 — index & telemetry](./13-code-intelligence-indexing-telemetry.md) · [Bài 02 — các bề mặt](./02-cac-be-mat-vscode-ide-web-cli.md)

## Reference

- [GitHub Copilot CLI — concepts](https://docs.github.com/en/copilot/concepts/copilot-surfaces/copilot-cli)
- [GitHub Copilot CLI — reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- [Get started with GitHub Copilot](https://docs.github.com/en/copilot/get-started)

**Chốt:** "Chi phí một request = số tokens × giá per-token; ba đòn bẩy rẻ nhất là model, effort và context — model chỉ là một trong ba."
