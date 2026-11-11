# 10 — Modes, Permissions & Availability: ai lái, ai duyệt, plan nào mở gì

> **Dành cho:** dev đã dùng Copilot Chat và muốn trao quyền đúng mức cho từng task, tech lead muốn commit baseline duyệt tool, admin cần trả lời "vì sao plan này không thấy setting kia". Bài 10 là **chủ sở hữu matrix modes/permissions** mà bài 00/06/12 trỏ về.
> **Vấn đề:** allow hết thì agent tự chạy lệnh nguy hiểm; siết quá thì bấm Allow mỏi tay rồi bấm mù; còn "setting không thấy" thường bị kêu bug trong khi do plan hoặc do harness.
> **Đọc xong:** chọn đúng mode theo harness, set 3 permission levels + approval per-tool, bọc Autopilot bằng sandbox, biết plan nào mở tính năng gì. **Thời gian:** ~25 phút.

## Mục tiêu bài học

Mục này cho bạn biết sau 25 phút sẽ mang được gì về — danh sách núm vặn cần sờ tận tay trước khi mang vào họp team.

- Đọc thuộc **matrix modes × harness**: Ask/Edit là mode của **Local**; **Copilot harness** có built-in agents Ask/Plan/Agent với Autopilot là **agent mode** ở mode picker; **Cloud không phải harness** mà là execution target.
- Set được **3 permission levels** (Manual · Assisted · Allow all) + approval **allow/ask/deny** per-tool; khắc câu "bật tool ≠ auto-approve", "`[]` = lockdown, nhiều nguồn giao nhau".
- Dùng **sandbox** làm hàng rào cứng — vẫn chặn kể cả Allow all — và tra hàng rào thật bằng `/sandbox policy` + managed settings.
- Biết **plan nào mở tính năng gì**, AI Credits trừ thế nào — trước khi kêu bug.

> **Tóm gọn 1 câu:** Mode quyết định agent tự lái tới đâu, permission quyết định ai duyệt tool, sandbox quyết định hàng rào tới đâu, còn plan quyết định bạn có được thấy núm đó không.

---

## 1. Modes × harness — matrix mà bài 00/06/12 trỏ về đây

Cùng chữ "mode" nhưng mỗi harness nghĩa khác nhau — đây là bảng các bài khác dẫn về. Bốn câu hỏi trên bảng điều khiển (*ai lái · ai duyệt · tool nào được chạy · rào ở đâu*) trả lời riêng theo từng mục dưới đây:

| Nơi chạy phiên | Núm tự chủ ở mode picker (đúng tên docs) | Ghi chú |
|---|---|---|
| **Local harness** (Chat view VS Code) | **modes Ask / Edit / Agent** | Autopilot ở đây là permission level, không phải mode |
| **Copilot harness** (session VS Code, Agents window, CLI, Copilot app) | **built-in agents Ask / Plan / Agent**; **Autopilot = agent mode** | không có mode Edit |
| **Copilot in the cloud** (GitHub.com) | modes **Interactive / Autopilot** | bảng 3 núm: mục 6 |
| **Claude / Codex** (provider harness) | Claude: **permission modes** · Codex: **approval presets** — tên theo docs ở mục 4 | cùng ý tưởng, khác tên |

- **Ask** = chỉ đọc + trả lời. **Plan** = nghiên cứu, đề xuất kế hoạch, **không sửa file** dù bạn bảo "cứ code đi" (trong editor: [`/plan`](commands/copilot/code-actions/plan/README.md)). **Agent** = tự lập kế hoạch + sửa nhiều file + chạy test + lặp. Slug chi tiết từng núm: [`/ask`](commands/copilot/model-agent/ask-mode/README.md) · [`/agent`](commands/copilot/model-agent/agent-mode/README.md) · Autopilot ở CLI: bài 12 — 📄 ảnh 2 trạng thái picker: [`./examples/00-tong-quan-copilot/session-target-picker.md`](./examples/00-tong-quan-copilot/session-target-picker.md).
- **Autopilot**: tự duyệt mọi tool như Allow all, retry khi lỗi, tự trả lời câu hỏi chặn tiến trình — và **vẫn tiêu AI Credits như chat thường**; tiết kiệm công trông, không tiết kiệm tiền. Advanced Autopilot (Experimental) để model nhỏ riêng quyết "xong chưa", bật bằng `chat.autopilot.advanced.enabled`. Ở CLI, Shift+Tab xoay standard → plan → autopilot → bài 12.

```text
10 giay chon mode, dung vao harness cua ban:
- Task chua ro scope, chi can hieu     -> Ask
- Can duyet ban do truoc khi dong code -> Plan (Copilot) / Ask roi Edit (Local)
- Multi-file, chay test, tu iterate    -> Agent
- Viec dai, scope ro, repo co test     -> Agent + mode Autopilot, boc sandbox (muc 5) + git sach
```

> **Vì sao quan trọng?** Bài 00 và bài 12 dẫn thẳng vào bảng này; hiểu sai "mode thuộc về harness nào" thì mọi hướng dẫn sau lệch theo.
> **Nếu làm sai thì sao?** Dạy "leo thang Ask→Edit→Agent→cloud agent" như một chuỗi mode Copilot là sai — Edit không tồn tại ở Copilot harness; dùng Agent cho việc một dòng thì đốt Credits và mở rộng scope.

> ⚠️ **Khác biệt Local harness** (legacy, chỉ để so sánh): countdown auto-accept `chat.editing.autoAcceptDelay` chỉ có ở Local; `*.prompt.md`, participants ([README](commands/local/model-agent/participants/README.md)) và tool sets cũng chỉ sống ở Local; sandbox của Local chỉ bọc lệnh terminal, không enforce rule managed.

> **Tóm gọn 1 câu:** Ask là người chỉ nói, Plan vẽ bản đồ không đụng code, Agent làm hết — còn Autopilot nằm ở mode picker, không phải permission level.

## 2. Session Target: phiên chạy ở đâu, tay chân của ai

Model là "não"; **agent harness** là "tay chân + nhà xưởng" — điều phối model, context và tools. Docs gọi picker là *Choose an agent harness*:

| Target | Nó là gì | Điểm nổi bật | Chọn khi |
|---|---|---|---|
| **Local** | harness **legacy** trong extension host của editor | đóng cửa sổ là agent dừng; **không có** trong Agents window | cần tool built-in của editor hoặc customization cũ |
| **Copilot** | harness chạy trong **Agent Host** bằng Copilot SDK | session chạy nền cả khi tắt editor; tiếp nối Chat view ↔ Agents window ↔ máy khác | mặc định cho mọi việc trong khoá |
| **Claude / Codex** | harness thật của provider, hiện trong picker | bị **chặn** khi org bật enterprise-managed settings | chủ đích dùng agent của provider |
| **Cloud** | **không phải harness** — execution target chạy Copilot harness trên hạ tầng managed của GitHub | kết thúc bằng PR; không đụng local của bạn | mục 6 · chủ sở hữu bài 12 |

- Picker chỉ liệt kê harness đủ điều kiện: không thấy lựa chọn = chưa đăng nhập hoặc org policy chặn — xác nhận bằng `Developer: Policy Diagnostics`, đừng vội kết luận bug ([session-target](commands/copilot/model-agent/session-target/README.md)).
- File MCP khác nhau theo harness: **Copilot** đọc `.mcp.json` (root repo) + `~/.copilot/mcp-config.json`; `.vscode/mcp.json` là file của **Local** → bài 08. Local **không có nghĩa là offline**: model vẫn chạy trên service, Local chỉ quyết định *tay chân của ai* thực thi tool.

> **Vì sao quan trọng?** Cùng prompt cho kết quả khác nhau giữa hai phiên thường là do bảng này, không phải do model.
> **Nếu làm sai thì sao?** Giao việc cần file local cho Cloud → agent chịu, không có context; gộp "harness = VS Code" → tưởng đang chạy Copilot trong khi phiên vẫn là Local legacy.
> **Tóm gọn 1 câu:** Não là model, nhà xưởng là harness, cloud chỉ là nhà xưởng thuê của GitHub — đổi target không phải đổi model. 📄 Picker 2 trạng thái: [`./examples/00-tong-quan-copilot/session-target-picker.md`](./examples/00-tong-quan-copilot/session-target-picker.md) · file `.vscode/mcp.json` dạng thật: [`01-cach-goi-copy-paste.sh`](commands/local/system-knowledge/vscode-mcp-json/examples/01-cach-goi-copy-paste.sh).

## 3. Approval per tool: người gác cổng allow / ask / deny

**Nôm na:** người gác cổng trước máy bạn — việc đọc thì gật đầu cho qua, việc ghi/chạy thì hỏi, việc nguy hiểm thì chặn. Agent có quyền đọc file, chạy shell, gọi tool MCP; không có cổng thì một prompt injection nằm trong issue text là đủ để nó chạy lệnh phá hoặc gửi `.env` đi — docs ghi rõ **kết quả tool trả về cũng có thể chứa prompt injection**, và tool approval chặn cả hai hướng.

Baseline team — commit vào `.vscode/settings.json`:

```jsonc
{
  // terminal: true = tu chay; false = LUC NAO cung phai hoi (regex dat trong /.../)
  "chat.tools.terminal.autoApprove": {
    "git status": true, "git diff": true,
    "/^npm (test|lint)\\b/": true,
    "rm": false, "sudo": false, "/docker push/": false
  },
  // URL: "request" (thong di ra) khac quyet dinh voi "response" (thong chay vao context)
  "chat.tools.urls.autoApprove": {
    "https://docs.npmjs.com": true,
    "https://*.internal.example/*": { "approveRequest": true, "approveResponse": false }
  }
}
```

- **`deny > ask > allow`**: trong cùng scope, rule chặt thắng — deny ở đâu thì allow không lật được ở đó. Lệnh ghép chỉ tự chạy khi **mọi** subcommand đều thuộc phía allow.
- **Allowlist hiệu lực = intersection** giữa org policy + repo settings + personal: mỗi nguồn góp một phần hàng rào, giao nhau mới là ô mở; danh sách để `[]` là **lockdown** — không gì qua được. Rule `false` ở VS Code nghĩa là **bắt buộc duyệt tay**, không chặn hẳn — muốn chặn thật dùng sandbox (mục 5) hoặc cờ CLI `--deny-tool` / `--deny-paths` / `--deny-url` → bài 12.
- **Chat: Manage Tool Approval** (Command Palette) soát theo từng MCP server/extension; *Always Allow* ghi thẳng vào user settings của bạn; tool không bao giờ cho pre-approve → đặt `false` trong `chat.tools.eligibleForAutoApproval`. Và docs cảnh báo: auto-approval là **tiện ích best-effort, không phải security boundary** — lệnh cố tình làm tối nghĩa có thể lọt máy parse rule.

> **Vì sao quan trọng?** Đây là ma trận mà bài 06/08/16 dẫn về — nắm nó thì không cần đọc từng lệnh vẫn biết lệnh nào đáng sợ.
> **Nếu làm sai thì sao?** Allow write/delete cho "nhanh" → một injection là dọn hậu quả cả buổi; deny cả lệnh đọc lặp lại → mỏi tay rồi bấm mù, tự vô hiệu hóa cổng mình dựng.
> **Tóm gọn 1 câu:** Nới việc đọc, siết việc ghi/chạy — và nhớ chính sách hiệu lực là giao nhau của mọi nguồn, không phải của riêng file nào.

> 📄 **Code ví dụ (allow/ask/deny trong settings.json):** [`./examples/08-mcp-ket-noi-cong-cu-ngoai/approval-allow-ask-deny.jsonc`](./examples/08-mcp-ket-noi-cong-cu-ngoai/approval-allow-ask-deny.jsonc) · mẫu sandbox + managed: [`./examples/10-modes-permissions-availability/mau-sandbox-va-verify.jsonc`](./examples/10-modes-permissions-availability/mau-sandbox-va-verify.jsonc) · tra nhanh: [policy-approval](commands/copilot/model-agent/policy-approval/README.md)

## 4. Permission levels & auto-approve: Manual / Assisted / Allow all

Núm vặn này tự duyệt cho **cả phiên**, đặt TRƯỚC bộ rule per-tool mục 3; chọn ở permissions picker — docs gọi ba giá trị là **Allow access · Ask every time · Always allow**; phiên mới theo `chat.permissions.default` (org có thể đặt managed default; không áp được thì về Manual).

| Level (đúng tên docs) | Nó làm gì | Khi dùng |
|---|---|---|
| **Manual permissions** (default) | chạy đúng rule mục 3; chưa pre-approve thì phải bấm | mặc định hàng ngày |
| **Assisted permissions** | LLM judge chấm rủi ro từng tool call; judge không duyệt thì vẫn phải bấm — mà judge có thể chấm sai | khi mỏi tay mà vẫn muốn có lưới an toàn |
| **Allow all** | mọi tool call chạy không hỏi — **nhưng không gỡ được sandbox** (mục 5) | gần như không bao giờ |

> **Luật sắt: bật tool ≠ auto-approve.** Cho agent *thấy* tool (card Tools trong Agent Customizations editor — mở bằng `Chat: Open Customizations`, bài 17) khác với cho nó *được chạy*; chạy hay không do permission level + approval quyết. Trong CLI, `--available-tools` cũng chỉ thu hẹp danh sách tool *nhìn thấy*.

- Nới cả phiên: `/yolo` · `/autoApprove` (hủy bằng `/disableYolo` · `/disableAutoApprove`) — hỗ trợ ở local hoặc Copilot CLI session; `chat.tools.global.autoApprove` tắt cổng ở **mọi workspace**, chỉ bật khi hiểu mình vừa từ bỏ gì.
- **Autopilot vs Allow all:** Autopilot (mục 1) tự lái tới đích — retry, tự trả lời câu hỏi chặn; Allow all chỉ tắt popup per-call, không bảo đảm việc xong. Ở **Local**, Autopilot mới là permission level. Bẫy docs ghi rõ: session **worktree** ở Agents window luôn chạy Allow all — worktree cô lập code, không tạo lòng tin (bài 11).
- Cùng một ý tưởng, ba cách gọi: **Copilot** = permission levels (bảng trên) · **Claude** = permission modes (Edit automatically · Request approval · Plan) · **Codex** = approval presets (Default Permissions · Auto-Review · Full Access). Level bị org policy chặn vẫn **hiện nhưng disabled**, không biến mất.

> **Vì sao quan trọng?** Đây là matrix permission levels mà bài 06/08/16 trỏ về — vặn sai một núm là cả hệ thống approval đổi hành vi.
> **Nếu làm sai thì sao?** Tin LLM judge của Assisted tuyệt đối → quên mất nó chỉ là lưới; hàng rào thật là sandbox (mục 5).
> **Tóm gọn 1 câu:** Manual cho hàng ngày, Assisted khi mỏi tay nhưng vẫn muốn có lưới, Allow all gần như đừng bật — thứ thay nó là sandbox, không phải niềm tin.

## 5. Sandbox — hàng rào vẫn chặn khi bạn Allow all

**Nôm na:** cái cũi cho lệnh của agent — trong cũi thì chạy thoải mái vì đã bị khoanh chân; lệnh xin ra khỏi cũi mới cần tay bạn duyệt. Docs chốt: sandboxing **độc lập với permission level** — Allow all và Autopilot skip approval, nhưng sandbox đang bật vẫn cắt file system + network của lệnh terminal.

- Bật: `chat.agent.sandbox.enabled` = `off` (default) / `on`, hoặc toggle "Sandboxing for terminal" trong permissions picker (Copilot session). **Preview** trên macOS/Linux/WSL2, **Experimental** trên Windows; chạy bằng **MXC (Microsoft eXecution Container)** — macOS ≥15 Seatbelt, Linux/WSL2 bubblewrap + slirp4netns + iptables, Windows 11 BaseContainer; Alpine-musl và WSL1 không hỗ trợ.
- **Đừng đoán hàng rào, hãy đọc nó:** [`/sandbox policy`](commands/copilot/model-agent/sandbox-policy/README.md) in ra **chính sách hiệu lực kể cả khi sandbox đang tắt**; danh sách path/mạng của org + user + session **giao nhau** và mảng `[]` = **lockdown**.
- Enterprise enforce bằng managed settings: `sandbox.enabled`, `sandbox.failIfUnavailable` (máy không hỗ trợ thì **từ chối chạy**, không im lặng chạy trần), `sandbox.allowBypass`. Riêng **Local**: chỉ sandbox lệnh terminal, không enforce rule managed.
- Đừng nhầm với hàng rào khác: **git worktree** chỉ tách code — docs: "is not a security boundary" (bài 11); **cloud sandbox** là hạ tầng GitHub, không phải MXC trên máy bạn (mục 6). Mẫu cấu hình + verify: [`./examples/10-modes-permissions-availability/mau-sandbox-va-verify.jsonc`](./examples/10-modes-permissions-availability/mau-sandbox-va-verify.jsonc)

> **Vì sao quan trọng?** Approval là "ai bấm nút", sandbox là "nút đó đi tới đâu" — khi bạn bấm nhầm (hay Allow all), chỉ hàng rào còn tác dụng.
> **Nếu làm sai thì sao?** Bật sandbox rồi tưởng mạng đã kín — hàng rào phụ thuộc danh sách; quên `failIfUnavailable` thì máy không hỗ trợ âm thầm chạy trần.
> **Tóm gọn 1 câu:** Cổng do người gác, rào do máy dựng — cổng càng mở thì càng cần rào, và rào chỉ chắc khi bạn đọc được bản vẽ của nó.

## 6. Copilot in the cloud: 3 núm trên một màn hình

Tên theo docs GitHub 11/2026: **Copilot cloud agent** (con agent) và **Copilot in the cloud** (bề mặt chat + agent trên GitHub.com). Nhắc lại: **Cloud không phải harness** — là execution target chạy Copilot harness trên hạ tầng managed của GitHub. Mỗi phiên có 3 núm **độc lập** (chi tiết núm: [cloud-agent-session](commands/cloud/model-agent/cloud-agent-session/README.md); giao việc + workflow PR: chủ sở hữu bài 12):

| Núm | Giá trị theo docs | Mặc định |
|---|---|---|
| Mode | **Interactive / Autopilot** | Interactive |
| Tool permissions | **Assisted / Always ask / Allow all** | Assisted |
| Environment | **Cloud sandbox / GitHub Actions / Remote** | Cloud sandbox |

- Chỉ vặn mode sang Autopilot mà tool permissions vẫn **Always ask** → phiên đứng chờ duyệt từng hành động; ngược lại Autopilot + Allow all trên repo chưa có test là cặp dễ cháy. Trần **59 phút/phiên** chỉ áp cho environment chạy bằng GitHub Actions minutes — việc dài, giao khoán thì chọn Cloud sandbox.

> **Vì sao quan trọng?** Người giao việc trên cloud hay gộp "tự lái" thành một quyết định, trong khi docs tách thành ba câu hỏi rời.
> **Nếu làm sai thì sao?** Chọn GitHub Actions cho việc dài → phiên bị cắt giữa đường vì chạm trần minutes, không phải vì agent làm sai.
> **Tóm gọn 1 câu:** Trên cloud, *ai lái · ai duyệt · chạy ở đâu* là ba ô phải chọn riêng — đừng để chữ "Autopilot" tự trả lời cả ba.

## 7. Availability: plan nào mở gì & tiền trừ thế nào

| Khả năng | Free | Pro · Pro+ · Max | Business · Enterprise |
|---|---|---|---|
| Chat + built-in agents trên VS Code/CLI/app, cloud agent trên repo của bạn | ✓ | ✓ | ✓ |
| AI Credits kèm theo | allowance cố định | allowance tăng theo bậc | per-user, **gộp pool tại billing entity** |
| Org policy cho từng tính năng (bảng supported surfaces) · managed settings (sandbox, plugins) · content exclusion toàn org | ✗ | ✗ | ✓ |

**AI Credits — khung tiền đủ để quyết chuyện permissions** (chọn model + bảng giá đầy đủ: chủ sở hữu bài 14 · cờ `--max-ai-credits` trong CLI: [`ai-credits`](commands/copilot/model-agent/ai-credits/README.md) · content exclusion / duplication detection / telemetry & audit: đọc ở bài 07 · 13):

- **1 credit = $0,01**, tính **per-token**: câu Ask một dòng gần như miễn phí, phiên Agent cày cả repo thì đắt — nên "mode nào cho việc nào" cũng là quyết định tài chính. Hết allowance thì trừ tiếp theo budget: **Bundled AI credits budget** + "Stop usage when budget limit is reached" (cap được về $0).
- **Code completions & next edit suggestions KHÔNG trừ Credits** — không giới hạn trên mọi plan trả phí.
- **Code review** billing hai đường: Credits theo **review effort Lite / Balanced / Max** — tiêu thụ per-token, con số ~$0.25/$1.50/$10 mỗi review trong docs chỉ là **ước tính, không phải số cố định** — cộng **GitHub Actions minutes** → bài 15.

```text
"Setting X khong thay / khong chay?" - 4 cau hoi truoc khi bao bug:
1. Plan nao? (bang tren: chinh sach org/managed chi co o Business/Enterprise)
2. Dung harness nao? (Edit + autoAcceptDelay chi Local; Assisted va /sandbox policy chi Copilot; Claude/Codex bi chan khi org bat managed settings)
3. Level dang bi xam? = org policy chan -> hoi admin, dung lay personal setting "lach";
   reload window, org policy can thoi gian ngam, xac nhan bang Developer: Policy Diagnostics
4. Van khong -> tra bang supported-surfaces-for-policies roi moi ket luan bug
```

> **Vì sao quan trọng?** Phân nửa báo cáo "Copilot lỗi" trong kênh team là do vặn núm mà plan hoặc harness không có.
> **Nếu làm sai thì sao?** Đem personal setting ra "phá" org deny → intersection và deny thắng mọi nơi, chỉ mất buổi chiều.
> **Tóm gọn 1 câu:** Tính năng hiện hay không đi theo plan + harness — kiểm cả hai trước khi kêu bug; và tiền đi theo token chứ không theo số request.

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| Dạy "leo thang Ask→Edit→Agent→cloud agent" như chuỗi mode Copilot | tập dùng Edit — mode không tồn tại ở Copilot harness | Local: modes Ask/Edit/Agent · Copilot: built-in agents Ask/Plan/Agent + Autopilot là agent mode (mục 1) |
| Gọi con agent trên GitHub.com bằng tên cũ | không tra được docs, link tài liệu sai | docs 11/2026: **Copilot cloud agent / Copilot in the cloud**; Cloud không phải harness (mục 6) |
| Dạy "hooks chỉ tồn tại ở Local" | chiến lược guardrail team sai một tầng | hooks chạy ở Copilot CLI + Copilot in the cloud (subset event); hook Local copy sang không giữ tool names → bài 07/17 |
| Coi rule `false` trong settings là chặn lệnh | lệnh destructive lọt qua vì bạn bấm Allow tiện tay | `false` = bắt buộc duyệt; chặn thật = sandbox (mục 5) / `--deny-*` (bài 12) / org policy |
| "Setting không thấy = bug" | báo bug vô hiệu, admin mất thời gian | chạy cây 4 câu hỏi mục 7 trước |

**Bài học:** ba tầng mode · approval · sandbox cùng trỏ một nguyên tắc — agent *làm được nhiều*, nhưng *được làm* phải ít hơn, và hàng rào do người vẽ.

## Best practices

- **Chọn mode thấp nhất làm được việc; nới đọc, siết ghi/chạy, rồi mới tới hàng rào.** *Vì sao?* Agent cho task một dòng vừa đốt AI Credits vì loop dài, vừa mở scope ngoài ý; đọc không có side effect, ghi/xoá/gửi đi mới là chỗ gây hại — mà approval chỉ là best-effort, chỉ sandbox là enforce thật.
- **Đặt deny ở org/repo thay vì personal.** *Vì sao?* allowlist hiệu lực = intersection và deny thắng mọi nơi; personal setting không cứu được baseline tệ.
- **Autopilot / Allow all chỉ trong worktree sạch + sandbox + repo có test.** *Vì sao?* không có lệnh verify thì bạn không biết agent làm đúng chưa; worktree không phải security boundary (bài 11).
- **Sau migrate Local→Copilot: chạy `Developer: Policy Diagnostics` + `/sandbox policy`.** *Vì sao?* docs ghi file gốc và file migrate **không sync nhau** — rule quên migrate là cổng mở âm thầm.

## Bài tập

1. **(5 phút)** Trong Copilot session, gõ [`/plan`](commands/copilot/code-actions/plan/README.md) cho một task multi-file: xác nhận nhận được kế hoạch chứ không phải diff; rồi cho Agent chạy theo plan vừa duyệt.
2. **(6 phút)** Chạy `/sandbox policy` với `chat.agent.sandbox.enabled` đang `off` rồi `on`: ghi lại gì đổi và gì giữ nguyên; tìm xem có danh sách nào đang `[]` (= lockdown) không.
3. **(6 phút)** Commit baseline mục 3 (đổi tên lệnh theo stack của bạn): verify `git diff` chạy thẳng, `rm` bị hỏi; mở `Chat: Manage Tool Approval` xem tool write nào đang "without approval" thì tắt.

## Link qua

- Matrix mode × harness dùng cho toàn khoá → [bài 00](./00-tong-quan-copilot.md) · custom agents + song song → [bài 06](./06-custom-agents-parallel.md) · MCP theo harness → [bài 08](./08-mcp-ket-noi-cong-cu-ngoai.md).
- CLI flags + workflow cloud agent → [bài 12](./12-copilot-sdk-ci-cd-automation.md) · model & bảng giá → [bài 14](./14-models-chon-model-dung.md) · kinh tế code review → [bài 15](./15-security-stack-5-tang.md) · org policy & validate → [bài 16](./16-extensions-mcp-bao-mat-validate.md) · card Tools & `Chat: Open Customizations` → [bài 17](./17-agent-customizations-hub.md) · lệnh tra cứu: [session-target](commands/copilot/model-agent/session-target/README.md) · [sandbox-policy](commands/copilot/model-agent/sandbox-policy/README.md) · [cloud-agent-session](commands/cloud/model-agent/cloud-agent-session/README.md) · [ai-credits](commands/copilot/model-agent/ai-credits/README.md).

## Reference

- VS Code — [Approvals & permissions](https://code.visualstudio.com/docs/agents/run/approvals) (permission levels, Autopilot, Claude/Codex, tool/URL/terminal approval) · [Agent sandboxing](https://code.visualstudio.com/docs/agents/run/agent-sandboxing) · [Agent harnesses](https://code.visualstudio.com/docs/agents/concepts/agent-harnesses) · [Move from Local to Copilot](https://code.visualstudio.com/docs/agents/run/move-to-copilot) · [AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)
- GitHub — [Models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) (AI Credits per-token, review effort) · [Supported surfaces for policies](https://docs.github.com/en/copilot/reference/supported-surfaces-for-policies) · [About local sandboxing](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/understanding-local-sandboxing) · [Copilot CLI reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference) · [About Copilot in the cloud](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent)

**Chốt:** mode cho biết agent đi tới đâu, permission cho biết ai được gật, sandbox cho biết hàng rào dừng ở đâu, và plan cho biết bạn có quyền thấy cả ba núm đó không. Nới đọc — siết ghi, nhớ `deny > ask > allow` cùng intersection, rồi hãy giao bàn phím cho Autopilot.
