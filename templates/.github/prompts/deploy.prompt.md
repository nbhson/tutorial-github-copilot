---
mode: agent
description: Deploy staging/prod theo checklist (dry-run + smoke test truoc)
tools: [search]
---

# Deploy

Quy trinh deploy chuan team. Lam tung buoc, dung khi xanh.

## Buoc 1 — Kiem tra truoc deploy

1. `git status --short` phai sach (khong con change chua commit).
2. Dang o branch dung (`main` cho prod, `develop` cho staging)? `git branch --show-current`.
3. Chay full check: `pnpm lint && pnpm test && pnpm build`.

## Buoc 2 — Dry-run (staging bat buoc, prod khuyen nghi)

```bash
pnpm deploy --env staging --dry-run
```

- Doc ky diff dry-run: co migration nao? co env var moi nao?
- Co migration → backup DB staging truoc, chay `pnpm migrate:up` o staging truoc.

## Buoc 3 — Deploy that

```bash
pnpm deploy --env <staging|prod>
```

- Prod: can 2 nguoi (1 chay, 1 giam sat). KHONG deploy prod thu 6 chieu/toi.
- Trong luc deploy: theo doi log, khong chay lenh DB tay song song.

## Buoc 4 — Smoke test sau deploy

```bash
curl -s -o /dev/null -w "health:%{http_code}\n" https://<domain>/health
# Login thu 1 user test, check 1 flow chinh (doc + ghi)
```

- Do o buoc nao → rollback theo runbook team (`pnpm deploy:rollback --env <env>`), KHONG fix forward tren prod khi chua ro nguyen nhan.

## Ket qua tra ve

- PASS/FAIL tung buoc + link log + commit da deploy (`git rev-parse --short HEAD`).
