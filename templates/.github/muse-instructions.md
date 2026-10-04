# Project: <Ten-du-an> — one-liner mô tả

> File này Copilot tự đọc mỗi lần gợi ý/chat. Giữ <200 dòng. Chi tiết theo path → `.github/instructions/`. Procedure dài → `.github/prompts/` hoặc `.github/skills/`.

## Tech Stack
- <Framework + version>, <Ngôn ngữ + version>, <DB>, <lib chính>
- VD: NestJS 11, TypeScript 5.6 strict, Postgres 16, pnpm 9

## Commands (VERIFIED — chỉ ghi lệnh đã chạy thử)
- Dev: `pnpm dev` (API :3000, web :5173)
- Build: `pnpm build`
- Test (focused): `pnpm --filter @acme/api test -- auth`
- Lint: `pnpm lint`
- Full check: `pnpm lint && pnpm test && pnpm build`
- DB migrate: `pnpm migrate:up` (KHÔNG sửa file trong `db/migrations/` đã merge)

## Architecture
- `apps/api/` owns HTTP transport; `packages/domain/` không phụ thuộc framework
- Routes ở `apps/api/src/routes/`, models/types ở `packages/domain/src/`, tests cạnh code `*.spec.ts`
- DB change → migration mới trong `db/migrations/`, chạy `pnpm migrate:up` ở staging trước

## Code Style (cụ thể, check được)
- TypeScript strict, không `any` trừ khi có comment ép kiểu
- API errors shape `{ code, message, requestId }` (VD mẫu trong instructions backend)
- File >300 dòng thì tách; hàm >50 dòng thì tách
- Commit message: conventional commits (`feat(auth): ...`, `fix(api): ...`)

## Rules (bắt buộc — Copilot phải tuân thủ)
- NEVER commit trực tiếp `main`. Luôn branch `feat/<ten>` + PR + CI xanh.
- NEVER sửa `db/migrations/**` đã merge. Tạo migration mới.
- NEVER hardcode secret. Secrets chỉ qua `process.env.*` (local) / secret manager (prod).
- NEVER `git push --force` lên branch chung. Chỉ `--force-with-lease` trên branch cá nhân.
- ALWAYS chạy focused test sau mỗi sửa, báo PASS/FAIL.
- ALWAYS dùng read-replica cho query đọc (xem `.vscode/mcp.json`).

## Model guidance (khuyến nghị, không ép buộc)
- Chat hằng ngày: model mặc định.
- Refactor multi-file / review bảo mật: model mạnh nhất hiện có.
- Hết quota → về model nhẹ + tắt Agent mode (xem FAQ 02).

## Permissions baseline (team)
- Agent được chạy: `pnpm test`, `pnpm lint`, `git status`, `git diff`.
- Agent KHÔNG: commit, push, sửa `db/migrations/`, gọi API prod.
- File cấm đọc: `**/*.pem`, `secrets/**`, `.env*` (xem `.vscode/settings.json`).

---
Chi tiết backend → `.github/instructions/backend-api.instructions.md`.
Chi tiết frontend → `.github/instructions/frontend-react.instructions.md`.
Review PR → `/review-pr` (`.github/prompts/review-pr.prompt.md`).
