# 17 — Agent Customizations Editor: Quản Mọi Tuỳ Biến Agent Trên Một Màn Hình

> **Dành cho:** dev/team muốn agent "hiểu nhà mình" thay vì trả lời chung chung — và muốn thấy rõ harness đang chọn đọc những gì trên cùng một màn hình.
> **Vấn đề:** instructions/skills/agents/MCP/hooks nằm rải rác nhiều nơi, không biết cái nào dẫn cái nào; cài plugin lạ là giao agent quyền chạy code trên máy.
> **Đọc xong:** mở editor bằng `Chat: Open Customizations`, chọn đúng card cho từng nhu cầu, draft bằng Customize Your Agent rồi kiểm chứng trước khi lưu, đọc hiểu schema đóng + marketplace của Agent Plugins. *(Bài 17 của series, ~30 phút)*

## Mục tiêu bài học

Bài này là "cửa sổ một chỗ" của cả khoá: dạy cách nhìn, cách chọn, cách quản lý; chi tiết từng loại tuỳ biến thuộc bài chủ của nó (03/05/06/07/08) — riêng **Agent Plugins do bài này sở hữu**.

- Mở đúng editor (`Chat: Open Customizations`) và đọc các card theo **harness đang chọn** — không phải theo "mọi file trên đĩa".
- Kể được 4 dòng cho mỗi loại tuỳ biến: là gì · file sống đâu · harness nào · bài chủ nào.
- Hiểu **Agent Plugins 1.0 schema đóng**, marketplace = Git repo có `.github/plugin/marketplace.json`, `/plugin` **chỉ Copilot harness**.
- Phán bản draft của **Customize Your Agent**: đọc → validate → PR; biết đường migrate từ Local sang `~/.copilot/` và cách verify "đã ngấm".

> **Tóm gọn 1 câu:** Editor là cửa sổ một chỗ để thấy và quản mọi tuỳ biến của harness đang chọn — thuộc lòng bảng routing "mỗi món một bài chủ".

---

## 1. Vì sao cần một màn hình?

**1 câu định nghĩa:** Agent Customizations editor là màn hình VS Code mở bằng lệnh `Chat: Open Customizations`, liệt kê **toàn bộ** tuỳ biến (instructions / skills / agents / MCP / hooks / plugins / tools / voice) của **harness đang được chọn** tại một chỗ.

**Nôm na:** **bảng điện tổng** của ngôi nhà — đứng một chỗ biết line nào đang cấp điện, line nào cắt được; mỗi line ghi nó cấp cho phòng nào, đó là "bài chủ" của từng card.

**Ví dụ:** cũng card Skills, đổi Session Target từ Copilot sang Local — danh sách vị trí file đổi ngay, vì hai harness đọc hai tập thư mục khác nhau.

> **Vì sao quan trọng?** Lỗi phổ biến nhất của customizations không phải viết sai mà là **đặt chỗ harness không đọc**: file tồn tại, agent không thấy, không báo lỗi. Editor giải một màn hình câu "agent đang đọc gì", kèm syntax highlighting + validation — tạo file trong editor thay vì viết tay ngoài.
> **Nếu làm sai?** Chọn nhầm harness trước khi tạo → format + vị trí sai (như gửi thư sai bưu cục); cài plugin lạ mà không đọc "hộp" → âm thầm mang theo hooks + MCP chạy code trên máy bạn.
> **Tóm gọn 1 câu:** Editor = bảng điện tổng: thấy gì là thấy theo harness đang chọn — chọn sai harness là thấy sai hết.

## 2. Mở editor & đọc theo harness

```text
1. Command Palette (Cmd+Shift+P / Ctrl+Shift+P) -> "Chat: Open Customizations".
2. Agents window (Copilot harness): panel Customizations ở sidebar.
3. Xem Session Target trước khi thao tác (bài 02 §3.1) — editor hiển thị theo harness,
   không phải theo "mọi file trên đĩa".
```

- Ở **Copilot harness**, instructions/skills/agents/MCP/plugins/tools quản lý **bằng editor** — slash `/instructions` `/skills` `/agents` trong Chat view **không tồn tại** (docs nguyên văn: Copilot chỉ có `/prompts` và `/hooks`).
- Agent Host (Copilot harness) đọc user-level từ `~/.copilot/`, **không đọc** VS Code profile storage cũ; chỉ Local còn đọc đồ cũ.
- **Browse → GitHub Feed** (tìm skill/MCP/plugin theo `@type:skill`): experimental, cần harness có marketplace search — session Local không có nguồn này, org policy có thể chặn.

> **⚠️ Khác biệt Local harness** (legacy — chỉ để so sánh, chi tiết bài 02 §3.1):
> - Editor hiện `.prompt.md`, participants, user tool sets ở đây — Copilot harness không đọc các thứ đó.
> - Slash cấu hình customizations (`/instructions` `/skills` `/agents` …) chỉ có trong phiên Local.
> - Agent Plugins và Connectors: không có ở Local harness.
> - Customizations user-level sống trong VS Code profile storage → phải migrate sang `~/.copilot/` (§7).

> 📄 Các bước mở + kiểm editor theo harness: [`examples/17-1-open-customizations-editor.sh`](examples/17-1-open-customizations-editor.sh)

## 3. Customize Your Agent: mô tả → draft

```text
- Ô "Customize Your Agent" -> nhập mô tả ("commit ngắn gọn, review kỹ, code có test")
  -> agent hỏi làm rõ -> draft instructions/skills/agents -> BẠN review -> save.
- Muốn agent viết riêng một món: ở phiên Local có /create-skill /create-agent
  /create-hook; /init sinh/cập nhật file instructions của workspace
  (.github/copilot-instructions.md hoặc AGENTS.md).
- Luật sắt: draft là bản nháp, không phải bản chốt — schema model biết có thể đã cũ
  theo version -> mở editor validate, xem References, rồi mới commit qua PR.
  (📄 [`examples/03-7-walkthrough-5-phut-skill-au-tien-cua.sh`](examples/03-7-walkthrough-5-phut-skill-au-tien-cua.sh) — tạo skill/agent khớp cấu trúc [`templates/.github/`](../templates/.github/))
```

## 4. Các card trong editor — mỗi card đúng 4 dòng

### 4.1. Plugins — hộp cơm đóng sẵn (bài này là chủ)

- **Là gì:** cách chính thức để **phân phối cả bộ** tuỳ biến; **Agent Plugins 1.0 là schema đóng** — phần portable chỉ gồm `skills/` + `mcp.json` ở gốc, mọi thứ khác (agents/hooks/commands/rules/LSP) phải vào namespace `com.github.copilot/`; field lạ bị báo cáo + bỏ qua, ngoài schema là **reject cả plugin**.
- **Khác VS Code extensions** (docs nguyên văn *"distinct from VS Code extensions"*): plugin thêm tuỳ biến cho agent, không thêm tính năng cho editor.
- **Marketplace = một Git repo** có mô tả ở `.github/plugin/marketplace.json`; `awesome-copilot` là built-in không remove được, `copilot-plugins` phải thêm manual: `copilot plugin marketplace add github/copilot-plugins`.
- **`/plugin list|install|update|enable|disable|uninstall|marketplace add|browse|update|remove` chỉ chạy trong Copilot harness session**; plugin cài vào `~/.copilot/installed-plugins/<MARKETPLACE>/<PLUGIN>`, bật/tắt bằng `chat.plugins.enabled`.
- Skill từ plugin khi gọi bị đặt namespace: `/plugin:skill` (bài 05); tắt plugin = sạch bộ skill/agent/MCP nó mang theo.
- Đọc "hộp" trước khi tin: duyệt repo chứa plugin, kiểm phần mang code thực thi (hooks/MCP) — chợ nổi tiếng ≠ từng plugin an toàn; walkthrough ở [`examples/17-2-plugin-marketplace.sh`](examples/17-2-plugin-marketplace.sh).

### 4.2. MCP Servers — cổng giao hàng

- **Là gì:** server phơi tool nối agent với hệ ngoài (DB, API, issue tracker).
- **File:** Copilot harness: `.mcp.json` ở gốc repo + `~/.copilot/mcp-config.json`; Local: `.vscode/mcp.json` (key `servers`; `${input:}` xác thực **không port** sang Copilot).
- **Harness:** cả hai; **Connectors** (MCP do GitHub quản lý) chỉ cung cấp tool cho Copilot harness.
- **Bài chủ:** **08** · [mcp](commands/copilot/system-knowledge/mcp/README.md) · [connector](commands/copilot/system-knowledge/connector/README.md) · [.vscode/mcp.json](commands/local/system-knowledge/vscode-mcp-json/README.md) · 📄 [`templates/.mcp.json`](../templates/.mcp.json) + [`01-cach-goi-copy-paste.sh`](commands/local/system-knowledge/vscode-mcp-json/examples/01-cach-goi-copy-paste.sh) (Local).

### 4.3. Skills — công thức món khó

- **Là gì:** quy trình nhiều bước theo từng việc, chuẩn mở agentskills.io; prompt khớp `description` thì agent tự nạp.
- **File:** project `.github/skills/<ten>/SKILL.md` (`name` = tên thư mục); cá nhân `~/.copilot/skills/`; Local đọc thêm `.claude/skills/`, `.agents/skills/`.
- **Harness:** chạy ở mọi harness: Copilot · Local · CLI · cloud agent; prompt files `.prompt.md` — chỉ Local.
- **Bài chủ:** **05** · [agent-skill](commands/copilot/system-knowledge/agent-skill/README.md) · 📄 [`templates/.github/skills/review-pr/SKILL.md`](../templates/.github/skills/review-pr/SKILL.md) · [`examples/03-7-walkthrough-5-phut-skill-au-tien-cua.sh`](examples/03-7-walkthrough-5-phut-skill-au-tien-cua.sh).

### 4.4. Instructions — nội quy bếp

- **Là gì:** quy tắc nên tuân ở mọi chat; model **có thể quên** — việc bắt buộc chạy thì đưa xuống hook.
- **File:** `.github/copilot-instructions.md` hoặc `AGENTS.md`; nhắm đường dẫn: `.github/instructions/*.instructions.md` + `applyTo`; cá nhân `~/.copilot/instructions/`.
- **Harness:** cả hai; thứ tự nạp **khác nhau theo harness** — không có luật "file cao nhất thắng" toàn vũ trụ.
- **Bài chủ:** **03** · [instructions](commands/copilot/system-knowledge/instructions/README.md) · 📄 [`templates/.github/copilot-instructions.md`](../templates/.github/copilot-instructions.md) + [`backend-api.instructions.md`](../templates/.github/instructions/backend-api.instructions.md).

### 4.5. Agents — đầu bếp chuyên món

- **Là gì:** persona gói instructions + tool (+ model) thành vai trò gọi lặp lại.
- **File:** `.github/agents/<TEN>.agent.md` (hoặc `.md`); cá nhân `~/.copilot/agents/`; user agent của Local nằm trong VS Code profile storage → phải migrate.
- **Harness:** cả hai; built-in Ask/Plan/Agent là chuyện khác (bài 02 §3).
- **Bài chủ:** **06** · [custom-agent](commands/copilot/model-agent/custom-agent/README.md) — 📄 3 agent mẫu: [`templates/.github/agents/`](../templates/.github/agents/).

### 4.6. Hooks — chuông báo cháy tự động

- **Là gì:** code chạy **tất định** tại sự kiện vòng đời (`PreToolUse` chặn trước khi chạy lệnh, `PostToolUse` format sau khi sửa…) — không phụ thuộc model có nhớ không.
- **File:** `.github/hooks/*.json` + `~/.copilot/hooks/`; schema `{"version":1,"hooks":{"<Event>":[{type, command, matcher, timeoutSec}]}}`, lọc bằng `matcher` (regex).
- **Harness:** chạy ở **Copilot CLI + Copilot in the cloud** (một subset event; docs GitHub còn chấp nhận PascalCase alias); trong editor VS Code là Preview; không auto-convert sang harness khác.
- **Bài chủ:** **07** (event, payload, ví dụ chặn lệnh nguy hiểm).

### 4.7. Tools — dao thớt được phép cầm

- **Là gì:** từng tool agent được cầm: built-in (đọc/sửa/terminal/search) · từ MCP server · từ extension.
- **Ở đâu:** tab **Tools** trong editor; selection **lưu theo harness** — chọn ở harness này, harness kia không chạy theo.
- **Harness:** tool names **phụ thuộc harness**; `#` trong ô chat để browse tools/context; tool do extension cung cấp cần editor window đang kết nối.
- **Bật ≠ auto-approve:** bật là cho agent *thấy*; chạy được hay không do permission level quyết — **bài 10** · [policy-approval](commands/copilot/model-agent/policy-approval/README.md).

## 5. Cần gì → dùng gì (bảng quyết định)

| Triệu chứng | Thay đổi nhỏ nhất nên thử | Bài chủ |
|---|---|---|
| Quên 1 yêu cầu / thiếu 1 file ở yêu cầu vừa rồi | Thêm vào prompt hiện tại (đừng tạo file) | 04 |
| Lặp lỗi về lệnh/convention toàn project | Thêm/sửa **Instructions** | 03 |
| Lỗi chỉ ở vài file / một ngôn ngữ | **Instructions** nhắm mục tiêu (`applyTo`) | 03 |
| Team giải thích mãi một quy trình nhiều bước | Tạo **Skill** | 05 |
| Vai trò lặp lại cần tool giới hạn | Tạo custom **Agent** | 06 |
| Agent cần chạm hệ ngoài (DB, API, tracker) | Thêm **MCP server** | 08 |
| Việc PHẢI chạy ở một điểm vòng đời | Cấu hình **Hook** | 07 |
| Muốn bộ tuỳ biến đóng gói cho nhiều repo | Cài/tạo **Plugin** | bài này §4.1 |
| Tool quá nhiều / không đúng | Rà tab **Tools** | §4.7 · 10 |

> **Cách đọc bảng này:** cột trái là triệu chứng bạn đang gặp, cột phải là thay đổi nhỏ nhất nên thử trước khi thêm bất cứ gì. **Luật tầng:** instructions/skills *dẫn dắt* (model có thể quên); hooks chạy *tất định*; agents gói persona; MCP/tools thêm khả năng; plugins để phân phối. Việc bắt buộc → hook; gợi ý → instructions.

## 6. Voice + Dictation

- **Voice Mode:** hội thoại hai chiều bằng giọng nói với agent — **experimental**, `feature(voice-mode)`; bật ở card Voice của editor; cần mic.
- **Dictation:** nói → chèn text vào ô prompt — **built-in** ở ô chat; bản cleanup bằng LLM (experimental) rất hợp prompt tiếng Việt dài kèm tên biến tiếng Anh.
- File kiểu nói riêng: cá nhân `~/.copilot/voice.md`, `~/.copilot/dictation.md`; repo `.github/voice.md`, `.github/dictation.md`.
- Voice/Dictation là **kênh giao tiếp**, không phải tuỳ biến hành vi agent — muốn đổi "cách nó trả lời" thì về Instructions (03). Tính năng experimental có thể không có trên harness/plan của bạn: không thấy card thì đừng đi mò setting của bản cũ. 📄 Mở editor để bật card Voice: [`examples/17-1-open-customizations-editor.sh`](examples/17-1-open-customizations-editor.sh).

## 7. Migrate & verify "đã ngấm chưa"

```text
1. Prompt files -> skills: .prompt.md chỉ chạy ở Local harness; việc mới tạo bằng skill.
   Khi migrate tự map name/description/arguments + gắn disable-model-invocation: true;
   MẤT: agent/model/tools (bài 05 §8).
2. User data của Local (VS Code profile storage) KHÔNG tự convert — Copilot harness đọc
   ~/.copilot/: chủ động chuyển instructions/skills/agents cá nhân sang đó; hooks không port
   nguyên file (event + payload khác harness); ${input:} của MCP -> chuyển sang env vars.
3. File gốc và file sau migrate KHÔNG sync nhau -> chọn một bên sống, dẹp bên kia.
4. Verify "ngấm": References trong câu trả lời liệt kê đúng file? Editor báo lỗi validate gì?
   Agent "dường như" không thấy file -> /troubleshoot (local hoặc Copilot CLI session);
   sau migrate chạy 1 task đại diện + Developer: Policy Diagnostics + /sandbox policy.
5. Governance — ai được cài gì, managed settings, plugin allowlist — bài 16 sở hữu; ở đây
   chỉ thuộc lòng: cài personal -> thử -> rồi mới đưa vào .github/ qua PR.
```

## 8. So với Claude Code & Codex

```text
- Instructions: CLAUDE.md hoặc GEMINI.md là thay thế hợp lệ cho file gốc repo; AGENTS.md đặt
  bất kỳ đâu trong repo, file gần nhất thắng; phía Copilot: .github/ + ~/.copilot/.
- Skills: .claude/skills/ (Claude) vs .github/skills/ + ~/.copilot/skills/ (Copilot) — cùng một
  SKILL.md chạy được cả hai vì agentskills.io là chuẩn mở.
- MCP: .mcp.json dùng chung; hooks khác sâu nhất (.claude/settings.json vs .github/hooks/*.json
  — file giống nhau không bảo đảm hành vi giống nhau).
- Claude/Codex là provider harness hiện trong Session Target (bài 02 §3.1); org bật
  enterprise-managed settings là hai harness này bị chặn.
```

> 📄 [`examples/17-1-open-customizations-editor.sh`](examples/17-1-open-customizations-editor.sh) (mở editor, đổi harness, kiểm file) · [`examples/17-2-plugin-marketplace.sh`](examples/17-2-plugin-marketplace.sh) (marketplace + cài plugin + đọc "hộp")

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| Quản skills của session Copilot bằng `/skills` | Slash đó không tồn tại ở Copilot harness (chỉ `/prompts`, `/hooks`) | **New Skill** trong editor; `/skills` là shortcut của phiên Local |
| Nghĩ "thấy file trong editor là agent đang đọc" | File nằm đó, agent không thấy, không báo lỗi | Editor hiển thị theo *harness đang chọn* — đổi target để so hai list |
| Draft từ Customize Your Agent commit ngay | Schema cũ theo version / luật team chưa duyệt vào repo | Đọc → validate trong editor → References → PR |
| Cài plugin lạ thẳng vào `.github/` cho cả team | Hook/MCP chạy code trên máy thành default của mọi người | Cài personal → đọc "hộp" plugin → đề xuất qua PR |
| Bật tool là nghĩ agent được phép chạy | Hành động chạm production xảy ra ngoài ý | enabling ≠ auto-approve — permission level (bài 10) mới quyết |
| Một file hook mong chạy giống nhau ở mọi harness | Event/payload khác nhau → hook âm thầm không chạy | Theo schema bài 07, verify trên harness sẽ chạy thật |

## Best practices

- **Tạo file trong editor, đừng viết tay ngoài.** *Vì sao:* editor có highlighting + validation — bắt lỗi format trước khi nó thành "âm thầm không load".
- **Đọc cấu trúc plugin trước khi cài: `skills/`, `mcp.json` gốc, `com.github.copilot/`.** *Vì sao:* plugin mang code thực thi; uy tín chợ ≠ an toàn từng plugin.
- **Personal trước, team qua PR.** *Vì sao:* mọi thứ vào `.github/` thành hành vi của cả team — một customizations sai nhân bản lỗi đi khắp các phiên.
- **Việc bắt buộc đưa xuống hook, gợi ý để instructions.** *Vì sao:* model có thể "quên" nội quy; hook chạy tất định theo event.
- **Verify bằng References + diagnostics, không bằng "agent bảo đã hiểu".** *Vì sao:* tự báo cáo ≠ đã nạp thật; silent failure là bệnh đặc trưng của customizations.

## Bài tập

1. **(10 phút)** Mở editor bằng `Chat: Open Customizations`, ghi lại từng card §4 trong session Copilot; nếu cửa sổ cho phép, đổi sang harness Local và liệt kê 3 khác biệt về vị trí/format (theo examples/17-1).
2. **(10 phút)** Draft instructions bằng Customize Your Agent → validate trong editor → sửa ít nhất 2 dòng bạn không đồng ý, rồi mới commit.
3. **(15 phút)** Thêm một marketplace và cài 1 plugin nhỏ trong session Copilot harness (examples/17-2); đọc "hộp" của nó và trả lời: món nào trong plugin có thể chạy code trên máy bạn?
4. **(5 phút)** Tab Tools: tắt 2 tool repo này không cần, nêu rủi ro nếu để mở — và xác nhận enabling ≠ auto-approve.

## Link qua

- Session Target + khái niệm harness → bài 02. · `applyTo`, `AGENTS.md` → 03. · Prompt để draft "đúng ý" → 04. · Giải phẫu `SKILL.md` → 05. · Custom agents → 06. · Hooks → 07. · MCP → 08. · Permission levels → 10. · Review an toàn plugin/MCP trước khi cài → 16.
- Lệnh: [plugins](commands/copilot/system-knowledge/plugins/README.md) · [connector](commands/copilot/system-knowledge/connector/README.md) · [mcp-add](commands/copilot/system-knowledge/mcp-add/README.md) · [prompt file (Local)](commands/local/system-knowledge/prompt-file/README.md) · [participants (deprecated)](commands/local/model-agent/participants/README.md) · [troubleshoot](commands/copilot/chat-session/troubleshoot/README.md) · [sandbox policy](commands/copilot/model-agent/sandbox-policy/README.md).

## Reference

- VS Code — [Customizing your agent (overview)](https://code.visualstudio.com/docs/agent-customization/overview) · [Agent Plugins](https://code.visualstudio.com/docs/agent-customization/agent-plugins) · [Tools](https://code.visualstudio.com/docs/agent-customization/tools) · [Hooks](https://code.visualstudio.com/docs/agent-customization/hooks) · [MCP servers](https://code.visualstudio.com/docs/agent-customization/mcp-servers) · [Migrate customizations](https://code.visualstudio.com/docs/agent-customization/migrate-customizations)
- GitHub — [Agent skills (concept)](https://docs.github.com/en/copilot/concepts/customizations/agent-skills) · [About Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent) (surfaces + hooks) · [Hooks reference](https://docs.github.com/en/copilot/reference/hooks-reference) · [Copilot docs](https://docs.github.com/en/copilot)

**Chốt:** editor là nơi "thấy đúng cái harness đang thấy" — chọn đúng harness trước khi tạo, đọc hộp plugin trước khi cài, verify bằng References trước khi commit; và thuộc bảng routing: luật → 03, quy trình → 05, vai trò → 06, sự kiện → 07, kết nối → 08, plugin và quản lý một màn hình → bài này.
