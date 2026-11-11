# 15 — Security Stack 5 Tầng Cho Copilot (Defense-in-Depth, Không Tin 1 Lớp Nào)

> **Bài 15 series 01.** · **Dành cho:** dev đã dùng Copilot (muốn tự verify từng tầng) + admin/org owner (rà policy).
> **Vấn đề:** 1 lớp bảo mật luôn có lỗ — exclusion sai 1 path là secret lọt vào context, alert bị dismiss mà không ai hay.
> **Đọc xong:** dựng + verify được 5 tầng, chỉ ra được tầng team đang yếu và vá thế nào. · **Thời gian:** ~35 phút.
> **Cấu trúc series — bài 15 nằm ở tầng nào:** bài 01–13 dạy để agent *làm được việc*, bài 14 chọn model; bài 15 là tầng **quản trị** — mở sẵn cửa an toàn trước khi để agent bước vào; bài 16 đi trước một bước: "tầng 0" soi tool bên ngoài trước khi cài.

## Mục tiêu bài học

Mục này cho bạn biết sau ~35 phút sẽ mang được gì về — như danh sách ổ khóa cần lắp trước khi về nhà mới.

- Dựng **5 tầng** theo thứ tự nước đi: content exclusion → secret scanning/push protection → AI code review → review effort + auto-trigger → branch protection + audit trail.
- Nói đúng **giới hạn tầng 1 theo docs**: áp dụng surface nào, vì sao "không phải khóa an toàn filesystem", và hai chuyện không tồn tại (API tự phát hiện, "403 khi PR").
- Chọn **review effort** theo tiền thật: per-token AI credits + Actions minutes, rough guide không phải mức hứa.
- Chạy được buổi **audit 30 phút** với URL settings cho từng bước và chỉ ra tầng yếu nhất bằng evidence.

> **Tóm gọn 1 câu:** Không tầng nào một mình đáng tin — giá trị của stack nằm ở chỗ tầng trước trượt thì tầng sau đỡ, và tầng cuối cho biết chuyện đó đã xảy ra khi nào.

---

## 1. Stack 5 tầng — hiểu trước khi bật

**Nôm na:** nhà 5 ổ khóa — trộm phá được cổng thì kẹt cửa, phá được cửa thì kẹt két; không ổ nào "chống trộm" một mình, nhưng phá cả năm thì kẻ xấu bỏ cuộc. Mỗi gạch dưới trả lời đủ 3 câu: bật gì · vì sao · tắt thì sao.

- **Tầng 1 — Content exclusion.** *Bật gì:* danh sách path Copilot bị cấm đọc. *Vì sao:* rẻ nhất vì chặn từ "nguyên liệu" — file không vào context thì không thể bị trích dẫn. *Tắt thì sao:* `.env` vào chat/agent, secret đi theo transcript (§2).
- **Tầng 2 — Secret scanning + push protection.** *Bật gì:* quét key đã lọt + chặn push chứa key ngay tại cửa. *Vì sao:* bắt tại trận đỡ hơn sửa history. *Tắt thì sao:* key nằm im trong repo đến lúc kẻ xấu scrape (§3).
- **Tầng 3 — AI code review.** *Bật gì:* Copilot làm reviewer mỗi PR. *Vì sao:* mắt máy đọc diff mọi lúc, gắn severity từng comment. *Tắt thì sao:* bug logic phải chờ mắt người — hoặc không chờ ai cả (§4).
- **Tầng 4 — Review effort + auto-trigger.** *Bật gì:* mức Lite/Balanced/Max theo độ nhạy PR + auto-review cấu hình trong ruleset. *Vì sao:* đây là chỗ tiền AI credits chảy nhiều nhất và đều nhất. *Tắt thì sao:* hoặc đốt tiền review file rác, hoặc PR nhạy cảm không ai ngó (§5).
- **Tầng 5 — Branch protection + audit trail.** *Bật gì:* Rulesets required checks + audit log org. *Vì sao:* 4 tầng trên do người bật thì cũng do người tắt — tầng này ghi tên ai đã tắt. *Tắt thì sao:* stack "tự nhiên" trôi mất lúc nào không hay (§6–§7).

---

## 2. Tầng 1 — Content exclusion

**Định vị docs:** "Copilot bị làm cho mù một số file" — *guardrail cho các tool do GitHub kiểm soát*, không phải khóa access. Màn hình cá nhân: [github.com/settings/copilot/content-exclusion](https://github.com/settings/copilot/content-exclusion); org/repo: Settings → Copilot → Content exclusion (repo admin + org owner đặt; plan Business/Enterprise).

Những điều docs nói xảy ra với file bị exclude:

- Inline suggestions biến mất **ngay trong file đó** và nội dung của nó không còn tham gia nuôi gợi ý ở file khác — tức exclusion **không giết code completion toàn repo**, chỉ đúng file được gọi tên.
- Nội dung không đi vào câu trả lời của các surface chat/agent: **Copilot Chat, Copilot on GitHub mobile, Copilot in the cloud** (gồm cloud sandbox) — bảng availability còn đánh dấu ✓ cho **code review** và **Copilot CLI**.
- File bị exclude **không được Copilot code review** xem tới.

**Những gì docs KHÔNG nói — đừng dạy lẫn:**

- **Không có API tự phát hiện**: không có endpoint "liệt kê file bị exclude của session này"; verify bằng hành động — hỏi Copilot một chuỗi chỉ có trong `.env`, nó phải chịu không biết.
- **Không có "403 khi PR"**: bị exclude thì Copilot *mù*, không *cản* — không lỗi, không thông báo; triệu chứng duy nhất là "ít ngữ cảnh hơn". Mất gợi ý đúng một chỗ → nghi exclusion trước khi nghi bug ([content-exclusion](commands/cloud/system-knowledge/content-exclusion/README.md) · [troubleshoot](commands/copilot/chat-session/troubleshoot/README.md)).
- Giới hạn nguyên văn: *"not a filesystem security boundary"* — **symlink** và repo trên **remote filesystem** không áp dụng; **third-party MCP** servers/clients không được đảm bảo tôn trọng; thông tin gián tiếp (type info, hover, build config) vẫn có thể lọt. Kết luận: key nên ở ngoài repo (env, secret manager), không chỉ "được exclude".
- **Kinh nghiệm thực hành, không phải docs:** debug log của client nổi hai counter `excluded_files` / `excluded_chars` (một team rà gần đây ghi nhận ~25 file · ~60000 char); phình bất thường = tín hiệu chặn quá tay — chính cái đó khiến cả team tắt luôn exclusion.
- `.githubignore` là quy ước team "nhắc agent đừng đọc": nó là ghi chú trong repo, **không phải enforcement** — và đừng ghi key nội bộ vào file đó, người ngoài đọc được repo là đọc được luôn danh sách key.
- Công tắc cùng màn hình: "Suggestions matching public code" (duplication detection) Block/Allow — policy chi tiết thuộc **bài 07**.

> **Tóm gọn 1 câu:** Tầng 1 là "làm Copilot không thấy" — không thay được "đừng để key nằm trong repo"; hiểu sai hai chuyện này là gốc của mọi vụ "em đã exclude rồi mà".

---

## 3. Tầng 2 — Secret scanning & push protection

**Định vị:** tầng 1 làm Copilot mù, tầng 2 **khám mọi thứ lọt vào repo** — quét quá khứ + tương lai, alerts về Security tab; push protection chặn **ngay lúc push** khi phát hiện key. Bật: org/repo → Settings → Code security ([push protection](https://docs.github.com/en/code-security/concepts/secret-security/push-protection) · [secret scanning](https://docs.github.com/en/code-security/concepts/secret-security/secret-scanning)).

- Vì sao rẻ: key đã vào history thì revoke + xoay credential + dọn lịch sử luôn painful hơn giữ nó ngoài cửa rất nhiều — chốt tại push là chỗ sửa rẻ nhất.
- Agent cũng bị soi: cloud agent và code review chạy trên nền GitHub nên push của chúng đi qua push protection (docs có trang riêng cho GitHub MCP server và cho REST API).
- Bypass tồn tại (bypass request + delegated bypass) nhưng **mỗi lần bypass là một alert** — admin rà ở §7; "bypass cho nhanh" hằng ngày là cách tầng 2 chết âm thầm.
- Fix đúng khi bị chặn: bỏ secret khỏi diff → chuyển sang env/secret manager → commit lại; đừng đổi tên biến rồi push lại key cũ.
- Case study copy-paste (bị chặn / đã lọt / thử lửa an toàn): [`./examples/15-security-stack-5-tang/tang-2-secret-scanning-push-protection.sh`](./examples/15-security-stack-5-tang/tang-2-secret-scanning-push-protection.sh).

> **Tóm gọn 1 câu:** Push protection là chốt cửa trên thảm — key chưa kịp rời máy đã bị chặn; mỗi cú bấm "bypass" là bạn tự tay nới cái chốt đó ra.

---

## 4. Tầng 3 — AI code review

**Định vị:** reviewer máy đọc từng diff — request tay (Reviewers → Copilot → **Request**, hoặc `gh pr create --reviewer @copilot`) hay auto (Repo Settings → Copilot → Code review).

- Mặc định Copilot để review kiểu **Comment** — **không tính** vào required approvals; org có thể bật cho Copilot "Approve" nhưng quyết định merge vẫn là mắt người.
- Mỗi comment gắn severity High/Medium/Low — đọc để xếp hàng sửa, không phải để tin mù: đối chiếu từng comment, sai thì ghi lý do bác (thumb-down giúp cải thiện sản phẩm; và reply của bạn trên comment Copilot **không** được Copilot đọc lại).
- Instructions + skills đọc từ **head branch** — sửa `.github/copilot-instructions.md` ngay trong PR là test được luôn; skill tên thư mục `code-review` được code review ưu tiên nạp ([agent-skill](commands/copilot/system-knowledge/agent-skill/README.md) · bài 05) — 📄 Mẫu: [`templates/.github/skills/review-pr/SKILL.md`](../templates/.github/skills/review-pr/SKILL.md) · [`templates/.github/prompts/review-pr.prompt.md`](../templates/.github/prompts/review-pr.prompt.md).
- Hai toggle nên biết ở cùng màn hình: "Use custom instructions when reviewing pull requests" (bật cho PR nhạy cảm) và "Allow Copilot to use MCP tools when reviewing pull requests" — **mặc định đã bật**, tắt nếu team không muốn tool chạy lúc review.

> **Tóm gọn 1 câu:** Copilot review là một junior không biết mệt — đọc trước được mọi diff, nhưng không phải con dấu đóng lên merge.

---

## 5. Tầng 4 — Review effort & auto-trigger

Ba mức effort = ba mức "đốt token": **Lite** targeted (bug/security hiển hiện) · **Balanced** model reasoning cao cho logic phức tạp + security-sensitive · **Max** nhiều model reasoning cao cho PR cần soi kỹ nhất. Docs mô tả tiêu thụ bằng **AI credits theo token** — **không công bố mức cố định mỗi review**: rough guide ≈ $0,25 / $1,50 / $10 cho Lite/Balanced/Max và *"actual costs vary"* theo cỡ PR. Kinh nghiệm team ghi nhận xấp xỉ Lite ~$0,25 · Balanced ~$1,50 · Max ~$10 — đừng hứa con số với CFO, **đo bằng AI credits dashboard** (bài 13).

- Hóa đơn code review đi **hai đường**: AI credits (token) + **GitHub Actions minutes** tính riêng — effort tăng thì cả hai cùng tăng.
- Org owner / repo admin đặt **default effort** cho auto-review; từng PR đổi được ngay ở khối Reviewers trước khi request.
- **Auto-trigger cấu hình trong ruleset**: Copilot review khi PR mở, "Review new pushes" để re-review mỗi push, phạm vi repo/branch áp luật. Mẫu Rulesets hai khối `bypass_list` vs `pull_request_checks`: [`./examples/15-security-stack-5-tang/auto-review-rulesets.sh`](./examples/15-security-stack-5-tang/auto-review-rulesets.sh).
- Muốn vài file nằm ngoài review: thêm pattern trong settings hoặc `.github/copilot-audit.json` — **không có** lệnh `Copilot: Exclude from code review` như bản cũ từng dạy.
- Máy bạn là tầng 4 mini: `settings.json` → `"github.copilot.chat.agent.autoApprove": false` — đừng để agent tự duyệt tool của nó rồi PR sau mới vỡ.
- Cloud session chạy trong sandbox nhất thời — docs **không** nói checkpoints theo ra cloud; coi như **không có**: commit sớm, push thường, mất session là mất tiến độ thật.

> **`.github/copilot-audit.json` (quy ước repo — docs mỏng ở file này, xem là thực hành):** repo có file thì cloud agent đọc nó khi chạy task · ba khối chính `content_exclusion` / `review_triggers` / `audit_retention_days` · không đè được policy org, hai bên trái nhau thì nền tảng thắng · schema mẫu: [`./examples/15-security-stack-5-tang/copilot-review-rules.jsonc`](./examples/15-security-stack-5-tang/copilot-review-rules.jsonc).

> **Tham số chi phí cloud (blog GitHub 25/09/2025 — chỉ áp dụng **Copilot cloud agent chạy qua GitHub Actions**):**
> - Trung bình **59 phút/task** — con số của session chạy bằng Actions minutes; **session chat web/mobile không hạn chế này**.
> - Cùng blog: chi phí AI **~75% thấp hơn 2024** — số của blog, không phải cam kết docs.
> - Cloud sandbox bill theo usage, tách đường AI credits — tổng bill = credits + Actions + sandbox.

```text
# Mau prompt giao task cho cloud agent (mo issue tren github.com):
# "Nang cap dependency trong package.json. Quy tac an toan:
#  - KHONG doc/sua file trong content exclusion: .env*, secrets/, *.pem.
#  - Key lay tu env; thay key hard-code trong code thi dung va bao cao, khong tu doi.
#  - Commit tung buoc nho va push som (cloud session coi nhu khong co checkpoints).
#  - Mo PR, dua Copilot review + tests xong moi doi approve."
```

---

## 6. Tầng 5 — Branch protection & audit trail

**Định vị:** các tầng dưới chặn code, tầng này chặn *người đổi luật* — và lưu dấu vết cho ai muốn biết chuyện gì đã xảy ra.

- **Branch protection** (Repo Settings → Branches): require review (≥1 approve; team payments/auth đặt ≥2 — khuyến nghị thực hành), require status checks (CodeQL + tests + secret scanning xanh mới được merge), dismiss stale approvals khi push mới. Mẫu gh CLI: [`./examples/07-policies-guardrails-tu-dong-hoa/lop-5-branch-protection-required-checks.sh`](./examples/07-policies-guardrails-tu-dong-hoa/lop-5-branch-protection-required-checks.sh).
- **Rulesets** thay quản lý từng repo bằng một luật áp cho cả org — đọc hai khối cạnh nhau: `pull_request_checks` (PR phải qua gì) vs `bypass_list` (ai được đi tắt — càng ngắn càng tốt): [About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets).
- **Audit trail** — Org Settings → Logs → Audit log, lọc `operation:read/copilot`: docs có bảng event riêng cho hoạt động agent (`session_created`, `review_requested`, `review_completed`, ...): [Agentic audit log events](https://docs.github.com/en/copilot/reference/agentic-audit-log-events). Audit log **không chứa prompt text** — cần forensic prompt thì tự hook/telemetry (bài 07 + 13).
- managed-settings.json, network allowlist, MCP allow/deny — **bài 07 chủ sở hữu**; ở đây chỉ ghi: policy as code là chân của tầng 5, thiếu nó 4 tầng trên trôi theo từng admin mới.
- **BYOK (bring your own key)** — 3 gạch: (1) request đi thẳng provider bằng key của bạn → **không nằm cùng đường** audit + billing Copilot của org; (2) model allowlist org không khóa BYOK như khóa catalog dựng sẵn — phải đo ở phía gateway/proxy; (3) bảng BYOK theo surface: **bài 14** (nhiều model, xem bảng 14).

> **Tóm gọn 1 câu:** Tầng 5 là camera + khóa tổng — 4 tầng kia do người bật thì cũng do người tắt, và audit log là chỗ duy nhất giữ tên người đã tắt.

---

## 7. Audit 30 phút

Buổi rà định kỳ (mỗi quý, calendar block) — 6 gạch × 5 phút, cầm đúng URL settings mà mở.

- **(5′) Exclusion:** [github.com/settings/copilot/content-exclusion](https://github.com/settings/copilot/content-exclusion) (cá nhân) · [org → Settings → Copilot → Content exclusion](https://github.com/organizations/ORG/settings/copilot/content_exclusions) — repo mới sinh có được pattern cũ cover không?
- **(5′) Secret scanning/push protection:** [org → Settings → Security → Code security](https://github.com/organizations/ORG/settings/security_analysis) — ON cho *mọi* repo; bypass không lý do = red flag.
- **(5′) Code review toggles:** [repo → Settings → Copilot → Code review](https://github.com/OWNER/REPO/settings/copilot) — custom instructions bật chưa? MCP-tools-during-review còn đúng ý team không?
- **(5′) Effort + bill:** vẫn màn hình trên — default effort đang mức nào, ruleset "Review new pushes" bật chưa; đo chi phí tại [github.com/settings/copilot](https://github.com/settings/copilot) (AI credits usage).
- **(5′) Rulesets/branch protection:** [repo → Settings → Rules → Rulesets](https://github.com/OWNER/REPO/settings/rules) — main đã bắt review + required checks? `bypass_list` có phình?
- **(5′) Audit log:** [org → Settings → Logs → Audit log](https://github.com/organizations/ORG/settings/audit-log) với filter `operation:read/copilot` — tuần rồi ai dismiss alert, có lý do không?

**Ba việc nhanh — chọn 1 làm ngay trước khi đóng bài (mỗi gạch ghi tầng nó chạm):**

- Thêm `**/.env*` vào danh sách exclusion → **tầng 1** (thấy kết quả ngay cùng màn hình).
- Push thử file chứa fake key `sk-live-FAKE...` → **tầng 2** (chặn là nó sống; nhớ xóa commit thử ngay).
- Bật auto-review + default effort Balanced cho 1 repo nhạy cảm → **tầng 3–4** (đo bill 2 tuần sau ở gạch 4).
- Gắn 1 Ruleset cho main: ≥1 reviewer + required checks, bypass_list tối thiểu → **tầng 5**.
- Đặt calendar rà quý + ghi owner từng tầng vào tài liệu team → **toàn stack**.

---

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| Exclude nguyên `src/` cho chắc | Context rỗng, cả team tắt luôn exclusion vì "Copilot dumb" | Pattern tối thiểu; verify 2 chiều: file thường vẫn gợi ý, file secret thì không |
| Chờ "403 khi PR" hoặc tìm API liệt kê file bị exclude | Debug oan, mất niềm tin vào tầng 1 | Docs không hứa lỗi hay API đó — verify bằng cách hỏi Copilot chuỗi chỉ có trong `.env` |
| Bypass push protection thành thói quen | Tầng 2 chết âm thầm, key lọt không ai hay | Fix diff rồi push lại; đã lọt thì revoke ngay, mỗi bypass phải có lý do trong alert |
| Tin Copilot review như con dấu approve | Bug machine-generated đi qua ải máy | Nó để kiểu Comment — đối chiếu từng comment, bác bằng lý do, người mới đóng dấu |
| Hứa "Lite = N credit cố định mỗi review" | Bill thật lệch, mất niềm tin cả vào dashboard | Chi phí per-token theo cỡ PR — dẫn rough guide của docs rồi **đo** bằng AI credits dashboard |
| Áp "59 phút" cho mọi session trên mọi thiết bị | Tưởng mobile chat bị giới hạn y hệ thống | 59 phút là trung bình của **cloud agent chạy qua GitHub Actions** (§5) — web/mobile không hạn đó |

---

## Best practices

- **Đặt exclusion TRƯỚC khi bật index/agent.** *Vì sao:* index và context là ảnh chụp — secret lọt vào transcript rồi thì exclude sau cũng đã muộn.
- **Đối xử exclusion như "đóng vai mù", không phải khóa két.** *Vì sao:* docs ghi nguyên văn "not a filesystem security boundary" — symlink, MCP bên thứ ba, access gián tiếp đều lọt; key thật phải ở env/secret manager.
- **PR nhạy cảm → Balanced/Max; PR dependency lặt vặt → Lite.** *Vì sao:* effort tăng là AI credits + Actions minutes cùng tăng — trả tiền cho chỗ cần chiều sâu.
- **Required checks + dismiss stale approvals thay vì "tin nhau cả".** *Vì sao:* approve bản cũ rồi push bản mới merge là cửa lách kinh điển của tầng 3–5.
- **Đưa audit log vào calendar quý, đừng đợi incident.** *Vì sao:* stack không ai rà chết bằng những cú toggle nhỏ không ai nhớ.

## Bài tập

1. **(10′) Test tầng 1:** thêm `**/.env*` vào content exclusion (cá nhân hoặc nhờ admin), hỏi chat một chuỗi chỉ có trong `.env` — phải không biết; mở file thường — gợi ý vẫn phải còn.
2. **(15′) Drill tầng 2 + 4:** push file chứa fake key, đọc màn hình chặn; sau đó bật auto-review cho 1 repo test với default effort Balanced, 2 tuần sau mở [github.com/settings/copilot](https://github.com/settings/copilot) đọc con số AI credits thật.
3. **(15′) Policy as code tầng 5:** sửa [`./examples/15-security-stack-5-tang/auto-review-rulesets.sh`](./examples/15-security-stack-5-tang/auto-review-rulesets.sh) theo org của bạn (`bypass_list` là ai, `pull_request_checks` bắt gì); copy [`./examples/15-security-stack-5-tang/copilot-review-rules.jsonc`](./examples/15-security-stack-5-tang/copilot-review-rules.jsonc) thành `.github/copilot-audit.json` và cắt 3 khối cho đúng repo.

> **Ô cần điền:** Tầng tôi chưa bật: ____ · Prompt mẫu cho cloud agent: ____

## Link qua

- Policy chi tiết, managed-settings.json, network allowlist → **bài 07** · Quy ước secrets đưa vào instructions → **bài 03**.
- Skill `code-review` cho máy review → **bài 05** · Lỗ "MCP bên thứ ba không tôn trọng exclusion" → **bài 08** + [connector](commands/copilot/system-knowledge/connector/README.md).
- Cloud agent session (59 phút, sandbox, env): [cloud-agent-session](commands/cloud/model-agent/cloud-agent-session/README.md) · MCP config trong repo: [vscode-mcp-json](commands/local/system-knowledge/vscode-mcp-json/README.md).
- Policy sandbox hiệu dụng — agent được chạy gì: [sandbox-policy](commands/copilot/model-agent/sandbox-policy/README.md) · Tiền AI credits: [ai-credits](commands/copilot/model-agent/ai-credits/README.md).
- Dashboard đo block/alert → **bài 13** · Model allowlist + bảng BYOK (nhiều model, xem bảng 14) → **bài 14** · Validate tool trước khi cài ("tầng 0") → **bài 16**.
- So sánh Claude Code/Codex: một câu gọn — bảng đối chiếu đầy đủ nằm ở **bài 00**, không lặp lại ở đây.

## Reference

- GitHub — [Content exclusion](https://docs.github.com/en/copilot/concepts/content-exclusion): 4 tác dụng, bảng availability theo surface, nguyên văn giới hạn "not a filesystem security boundary".
- GitHub — [Push protection](https://docs.github.com/en/code-security/concepts/secret-security/push-protection) · [Secret scanning](https://docs.github.com/en/code-security/concepts/secret-security/secret-scanning).
- GitHub — [Using GitHub Copilot code review](https://docs.github.com/en/copilot/using-github-copilot/code-review/using-copilot-code-review): effort Lite/Balanced/Max + rough guide, mặc định Comment, ruleset "Review new pushes", toggle MCP tools, đọc instructions từ head branch.
- GitHub — [Models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing): AI credits per-token, 1 credit = $0.01 — review cost không phải số cố định.
- GitHub — [Agentic audit log events](https://docs.github.com/en/copilot/reference/agentic-audit-log-events) · [About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets).
- VS Code — [Review agent code edits](https://code.visualstudio.com/docs/agents/run/review-code-edits): checkpoints ở editor (mà không thấy docs nói chạy ở cloud — vì vậy §5 bảo commit sớm).
- GitHub blog (25/09/2025) — hai số "59 phút/task" và "chi phí AI ~75% thấp hơn 2024" trích ở box §5; các mốc $ của effort và `audit_retention_days` là **kinh nghiệm thực hành**, không phải bảng giá docs công bố cố định.

**Chốt:** "Security không phải cửa cuối — nó là cửa đầu tiên bạn phải mở sẵn trước khi để agent bước vào."
