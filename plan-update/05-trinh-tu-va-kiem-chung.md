# 05 — Trình tự thực hiện & kiểm chứng

> Phạm vi file này: **thứ tự làm, script, và gate**. Nội dung làm gì ở từng bài nằm ở `03`, từng lệnh ở `04`.

## 0. Tình trạng chốt (10/11/2026)

**(a) ✅ ĐÃ CHỐT — tiêu chí bucket `copilot/`** (xem `04` §1): *slug thuộc `copilot/` nếu lệnh chạy được trong Copilot harness session* → **47 slug: copilot 36 · local 6 · cloud 4 · xoá `extensions` 1**; sau khi thêm 9 slug + 2 rename: **copilot 42 · local 8 · cloud 5 = 55**. Kèm tie-breaker "hành động harness-agnostic → `copilot/`" (file `04` §1). Phương án hẹp hơn ("chỉ Copilot harness") sẽ đảo ~30 slug sang `local/` và đi ngược yêu cầu "khoá học chỉ dạy Copilot harness".

**(b) ⏳ VIỆC CÒN LẠI — 5 kết quả phải verify bằng mắt trong session thật** (VS Code 1.127+ / Copilot CLI, 15 phút, không tự động hoá được):

| # | Câu hỏi | Nếu khác giả định |
|---|---|---|
| 1 | `Chat: Export Chat…` có chạy trong Copilot session? (đang xếp `local/`) | nếu **có** → `export` về `copilot/` (43/7) |
| 2 | Quick Chat (`Ctrl+Shift+Alt+L`) mở được khi session đang Copilot harness? | `quick-chat` → `local/` |
| 3 | `/rename` có trong session Copilot harness (docs chỉ hứa "in a local chat")? | README `history`/`shortcuts` ghi "Local" |
| 4 | Checkpoints: `Restore Checkpoint` hiện trong session Copilot? | `checkpoints` → `local/` |
| 5 | Copilot CLI: `/status` `/settings` `/permissions` `/plugin` `/sandbox` `/model` `/compact` `/resume` — slash nào có thật? | xoá/gắn nhãn theo thực tế (docs GitHub đã xác nhận `/status`, `/sandbox`, `/plugin`, `/permissions`, `/limits`) |

> Kết quả verify ghi vào `plan-update/07-bien-ban-verify.md` (tạo mới khi làm W0) — mọi sửa đổi về sau viện dẫn file này.

## 1. ba nguyên tắc an toàn

1. **Move trước, sửa sau.** W2 chỉ đổi đường dẫn + link, **không sửa một chữ nào** → diff thuần cơ học, `git mv` detect được, link-check xanh là đủ tin.
2. **Một wave = một gate.** Không sang wave sau khi gate chưa xanh. Không commit trộn 2 wave.
3. **Không xoá nội dung để "chữa cháy" độ dài.** Nếu bài vượt 210 dòng mà chưa cắt được vì cần nó cho ownership → ghi `TODO-don` và đưa vào W7, đừng phá mạch bài.

## 2. Các wave

### W0 — Nền (0,5 ngày)
- Chốt (a)(b) ở §0; tạo `plan-update/07-bien-ban-verify.md`.
- Chụp baseline: `bash plan-update/scripts/baseline.sh` (số dòng từng file + tổng link + số link gãy).
- Tạo **`commands/bucket.tsv`**: 47 dòng `slug<TAB>group<TAB>bucket` — nguồn duy nhất cho script move (kèm 9 slug mới = 55).

### W1 — Đổi "luật" trước khi đổi nội dung (0,5 ngày)
| File | Sửa |
|---|---|
| `CONTRIBUTING.md:15,27,53` | **"300–450 dòng" → "150–200 dòng, hard cap 220"** (đây là gốc bệnh phình — sửa sau thì mọi bài mới lại phình); rule lệnh giữ 60–200 nhưng thêm "đích ≤95"; thêm luật mới: *mọi khẳng định phải thuộc nhóm A/B trong `plan-update/02` hoặc ghi "kinh nghiệm thực hành"* |
| `STYLE.md` | §3 giữ nguyên (format "Mục tiêu bài học" **không đổi**); §4 khuôn 13 mục giữ nguyên; thêm §7 "Nguồn docs": bắt buộc `Reference` dẫn URL `code.visualstudio.com/docs` hoặc `docs.github.com`, và quy tắc ghi nhãn surface (`VS Code Chat` / `Copilot CLI` / `Copilot in the cloud`) |
| `CHANGELOG.md` | mở mục `[Unreleased] — TÁI CẤU TRÚC THEO COPILOT HARNESS (11/2026)` + **sửa dòng 48: "code-actions 9" → 10**; ghi 3 con số: bài −2.225 dòng, commands 47→55 slug, link 663 → 0 gãy |

Gate: `grep -n "300–450" CONTRIBUTING.md` = 0 kết quả.

### W2 — Move + rewrite link (1 ngày, thuần cơ học)
```bash
mkdir -p 01-huong-dan-su-dung/commands/{copilot,local,cloud}
# move theo TỪNG SLUG (16/47 slug nằm cùng nhóm với slug khác bucket → không move theo nhóm)
while IFS=$'\t' read -r slug group bucket; do
  [ "$bucket" = "REMOVE" ] && continue
  mkdir -p "01-huong-dan-su-dung/commands/$bucket/$group"
  git mv "01-huong-dan-su-dung/commands/$group/$slug" "01-huong-dan-su-dung/commands/$bucket/$group/$slug"
done < 01-huong-dan-su-dung/commands/bucket.tsv
```
Rewrite link bằng **1 pass Node** (không dùng `sed` lặp `../` — dễ double-shift): quy tắc ở `04` §5, đã prototype (`link-class.js`). Điểm cần nhớ:
- **không đổi**: `../README.md` (group index, 47 chỗ) và sibling cùng bucket (10 chỗ).
- **đổi**: 25 sibling cross-bucket · 4 cross-group · 15 link bài học L3→L4 · **99 link repo-root L4→L5** (47 `CHEATSHEET.md` + 50 FAQ + 2 tips) · 80 link trong `examples/` (+1 cấp).
- **từ ngoài vào**: 47 link trỏ vào slug chèn `<bucket>/` (bài 04 **45**, folder README **2**) + 5 chỗ text (`CHANGELOG.md`, `README.md` gốc, `CONTRIBUTING.md`) + 4 chỗ ghi "47 lệnh" ở `README.md`/`CHEATSHEET.md`.
- xoá/sửa 3 footer group README lạc (`code-actions:103`, `model-agent:67`, `chat-session:69`). **Link gãy `09:57` ✅ đã sửa 2026-11-11** — nhưng chiều sửa ngược với ghi chú cũ: đúng là `../copilot-extensions-ai-powered/README.md` (bài học ở cấp 1, repo root là `..`), **không phải** `../../`. Toàn repo hiện **0 link gãy**.

Gate: `node plan-update/scripts/linkcheck.js` → **0 gãy**; `wc -l` của 47 README **bằng chính xác** baseline (chứng tỏ chưa sửa chữ).

### W3 — Sửa từ vựng toàn repo (1 ngày, cơ học + review)
Đã đo (trừ `plan-update/`, `.git.bak`):

| Chuỗi | Lần / file | Cách xử lý | được `sed`? |
|---|---|---|---|
| `premium` (premium requests/session) | 41 / 27 | → **AI credits** (1 credit = $0.01); con số $ phải có URL, không có thì bỏ | ✅ rồi review |
| `coding agent` | 210 / 40 | → **Copilot cloud agent / Copilot in the cloud** — nhưng phải đọc từng chỗ ("coding agent" chung chung ≠ tên sản phẩm) | ❌ hand-review |
| `@workspace` / `@terminal` | 139 / 38 | participants **deprecated, không chạy Copilot harness** → thay `#`-mentions / Add Context / agent tự gather | ❌ hand-review |
| `.vscode/mcp.json` | 57 / 32 | giữ ở ví dụ Local; mặc định dạy = **`.mcp.json`** + `~/.copilot/mcp-config.json` | ❌ |
| `/summarize` | 36 / 12 | → **`/compact`** (docs) | ✅ |
| `Shift+Alt+I` / `Ctrl+Shift+I` | 13/7 · 13/6 | → bảng phím `02` §3 (Quick Chat `Ctrl+Shift+Alt+L`, Chat view `Ctrl+Alt+I`, inline `Ctrl+I`) | ✅ |
| `Customizations Hub` | 12 / 8 | → **Agent Customizations editor** (`Chat: Open Customizations`) | ✅ |
| `Copilot Extensions` | 25 / 8 | retired 10/11/2025 → xem W6 | ❌ |

Gate: `grep -riE "premium request|Customizations Hub|/summarize|Shift\+Alt\+I" --include='*.md' .` (trừ `plan-update`, CHANGELOG lịch sử) = 0.

### W4 — Rewrite 18 bài theo `03` (3 ngày, song song được)
5 batch, mỗi batch 1 subagent/1 người, giao việc = dòng tương ứng trong bảng `03` §0:
- **B1 (overview + so sánh):** 00, 02, 10, 17 — *nén, không xoá quyền so sánh*
- **B2 (nền tảng):** 01, 03, 04
- **B3 (customization):** 05 ✅ **đã rewrite + đã rename** (200 dòng, xem `03` §05 "ĐÃ THỰC HIỆN" — khuôn cho 17 bài còn lại), còn 06, 08
- **B4 (governance):** 07 (rewrite hooks), 09 (rewrite extensions), 16
- **B5 (cloud/ops):** 11, 12, 13, 14, 15

Mỗi bài: sửa theo lệnh GIỮ/CẮT/SỬA/NỘP → cập nhật Mục lục + anchor → block "Mục tiêu bài học" **giữ format, chỉ siết gạch** → di chuyển nội dung đã cắt sang bài chủ sở hữu (đừng xoá mà mất nội dung có giá trị).

Gate: `bash plan-update/scripts/measure.sh` → mọi bài ≤210, trung bình ≤190; `grep -L "## Mục tiêu bài học" *.md` = 0.

### W5 — Tầng `commands/` (2 ngày)
- 36 README thuộc `copilot/`: sửa "Cách gọi" + "Lỗi thường gặp" theo docs (file `04` §2); thêm dòng harness trong mục Cách gọi.
- 6 slug `local/` + 4 `cloud/`: thêm block **"Harness: chỉ Local"** / **"Surface: Copilot in the cloud"** đầu bài (đây là thứ khiến bucket mới có nghĩa).
- 2 rename: `summarize → compact`, `premium-requests → ai-credits` (`git mv` + sửa `examples/` filenames + 3 index).
- Xoá `system-knowledge/extensions/` (nội dung → `plugins` mới + bài 09).
- Thêm 9 slug mới theo `04` §3 (P1 trước, P2 sau). Mỗi slug mới: đủ 13 mục + `examples/` (theo `STYLE.md` §4) — **mẫu để copy: `copilot/chat-session/clear/`** (đúng khuôn nhất).
- **Tách 4 group README → 9** (`copilot/` 4 nhóm, `local/` 3, `cloud/` 2) — nếu không làm, 12 footer `../README.md` gãy ngay sau W2 (file `04` §4).
- `commands/README.md` viết lại: bảng 55 lệnh **chia theo 3 bucket** + cột "Harness/Surface" + cột "Nguồn docs"; 3 bucket README mới (mỗi file ≤60 dòng).

Gate: 55 slug × 13 mục; `examples/` không giả định "4 file `.sh`" (12 slug chỉ 2 file, `content-exclusion` dùng `.jsonc`, `mcp-add` 6 file) — script QA đọc `examples/README.md`.

### W6 — Vùng ngoài folder 01 (1 ngày)
| Nơi | Việc |
|---|---|
| `README.md` (gốc) | 1 mention commands (dòng 43) + 2 chỗ "47 lệnh" (dòng 23, 59) → **55**; **12** chỗ "Customizations Hub" (toàn repo); bảng slash; `.vscode/mcp.json` neo → `.mcp.json`; "70 commands" → 55 |
| `CHEATSHEET.md` | 1 link commands (+bucket); `Ctrl+Shift+I` → bảng phím docs; `/summarize` → `/compact`; `premium` → AI credits; `Copilot Extensions` → Agent Plugins/MCP/connectors |
| `02-tips-thuc-chien/` (11 bài, 4.5k dòng) | 2 link commands; **`08-tiet-kiem-premium-requests.md` → rename `08-tiet-kiem-ai-credits.md`** + viết lại bảng giá; `09-teamwork-chuan-hoa.md` ("Customizations Hub"); `11-nang-cao-cli-web-coding-agent.md` (tên + nội dung cloud agent); `@workspace` ở 01/02/03/05/08 |
| `03-cau-hoi-thuong-gap/` (11 bài) | 50 link commands trỏ vào đây (phải +1 cấp — đã làm ở W2); `02-model-context-premium.md` (tên + thuật ngữ); `07-…coding-agent-workflows.md`; `04-mcp-faq.md` (`.vscode/mcp.json` → `.mcp.json`); 6 file `examples/*.sh` dẫn `.vscode/mcp.json` |
| `templates/` | `.vscode/mcp.json` + `settings.json` = **Local** → thêm `templates/.mcp.json` (Copilot harness) và ghi rõ trong `templates/README.md`; `*.prompt.md` → ghi nhãn "chỉ Local harness" hoặc **convert sang `.github/skills/<name>/SKILL.md`**; `copilot-instructions.md` giữ ✓ |
| `copilot-extensions-ai-powered/README.md` (178 dòng, EN) | §1 "Copilot Extensions — GA" đã **retired** → thêm cảnh báo đầu file + đổi chương thành "Agent Plugins / MCP / Copilot connectors"; **không xoá file** (là nguồn link của `09:57`) |

### W7 — QA cuối (0,5 ngày)
`bash plan-update/scripts/qa.sh` (mục 3) + đọc tay 3 trang: `commands/README.md`, `01-huong-dan-su-dung/README.md`, `README.md` gốc.

## 3. Ba script (viết ở `plan-update/scripts/`, không đụng nội dung)

**`baseline.sh`** — số dòng 18 bài + 47 README lệnh + tổng `examples/`; `git stash` an toàn trước/sau.

**`linkcheck.js`** — với mỗi link `](./…md|README.md)` trong `**/*.md`: resolve `path.relative`, kiểm `fs.existsSync`. Báo `file:line -> target`. Phải xanh (**0 gãy**) ở cuối W2, W5, W7. Bỏ qua link `http`, `#anchor`; kiểm tra thêm anchor `#…` trong file đích (`grep -i '^##.*<anchor text>'`).

**`qa.sh`** — 8 kiểm tra, exit ≠ 0 nếu fail:
1. `grep -L '^## Mục tiêu bài học' 01-huong-dan-su-dung/[0-1]*.md` = rỗng (18/18).
2. `awk 'END{print FILENAME, NR}'` mỗi bài ≤ 210; TB 150–200.
3. `grep -rniE "premium request|Agent Customizations Hub|/summarize|Shift\+Alt\+I|Ctrl\+Shift\+I\b|128 tools|virtualTools|Waza|/delegate|/policy|/customAgent"` (trừ `plan-update/`, `CHANGELOG.md`) = 0.
4. `grep -rn "\.vscode/mcp\.json" 01-huong-dan-su-dung/commands/copilot` = 0 (đường dẫn Local không được sống trong bucket Copilot).
5. Mỗi `README.md` trong `commands/` có 13 heading mục theo `STYLE.md` §4 + có dòng `Harness:` hoặc `Surface:`.
6. `linkcheck.js` = 0.
7. `commands/bucket.tsv` khớp 1-1 với cây thư mục (`diff <(ls -d commands/*/*/*/ | …)`).
8. Mỗi bài có ≥1 link vào `examples/` (bài 17 hiện **0** — bắt buộc sửa).

## 4. Acceptance criteria (khi nào được coi là xong)

- [ ] Khoá học dạy **Copilot harness làm mặc định**: mọi ví dụ copy-paste chạy được trong session Copilot; ví dụ Local chỉ xuất hiện trong block "⚠️ khác biệt Local harness" ≤6 dòng, ở 4 bài (00/02/10/17) + `commands/local/`.
- [ ] **18/18** giữ đúng format "Mục tiêu bài học"; tổng 5.460 → **≤3.300 dòng**; không bài nào >210.
- [ ] **55 slug** trong `commands/copilot|local|cloud/`, mỗi slug 13 mục + `examples/` khớp `README.md` của nó; `commands/README.md` chia theo harness.
- [ ] **0 link gãy** (toàn repo, kể cả `02-tips`, `03-FAQ`, `templates`, `copilot-extensions-ai-powered`).
- [ ] Mọi khẳng định về hành vi Copilot có URL `code.visualstudio.com/docs` **hoặc** `docs.github.com` trong mục Reference; cái không có nguồn đã bị cắt hoặc ghi rõ "kinh nghiệm thực hành".
- [ ] Không còn thuật ngữ ma: `premium requests`, `Agent Customizations Hub`, `/summarize`, `128 tools/request`, `virtualTools.threshold`, `Waza`, `/delegate`, `/policy`, `/customAgent`, "hooks chỉ Local", "Copilot Extensions GA".
- [ ] 3 mâu thuẫn nội tại đã được gỡ: phím Quick Chat · hooks · `.vscode/mcp.json` (xem `01` mục 4).
- [ ] `CONTRIBUTING.md`/`STYLE.md` đã đổi rule độ dài → bài mới không thể phình lại; `CHANGELOG.md` có mục mới + sửa số liệu sai ("code-actions 9").

## 5. Rủi ro & rollback

| Rủi ro | Giảm thiểu |
|---|---|
| W2 move xong, rewrite link sót → **237 link gãy** cùng lúc | Move trên branch riêng (`refactor/copilot-harness`), gate W2 bắt buộc `linkcheck.js` = 0; **không** sang W3 khi chưa 0 |
| Rename bài 05 (`05-prompt-files-…` → `05-agent-skills-…`) gãy link từ `commands/` (5 file) + 00:347 + CHEATSHEET | Làm ở W4-B3 với script thay 1 chuỗi cố định; kiểm bằng linkcheck |
| `sed` toàn cục phá tên file / link (`premium` nằm trong filename `08-tiet-kiem-premium-requests.md`) | W3 chỉ sed trong `.md` nội dung, **đường dẫn/filename đổi bằng `git mv` + rewrite link riêng** |
| Docs VS Code & docs.github đổi tiếp (khoá học vừa chốt 11/2026) | Mỗi claim có `Last verified: 2026-11-10` + URL; trang `02` là "luật" — khi docs đổi chỉ sửa `02` rồi chạy lại `qa.sh` |
| Mất nội dung quí khi cắt | Cắt = **dời** theo ownership map (`01` mục 3), không xoá; diff W4 review từng bài |
| User không đồng ý tiêu chí bucket | W2 là move — nếu đổi tiêu chí chỉ cần sửa `bucket.tsv` rồi chạy lại script trên tree gốc (`git reset --hard` W2) |
