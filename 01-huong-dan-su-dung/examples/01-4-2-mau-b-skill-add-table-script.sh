# .github/skills/add-table/scripts/migrate.sh (chmod +x)
#!/bin/sh
case "$1" in
  dev)  pnpm migrate:dev ;;     # chay local
  dry)  pnpm migrate:dry ;;     # dry-run truoc khi chay that
  *)    echo "Dung: $0 dev|dry" ; exit 1 ;;
esac
