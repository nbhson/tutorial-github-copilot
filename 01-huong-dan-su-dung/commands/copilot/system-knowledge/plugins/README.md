# /plugin — Cài cả bộ skills + MCP config từ một Git repo bằng một lệnh

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) + Copilot CLI — Local harness không chạy Agent Plugins · **Đọc:** ~2 phút

**Nôm na:** Mua nguyên hộp đồ nghề thay vì lẻ từng món: một plugin gói nhiều skills kèm cấu hình MCP, cài một lệnh là xong, team không phải copy từng file. Hợp khi team cần dùng đúng bộ customization bạn đang có, hoặc bạn muốn tái dùng workflow giữa các repo.

## Vì sao dùng?

Đơn vị chia sẻ của hệ sinh thái Copilot là **cả bộ tùy chỉnh**, không phải từng file. Marketplace không phải "chợ" mà chỉ là một Git repo có `.github/plugin/marketplace.json` — repo nội bộ công ty bạn cũng là marketplace; admin siết bằng managed settings `enabledPlugins`, `extraKnownMarketplaces`, `strictKnownMarketplaces`, plugin do admin đẩy xuống có badge "Managed". Plugin mở rộng **agent**, docs nói rõ *distinct from VS Code extensions* — extension mở rộng editor, hai thứ đừng lẫn.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ `/` không thấy `/plugin` | session Local, hoặc plugin chưa bật | chạy trong Copilot harness; kiểm setting `chat.plugins.enabled` |
| `marketplace add github/copilot-plugins` báo không phải built-in | `copilot-plugins` **không còn built-in** (`awesome-copilot` mới là built-in không remove được) | add như marketplace thường |
| Skill trong plugin không gọi tên trần được | skill từ plugin bị namespace | gọi `/plugin:skill`, không phải `/skill` trần |
| Manifest hợp lệ mà field không chạy | schema 1.0 là **schema đóng** — field ở ngọn ngoài `skills/` + `mcp.json` bị *lặng lẽ bỏ qua* | phần khác đặt trong namespace `com.github.copilot/` |

**Nếu làm sai:** khai `agents:`/`hooks:` thẳng ở ngọn như bản legacy — docs: field lạ bị *"reported and ignored"*, còn schema không hỗ trợ thì reject cả plugin; bạn không nhận cảnh báo to đùng nào ngoài danh sách field bị bỏ.

## Cách dùng

Gõ trong Copilot harness session; ngoài terminal dùng `copilot plugin …` (docs CLI không liệt kê `validate`):

```prompt
/plugin marketplace add acme/agent-toolbox
/plugin install code-style@acme-agent-toolbox
/plugin list
```

- **Biến thể:** `update | enable | disable | uninstall | marketplace add`; `copilot plugin install` nhận `plugin@marketplace`, `OWNER/REPO`, `OWNER/REPO:PATH`, git URL hoặc local path — thử local path trước khi push vì schema đóng reject tại chỗ.
- **Setting:** `chat.plugins.enabled` (VS Code); auto-update mỗi session là mặc định, tắt bằng env `COPILOT_AUTO_UPDATE=false`; cài vào `~/.copilot/installed-plugins/<MARKETPLACE>/<PLUGIN>`; pin bản bằng `@TAG`/sha khi plugin ảnh hưởng pipeline.
- **✅ Verify:** gõ `/` thấy skill của plugin với tên namespace `/plugin:…`, và `copilot plugin list` liệt kê đúng plugin vừa cài.

## Liên quan

- Đơn vị mà plugin đóng gói: [agent-skill](../agent-skill/README.md) · [mcp](../mcp/README.md) · Bài chủ: [09-extensions-marketplaces.md](../../../../09-extensions-marketplaces.md) (nơi Copilot Extensions được khai tử)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Agent Plugins](https://code.visualstudio.com/docs/agent-customization/agent-plugins) · [GitHub Docs — CLI plugin reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference)
