# /plugin — cài và quản lý Agent Plugins cho Copilot harness

> **Dành cho:** dev muốn chia sẻ cả bộ skills/MCP cho team, hoặc cài đồ của người khác làm sẵn · **Vấn đề:** mỗi lần setup lại copy từng file skill, MCP config · **Đọc xong:** cài/update/bật/tắt plugin bằng slash và CLI, phân biệt với VS Code extension (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) + Copilot CLI — Local harness không chạy Agent Plugins

## 1 câu nôm na

Thợ sửa đồ nghề cả thùng: mua một hộp đồ nghề có sẵn cờ-lê, tua-vơ, sách hướng dẫn — thay vì mua lẻ từng món. Agent Plugin là hộp đồ nghề của agent: một gói chứa skills (và cấu hình MCP); `/plugin` là lệnh mở tủ, lắp vào, gỡ ra. Còn "extension" VS Code là đồ nghề cho *cái editor* — docs nói rõ hai thứ là **distinct from VS Code extensions**.

## Vì sao dùng /plugin?

Vì đơn vị chia sẻ của hệ sinh thái Copilot 2026 là **cả bộ tùy chỉnh**, không phải từng file. Plugin cho bạn:

- **Cài một lệnh, có cả gói** — skill + `mcp.json` đi cùng nhau; team không phải dò từng file.
- **Quản tại chỗ trong session**: `/plugin list|install|update|enable|disable|uninstall|marketplace add` — docs gắn riêng cho **Copilot harness session**.
- **Có "chợ" mà không cần chợ**: marketplace chỉ là **một Git repo** có file `.github/plugin/marketplace.json` — repo nội bộ của công ty bạn cũng là marketplace.
- **Enterprise kiểm soát được**: managed settings `enabledPlugins`, `extraKnownMarketplaces`, `strictKnownMarketplaces`; plugin do admin đẩy xuống có badge "Managed".

Vài con số/nếp cũ cần biết: plugin cài vào `~/.copilot/installed-plugins/<MARKETPLACE>/<PLUGIN>`; auto-update chạy mỗi session, tắt bằng `COPILOT_AUTO_UPDATE=false`; bật/tắt phía VS Code bằng setting `chat.plugins.enabled`.

> **Tóm gọn 1 câu:** Muốn đồng đội có đúng bộ skills bạn đang dùng? Đóng một plugin, đẩy một repo — `/plugin install` là toàn bộ phía người nhận.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** tái dùng workflow giữa các repo; team cần cùng một bộ skills; cài thử plugin từ marketplace công khai hoặc repo nội bộ.
- **ĐỪNG dùng khi:** bạn đang ở Local session (docs: Agent Plugins thuộc Copilot harness — Local có ❌); cần mở rộng *editor* (giao diện, keybinding) — việc đó là VS Code extension, không phải plugin.
- **Lịch sử 2 dòng:** "Copilot Extensions" (GitHub App, gọi bằng `@`) đã deprecated 24/09/2025 và retired 10/11/2025 — slug này thay chỗ nó; đường mở rộng hiện hành là **Agent Plugins + MCP servers + connectors** ([bài 09](../../../../09-extensions-marketplaces.md)).

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Trong Copilot session dùng `/plugin …`; ngoài terminal dùng `copilot plugin install|list|update|enable|disable|uninstall|marketplace` (nguyên văn docs GitHub CLI — bản 11/2026 **không** liệt kê `validate`/`recommendations`). `copilot plugin install` nhận `plugin@marketplace`, `OWNER/REPO`, `OWNER/REPO:PATH`, git URL hoặc local path; pin bản bằng `@TAG`/sha.

## Ví dụ thật

Nghiệp vụ: team bạn có 3 skills review code để trong repo `acme/agent-toolbox` kèm marketplace. Ở Copilot session:

```
/plugin marketplace add acme/agent-toolbox
/plugin install code-style@acme-agent-toolbox
/plugin list
```

**Kết quả mong đợi:** Plugin hiện trong `copilot plugin list` và `/plugin list`, skills của nó gọi được — lưu ý skill từ plugin bị **namespace**: `/plugin:skill` chứ không phải `/skill` trần.

**✅ Verify:** Gõ `/` trong session — thấy skill của plugin trong menu với tên có namespace; thư mục `~/.copilot/installed-plugins/<MARKETPLACE>/<PLUGIN>` tồn tại.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI:** viết manifest Agent Plugins 1.0 rồi khai thẳng các field `agents:`/`hooks:` ở ngọn như bản legacy — docs: field lạ bị *"reported and ignored"*, còn schema không hỗ trợ thì **reject cả plugin**; bạn không có cảnh báo to đùng nào ngoài danh sách field bị bỏ.
**✅ ĐÚNG:** 1.0 là **schema đóng**: portable chỉ có `skills/` + `mcp.json` ở gốc; muốn ship agents/hooks/commands/rules/LSP thì đặt trong namespace `com.github.copilot/`; giữ manifest `plugin.json` legacy nếu nhắm tương thích cũ (manifest legacy được tìm ở `.plugin/plugin.json`, `plugin.json`, `.github/plugin/plugin.json`, `.claude-plugin/plugin.json`).

**Bài học:** Plugin không "báo lỗi khi sai" — nó *lặng lẽ bỏ qua* thứ nó không hiểu. Đặc schema đóng thì phải viết đúng khuôn của nó.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ `/` không thấy `/plugin` | Session Local, hoặc plugin chưa bật | Chạy trong Copilot harness session; kiểm tra `chat.plugins.enabled` |
| `marketplace add github/copilot-plugins` báo không phải built-in | `copilot-plugins` **không còn built-in** | Add như marketplace thường (lệnh trên); `awesome-copilot` mới là built-in không remove được |
| Skill trong plugin không gọi tên trần được | Plugin skill bị namespace | Gọi `/plugin:skill` — docs ghi rõ namespace này |
| Manifest hợp lệ mà field không chạy | Trộn schema 1.0 với field legacy | Portable 1.0 = `skills/` + `mcp.json`; còn lại vào `com.github.copilot/` |
| Tưởng `/extensions` (CLI) là Copilot Extensions cũ | Tên gần giống, khác chất | CLI `/extensions` quản lý **CLI extensions (JS modules, experimental)** — cái cũ đã retired |

## So sánh với Claude Code

| Việc | Copilot (`/plugin`) | Claude Code | Ghi chú |
|---|---|---|---|
| Gói customization cài bằng một lệnh | Agent Plugins, `/plugin install …` | Không có tương đương trực tiếp trong tài liệu đối chiếu | docs VS Code: plugin ≠ VS Code extension |
| Manifest đặt cạnh hệ cũ | Manifest legacy tìm cả `.claude-plugin/plugin.json` | — | cùng *địa điểm* manifest, không có nghĩa cùng schema — đừng kỳ vọng port 100% |

## Best practices (kèm "vì sao")

- **Thêm marketplace từ repo bạn control được (team/org), trước khi thêm repo lạ.** *Vì sao?* Marketplace là Git repo — thứ nó chứa sẽ chạy trong session của bạn; nguồn đáng tin quan trọng hơn nguồn đa dạng.
- **Cài thử plugin bằng `copilot plugin install <local path>` ngay trên máy bạn trước khi push.** *Vì sao?* Docs CLI chưa liệt kê lệnh `validate` — đường kiểm sớm duy nhất có nguồn là install local: schema 1.0 reject file lạ field tại chỗ, đỡ cảnh plugin "im lặng hỏng" trên máy đồng nghiệp.
- **Ghim bản bằng `@TAG`/sha khi plugin ảnh hưởng pipeline.** *Vì sao?* Auto-update mỗi session là mặc định; phiên của bạn không nên đổi hành vi giữa chừng.
- **Admin: chốt marketplaces bằng `strictKnownMarketplaces` thay vì nhắc nhở.** *Vì sao?* Docs cho thấy managed settings thắng local — đó là enforcement, không phải khuyến cáo.

## Bài tập nhỏ

1. **(3 phút)** Trong Copilot session: `/plugin list` — ghi lại plugin nào có badge "Managed" (nếu org bạn bật).
2. **(10 phút)** `copilot plugin marketplace add github/copilot-plugins` (nó *không* còn built-in), cài một plugin nhỏ, rồi gọi `/` để thấy skill namespace `/plugin:…`.
3. **(5 phút)** Viết manifest 1.0 cho một skill bạn có sẵn trong `~/.copilot/skills/`: chỉ `skills/` + `mcp.json` ở gốc — rồi `copilot plugin install ./<thu-muc>` để xem CLI báo lỗi schema gì (nếu có).

## Tham khảo

- Index nhóm: [../README.md](../README.md) · [Commands index](../../../README.md)
- Nguồn docs: [VS Code — Agent Plugins](https://code.visualstudio.com/docs/agent-customization/agent-plugins) · [GitHub — CLI plugin reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference) · [GitHub — Plugin & marketplace reference](https://docs.github.com/en/copilot/reference/plugin-and-marketplace-reference)
- Bài liên quan: [bài 09 — Extensions & Marketplaces](../../../../09-extensions-marketplaces.md) (nơi Copilot Extensions được khai tử) · [bài 16 — bảo mật & validate](../../../../16-extensions-mcp-bao-mat-validate.md) · [bài 05 — Agent Skills](../../../../05-agent-skills-reusable-workflows.md)
- Anh em cùng nhóm: [../agent-skill/README.md](../agent-skill/README.md) (đơn vị mà plugin đóng gói) · [../mcp/README.md](../mcp/README.md)

> Hệ sinh thái Copilot đổi chủ: Extensions chết, plugins sống — và plugin tốt là plugin *cả team cài được bằng một dòng*, không phải một thư zip truyền tay.
