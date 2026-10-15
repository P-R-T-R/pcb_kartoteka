#!/bin/sh
set -eu
umask 077

BACKUP_DIR="${BACKUP_DIR:-./backups}"
RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-14}"
TIMESTAMP="$(date -u +%Y%m%d_%H%M%S)"
BACKUP_FILE="$BACKUP_DIR/activity_backup_${TIMESTAMP}_$$.sql.gz"
RAW_FILE="${BACKUP_FILE}.raw"
TEMP_FILE="${BACKUP_FILE}.tmp"
mkdir -p "$BACKUP_DIR"
trap 'rm -f "$RAW_FILE" "$TEMP_FILE"' EXIT

# Separate commands preserve pg_dump's failure status on POSIX shells.
docker compose exec -T activity-db sh -c 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB"' > "$RAW_FILE"
test -s "$RAW_FILE"
gzip -c "$RAW_FILE" > "$TEMP_FILE"
gzip -t "$TEMP_FILE"
awk '
  /^(CREATE TABLE|CREATE SCHEMA|COPY .+ FROM stdin;|INSERT INTO )/ { found = 1 }
  END { exit(found ? 0 : 1) }
' "$RAW_FILE"
mv "$TEMP_FILE" "$BACKUP_FILE"
find "$BACKUP_DIR" -type f -name 'activity_backup_*.sql.gz' -mtime "+$RETENTION_DAYS" -delete
echo "Activity backup created: $BACKUP_FILE"
