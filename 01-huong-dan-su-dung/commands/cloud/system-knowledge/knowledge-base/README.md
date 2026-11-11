# Copilot Spaces — kho tài liệu của team, hỏi là có nguồn

> **Dành cho:** người phải tra docs/wiki/runbook nội bộ mỗi ngày · **Vấn đề:** hỏi Slack đi hỏi lại, hoặc model bịa khi không có tài liệu · **Đọc xong:** dựng một Space và hỏi đúng cách để câu trả lời trích được nguồn (~2 phút)
>
> **Surface:** Copilot in the cloud (GitHub.com) — Space tạo trên GitHub.com; gọi lại từ IDE qua GitHub MCP server

## 1 câu nôm na

Space là "túi tài liệu" bạn gom cho Copilot: repo, file, PR/issue, ảnh, file upload, ghi chú. Hỏi trong space thì câu trả lời dựa trên đúng túi đó, và túi tự cập nhật khi nguồn trên GitHub thay đổi.

Docs cũ gọi khái niệm này là *knowledge base*; hôm nay trang đó trả về **Copilot Spaces** — tên mới, cùng một việc.

## Vì sao dùng Copilot Spaces?

Vì tri thức team nằm rải rác trong wiki, docs, runbook; hỏi người thì phiền, hỏi model trần thì nó đoán. Space cho bạn hai thứ: **Instructions** (nói Copilot nên tập trung gì, tránh gì) và **Sources** (nguồn thật để nó trả lời dựa vào). Nguồn là GitHub file/PR/issue thì tự đồng bộ — không có bản index cũ hỏng.

| Loại nguồn | Đưa vào space kiểu gì | Hệ quả khi hỏi |
|---|---|---|
| Repository | Attach repo | Copilot **không** nạp cả repo: nó tìm và lấy phần liên quan — hợp cho "hỏi xuyên suốt docs" |
| File/folder cụ thể | Attach file/folder | Nạp **toàn bộ nội dung** file — hợp cho schema, runbook ngắn |
| PR/issue/link | Dán URL | Trích đúng thread làm ngữ cảnh |
| Upload / text | Upload từ máy, paste ghi chú | Chụp/scan tài liệu cũng vào được; **chỉ dùng được trên web, không qua IDE** |

> **Cách đọc bảng này:** hàng 1–2 là khác biệt hay bị hiểu nhầm nhất — attach repo để tìm, attach file để đọc trọn; chọn sai thì hoặc thiếu ngữ cảnh hoặc loãng câu trả lời.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** onboard ("quy trình deploy team mấy bước?"); cần câu trả lời gắn với tài liệu cụ thể; muốn giảm câu hỏi lặp trong Slack; chia sẻ ngữ cảnh cho cả team.
- **ĐỪNG dùng khi:** tài liệu nằm ngoài GitHub và không có MCP server nào nối tới (tự nó không thấy); bạn cần Copilot **sửa** code từ space (space là context, không phải quyền sửa); repo của bạn bị content exclusion → không vào được context.
- **Cho ai:** người mới onboard, tech lead muốn đóng "bộ tài liệu chuẩn" một lần.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

Tạo: `github.com/copilot/spaces` → **Create space** → đặt tên → chọn sở hữu (cá nhân hay organization) → thêm Instructions + Sources.

## Ví dụ thật

Bạn mới vào team, cần biết quy trình xin review PR mà không muốn hỏi Slack lần thứ ba.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** câu trả lời dẫn về nguồn cụ thể (file/issue trong space); nếu tài liệu không có, nó phải nói không có thay vì bịa.

**✅ Verify:** mở đúng nguồn được trích và đối chiếu. Không mở được nguồn → coi như chưa có câu trả lời.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — hỏi "quy trình deploy thế nào?" không trỏ nguồn**, rồi tin ngay: model đoán từ mô hình chung, không phải từ tài liệu team.

**✅ ĐÚNG — bó câu hỏi vào space và bắt trích nguồn:** "Theo các tài liệu trong space 'Backend Onboarding', quy trình deploy staging gồm mấy bước? Trích nguồn; nếu không có trong tài liệu thì nói rõ không có."

**Bài học:** câu trả lời chỉ đáng tin bằng nguồn mở ra kiểm được; câu hỏi nêu rõ phạm vi thì model hết chỗ để bịa.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| IDE không thấy nội dung đã upload | Spaces trong IDE chỉ qua GitHub MCP, và **repo context + uploaded files không được hỗ trợ** | Mở `github.com/copilot/spaces` trên web để xem các nguồn đó |
| Space không xuất hiện trong Agent | Toolset Spaces chưa bật (`X-MCP-Toolsets: default,copilot_spaces`) | Bật toolset, kiểm `list_copilot_spaces`/`get_copilot_space` có trong danh sách tool |
| Hỏi mãi không ra ý team | Space thiếu Instructions/nguồn | Viết Instructions rõ vai trò + thêm file nguồn cụ thể |
| Chi phí tăng | Câu hỏi trong space tính như Chat request, **tiêu AI credits** theo model + tokens | Cân nhắc size nguồn; theo dõi usage |

> **Cách đọc bảng này:** hàng 1–2 là hai hiểu lầm "space dùng được mọi nơi" — trên IDE nó đi qua MCP và bị cắt bớt nguồn; hàng 4 nhắc rằng context nhiều hơn cũng đắt hơn.

## So sánh với Claude Code

| Việc cần làm | Copilot in the cloud (Spaces) | Claude Code | Ghi chú |
|---|---|---|---|
| Gom tài liệu cho một chủ đề | Space trên GitHub.com (Instructions + Sources) | Đọc file trong repo, hoặc MCP trỏ tới docs | Space sống trên GitHub và tự đồng bộ theo nguồn |
| Chia sẻ cho team | Org-owned space với quyền admin/editor/viewer | Commit file docs/skill vào repo | Copilot phân quyền theo mô hình GitHub sẵn có |
| Dùng khi đang code | Agent mode + GitHub MCP (`list_copilot_spaces`) | Agent đọc file/MCP tại chỗ | IDE không thấy repo context/uploaded files của space |

## Best practices (kèm "vì sao")

- **Luôn bắt câu trả lời trích nguồn + section.** *Vì sao?* Có nguồn mới verify được; không có nguồn thì đó là phỏng đoán.
- **Attach file cho thứ cần đọc trọn, attach repo cho thứ cần tìm.** *Vì sao?* Hai cơ chế khác nhau (nạp toàn bộ vs. tìm kiếm) — chọn đúng thì câu trả lời vừa đủ vừa gọn.
- **Ghi ngày cập nhật vào tài liệu trong space.** *Vì sao?* Nguồn GitHub tự đồng bộ, nhưng file upload/ghi chú thì không.
- **Tài liệu ngoài GitHub thì nối bằng MCP/connector.** *Vì sao?* Space chỉ biết những gì GitHub (hoặc MCP) đưa được vào; surface khác dùng MCP — xem [connector](../../../copilot/system-knowledge/connector/README.md).

## Bài tập nhỏ

1. **(5 phút)** Tạo một space "Team Runbook", thêm 2 file docs + 1 issue, viết Instructions 3 dòng, rồi hỏi một câu quy trình và mở nguồn được trích.
2. **(7 phút)** Hỏi một câu bạn biết chắc tài liệu **không** có; ghi lại cách model trả lời (nói "không có" hay bịa?).
3. **(10 phút)** Bật GitHub MCP + toolset Spaces, gọi cùng câu hỏi từ Agent mode trong IDE và so giới hạn với trên web.

## Tham khảo

- [Group index: System & kiến thức repo](../README.md) · [FAQ 11 — Spaces](../../../../../03-cau-hoi-thuong-gap/11-spaces-spark-workspace.md) · [Cheatsheet](../../../../../CHEATSHEET.md)
- [GitHub — About Copilot Spaces](https://docs.github.com/en/copilot/concepts/prompting-and-context/spaces)
- [GitHub — Creating Copilot Spaces](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/copilot-spaces/create-copilot-spaces)
- [GitHub — Using Copilot Spaces in your IDE](https://docs.github.com/en/copilot/how-tos/copilot-in-your-ide/customize-copilot/extend-copilot-with-tools-and-context/use-copilot-spaces)
- [GitHub — Collaborating with others using Spaces](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/copilot-spaces/collaborate-with-others)
