# /login — Đăng nhập GitHub account cho Copilot, verify đúng account/plan

> **Harness:** Copilot · **Surface:** VS Code (icon Copilot / Account) / Copilot CLI / GitHub.com · **Đọc:** ~2 phút

**Nôm na:** Giống xuất trình thẻ nhân viên để vào tòa nhà: xác thực bằng OAuth GitHub, rồi kiểm tra lại mình đã vào đúng account chưa. Hợp khi Copilot im lặng bất thường — token hết hạn là lỗi ít báo nhất, không gợi ý gì cả.

## Vì sao dùng?

Copilot im lặng khi token hết hạn hoặc khi bạn login sai account — không có thông báo rõ, chỉ là không thấy gợi ý nào. Login lại là cách nhanh nhất để cấp quyền, và verify trạng thái để chắc đã vào đúng account/plan. Máy có 2 account là cái bẫy hay gặp nhất: token cũ còn cache, `copilot login` chồng lên dễ đưa bạn vào sai account với sai hạn mức và policy.

| Bạn đang ở đâu | Login | Verify sau login |
|---|---|---|
| VS Code (Copilot harness) | icon Copilot / Account → **Sign in with GitHub** | hover icon Copilot ở thanh dưới cùng → status dashboard |
| Copilot CLI | `copilot login` (từ shell) hoặc `/login` trong phiên | `/user show` (account/plan), `/diagnose` khi có vấn đề |
| CLI trên server không browser | `copilot login --device-code` | `/user show` |
| Script/CI | `copilot login --with-token < mytoken.txt` | `copilot version` + chạy 1 prompt thử |

**Nếu làm sai:** muốn đổi account thì **logout trước rồi login lại**, đừng login chồng cache cũ; login đúng mà vẫn không có gợi ý thì còn hai nguyên nhân khác — chưa được cấp seat, hoặc file bị content exclusion — đừng quay lại đăng nhập tiếp.

## Cách dùng

Chạy từ shell trước khi vào phiên; trong Copilot CLI thì slash `/login` cũng có tác dụng:

```sh
copilot login                          # lần đầu, mở browser OAuth
copilot login --device-code            # máy từ xa, không browser (còn --web-flow, --host <URL> cho GHES)
copilot login --with-token < mytoken.txt
```

- **Biến thể:** `--web-flow` (mở browser), `--device-code` (máy từ xa, hoặc khi popup OAuth bị browser/proxy chặn), `--with-token` (CI đọc token từ stdin), `--host <URL>` (GHES); đổi nhanh giữa hai account đang đăng nhập: `/user switch`.
- **✅ Verify:** ghost text **và** Chat đều chạy lại sau login là đạt — chỉ một cái chạy thì kiểm seat + [content-exclusion](../../../cloud/system-knowledge/content-exclusion/README.md).

## Liên quan

- Đổi account sạch: [logout](../logout/README.md) · Kiểm trạng thái sau login: [status](../status/README.md) · Bài chủ: [01-cai-dat-va-xac-thuc.md](../../../../01-cai-dat-va-xac-thuc.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Set up GitHub Copilot](https://code.visualstudio.com/docs/setup/copilot#set-up-github-copilot) · [GitHub Docs — Install & authenticate Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli)
