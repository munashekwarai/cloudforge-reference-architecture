# CloudForge Deployment and Recovery

## Local proof

Run `./scripts/bootstrap-local.sh`, `./scripts/validate.sh`, `docker compose up --build -d`, then `./scripts/smoke-test.sh`. The self-signed certificate is local-only. Inspect `docker compose ps`, confirm only `127.0.0.1:8443` is published, and review Terraform outputs before use.

## Environment promotion

Development and production have distinct Terraform roots and CIDRs. Copy the example tfvars outside version control, replace documentation ranges with allocated networks, restrict management to named /32 or approved ranges, review the plan, and require peer approval. Do not reuse local secrets or state.

## Backup and restore

`./scripts/backup.sh` runs a one-shot `pg_dump -Fc` in the data zone. Copy the artifact to encrypted off-host storage with retention. A restore drill must create a fresh PostgreSQL instance, run `pg_restore --clean --if-exists`, start the matching application revision, execute readiness and business smoke checks, and record recovery time. A dump without a successful drill is not a backup guarantee.

## Rollback

Retain immutable application/proxy image references and reviewed Terraform plans. Roll back stateless services first. Database schema changes require backward compatibility or an explicit restore/migration reversal. Never automatically restore an older database over newer accepted writes.
