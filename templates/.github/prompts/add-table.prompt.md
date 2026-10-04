---
mode: agent
description: Tao bang Postgres moi (migration + RLS + test). Dung: /add-table ten_bang
tools: [search]
---

# Add Table

Tao bang Postgres moi hoan chinh: migration + RLS + test. Hoi ten bang neu user chua cho.

## Buoc 1 — Hoi thieu gi thi hoi (dung doan)

- Ten bang? Cac cot (ten + kieu + nullable)? Co can `created_at/updated_at`?
- Co can Row Level Security? Ai duoc doc/ghi (role nao)?

## Buoc 2 — Tao migration (KHONG sua file cu)

```bash
ls db/migrations/  # xem so thu tu moi nhat, dat ten tiep theo: NNN_them_bang_<ten>.sql
```

Viet migration moi:

```sql
CREATE TABLE <ten> (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
  -- them cot o day
);
```

- Neu can RLS: `ALTER TABLE <ten> ENABLE ROW LEVEL SECURITY;` + policy SELECT/INSERT theo role.

## Buoc 3 — Chay + verify

```bash
pnpm migrate:up
# Viet test nho: insert 1 row + select lai duoc (dat canh module lien quan, *.spec.ts)
pnpm --filter @acme/api test -- <ten-module>
```

## Buoc 4 — Tra ve

- Ten file migration + tom tat schema + ket qua test PASS/FAIL.
- Luu y: KHONG chay migrate truc tiep len prod tu day — theo quy trinh deploy (`/deploy`).
