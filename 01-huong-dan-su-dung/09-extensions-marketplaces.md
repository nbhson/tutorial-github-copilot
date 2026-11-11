# 09 — Extensions & Marketplaces: Ba Tầng Mở Rộng Copilot (Chuẩn 2026)

> **Dành cho:** dev muốn setup "một lần cả team dùng chung", và tech lead cần biết ai đang cài gì vào editor/agent.
> **Vấn đề:** từ "extension" và "plugin" bị dùng lẫn cho **ba tầng khác nhau** — cài nhầm tầng là config không chạy; và cái tên "Copilot Extensions" (sản phẩm GitHub App cho chat) đã **retired từ 10/11/2025** nhưng tài liệu cũ vẫn còn đầy.
> **Đọc xong:** phân tầng đúng — pack VS Code, Agent Plugins + marketplace, MCP/connectors — và dựng được pack commit vào repo cho cả team. **Thời gian:** ~30 phút đọc + 20 phút thực hành.

## Mục tiêu bài học

Mục này cho bạn biết 50 phút nữa sẽ mang được gì về — như kiểm sơ đồ tầng trước khi cắm đồ nghề.

- Phân được **ba tầng mở rộng**: extension của *editor* (`.vscode/extensions.json`), **Agent Plugins** + marketplace (`.github/plugin/marketplace.json`), và MCP/connectors — mỗi tầng file nào, harness nào đọc.
- Commit được pack VS Code chuẩn team + **pin version** để auto-update không đổi hành vi giữa sprint.
- Biết "Copilot Extensions" là sản phẩm đã retired — gặp trong tài liệu cũ thì nhận ra ngay, không đi tìm chỗ cài.
- Nói được marketplace không cần "chợ chính thức": **một Git repo nội bộ** có manifest là đủ; và enterprise khoá được bằng managed settings.

> **Tóm gọn 1 câu:** Mở rộng Copilot là ba tầng ba file — editor thì extension pack, agent thì plugin/marketplace, tool thì MCP/connector; nhầm tên là nhầm luôn chỗ cài, và "Copilot Extensions" chỉ còn là quá khứ.

---

## 1. Ba tầng mở rộng — đừng lẫn tên

**Nôm na 1 câu:** Mỗi tầng là một "ổ cắm" khác nhau: tầng 1 cắm vào **editor** (UI cho người), tầng 2 cắm vào **agent** (đồ nghề model dùng), tầng 3 cắm vào **tool server** (kết nối hệ thống ngoài).

| Tầng | Bạn cài gì | File/surface nào quản lý | Chạy ở đâu |
|---|---|---|---|
| **1. VS Code extensions** | công cụ editor: Copilot Chat, ESLint, Prettier | Marketplace VS Code + `.vscode/extensions.json` (pack team) | chỉ trong VS Code / VS Code-compatible editor |
| **2. Agent Plugins** | gói **skills + cấu hình MCP** cho Copilot | `/plugin` (session Copilot) · `copilot plugin …` (CLI) · marketplace = Git repo | Copilot harness (VS Code + CLI) — Local harness không chạy |
| **3. MCP & connectors** | server cung cấp tool ngoài | `.mcp.json` (root repo, key `mcpServers`) · `~/.copilot/mcp-config.json` · `.vscode/mcp.json` (**Local**, key `servers`) | Copilot harness hoặc Local — tuỳ file |

Ba cái bẫy tên đã làm hỏng bài này bản cũ:

- **"Copilot Extensions"** (sản phẩm GitHub App mở rộng chat) — **đã retired**, xem mục 2. Không còn chỗ nào để cài.
- **Agent Plugins ≠ plugin kiểu khác**: docs gốc của VS Code ghi nguyên văn Agent Plugins *"are distinct from VS Code extensions"* — còn chữ "plugin" nằm trong tên một số extension (mở rộng của extension) là khái niệm của *editor*, không phải tầng này.
- **"Marketplace"** ở tầng 2 không phải chợ: nó chỉ là **một Git repo** có file `.github/plugin/marketplace.json` — repo nội bộ công ty bạn cũng là một marketplace.

📄 Ba file thật của ba tầng: [`examples/09-3-1-vs-code-pack-settings.jsonc`](examples/09-3-1-vs-code-pack-settings.jsonc) (`.vscode/extensions.json`) · [`examples/16-3-plugin-json-schema-dong.json`](examples/16-3-plugin-json-schema-dong.json) (`plugin.json`) · [`templates/.mcp.json`](../templates/.mcp.json) (`mcpServers`).

> **Vì sao quan trọng?** Đúng tầng = đúng file = đúng harness. Cấu hình để sai tầng không báo lỗi to — nó chỉ **im lặng không chạy** (vd: MCP khai trong `.vscode/mcp.json` thì session Copilot harness không thấy).
> **Nếu làm sai?** Team "cài plugin" bằng cách install extension editor → skills không vào agent; hoặc đi tìm "Copilot Extension" theo tutorial 2024 → không tồn tại nữa.
> **Tóm gọn 1 câu:** Trước khi cài, hỏi ba câu: *editor hay agent? file nào đọc config này? harness nào đang chạy?*

## 2. ⚠️ "Copilot Extensions" — cái tên chỉ còn trong tài liệu cũ

**Copilot Extensions** (GitHub App do bên thứ ba viết, thêm capability vào chat) bị khai tử theo lộ trình: deprecated 24/09/2025, **retired 10/11/2025** ([thông báo gốc](https://github.blog/changelog/2025-09-24-deprecate-github-copilot-extensions-github-apps/)). Product GA 19/02/2025 chỉ là mốc lịch sử; không còn marketplace để cài. Người dùng được chuyển sang đường tương đương: **Agent Plugins (bài 17), MCP (bài 08), connectors** — còn prompt/chat kiểu cũ đang deprecated ở Local xem [`commands/local/model-agent/participants/README.md`](commands/local/model-agent/participants/README.md).

**Một ngoại lệ để không loạn:** menu `/extensions` trong *Copilot CLI* là thứ khác — CLI extensions dạng module JavaScript (experimental), không phải "Copilot Extensions" đã retired.

## 3. Tầng 1 — extension pack cho VS Code: commit "cả team dùng đồ này"

### 3.1 `.vscode/extensions.json` — danh sách khuyến nghị

Pack nằm trong repo, ai mở folder đều được VS Code gợi ý cài ("Recommended"). Một sample chuẩn — dòng đầu là bắt buộc, còn lại tuỳ stack:

```jsonc
// .vscode/extensions.json
{
  "recommendations": [
    "github.copilot",            // Chat + completions — cai truoc
    "github.copilot-chat",       // Copilot Features (agent mode, tools)
    "dbaeumer.vscode-eslint",    // LSP: mo file la chay, agent khong phai cai lenh
    "esbenp.prettier-vscode",    // Format theo thong le team
    "editorconfig.editorconfig"  // Dong bo thong le giua cac editor
  ],
  "unwanted": []                 // extension conflict hoac da bo
}
```

Cài + verify bằng CLI (`code --install-extension <publisher.name>` → `code --list-extensions`), walkthrough từng lệnh ở [`examples/09-3-1-vs-code-pack-install.sh`](examples/09-3-1-vs-code-pack-install.sh), file mẫu [`examples/09-3-1-vs-code-pack-settings.jsonc`](examples/09-3-1-vs-code-pack-settings.jsonc). Docs: *"VS Code prompts a user to install the recommended extensions when a workspace is opened for the first time"* — prompt chỉ bật lần đầu mở folder; ai bỏ lỡ thì tự thấy danh sách qua filter `@recommended` trong Extensions view.

**Extension host là gì:** docs định nghĩa *"the server that runs your UI, extensions, and other pieces"* — process chạy extensions; host chết thì debug/terminal/extensions liệt, không phải "Copilot lỗi". Đây cũng là lý do pack nên **ít mà chất**: mở rộng là thêm process vào máy mỗi dev.

> **Vì sao quan trọng?** Đây là cách rẻ nhất để một người setup hộ cả team: file 10 dòng commit một lần, không còn cảnh "sao máy anh chạy được mà máy em không".
> **Nếu làm sai?** Pack 30 extension "cho đủ" → mỗi dev tải thêm 30 extension về máy và trả giá tốc độ mà không ai giải trình được từng cái để làm gì.

### 3.2 Pin version — mặc định auto-update, và hệ quả

Mặc định VS Code **tự cập nhật mọi extension**. Với extension ảnh hưởng hành vi agent (Copilot Chat, công cụ MCP trong editor), "tự update" = luật chơi đổi giữa sprint. Chốt 4 dòng:

- Tắt auto-update: setting `"extensions.autoUpdate": false` (hoặc update từng cái bằng tay: Extensions → bánh răng → *Update* / *Install Another Version*).
- Cài đúng version: `code --install-extension github.copilot-chat@<version>`.
- Audit: `code --list-extensions --show-versions` — so với allowlist của team mỗi tháng.
- Nâng version: cuối sprint, test 1 ngày trên repo thử rồi mới announce. Lệnh đầy đủ: [`examples/09-3-2-pin-version.sh`](examples/09-3-2-pin-version.sh).

## 4. Tầng 2 — Agent Plugins và marketplace

### 4.1 Plugin là gì (6 dòng, phần sâu ở bài 17)

Plugin = **một gói chia sẻ đồ nghề của agent**: chứa skills (và cấu hình MCP), cài một lần có cả bộ thay vì copy từng file. Docs VS Code: *"Agent plugins are portable packages of expertise… distinct from VS Code extensions"*. Bật/tắt phía editor: setting `chat.plugins.enabled`; trong session Copilot dùng `/plugin`, ngoài terminal dùng `copilot plugin install|list|validate|recommendations`. Manifest schema **1.0 là schema đóng**: phần port dùng chung nằm ở `skills/` và `mcp.json` root; mục Copilot-specific (agents/hooks/commands…) phải nằm trong namespace `com.github.copilot/`. Quản lý từng lệnh + kiểm manifest: [`commands/copilot/system-knowledge/plugins/README.md`](commands/copilot/system-knowledge/plugins/README.md) · walkthrough đầy đủ: bài 17 + [`examples/17-2-plugin-marketplace.sh`](examples/17-2-plugin-marketplace.sh).

### 4.2 Marketplace — "chợ" chỉ là một Git repo

Chỉ một lệnh: `copilot plugin marketplace add OWNER/REPO` — repo đó phải có `.github/plugin/marketplace.json` liệt kê plugin. Vài sự thật hay bị hiểu sai:

- `awesome-copilot` là marketplace **built-in, không remove được**; `github/copilot-plugins` thì **phải add thủ công** (nhiều người tưởng nó có sẵn).
- Plugin cài vào `~/.copilot/installed-plugins/<MARKETPLACE>/<PLUGIN>` — kiểm thư mục này là cách verify nhanh nhất.
- Auto-update plugin chạy **mỗi session**: muốn đóng băng như mục 3.2 thì đặt `COPILOT_AUTO_UPDATE=false`; và cài thì pin bằng `@TAG` hoặc sha (`OWNER/REPO@v1.2.0`) — không có `--ref`.
- Slash `/plugin …` chỉ tồn tại trong session Copilot harness; Local harness không chạy Agent Plugins.

> **Vì sao quan trọng?** Marketplace nội bộ = cách phát đồ nghề cho cả org không cần "xin chợ": một Git repo thường + code review + pin sha là đủ nguồn tin cậy.
> **Nếu làm sai?** Cài plugin từ repo lạ không đọc manifest — plugin chứa hooks/MCP nghĩa là **code chạy trên máy bạn**; đọc "hộp" trước khi lắp (best practice bài 16–17).

## 5. Tầng 3 — MCP và connectors: agent chạm hệ thống ngoài

Bài này không dạy MCP (đồ của **bài 08**); chỉ chốt vị trí trong bản đồ: **MCP server** bạn tự nuôi và khai (`.mcp.json` root repo key `mcpServers` · `~/.copilot/mcp-config.json` · `.vscode/mcp.json` là của **Local harness**, key `servers` — Copilot harness không đọc nó: [`commands/local/system-knowledge/vscode-mcp-json/README.md`](commands/local/system-knowledge/vscode-mcp-json/README.md)); **connector** là MCP do GitHub host — bạn chỉ bấm Connect, không có file cấu hình, và nó chỉ phục vụ **Copilot harness**: dấu hiệu nhận là nhãn `Connector: <name>` trong MCP Servers ([`commands/copilot/system-knowledge/connector/README.md`](commands/copilot/system-knowledge/connector/README.md)).

## 6. Repo template — sinh repo mới là mang theo cả pack

Tech lead dựng một repo chuẩn (pack §3 + instructions + skills + hooks + workflows), bật **Settings → General → Template repository**; mỗi repo mới `gh repo create <tên> --template <org>/<template-repo>` là mang nguyên bộ. Điểm hay: pack đi theo tự nhiên, không ai phải nhớ cài gì. Demo + verify: [`examples/09-6-repo-template.sh`](examples/09-6-repo-template.sh).

Lưu ý portability khi template chứa đồ nghề agent: skill nằm trong `.github/skills/` (dạng `*.prompt.md` là format cũ — port trước khi đưa vào template, công thức ở bài 05); workflow/`extensions.json` thì mang sang y nguyên.

## 7. Org gate — admin khoá tầng nào bằng gì (chi tiết: bài 16)

- **Tầng 1 (VS Code):** enterprise policy cho phép/cấm extension nào được cài — cấu hình qua doc [Extensions and your enterprise](https://code.visualstudio.com/docs/enterprise/extensions), không phải nhắc miệng.
- **Tầng 2 (plugins):** managed settings `enabledPlugins` (allowlist), `strictKnownMarketplaces` + `extraKnownMarketplaces` (chợ nào được dùng); plugin admin đẩy xuống có badge **"Managed"**, dev không tắt được.
- **Tầng 3 (MCP/connectors):** allowlist + tool approval — ma trận ở bài 10, cách khoá ở bài 16.

Nguyên tắc chung: settings do dev giữ thì dev đổi được; **muốn "cấm thật" phải xuống managed settings** — vì sao: enforcement là việc của server, không của lời dặn (logic như stack 3 tầng bài 07).

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| Còn đi cài "Copilot Extension" theo tutorial 2024 | sản phẩm retired 10/11/2025, không tồn tại để cài | dùng Agent Plugins (bài 17) / MCP (bài 08) / connector |
| Khai MCP vào `.vscode/mcp.json` rồi hỏi "sao session Copilot không thấy tool" | file đó là của **Local harness** (key `servers`) | Copilot harness: `.mcp.json` root repo (key `mcpServers`) hoặc `~/.copilot/mcp-config.json` |
| Nghĩ marketplace phải là "chợ chính thức" | bỏ lỡ cách tổ chức đồ nghề nội bộ | marketplace = Git repo có `.github/plugin/marketplace.json` |
| Để auto-update mặc định chạy giữa sprint | extension/plugin đổi hành vi lúc nào không hay | pin version (`@TAG`/sha, `COPILOT_AUTO_UPDATE=false`), nâng cuối sprint sau test |
| Tưởng `copilot-plugins` built-in như `awesome-copilot` | lệnh cài fail vì chưa add nguồn | `copilot plugin marketplace add github/copilot-plugins` trước khi cài |

📄 Ba file mà bảng này nhắc tới: [`examples/09-3-1-vs-code-pack-settings.jsonc`](examples/09-3-1-vs-code-pack-settings.jsonc) (pack) · [`examples/16-4-marketplace-json-pin-sha.json`](examples/16-4-marketplace-json-pin-sha.json) (marketplace) · [`examples/01-cach-goi-copy-paste.sh`](commands/local/system-knowledge/vscode-mcp-json/examples/01-cach-goi-copy-paste.sh) (`.vscode/mcp.json` của Local).

## Best practices (kèm vì sao)

- **Pack ≤10 extension, mỗi cái có lý do ghi cạnh ID.** *Vì sao:* mỗi extension là code chạy trên máy người cài (extension host); pack "cho đủ" làm chậm mọi người mà không ai giải trình được.
- **Chung từ 3 repo trở lên → đưa vào pack/template, đừng dạy miệng.** *Ngưỡng 3 repo:* lần thứ 3 giải thích "cài gì" là lúc file `.vscode/extensions.json` đáng được commit hơn một tin nhắn.
- **Đọc manifest trước khi cài plugin từ nguồn lạ.** *Vì sao:* plugin có thể mang hooks/MCP = lệnh chạy trên máy bạn; publisher + repo source là hai thứ kiểm được bằng 5 phút.
- **Khoá tầng ở đúng tầng:** auto-update tắt bằng setting, nguồn plugin chặn bằng `strictKnownMarketplaces`, không "nhắc nhau". *Vì sao:* cái gì dev đổi được thì không phải chính sách.

## Bài tập

1. **(10 phút)** Tạo `.vscode/extensions.json` cho repo hiện tại (≤8 ID), commit; nhờ một người mở folder và báo có prompt "Install recommended" — xác nhận bằng `code --list-extensions | grep -i copilot` (theo 📄 [`examples/09-3-1-vs-code-pack-install.sh`](examples/09-3-1-vs-code-pack-install.sh)).
2. **(10 phút)** Pin `github.copilot-chat` về một version cụ thể, đặt `extensions.autoUpdate: false`; chạy audit `--show-versions`, ghi kết quả vào notes team (📄 [`examples/09-3-2-pin-version.sh`](examples/09-3-2-pin-version.sh)).
3. **(15 phút)** Thêm marketplace `github/copilot-plugins`, cài một plugin pin theo `@TAG`, verify thư mục `~/.copilot/installed-plugins/`, rồi `/plugin uninstall` — tất cả trong `examples/17-2-plugin-marketplace.sh`.

## Link qua

- Skills/`SKILL.md` trong plugin → bài 05. · MCP chi tiết + tool approval → bài 08. · Ma trận allow/ask/deny → bài 10.
- Stack guardrail (logic "khoá ở server") → bài 07. · Kinh tế + audit org → bài 16. · Plugin từng lệnh, quản lý "hộp" → bài 17.
- Thực hành: [`commands/copilot/system-knowledge/plugins/README.md`](commands/copilot/system-knowledge/plugins/README.md) · [`commands/copilot/system-knowledge/connector/README.md`](commands/copilot/system-knowledge/connector/README.md) · [`commands/local/system-knowledge/vscode-mcp-json/README.md`](commands/local/system-knowledge/vscode-mcp-json/README.md)

## Reference

- VS Code — [Extension Marketplace](https://code.visualstudio.com/docs/configure/extensions/extension-marketplace) (recommendations, auto-update, Install Pending) · [Extensions and your enterprise](https://code.visualstudio.com/docs/enterprise/extensions) (org allow/block)
- VS Code — [Agent Plugins](https://code.visualstudio.com/docs/agent-customization/agent-plugins) (manifest schema 1.0, marketplace, managed settings, `chat.plugins.enabled`) · [Copilot Connectors](https://code.visualstudio.com/docs/agent-customization/copilot-connectors)
- GitHub Changelog — [Deprecate GitHub Copilot Extensions](https://github.blog/changelog/2025-09-24-deprecate-github-copilot-extensions-github-apps/) (deprecated 24/09/2025 → retired 10/11/2025)

**Chốt:** Ba tầng — editor (extension pack), agent (plugin + marketplace), tool (MCP/connector) — mỗi tầng một file, một harness; "Copilot Extensions" đã retired và chỉ còn là cái tên dễ gây lẫn. Đồ nghề dùng từ 3 repo thì đóng gói vào pack/template, và nhớ: auto-update mặc định là bật — pin trước khi sprint chạy.
