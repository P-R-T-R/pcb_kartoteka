# Deploy repository context

This repository is a customer-owned installation boundary for PCB Kartoteka.
It is independent of the application's private source repository.

## Included

- Docker Compose configuration using prebuilt versioned images;
- an environment variable example without credentials;
- a local HTTP gateway configuration;
- startup, update, backup and restore instructions;
- integrity hashes for generated release files.

## Excluded

- backend and frontend source code;
- image build instructions;
- real environment files, credentials or tokens;
- databases, backups and customer files;
- internal development context;
- owner or customer account names;
- private server addresses.

## Ownership boundary

The customer controls the domain, TLS termination, users, database, backups,
monitoring and incident response. The application publisher supplies approved
container image names and immutable versions. Product support does not require
access to customer data.

Generated files are exported through an allowlist and recorded in
`release-files.json`. Changes to generated files must be reviewed against that
manifest before use.
