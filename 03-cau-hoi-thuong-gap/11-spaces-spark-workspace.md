# FAQ 11 — Copilot Spaces, Spark & Workspace

> **Vấn đề:** ba cái tên "Spaces / Spark / Workspace" dễ nhầm vì docs cũ hay blog 2024 dẫn vào ngõ cụt — một cái đang GA, một cái đã gỡ 08/2026, một cái biến mất từ 2025. Bài này cho bạn trạng thái chính xác tại 10/2026 và đường thay thế.

## Trạng thái nhanh (verify 2026-10-28 với github.blog/changelog + docs.github.com/copilot)

| Tính năng | Trạng thái 10/2026 | Vị trí |
|---|---|---|
| **Copilot Spaces** | ✅ **GA** (24/09/2025) + Spaces API GA (18/05/2026) | github.com → Copilot → Spaces |
| **Copilot Spark** | ⚰️ **Đã gỡ** (đóng cửa 31/08/2026) | Không còn — app đã deploy vẫn chạy |
| **Copilot Workspace** | ⚰️ **Sunset 2025** — hấp thụ vào coding agent | Không còn — dùng coding agent |

---

## 1. Copilot Spaces là gì?

**Trả lời 1 câu:** Spaces là "thư mục ngữ cảnh" trên github.com — gom repos, files, issues, PRs, docs + custom instructions vào một nơi để Copilot trả lời dựa trên đúng bộ context đó, thay vì mỗi lần hỏi lại phải dán link.

- **Nguồn context:** repos, file/folder, issues, PRs, file markdown — nguồn từ GitHub tự đồng bộ khi repo thay đổi.
- **Custom instructions:** chỉ dẫn riêng cho Space (VD "trả lời theo chuẩn API của team").
- **Chia sẻ:** Space cá nhân = private / share user / public (view-only); Space org = admin/editor/viewer.

```text
1. github.com → Copilot → tab "Spaces" → "Create new space"
2. Đặt tên theo nhiệm vụ (VD: "Dự án billing", đừng đặt "Test 1")
3. Thêm nguồn: repo (tích thư mục cụ thể, đừng cả repo lớn) + issues/PRs + file md
4. Instructions 2-3 dòng: ràng buộc + format mong muốn
5. Chat thử 1 câu thật của nhiệm vụ
Verify: câu trả lời cite đúng file/repo bạn đã thêm
```

> **Sai lầm phổ biến:** ném cả org vào một Space → context loãng, trả lời lan man, tốn token. Space tốt = một nhiệm vụ, ít nguồn, instructions ngắn. **Không thấy Spaces:** cần Copilot license (mở cho mọi plan kể cả Free); thử `github.com/copilot/spaces` trực tiếp.

## 2. Copilot Spark là gì, giờ còn không?

**Trả lời 1 câu:** Spark là công cụ "vibe coding" tạo micro-app từ mô tả tự nhiên, nhưng đã **đóng cửa hoàn toàn 31/08/2026** — tại 10/2026 không còn cách tạo app Spark mới.

Lịch sử cuối (verify github.blog/changelog/2026-08-04):

- **30/07/2026:** GitHub Models (service chạy hàm `llm()` của Spark) retired → app gọi `llm()` mất tính năng AI.
- **04/08/2026:** Spark ngừng nhận user/app mới.
- **31/08/2026:** Spark đóng cửa; đường export code app cũ qua workbench → `…` → **Create repository** cũng khép lại sau đó.

App **đã deploy** vẫn tiếp tục chạy — chỉ việc chỉnh sửa trong workbench là không còn. **App hỏng phần AI:** `llm()` không còn backend nào cả; thay bằng gọi trực tiếp provider (Anthropic/OpenAI/xAI) từ app bạn.

## 3. Copilot Workspace đâu rồi?

**Trả lời 1 câu:** Workspace (preview "issue → PR" của 2024) đã **sunset 2025** và kiến trúc bị **hấp thụ vào Copilot coding agent** — hôm nay làm workflow đó bằng cách assign issue cho Copilot, không còn sản phẩm riêng.

| Workspace cũ (đã chết) | Coding agent hôm nay |
|---|---|
| Màn hình riêng, preview | GA cho mọi subscriber trả phí |
| Issue → spec → plan → PR trong một UI | Assign issue → chạy trên GitHub Actions → draft PR |
| Chỉnh tay trong workbench | Sửa tiếp bằng comment trên PR, duyệt từ GitHub Mobile |

```bash
# Workflow "issue -> PR" hôm nay:
# 1. Mở issue -> gán assignee Copilot (nút Assign)
# 2. Agent tạo branch + draft PR + log tiến trình trong tab Sessions
# CLI thay thế: copilot (Copilot CLI) chạy agent trực tiếp trong terminal
```

> **Không thấy nút assign Copilot:** repo private của org Free plan (coding agent cần plan trả phí); hoặc org policy tắt coding agent — hỏi admin bật.

## 4. Truy cập Spaces ở đâu, ai dùng được?

**Trả lời 1 câu:** Ba lối vào: web (github.com → Copilot → Spaces — chính), code viewer (nút "Add to space" khi xem file trên github.com), và **Spaces API** (GA 18/05/2026) — mở cho mọi tài khoản có Copilot license kể cả Free.

Phân quyền: Space cá nhân = private / share user / public link (view-only); Space org = member thấy theo vai trò admin/editor/viewer hoặc "No access" ẩn hẳn.

```bash
# Verify qua API (token cần quyền Copilot thích hợp):
curl -s -H "Authorization: Bearer <TOKEN>" https://api.github.com/copilot/spaces | head -20
# 401/403 -> token sai scope / không có license / org chặn
```

## 5. Muốn "vibe coding" tạo app như Spark, giờ dùng gì?

**Trả lời 1 câu:** Dùng **Copilot coding agent** (assign issue → nhận PR) hoặc **Copilot CLI** (agent trực tiếp trong terminal) trên một repo mới — cùng trải nghiệm "mô tả → có code", nhưng code nằm trong repo của bạn, không bị khóa trong nền tảng.

| Nhu cầu | Đường đi hôm nay |
|---|---|
| Prototype UI nhỏ | Coding agent tạo repo + PR, xem trước qua preview deployment |
| App full-stack | Repo trống + issue mô tả spec → agent dựng khung + code |
| Học/AI trong app | Tự nối provider AI trực tiếp (`llm()` của Spark đã chết cùng GitHub Models) |
| Không muốn rời terminal | Copilot CLI: `copilot` rồi mô tả việc, duyệt từng bước |

```bash
gh repo create my-prototype --public --clone && cd my-prototype
gh issue create --title "Xay dung app dem calo" --body "Stack: ..., tinh nang: ..."
gh issue edit 1 --add-assignee "@copilot"
# Verify: PR draft xuat hien, comment de yeu cau sua tiep
```

> Agent làm sai ý: issue viết spec cụ thể hơn (stack, cấu trúc thư mục, tiêu chí xong); chia nhỏ thành nhiều issue thay vì 1 issue khổng lồ.

## 6. Muốn workflow "issue → PR" như Workspace cũ?

**Trả lời 1 câu:** Gán issue cho **Copilot coding agent** — đọc issue, lập kế hoạch, sửa code, tự mở draft PR; bạn review và comment để nó sửa tiếp (dùng Copilot CLI khi cần chạy local).

| Bạn từng làm ở Workspace | Bây giờ làm ở đâu |
|---|---|
| "Implement this spec" trong UI | Assign issue cho `@copilot` |
| Sửa spec giữa chừng | Comment vào PR: "đổi X thành Y" |
| Xem plan trước khi code | Đọc Sessions log + nội dung draft PR |
| Chạy local | Copilot CLI (`copilot`, 3 chế độ Interactive/Plan/Autopilot) |

## 7. Quản lý Spaces bằng code (Spaces API)?

**Trả lời 1 câu:** **Spaces API GA 18/05/2026** — CRUD đầy đủ Space + quản lý collaborators/nguồn qua REST, dành cho org cần quản lý hàng loạt: sinh 1 Space cho mỗi repo mới khi onboarding, dọn Space không ai dùng, đồng bộ collaborators theo bảng nhân sự.

```bash
curl -s -X POST -H "Authorization: Bearer <TOKEN>" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/copilot/spaces \
  -d '{"title":"Dự án billing","description":"Context cho team billing"}'

# Chi tiết đầy đủ: docs.github.com -> REST API -> Copilot -> Spaces
```

> 404 + config trông đúng → bản preview cũ có schema khác, API đã GA 18/05/2026.

## 8. Troubleshooting cả 3 (ma trận triệu chứng)

| Triệu chứng | Nguyên nhân khả dĩ | Xử lý |
|---|---|---|
| Không thấy tab Spaces | Không có Copilot license / org policy | Check license; hỏi admin; vào `github.com/copilot/spaces` |
| Copilot trả lời như không đọc context | Nguồn chưa đồng bộ / quá rộng | Chờ đồng bộ; thu hẹp nguồn; thêm instructions |
| Spaces API 401/403/404 | Token scope / schema preview cũ | Cấp lại PAT đúng quyền; xem docs API GA |
| App Spark hỏng tính năng AI | `llm()` chết (GitHub Models retired 30/07/2026) | Thay bằng gọi provider AI riêng |
| Không edit được app Spark | Spark đóng 31/08/2026 | Dựng lại từ repo (nếu đã export) bằng coding agent |
| Không tìm thấy Copilot Workspace | Sunset 2025 → coding agent | Assign issue cho Copilot / dùng Copilot CLI |

```bash
# Thu tu kiem tra:
# 1. License: github.com/settings/copilot -> thấy plan đang dùng
# 2. Org policy: hỏi admin (Copilot -> Policies)
# 3. Đồng bộ Space: mở Space -> check danh sách sources còn nguyên
```

---

> **Chốt:** nhớ 1 dòng — "Spaces cho Copilot biết **đọc gì**, coding agent **làm** việc thay bạn, Spark/Workspace là **di tích** lịch sử." Trạng thái các tính năng này có thể đổi tiếp sau 10/2026 — nguồn verify: github.blog changelog (24/09/2025, 18/05/2026, 04/08/2026) + docs.github.com/copilot. Quay về: [../README.md](../README.md) · Lỗi chung: [bài 08](08-loi-thuong-gap-troubleshooting.md).
