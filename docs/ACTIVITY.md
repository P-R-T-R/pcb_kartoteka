# Activity service deployment

Use this overlay only with a release whose backend image includes the Activity
service. The previously published 0.8.2 image does not include it. Keep the exact
approved backend digest: the web API and the worker use the same image in
separate containers.

Add these settings to the deployment environment using three different random
URL-safe values, for example at least 32 hexadecimal characters each:

```dotenv
ACTIVITY_DB_PASSWORD=CHANGE_ME_DATABASE_OWNER_PASSWORD
ACTIVITY_CORE_DB_PASSWORD=CHANGE_ME_OUTBOX_READER_PASSWORD
ACTIVITY_RUNTIME_PASSWORD=CHANGE_ME_ACTIVITY_WRITER_PASSWORD
COMPOSE_FILE=compose.yaml:compose.activity.yaml
```

On Windows use `;` instead of `:` in COMPOSE_FILE. Use this same environment for
all subsequent compose, backup, upgrade and rollback commands. Never print
resolved compose configuration or credentials into support logs.

## Installation and upgrade

1. Back up the core and Activity databases before upgrading.
2. Set the approved application version and digests, then run `docker compose pull`.
3. Stop `activity-service` before an upgrade of an existing installation.
4. Run `docker compose up -d --wait --wait-timeout 180`.
5. Verify `docker compose ps -a`: migration and role-bootstrap jobs must exit 0;
   both databases and both application services must be healthy.
6. Check `docker compose exec -T activity-service python -c "import urllib.request; print(urllib.request.urlopen('http://127.0.0.1:8000/health').read().decode())"`.
   Backlog should drain after normal edits. Investigate persistent backlog or
   unhealthy responses; database availability alone does not prove delivery.

The worker has no host port. Core access is limited to the outbox and its
delivery fields. The Activity database runtime role can select and append
events, not update/delete them or change schema. A one-shot owner migration
prepares the schema before the limited worker starts. Existing pilot events are
preserved by the migration chain.

## Backup and recovery

Use `sh scripts/backup.sh` for core data and `sh scripts/backup-activity.sh` for
the Activity database. Copy both outside the database host with encryption and
retention. Keep dumps until automated physical recovery is proven. The Activity
backup is separate: a backup of the core PostgreSQL volume does not include it.

For a consistent recovery point, pause user writes and stop `activity-service`
before taking both backups. Resume it afterward. On restore, stop the worker,
restore both snapshots into an isolated installation first, run migrations and
role jobs, then verify history and delivery. A core snapshot with events marked
delivered must not be paired silently with an older Activity snapshot. Missing
events require a reviewed replay of core outbox events; do not delete history
or reset all delivery flags as a routine restore operation.

For application rollback, stop the worker and retain its database and the core
outbox. Use the previously approved application digests. Do not downgrade the
Activity schema or delete its volume automatically. Queued events remain for
the next compatible worker. The existing administrator journal uses core audit
records and remains available while the mirror worker is stopped.
