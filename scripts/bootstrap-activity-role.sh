#!/bin/sh
set -eu

: "${PGHOST:?PGHOST is required}"
: "${PGUSER:?PGUSER is required}"
: "${PGPASSWORD:?PGPASSWORD is required}"
: "${PGDATABASE:?PGDATABASE is required}"
: "${ACTIVITY_RUNTIME_PASSWORD:?ACTIVITY_RUNTIME_PASSWORD is required}"

psql --set=ON_ERROR_STOP=1 <<'SQL'
\getenv activity_password ACTIVITY_RUNTIME_PASSWORD
SELECT 'CREATE ROLE pcb_activity_writer LOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'pcb_activity_writer')
\gexec
ALTER ROLE pcb_activity_writer PASSWORD :'activity_password';
ALTER ROLE pcb_activity_writer NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION;
SELECT format('REVOKE CREATE ON DATABASE %I FROM PUBLIC', current_database())
\gexec
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
SELECT format('GRANT CONNECT ON DATABASE %I TO pcb_activity_writer', current_database())
\gexec
GRANT USAGE ON SCHEMA public TO pcb_activity_writer;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM pcb_activity_writer;
GRANT SELECT, INSERT ON change_events TO pcb_activity_writer;
GRANT SELECT ON activity_schema_migrations TO pcb_activity_writer;
SQL
