# 14-5 · Thêm model ở đâu trên từng surface — CLI / VS Code / web / cloud

> Đồng hành với [bài 14 §7](../14-models-chon-model-dung.md#7-thêm-model-riêng-vào-picker).
> Nội dung chuyển ra từ bài 14 cũ để phần đọc liền mạch của bài học ngắn lại.

## Một câu

Model **available** (danh sách phụ thuộc gói) thì picker ở đâu cũng giống
nhau — việc "thêm model riêng" chỉ khác nhau ở **nơi khai báo**:

| Surface | Thêm model bằng cách | Có tiêu tốn AI Credits? |
|---|---|---|
| Copilot CLI | keys trong `config.json` (§dưới), hoặc file `~/.copilot/providers.json` cho custom provider | model trong danh sách GitHub: có; BYOK/custom provider: không |
| VS Code | Settings → Copilot → dán API key provider (BYOK) | BYOK: không — provider thu tiền trực tiếp |
| Copilot Chat trên github.com | không thêm được — chỉ chọn trong danh sách có sẵn của plan | model trả phí: tính credits bình thường |
| cloud agent | không có picker riêng — kế thừa model của session tạo ra nó | theo model được kế thừa |

## Copilot CLI

```sh
copilot            # mo phien trong terminal
/model             # go trong phien: mo picker, co ca tier Auto
```

Muon co model ngoai danh sach mac dinh, khai trong `~/.copilot/config.json`
(hai keys `models.custom` va `models.alias`, xem bai 14 §7). Tren may cua tac
gia, CLI luon tim thay model cua Ollama dang chay local — xuat hien trong
`/model` nhu mot model thuong, khong can cau hinh.

## VS Code

1. Settings (`⌘,`) → tìm **Copilot** → mục model / API key của provider.
2. Dán key (OpenAI, Anthropic, Groq, ...) → model của provider đó xuất hiện
   trong dropdown [model picker](../commands/copilot/model-agent/model-picker/README.md) của Chat.
3. Không có mục dán key? Tổ chức chưa bật BYOK (chính sách org) hoặc VS Code
   cũ — cập nhật rồi kiểm tra lại.

(Trình tự chọn surface và mở dropdown model đã hướng dẫn ở [bài 02](../02-cac-be-mat-vscode-ide-web-cli.md).)

## github.com — Copilot Chat

Chat mở trên web → dropdown cạnh ô nhập → chỉ danh sách model plan của bạn
được dùng. Không thêm model riêng ở đây; muốn model lạ thì dùng CLI hoặc
VS Code.

## cloud agent

Tạo session cho cloud agent (Agents tab / `/schedule`) → chọn model ngay lúc
tạo; mặc định là auto. Session sau đó chạy theo model đó, và model "name +
version" có thể bị đổi giữa chừng — xem [bài 14 §5](../14-models-chon-model-dung.md#5-auto-fallback-và-deprecation)
về lý do nên cân nhắc base model cho việc chạy dài.

## Hay gặp khi thêm model

- **Thêm rồi mà không thấy trong picker** → CLI: restart session; VS Code:
  reload window; org policy chặn BYOK thì key hợp lệ vẫn không lên danh sách.
- **Thấy 2 model trùng tên** → một cái là model gói (tính credits), một là
  BYOK (không tính) — đọc kỹ tag trong picker trước khi chọn.
- **Config JSON không được đọc** → validate JSON trước: thiếu 1 dấu phẩy là
  CLI im lặng bỏ qua cả file.

## Reference

- [Using the GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/copilot-surfaces/copilot-cli)
- [Bring your own model key](https://docs.github.com/en/copilot/concepts/models/bring-your-own-key)
- [Custom models in VS Code](https://code.visualstudio.com/docs/agent-customization/language-models)
