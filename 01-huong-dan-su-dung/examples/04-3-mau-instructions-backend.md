<!-- Mau instructions cho backend Node + Express + Postgres.
     Noi dung nay dat tai .github/copilot-instructions.md (repo-wide, khong can frontmatter).
     Thay <...> va du an cua ban; chay lai tung lenh khi doi toolchain. -->

# Project: Acme API — Express + Postgres 16 + TypeScript

## Commands (VERIFIED 2026-10)
- Dev: `npm run dev` (api :4000, can `.env` tu 1Password "Acme dev")
- Test focused: `npm test -- --filter api --testPathPattern=orders`
- Lint: `npm run lint`

## Architecture
- `src/routes/` HTTP layer mong; `src/services/` business logic; `src/db/` query only
- Route KHONG query DB truc tiep — goi qua service
- Zod schemas o `src/contracts/`, dung chung validator + test fixtures

## Rules
- ALWAYS tra loi loi dang `{ code, message }`, KHONG leak stack trace ra client
- ALWAYS them regression test khi fix bug
- NEVER doi schema DB trong cung PR voi logic (tach 2 PRs)
- Migration chi tien (forward-only), KHONG viet down migration pha du lieu

<!-- Bien the Python (FastAPI + uv + pytest + ruff) cung cau truc tren, chi thay:
     - Lenh: `uv run pytest <file>` (focused), `ruff check .` (truoc khi pytest).
     - Them rule: "ALWAYS chay ruff truoc pytest"; "dung timezone-aware datetime";
       "DB session per-request qua dependency injection". -->
