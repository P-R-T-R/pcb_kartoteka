#!/bin/sh
set -eu

BACKUP_FILE="${1:-}"
if [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
  echo "Usage: $0 ./backups/pcb_backup_YYYYMMDD_HHMMSS.sql.gz" >&2
  exit 1
fi

gzip -t "$BACKUP_FILE"
printf 'This replaces the current database. Type RESTORE: '
read -r CONFIRM
[ "$CONFIRM" = "RESTORE" ] || { echo "Restore cancelled"; exit 1; }

docker compose stop backend
docker compose exec -T postgres sh -c '
  case "$POSTGRES_DB:$POSTGRES_USER" in *[!A-Za-z0-9_:]*) echo "Unsafe database identifier" >&2; exit 1;; esac
  psql -U "$POSTGRES_USER" -d postgres -v ON_ERROR_STOP=1 \
    -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid();" \
    -c "DROP DATABASE IF EXISTS \"$POSTGRES_DB\";" \
    -c "CREATE DATABASE \"$POSTGRES_DB\" OWNER \"$POSTGRES_USER\";"
'
gunzip -c "$BACKUP_FILE" | docker compose exec -T postgres sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1'
docker compose start backend

echo "Restore completed. Verify login, projects, boards, products and executions."
