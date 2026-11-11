# 05 — Agent Skills: Đóng Gói Workflow Lặp Lại (Chuẩn 2026)

> **Dành cho:** dev đã xong bài 03–04, dùng Copilot Chat cơ bản và hay phải gõ lại cùng một prompt (deploy, review, migrate, sinh test). Không cần biết DevOps hay tự xây tool.
> **Vấn đề:** việc lặp lại giống mỗi sáng chép lại cùng một tờ ghi chú dài — tốn token, dễ quên bước, ai trong team cũng nhớ một kiểu.
> **Đọc xong:** bạn viết được **1 Agent Skill** ở `.github/skills/<ten>/SKILL.md`, gọi nó bằng `/ten-skill`, để agent tự nạp khi đúng việc, và port prompt file cũ sang skill. **Thời gian:** ~30 phút.
>
> **Lưu ý 2026:** `.prompt.md` (prompt files) **chỉ chạy ở Local harness** trong VS Code — docs ghi nguyên văn *"Prompt files run only in Local harness sessions in the Chat view"*, và khi migrate thì Copilot harness **không nạp** `*.prompt.md`. File cũ vẫn dùng được ở Local, nhưng **việc mới nên tạo bằng Agent Skills** (`SKILL.md`, chuẩn mở [agentskills.io](https://agentskills.io), chạy ở Copilot harness · CLI · Copilot app · cloud agent).

## Mục tiêu bài học

Mục này cho bạn biết sau 30 phút sẽ mang được gì về — như danh sách đồ cần mua trước khi vào chợ.

- Viết được **1 Agent Skill** `.github/skills/<ten>/SKILL.md` đúng format docs: `name` trùng tên thư mục, `description` chứa luôn "khi nào dùng".
- Biết **2 cách gọi** skill: gõ `/ten-skill` (tay) hoặc để agent **tự nạp** khi prompt khớp `description` — và điều khiển bằng `user-invocable` / `disable-model-invocation`.
- Phân biệt **skill vs instructions vs agent**: fact cho mọi chat → instructions (bài 03); quy trình nhiều bước cho một việc → skill; persona + tool riêng → agent (bài 06).
- **Port được prompt file `.prompt.md` sang skill** trong 5 phút và verify skill đã thật sự nạp.

> **Tóm gọn 1 câu:** Việc gì lặp lại, đóng thành skill một lần — agent tự giở đúng trang sổ mỗi lần sau, không ai phải gõ lại gì.

---

## 1. Agent Skill là gì?

**Nôm na 1 câu:** Agent Skill là **sổ tay nghề chuẩn hoá** — một thư mục chứa `SKILL.md` (công thức) kèm `scripts/`, `references/`, `examples/` (đồ nghề). Agent đọc `name` + `description` để biết khi nào mở, chỉ mở khi khớp việc.

```text
KHÔNG skill: "deploy staging giúp. Nhớ: check git status, migration dry-run, deploy,
   smoke test, báo cáo PASS/FAIL..." -> ~100 token/lần, hay quên bước 2
CÓ skill:    "deploy staging giúp" -> agent tự nạp .github/skills/deploy-checklist/,
   chạy đủ 5 bước, báo cáo theo mẫu trong examples/.
```

**3 mức nạp — đây là điểm ăn tiền của skill** (docs VS Code, mục "How Copilot uses skills"):

| Mức | Cái gì vào context | Khi nào |
|---|---|---|
| 1. Discovery | chỉ `name` + `description` của **mọi** skill | đầu mỗi session — cài 20 skill vẫn gần như không tốn chỗ |
| 2. Instructions | thân `SKILL.md` | khi prompt khớp description, hoặc bạn gõ `/ten-skill` |
| 3. Resources | file được **reference** trong SKILL.md | chỉ khi agent cần; file không được nhắc tới thì **không bao giờ nạp** |

> **Vì sao quan trọng?** Nó biến "prompt dài" thành "tên gọi ngắn": viết một lần, cả team dùng chung một chuẩn, và cùng file đó chạy ở Copilot harness, CLI, Copilot app, cloud agent (và cả Claude Code/Codex — chỉ khác thư mục đặt).
> **Nếu làm sai?** `description` chung chung → skill **không bao giờ được tự nạp**, bạn tưởng nó hỏng; sai `name` → skill **âm thầm không load**, không báo lỗi.
> **Tóm gọn 1 câu:** Skill = sổ tay nghề có nhãn "dùng khi nào"; nhãn sai thì sách hay mấy cũng nằm im trên kệ.

## 2. Skill khác instructions, khác agent, khác plugin ở đâu

```text
Bạn nói/gõ → Việc gì?
- Fact/luật cần MỌI chat          -> .github/copilot-instructions.md (bài 03)
- Quy trình nhiều bước, theo việc -> Agent Skill  .github/skills/<ten>/SKILL.md   <- bai nay
- Persona + tool riêng            -> Custom agent  .github/agents/<TEN>.agent.md  (bài 06)
- Cách dùng MCP cho một quy trình -> skill gọi MCP (bài 08) — cặp bài trùng
- Gói nhiều skill/agent/MCP cho ≥3 repos -> Agent Plugin (bài 17)
```

Docs GitHub chốt: **instructions** cho chỉ dẫn đơn giản áp cho mọi task; **skills** cho chỉ dẫn chi tiết mà Copilot chỉ nên đọc khi thật sự relevant. ⚠️ **Chỗ hay vấp:** ở **Copilot harness**, skill quản lý bằng **Agent Customizations editor** (mục 4); slash `/skills` và `/create-skill` **chỉ tồn tại ở Local harness** — gõ trong session Copilot sẽ không thấy.

> **Tóm gọn 1 câu:** Luật nền → instructions; quy trình lặp → skill; chân dung người làm → agent; gói để chia sẻ → plugin. 📄 File thật của từng loại: [`templates/.github/copilot-instructions.md`](../templates/.github/copilot-instructions.md) · [`templates/.github/skills/review-pr/SKILL.md`](../templates/.github/skills/review-pr/SKILL.md) · [`templates/.github/agents/tester.agent.md`](../templates/.github/agents/tester.agent.md) · [`./examples/05-agent-skills-reusable-workflows/plugin-marketplace.sh`](./examples/05-agent-skills-reusable-workflows/plugin-marketplace.sh)

## 3. Giải phẫu `SKILL.md`

Một skill = **một thư mục**, file bắt buộc tên `SKILL.md` (docs GitHub: *"Skill files must be named `SKILL.md`"*).

```markdown
---
name: deploy-checklist          # bat buoc = ten thu muc, chi a-z 0-9 va dau -
description: >                  # bat buoc: "lam gi" + "khi nao dung"
  Deploy staging/prod theo checklist migrate + smoke test.
  Dung khi user noi deploy, release, ship, xuat ban.
---
# Deploy checklist
1. `git status --short` phai sach; neu khong -> dung va bao.
2. Migration dry-run: chay `scripts/migrate.sh dry`.
3. Deploy theo lenh da verify trong `.github/copilot-instructions.md`.
4. Smoke test cac endpoint liet ke trong `references/endpoints.md`.
5. Ghi ket qua theo mau o `examples/output.md`.

**Cam:** NEVER deploy khi chua co xac nhan ro rang trong message cua user.
```

| Field | Bắt buộc | Nguồn docs | Ý nghĩa |
|---|---|---|---|
| `name` | ✅ | cả hai | ≤64 ký tự, **chỉ chữ thường + số + `-`** (VS Code). VS Code: **bắt buộc trùng tên thư mục cha**; docs GitHub: "thường thì trùng". Cấm `/` `:` `.` và tiền tố namespace → ký tự sai khiến skill **âm thầm không load** |
| `description` | ✅ | cả hai | ≤1024 (con số này là **VS Code docs**). Nêu **cả "khi nào dùng"** — tín hiệu duy nhất agent dùng để quyết định nạp (câu đầu = danh sách từ khoá user thật nói) |
| `argument-hint` | ✗ | VS Code | chỉ **gợi ý hiển thị** khi gọi `/skill` — không phải biến nội suy |
| `user-invocable` | ✗ | VS Code | default `true`; `false` = ẩn khỏi menu `/` nhưng agent vẫn tự nạp được |
| `disable-model-invocation` | ✗ | VS Code | default `false`; `true` = **chỉ** chạy khi bạn gõ `/skill` |
| `context: fork` | ✗ | VS Code | chạy trong subagent riêng, chỉ trả kết quả cuối → context chính sạch. Cần feature `forked-skill-context` + `github.copilot.chat.skillTool.enabled` |
| `license` · `allowed-tools` | ✗ | docs GitHub | licence / pre-approve tool (vd `allowed-tools: shell`) — **cẩn thận**, xem cảnh báo mục 7 |

**Thân file:** markdown tự do, docs gợi ý đúng 4 khối: *làm gì · khi nào dùng · các bước · output mẫu*. Reference file bằng **link markdown hoặc `#file:`** với đường dẫn **tương đối tới `SKILL.md`**, dùng `/` cho port. Kèm **script đã verify** (`scripts/migrate.sh`, `chmod +x`) thì chắc tay hơn để agent "tự nhớ" lệnh dài — mẫu: [`./examples/05-agent-skills-reusable-workflows/mau-b-skill-add-table-script.sh`](./examples/05-agent-skills-reusable-workflows/mau-b-skill-add-table-script.sh). **Docs của skill không khai báo biến nội suy nào** — `${input:...}`/`${selection}` là cú pháp của **prompt files** (Local harness), `${workspaceFolder}` là của tasks; `SKILL.md` chỉ nhận phần bạn viết sau lệnh: `/deploy-checklist staging, bỏ qua smoke test`.

> **Tóm gọn 1 câu:** `name` để hệ thống tìm, `description` để agent quyết định, thân file để làm đúng — thiếu một trong ba là skill vô dụng.

## 4. Tạo skill: Copilot harness làm qua editor

`/skills` và `/create-skill` là **"Local harness shortcuts"** (docs VS Code). Với **Copilot harness** (session mặc định trong VS Code, Agents window, Copilot CLI):

1. Chọn harness đúng ở Session Target → mở **`Chat: Open Customizations`** (Command Palette) → tab **Skills**. Trong Agents window: **Customizations** ở sidebar.
2. **New Skill** (dấu `+`) → **Workspace** (`.github/skills/<ten>/`, commit được, cả team dùng) hoặc **User** (`~/.copilot/skills/<ten>/`, chỉ máy bạn).
3. Điền `name`, viết `description` có "khi nào dùng" + các bước → **verify theo mục 6**, đừng tin "tạo xong là chạy".

**Ngắn nhất (docs khuyến nghị):** để agent viết hộ — *"Create a project skill named test-changes in a location supported by this harness. It should identify and run the relevant tests for a code change using this repository's documented commands, then report what passed, failed, or wasn't run."* Hoặc ngay sau một buổi làm việc tốt: *"create a skill from how we just debugged that."*

| Harness | Project skill | Personal skill |
|---|---|---|
| **Copilot** (VS Code session mặc định, CLI, Copilot app, cloud agent) | `.github/skills/` (docs GitHub đọc thêm `.claude/skills/`, `.agents/skills/`) | `~/.copilot/skills/` hoặc `~/.agents/skills/` — muốn cloud sandbox thấy thì đưa vào **dotfiles repo** ở `.copilot/skills/` (**không áp dụng** session GitHub Actions) |
| **Local** (VS Code) | `.github/skills/` — docs VS Code ghi thêm `.claude/skills/`, `.agents/skills/` | `~/.copilot/skills/` — docs VS Code ghi thêm `~/.claude/skills/`, `~/.agents/skills/` |

> Docs VS Code: trùng `name` giữa các workspace root thì **root chính thắng**; **Local harness không có trong Agents window** (ở Chat view phải bật `chat.editor.localAgent.enabled`, Copilot là mặc định), và Session Target **chỉ liệt kê harness nào đủ điều kiện** — không thấy lựa chọn là chưa đủ điều kiện, không phải tính năng bị bỏ.

## 5. Gọi skill: bằng tay hay để agent tự giác

Type `/` trong ô chat → skill hiện cùng danh sách lệnh, và phần bạn viết sau tên chính là ngữ cảnh: `/code-review cho #123, tập trung chỗ auth`.

| Cấu hình | Gõ `/ten-skill`? | Agent tự nạp? | Dùng cho |
|---|---|---|---|
| mặc định (bỏ 2 field) | ✅ | ✅ | skill đa dụng — **chọn cái này khi mới học** |
| `user-invocable: false` | ❌ | ✅ | "kiến thức nền" agent nên tự đọc, không cần menu |
| `disable-model-invocation: true` | ✅ | ❌ | skill mạnh/nhạy (deploy, xoá data) — **bắt buộc người gọi** |
| cả hai | ❌ | ❌ | tắt tạm mà không xoá file |

Skill đóng gói trong **Agent Plugin** bị đặt tiền tố tự động: `/my-plugin:test-runner`. Đừng tự nhét `myorg/` hay `myorg:` vào `name` — docs ghi rõ **skill sẽ âm thầm không load**. Muốn **Copilot code review** chắc chắn đọc skill: đặt tên thư mục `code-review` (docs GitHub).

> **Tóm gọn 1 câu:** Mặc định để cả hai cửa cùng mở; skill nào chạm production thì `disable-model-invocation: true`.

## 6. Verify skill (đừng bỏ qua bước này)

Ba kiểm tra của docs VS Code, làm theo thứ tự trong session **mới**, **đúng harness** dự định dùng:

1. Gõ `/` → skill có trong menu? Không → sai `name`/tên thư mục, hoặc skill đặt ở đường dẫn harness đó không đọc (mục 4).
2. Có trong menu → **gõ tay** `/ten-skill <việc nhỏ>`, xem tool activity + kết quả có đi đúng steps không.
3. Muốn agent **tự nạp** → test **tách riêng** bằng câu nói khớp description. Menu liệt kê ≠ agent sẽ chọn — docs nói rõ discovery không đảm bảo selection. Không tự nạp gần như luôn do `description` thiếu từ khoá bạn thật sự nói.

## 7. Lấy skill có sẵn: `gh skill`

**`gh skill`** — public preview, cần GitHub CLI ≥ **2.90.0**:

```bash
gh skill search TOPIC                            # tim theo chu de
gh skill preview OWNER/REPO SKILL                # doc SKILL.md + cay file TRUONG hop, khong cai
gh skill install github/awesome-copilot documentation-writer
gh skill install OWNER/REPO SKILL --pin v1.2.0   # @TAG hoac --pin, khong dung ca hai
gh skill update --all                             # skill da pin se bi bo qua
gh skill publish --dry-run                        # validate theo agentskills.io, khong up
```

`gh skill install` tự để vào đúng thư mục cho harness (mặc định Copilot, project scope) và ghi **provenance metadata** (repo, ref, tree SHA) vào frontmatter để `update` sau này.

> ⚠️ Docs cảnh báo nguyên văn: *"Skills are not verified by GitHub and may contain prompt injections, hidden instructions, or malicious scripts"* — luôn `gh skill preview` trước khi cài, và chỉ đặt `allowed-tools: shell` khi bạn **đã đọc hết script** trong skill đó.

Trong VS Code: **Customizations editor → Browse → GitHub Feed** (experimental, tìm theo `@type:skill`), và plugin marketplace (`gh copilot plugin marketplace add`) chứa skill đóng gói — chi tiết ở bài 17. 📄 Mẫu cây skill + SKILL.md: [`templates/.github/skills/review-pr/`](../templates/.github/skills/review-pr/) · script tạo skill đầu tay: [`./examples/05-agent-skills-reusable-workflows/walkthrough-5-phut-skill-au-tien-cua.sh`](./examples/05-agent-skills-reusable-workflows/walkthrough-5-phut-skill-au-tien-cua.sh).

## 8. Port prompt file `.prompt.md` sang skill (5 phút)

Prompt file vẫn hợp lệ ở Local harness, nhưng chỉ chạy ở đó — port sang skill là cách duy nhất để một workflow chạy được cả editor, CLI, app, cloud agent.

1. `mkdir -p .github/skills/<ten>/{scripts,references}`, tạo `SKILL.md`, copy body prompt vào, đổi `name` = **tên thư mục**, giữ/soạn lại `description` (đây là trigger).
2. Gắn **`disable-model-invocation: true`** — prompt file vốn chỉ chạy khi gọi tay, field này giữ hành vi không đổi.
3. Mất gì khi port: docs migrate ghi rõ 3 field của prompt file **không** map sang → `agent`, `model`, `tools` (muốn buộc persona → custom agent bài 06; muốn siết tool → permissions bài 10).
4. Test xong (mục 6) mới xoá file cũ.

> 📄 Các bước copy-paste: [`./examples/00-tong-quan-copilot/port-prompt-file-cu-sang-skill.sh`](./examples/00-tong-quan-copilot/port-prompt-file-cu-sang-skill.sh)

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| `description: "Hỗ trợ các việc liên quan đến code"` | không bao giờ tự nạp | `"Deploy staging/prod theo checklist. Dùng khi user nói deploy, release, ship."` |
| `name: MySkill` / `myorg/skill` / khác tên thư mục | **skill không load, không báo lỗi** | trùng khớp tuyệt đối, chữ thường + `-` |
| 150 dòng steps trong `SKILL.md`, key API nằm ở bước 3 | agent bỏ giữa chừng + lộ secret | ≤10 steps; chi tiết dài xuống `references/`; key nằm trong secrets (bài 15) |
| Skill tự tay deploy vì nghe "deploy đi" | deploy nhầm môi trường | `disable-model-invocation: true` + NEVER-confirm + luôn dry-run trước |

**Best practices (kèm vì sao):**

- **Một skill = một việc.** *Vì sao:* description càng hẹp, xác suất agent chọn đúng càng cao, và mức 3 (resources) không bị nạp oan.
- **Câu đầu `description` liệt kê từ khoá user thật nói.** *Vì sao:* đó là tín hiệu duy nhất ở mức discovery.
- **Commit skill vào `.github/skills/`, đừng chỉ để `~/.copilot/`.** *Vì sao:* personal skill chỉ mình bạn thấy — chuẩn team chết ngay khi bạn nghỉ.
- **Đừng bắt đầu bằng plugin.** *Vì sao:* skill lẻ copy được sang repo thứ 2; plugin chỉ đáng khi bạn chép tay sang repo thứ 3 (bài 17).

## Bài tập

1. Tạo skill `gen-test` (mẫu: [`./examples/05-agent-skills-reusable-workflows/walkthrough-5-phut-skill-au-tien-cua.sh`](./examples/05-agent-skills-reusable-workflows/walkthrough-5-phut-skill-au-tien-cua.sh)), rồi làm đủ 3 bước verify mục 6.
2. Chạy `gh skill preview` một skill trong `github/awesome-copilot` — đọc `SKILL.md` trước, quyết định có cài hay không, và nói vì sao.
3. Port một `.prompt.md` bạn đang dùng sang skill (mục 8), giữ `disable-model-invocation: true`, so sánh hành vi giữa Local và Copilot session.

## Link qua

- Luật nền, `applyTo`, `AGENTS.md` → bài 03. · Bí quyết viết prompt để skill được chọn đúng → bài 04.
- Persona + tool riêng cho agent → bài 06. · Skill gọi MCP theo quy trình → bài 08.
- Nơi đặt skill và thư mục `.claude` / `.agents` khi song song Claude Code, Codex → bài 02.
- Đóng gói nhiều skill + agent + MCP để chia sẻ → **bài 17** (Agent Plugins).

## Reference

- VS Code — [Use Agent Skills](https://code.visualstudio.com/docs/agent-customization/agent-skills) (frontmatter, skill locations, `user-invocable`, `context: fork`, verify) · [Prompt files](https://code.visualstudio.com/docs/agent-customization/prompt-files) · [Migrate customizations](https://code.visualstudio.com/docs/agent-customization/migrate-customizations)
- GitHub — [Agent skills (concept)](https://docs.github.com/en/copilot/concepts/customizations/agent-skills) · [Adding agent skills](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills) (`allowed-tools`, code review, `gh skill`) · Chuẩn mở: [agentskills.io specification](https://agentskills.io/specification) · [awesome-copilot skills](https://awesome-copilot.github.com/skills/)

**Chốt:** việc lặp lại ≥2 lần thì đáng thành skill — `name` trùng thư mục, `description` có "khi nào dùng", thân ≤10 steps, phần nặng xuống `scripts/` + `references/`, và **luôn verify bằng session đúng harness**.
