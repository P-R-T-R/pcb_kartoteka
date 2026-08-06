#!/bin/sh
set -eu

BACKUP_DIR="${BACKUP_DIR:-./backups}"
RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-14}"
TIMESTAMP="$(date -u +%Y%m%d_%H%M%S)"
BACKUP_FILE="$BACKUP_DIR/pcb_backup_${TIMESTAMP}.sql.gz"
TEMP_FILE="${BACKUP_FILE}.tmp"

mkdir -p "$BACKUP_DIR"
trap 'rm -f "$TEMP_FILE"' EXIT

docker compose exec -T postgres sh -c 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB"' | gzip > "$TEMP_FILE"
test -s "$TEMP_FILE"
gzip -t "$TEMP_FILE"
gunzip -c "$TEMP_FILE" | grep -Eq '^(CREATE TABLE|CREATE SCHEMA|COPY .+ FROM stdin;|INSERT INTO )'
mv "$TEMP_FILE" "$BACKUP_FILE"
find "$BACKUP_DIR" -type f -name 'pcb_backup_*.sql.gz' -mtime "+$RETENTION_DAYS" -delete

echo "Backup created: $BACKUP_FILE"
