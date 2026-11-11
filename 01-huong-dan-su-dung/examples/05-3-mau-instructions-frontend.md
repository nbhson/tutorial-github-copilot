<!-- Mau instructions cho frontend Next.js.
     Noi dung nay dat tai .github/copilot-instructions.md (repo-wide, khong can frontmatter).
     Thay <...> va du an cua ban; chay lai tung lenh khi doi toolchain. -->

# Project: Acme Shop Web — Next.js 15 storefront + API routes

## Tech Stack
- Next.js 15 (App Router), TypeScript strict, Tailwind, Prisma + Postgres 16
- Auth: NextAuth v5. Tests: Vitest + Playwright

## Commands (VERIFIED 2026-10 — chay lai neu doi toolchain)
- Dev: `pnpm dev` (web :3000, can `.env.local` tu 1Password "Acme dev")
- DB migrate: `pnpm prisma migrate dev`
- Test focused: `pnpm vitest run apps/web/src/app/login/`
- Test full: `pnpm test` (khong chay khi chi sua 1 file — dung focused)
- Lint: `pnpm eslint apps/web/src --max-warnings 0`
- Full check truoc PR: `pnpm lint && pnpm test && pnpm build`

## Architecture
- `apps/web/src/app/` routes (server components mac dinh)
- `apps/web/src/server/` owns DB access; client KHONG import prisma truc tiep
- `packages/ui/` design system; `packages/contracts/` zod schemas dung chung

## Code Style
- API errors shape `{ code, message, requestId }`, status dung (400/401/403/404/422/500)
- File >300 dong thi tach; component >150 dong thi tach; khong `any`

## Rules
- ALWAYS chay focused test sau khi sua; paste output vao bao cao
- ALWAYS `pnpm prisma migrate dev --name <ten>` khi doi schema, KHONG sua SQL tay
- NEVER commit truc tiep main, NEVER sua `src/generated/` va migration da merge
