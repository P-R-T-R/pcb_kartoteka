#!/bin/sh
set -eu

BACKUP_FILE="${1:-}"
if [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
  echo "Usage: $0 ./backups/activity_backup_YYYYMMDD_HHMMSS_PID.sql.gz" >&2
  exit 1
fi
gzip -t "$BACKUP_FILE"
printf 'This replaces the Activity history database. Type RESTORE_ACTIVITY: '
read -r CONFIRM
[ "$CONFIRM" = "RESTORE_ACTIVITY" ] || { echo "Restore cancelled"; exit 1; }

docker compose stop activity-service
docker compose exec -T activity-db sh -c '
  case "$POSTGRES_DB:$POSTGRES_USER" in *[!A-Za-z0-9_:]*) echo "Unsafe database identifier" >&2; exit 1;; esac
  psql -U "$POSTGRES_USER" -d postgres -v ON_ERROR_STOP=1 \
    -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '\''$POSTGRES_DB'\'' AND pid <> pg_backend_pid();" \
    -c "DROP DATABASE IF EXISTS \"$POSTGRES_DB\";" \
    -c "CREATE DATABASE \"$POSTGRES_DB\" OWNER \"$POSTGRES_USER\";"
'
gunzip -c "$BACKUP_FILE" | docker compose exec -T activity-db sh -c \
  'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1'
docker compose up -d --wait activity-migrate activity-runtime-role activity-service
echo "Activity restore completed. Verify health, event count and a new object change."
