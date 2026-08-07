# Approved release

Version: `0.7.0`

Published from source commit:

`ff34becfc6e39595c013cd7a0bc5d340d33eb39d`

Approved public images:

- Backend: `ghcr.io/p-r-t-r/pcb-kartoteka-backend:0.7.0@sha256:e428a77e41827f999340d90c723493cf6ee3c946a6a63ef4d937510ec88966a6`
- Frontend: `ghcr.io/p-r-t-r/pcb-kartoteka-frontend:0.7.0@sha256:6ce0754f82ab0c34df920318d63bf6b998bca64b0f4b8c67f16df74665aa96ea`

The release workflow completed successfully on 2026-08-07. Backend and
frontend tests, image-content checks and Trivy high/critical vulnerability
scans passed. Promotion run `31165475524` copied the approved RC3 manifests
without rebuilding, and both public digests match the owner-approved candidate.
Both packages were verified as public for anonymous download. Do not replace
this version with `latest`.

Clean-install workflow `31165991954` deployed the public images without registry
credentials and passed database migration, frontend delivery, security headers,
authentication, role enforcement, rate limiting, core CRUD, cross-project
product flows and Docker network/runtime isolation.
