#!/bin/sh
set -eu

: "${PGHOST:?PGHOST is required}"
: "${PGUSER:?PGUSER is required}"
: "${PGPASSWORD:?PGPASSWORD is required}"
: "${PGDATABASE:?PGDATABASE is required}"
: "${ACTIVITY_CORE_DB_PASSWORD:?ACTIVITY_CORE_DB_PASSWORD is required}"

attempts=0
until [ "$(psql -tAc "SELECT to_regclass('public.activity_outbox_events') IS NOT NULL")" = "t" ]; do
    attempts=$((attempts + 1))
    [ "$attempts" -lt 120 ] || { echo 'Core outbox migration is not ready' >&2; exit 1; }
    sleep 1
done

psql --set=ON_ERROR_STOP=1 \
    <<'SQL'
\getenv activity_password ACTIVITY_CORE_DB_PASSWORD
SELECT 'CREATE ROLE pcb_activity_reader LOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'pcb_activity_reader')
\gexec
ALTER ROLE pcb_activity_reader PASSWORD :'activity_password';
ALTER ROLE pcb_activity_reader NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION;
SELECT format('GRANT CONNECT ON DATABASE %I TO pcb_activity_reader', current_database())
\gexec
GRANT USAGE ON SCHEMA public TO pcb_activity_reader;
GRANT SELECT ON activity_outbox_events TO pcb_activity_reader;
GRANT UPDATE (published_at, delivery_attempts, next_attempt_at, last_error)
    ON activity_outbox_events TO pcb_activity_reader;
SQL
