# Operations

This repository contains customer-owned deployment configuration only. Application source code, customer databases, credentials and backups are not part of it.

## First start

1. Install Docker Engine with the Compose plugin.
2. Copy `.env.example` to `.env` and replace every `CHANGE_ME` value.
3. Keep `POSTGRES_PASSWORD` URL-safe and use the same value inside `DATABASE_URL`.
4. Confirm that `APP_VERSION` and the image digests match `docs/RELEASE.md`.
5. Authenticate Docker to the private image registry as described in `docs/REGISTRY_ACCESS.md`.
6. Run `docker compose config` and inspect the result without publishing it.
7. Run `docker compose pull && docker compose up -d`.
8. Check `docker compose ps` and `curl -fsS http://127.0.0.1:18003/api/health`.

The default bind address is loopback. Put a company-managed HTTPS reverse proxy in front of it. Do not expose PostgreSQL or the backend container directly.

## Updating

1. Create and verify a backup.
2. Change only `APP_VERSION` to the approved immutable release.
3. Run `docker compose pull`.
4. Run `docker compose up -d --remove-orphans`.
5. Check health, login, read access and one write operation.
6. Keep the previous image version available for rollback.

Never use a `latest` tag. Record the approved version and both image digests from `docs/RELEASE.md` in the change ticket before updating.

## Backup and restore

Run `sh scripts/backup.sh` from the repository root. Copy verified backups to encrypted storage outside this host. Test restore regularly on an isolated environment.

Restore is destructive: `sh scripts/restore.sh <backup-file>`. The script requires typing `RESTORE`, stops the backend, replaces the database and starts the backend again.

## Access policy

`PUBLIC_READ_ENABLED=false` requires authentication for normal use. Set it to `true` only when anonymous read access is explicitly accepted by the customer. Administrative and write operations remain authenticated.

The customer owns the domain, TLS certificates, users, database, backups, monitoring and incident response. The product owner supplies signed-off image versions but has no access to customer data.
