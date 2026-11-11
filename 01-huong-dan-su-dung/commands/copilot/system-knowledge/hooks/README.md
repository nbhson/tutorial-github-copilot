# /hooks — Mở card Hooks: xem và quản lý hook đang nạp

> **Dành cho:** người cần biết session đang bị "khóa" bởi hook nào · **Vấn đề:** hook nằm trong file JSON, không nhìn thấy từ Chat — cần một chỗ để xem list + trạng thái · **Đọc xong:** gọi được `/hooks`, đọc đúng bảng hook, và biết chỗ nào sửa file khi cần đổi hành vi (~2 phút)
> **Harness:** Copilot · **Surface:** Chat view (VS Code) · hook file chạy ở Copilot CLI + Copilot in the cloud

## 1 câu nôm na

Bảng điện của căn nhà: cầu dao (hook) nằm trong hộp, còn `/hooks` là cánh cửa mở hộp ra — bạn nhìn thấy mạch nào đang bật, cái nào vấp, nhưng muốn đi dây lại thì vẫn phải thao tác trong file. Trong Chat view VS Code, `/hooks` mở card Hooks liệt kê hook đang được nạp; bản thân hook là file JSON, không phải lệnh chạy một lần. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Vì sao dùng /hooks?

- **Nhìn thấy cái đang chặn mình** — khi tool call bị từ chối mà không hiểu vì sao, card Hooks cho thấy hook nào đang nạp từ đâu.
- **Xác nhận hook đã được đọc** — viết file xong mà không biết Copilot có nạp không; mở card là cách verify nhanh nhất.
- **Đúng chỗ, đúng vai** — docs VS Code: trong nhóm customization, Copilot harness CHỈ có `/prompts` và `/hooks` trong Chat view (`/agents` `/instructions` `/skills` phải dùng Agent Customizations editor).

**Nếu làm sai thì sao?** Nghĩ rằng `/hooks` là nơi TẠO hook → mất công mò UI; tạo/sửa hook là sửa file (repo hoặc user scope), card chỉ để xem.

> **Tóm gọn 1 câu:** `/hooks` = cửa sổ đọc trạng thái; nơi ở thật của hook là `.github/hooks/*.json` (repo) và `~/.copilot/hooks/` (máy bạn). · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** tool bị deny bất thường; mới nhận repo có hook; muốn verify hook mình viết được nạp chưa.
- **ĐỪNG dùng khi:** cần tạo hook mới — mở file JSON và viết theo schema; cần tắt hook của org — policy hooks do admin cài, dev không gỡ được.
- **Cho ai:** dev trong team có guardrail; người quản trị muốn xem dev đang nạp gì. · 📄 [VS Code Docs: Choose a customization scope](https://code.visualstudio.com/docs/agent-customization/overview#choose-a-customization-scope)

## Cách gọi (copy-paste)

```
/hooks            # Chat view: mở card Hooks (Copilot harness + Local)
```

> 📄 **Schema + test payload:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh) · 📄 [VS Code Docs: Choose the hook implementation](https://code.visualstudio.com/docs/agent-customization/hooks#choose-the-hook-implementation-for-your-session)

Kiểm tra: gõ `/` trong Chat view, tìm `/hooks`. Không thấy là bình thường nếu client không phải VS Code — CLI/cloud không có slash này, hook vẫn chạy theo file.

## Ví dụ thật — chặn lệnh nguy hiểm bằng preToolUse

Nghiệp vụ: team bạn muốn agent không được chạy `rm -rf` ngoài ý muốn. Một file `.github/hooks/guard.json` khai `preToolUse` với `matcher` trúng tool bash; script trả **exit code 2** = deny (quy tắc docs cho `preToolUse`/`permissionRequest`).

> 📄 **Hook hoàn chỉnh + test:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Create project instructions](https://code.visualstudio.com/docs/agents/guides/customize-copilot-guide#step-1-create-project-instructions)

**Kết quả mong đợi:** khi agent thử chạy lệnh trùng matcher, tool call bị chặn kèm lý do từ hook.

**✅ Verify:** khởi động CLI in `! Invalid hook configuration in FILE: REASON` nếu file sai; `jq . .github/hooks/*.json` pass; mở `/hooks` trong Chat view thấy hook nằm list.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — dùng `if` thay `matcher`, hoặc đặt event sai chữ hoa thường:** `hooks` là object keyed by event; entry lọc bằng `matcher` (regex), **không có field `if`**. Tên event chấp nhận cả PascalCase lẫn camelCase — nhưng một file nên dùng một kiểu cho dễ grep.

**✅ ĐÚNG — schema docs:** `{"version":1,"hooks":{"preToolUse":[{"type":"command","command":"./.github/hooks/guard.sh","matcher":"Bash","timeoutSec":10}]}}`; script chmod +x, đọc payload JSON từ stdin, exit 0 cho qua / exit 2 chặn.

**Bài học:** hook là cấu hình dạng file — "gọi lệnh" chỉ là cách mở ngăn kéo. · 📄 [VS Code Docs: Troubleshoot customization issues](https://code.visualstudio.com/docs/agent-customization/overview#troubleshoot-customization-issues)

## Lỗi thường gặp

📄 [VS Code Docs: Troubleshoot hooks](https://code.visualstudio.com/docs/agent-customization/hooks#troubleshoot-hooks)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tool bị deny không lý do | `preToolUse` trả exit 2 (hoặc cloud coi `ask` = deny) | Xem log/reason của hook; test payload tay |
| Viết hook xong không chạy | File sai schema / thiếu `chmod +x` / đặt sai thư mục | `jq .`, đặt `.github/hooks/*.json` hoặc `~/.copilot/hooks/` |
| Ở Copilot in the cloud hook không chặn gì | `permissionRequest` vô hiệu, `notification` không fire (subset) | Chuyển quyết định sang `preToolUse` |
| Tìm `/hooks` không thấy | CLI/cloud không có slash này | Hook vẫn nạp theo file; card chỉ có ở Chat view |
## So sánh với Claude Code

📄 [VS Code Docs: Migrate hooks](https://code.visualstudio.com/docs/agent-customization/migrate-customizations#migrate-hooks)

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Tên event | PascalCase hoặc camelCase | PascalCase | tương thích tên, KHÔNG tương thích payload |
| Chặn tool | exit 2 ở `preToolUse`/`permissionRequest` | `preToolUse` decision | copy file ≠ cùng runtime |
| Chỗ xem trạng thái | `/hooks` (Chat view, Preview ở VS Code) | `/hooks` | VS Code: tính năng Preview |
## Best practices (kèm "vì sao")

- **Commit hook vào `.github/hooks/` cho cả team, để `~/.copilot/hooks/` cho thử nghiệm.** *Vì sao?* Repo scope chạy cả team lẫn cloud; user scope không ai chết theo bạn.
- **Test payload bằng pipe trước khi tin card Hooks.** *Vì sao?* Card xác nhận "được nạp", còn exit code chứng minh "hành vi đúng".
- **Giữ `timeoutSec` ngắn.** *Vì sao?* timeout là fail-open — hook chậm không được chặn âm thầm việc của người khác. · 📄 [VS Code Docs: Hook security considerations](https://code.visualstudio.com/docs/agent-customization/hooks#security-considerations)

## Bài tập nhỏ

1. **(3 phút)** Gõ `/hooks` trong Chat view — ghi lại hook nào đang nạp (nếu trống là đúng: repo bạn chưa có file).
2. **(5 phút)** Copy hook từ examples vào `.github/hooks/`, test deny một lệnh `rm` tưởng tượng. · 📄 [VS Code Docs: Choose the hook implementation](https://code.visualstudio.com/docs/agent-customization/hooks#choose-the-hook-implementation-for-your-session)

## Tham khảo

- Bài chủ: [../../../../07-policies-guardrails-tu-dong-hoa.md](../../../../07-policies-guardrails-tu-dong-hoa.md) — schema đầy đủ, guardrail stack, policy hooks.
- Index nhóm: [../README.md](../README.md) · Lệnh liên quan: [../../model-agent/sandbox-policy/README.md](../../model-agent/sandbox-policy/README.md) · [instructions](../instructions/README.md)
- Docs: [Hooks (VS Code)](https://code.visualstudio.com/docs/agent-customization/hooks) · [Hooks reference](https://code.visualstudio.com/docs/agents/reference/hooks-reference) · [GitHub hooks reference](https://docs.github.com/en/copilot/reference/hooks-reference)
- Cheatsheet: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md)
