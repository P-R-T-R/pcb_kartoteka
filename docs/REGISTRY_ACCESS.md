# Container image access

The application images are public for anonymous download:

- `ghcr.io/p-r-t-r/pcb-kartoteka-backend`
- `ghcr.io/p-r-t-r/pcb-kartoteka-frontend`

No GitHub account or registry token is required to pull these images. The
application source repository remains private, and the images remain subject
to the proprietary license supplied with this deployment package.

Verify anonymous access without starting the service:

```sh
docker pull ghcr.io/p-r-t-r/pcb-kartoteka-backend:0.6.0
docker pull ghcr.io/p-r-t-r/pcb-kartoteka-frontend:0.6.0
```

Use only the approved immutable version in `docs/RELEASE.md`. Compare both
resulting digests with that record. Never use `latest`.
