# Private registry access

The application images are private:

- `ghcr.io/p-r-t-r/pcb-kartoteka-backend`
- `ghcr.io/p-r-t-r/pcb-kartoteka-frontend`

Create a dedicated GitHub service account for each customer installation. Grant that account read access to both container packages. Do not reuse a developer or administrator account.

GitHub Container Registry currently requires a personal access token (classic) for command-line package access. Create a token for the service account with only `read:packages`. Do not grant `write:packages`, repository access or organization administration.

Authenticate once on the Docker host:

```sh
printf '%s' "$GHCR_READ_TOKEN" | docker login ghcr.io --username CUSTOMER_SERVICE_ACCOUNT --password-stdin
```

Remove `GHCR_READ_TOKEN` from the shell immediately after login. Docker stores credentials under the operating account running Compose; protect that account and its Docker configuration. Never place the token in `.env`, Compose, this repository, command history, tickets or chat.

Verify access without starting the service:

```sh
docker pull ghcr.io/p-r-t-r/pcb-kartoteka-backend:APP_VERSION
docker pull ghcr.io/p-r-t-r/pcb-kartoteka-frontend:APP_VERSION
```

Use only an approved immutable version. Compare the resulting digests with the release record. Revoke the service account or token when the installation is retired or access may have been exposed.
