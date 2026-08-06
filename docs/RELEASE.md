# Approved release

Version: `0.6.0`

Published from source commit:

`da83daeca1dff86e048f1a3e4474f8cdaa391108`

Approved public images:

- Backend: `ghcr.io/p-r-t-r/pcb-kartoteka-backend:0.6.0@sha256:46c4c33a8c6fc9942971dd34244840838883b0f3aacccf019c7fc2593df8c6bf`
- Frontend: `ghcr.io/p-r-t-r/pcb-kartoteka-frontend:0.6.0@sha256:cacb597ab04b7155ae1de48f9530027a6f677c521e6cc72513c54acbda951d4e`

The release workflow completed successfully on 2026-08-06. Backend and
frontend tests, image-content checks and Trivy high/critical vulnerability
scans passed. Both packages were verified as public for anonymous download. Do not replace this
version with `latest`. A clean installation from these public images passed
database migration, frontend delivery, security headers, authentication and
role enforcement, login rate limiting, core CRUD and cross-project execution
flows, private-read-default checks, and Docker network/runtime isolation.
