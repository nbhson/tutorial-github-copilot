# /skills — Liệt kê Agent Skills khả dụng

> **Dành cho:** team muốn model tự làm đúng chuẩn mà không phải nhớ tên lệnh · **Vấn đề:** hay nhầm skill với prompt/agent nên gọi sai cách · **Đọc xong:** biết `/skills` liệt kê gì và khi nào model tự kích hoạt (~2 phút)

## 1 câu nôm na

`/skills` là danh sách “sổ tay nghề” tự động: khi bạn nói đúng việc, model tự rút đúng trang ra dùng thay vì bạn phải gọi tên. Phân biệt nhanh cho khỏi lẫn: **Prompt = bạn gọi tay; Skill = model tự gọi; Agent = một người làm việc riêng.**

## Vì sao dùng /skills?

Skill nằm trong `.github/skills/<ten>/SKILL.md`, có `description` liệt kê từ khóa trigger. Khi câu nói của bạn khớp, model tự nạp đúng quy trình — bạn không cần nhớ tên lệnh, và kết quả ổn định hơn vì cùng input đi cùng các bước. So với gõ prompt tay mỗi lần: skill gọn hơn (không phải nhét lại checklist), và rẻ hơn instructions (chỉ nạp khi cần, không nạp mọi lượt).

**Nếu làm sai thì sao?** Đóng quy trình vào skill nhưng `description` viết chung chung (“hỗ trợ deploy”) thì skill **không bao giờ tự kích hoạt** — bạn tưởng model đã biết, thực ra nó chưa từng thấy skill.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** muốn model tự biết “review PR thì làm gì”; chuẩn hóa kỹ năng team (không phụ thuộc việc nhớ tên); hay đang cân nhắc skill vs prompt/agent để chọn đúng.
- **ĐỪNG dùng khi:** cần **persona/quyền riêng** cho một vai (đó là custom agent); cần luật áp **mọi chat** (đó là instructions); hay cần nối hệ thống ngoài (đó là MCP).

> Prompt vs Skill vs Agent:

| Cách | Ai gọi | Khi nào dùng |
|---|---|---|
| Prompt (`/prompts`) | Bạn gõ tay tên prompt | Việc lặp lại muốn chủ động gọi, kiểm soát từng lần |
| Skill (`/skills`) | Model tự kích hoạt theo `description` | Muốn model tự chọn cách làm chuẩn, không cần nhớ tên |
| Agent | Bạn chạy như một “đồng nghiệp” riêng | Việc dài, cần persona/permission riêng |

## Cách gọi (copy-paste)

```bash
/skills
# xem skills đang có, rồi nhờ 1 việc quen: "review PR giúp tôi"
# Kỳ vọng: model tự kích hoạt đúng skill, output đúng form
# Verify: model báo đã dùng skill X — không cần gõ /review-pr
```

> Không thấy `/skills` trong list khi gõ `/`? Kiểm `/status` + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: team đã có skill `review-pr` (chỉ đọc diff, nêu bug + test thiếu, không sửa code). Bạn muốn nó tự chạy khi bạn chỉ nói như người thường.

```bash
# KHÔNG gõ /review-pr. Chỉ nói tự nhiên:
"review PR 123 giúp tôi"

# Kỳ vọng trên màn hình:
#  - Model báo đang dùng skill review-pr (description khớp từ "review")
#  - Trả về: danh sách lỗi theo file:line + test còn thiếu
#  - KHÔNG sửa code (đúng như skill đã quy định)
# Nếu model sửa code lung tung → SKILL.md thiếu dòng "chỉ đọc", sửa lại.
```

**Kết quả mong đợi:** model tự kích hoạt đúng skill, output đúng form; bạn không cần nhớ tên.

**✅ Verify:** nhờ 1 việc quen → model báo đã dùng skill X là đạt. Không báo → `description` thiếu từ khóa.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — `description` chung chung, không có từ khóa:**

```markdown
description: 'Hỗ trợ deploy'   # agent không biết khi nào load → skill chết.
```

**✅ ĐÚNG — câu đầu chứa đúng từ người dùng hay nói:**

```markdown
description: 'Deploy staging/prod kèm migrate + smoke test.
  Dùng khi user nói deploy, release, ship, xuất bản.'
```

**Bài học:** `description` là **trigger**, không phải khẩu hiệu — câu đầu phải chứa đúng những từ bạn sẽ nói thật.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Skill không kích hoạt | `description` mờ / trigger sai | Viết rõ “dùng khi …” + test 3 câu khác nhau |
| Nhầm skill với prompt | Chưa rõ khác biệt | Prompt = gọi tay; Skill = model tự gọi; Agent = người làm |
| Skill quá to, hay bỏ bước | Ôm cả quy trình dài | Mỗi skill 1 kỹ năng; `SKILL.md` <100 dòng + ví dụ input/output |

## So sánh với Claude Code

| Việc | Copilot (`/skills`) | Claude Code | Ghi chú |
|---|---|---|---|
| Chuẩn skill | Agent Skills `SKILL.md` (Copilot tự dò cả `.claude/skills/`) | Agent Skills `SKILL.md` (Anthropic khởi xướng, ~40 tools) | Cùng chuẩn mở — viết 1 lần chạy nhiều agent |
| Ai kích hoạt | Model tự nạp khi `description` khớp | Model tự nạp theo ngữ cảnh | Cùng tư tưởng “skill tự trigger” |
| Lệnh xem danh sách | Có `/skills` | Không có lệnh tương đương — skill được dò trong `.claude/skills/` | Copilot cho xem list; Claude Code tự dò |

## Best practices (kèm "vì sao")

- **Câu đầu `description` = từ khóa user sẽ nói.** *Vì sao?* Đây là cơ chế trigger; thiếu từ khóa thì skill hay cỡ nào cũng không bao giờ load.
- **Giữ `SKILL.md` <100 dòng, chi tiết dài đẩy sang `references/`.** *Vì sao?* File quá dài khiến agent bỏ bước giữa chừng.
- **Mỗi skill một kỹ năng, có ví dụ input/output.** *Vì sao?* Skill ôm nhiều việc khó trigger đúng, và output không ổn định.
- **Test bằng cách nói tự nhiên, KHÔNG gõ `/`.** *Vì sao?* Gõ `/` là dùng nó như prompt file — không chứng minh được skill tự trigger.
- **Không để secret trong skill.** *Vì sao?* Skill nằm trong git và agent host; secret trong đó là lộ. Ghi “lấy từ 1Password <tên>”.

## Bài tập nhỏ

1. **(15 phút)** Tạo `.github/skills/summarize-pr/SKILL.md` với `description` chứa từ “tóm tắt PR”, rồi nói tự nhiên xem model có tự dùng không.
2. **(10 phút)** Xóa 1 từ khóa trigger trong `description`, chạy lại, ghi khác biệt; sau đó đổi lại cho đúng.
3. **(10 phút)** So `/skills` với `/prompts` trên cùng một việc: gọi tay (prompt) khác model tự gọi (skill) ở điểm nào? Ghi 2 dòng.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh System & Knowledge.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Bản legacy và cách port: [../prompt-file/README.md](../prompt-file/README.md) · [bài 05](../../../05-prompt-files-custom-instructions.md).

> **Chốt:** skill mạnh nhất ở câu `description` — viết skill thì nên dồn 80% công sức vào phần trigger, chứ không phải phần thân.
