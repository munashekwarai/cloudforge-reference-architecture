# CloudForge

**Cloud · Infrastructure · DevOps · Security**

## Problem
Internet-facing applications are often placed with databases on one public host.

## Who This Helps
Teams moving from prototypes toward defensible deployments.

## Why It Matters
Excess exposure, configuration drift, weak secret handling, and unclear recovery make infrastructure fragile.

## Constraints
The system must be inexpensive, inspectable, testable without paid services, conservative about claims, and safe with untrusted input. SQLite/local execution is the default; production deployments need deliberate persistence, identity, networking, and backup choices.

## Solution
Terraform modules describe trust zones and firewall policy while a local Docker deployment proves reverse proxy, application health, private data networking, logging, and backups.

## Architecture
```mermaid
flowchart LR
  Internet((Internet)) -->|443 only| Proxy[NGINX public zone]
  subgraph Public[Public network]
    Proxy
  end
  Proxy -->|8080| App[Non-root application]
  subgraph Application[Internal application network]
    App
  end
  App -->|5432| DB[(PostgreSQL)]
  subgraph Data[Internal data network]
    DB
  end
  Secret[Docker secret file] --> DB
  Health[Container health checks] --> Proxy
  Health --> App
  Terraform[Terraform policy model] -. describes .-> Public
  Terraform -. describes .-> Application
  Terraform -. describes .-> Data
```
See [architecture](docs/architecture.md).

## Features
The repository implements its domain engine, validation, durable/local state where applicable, executable interfaces, meaningful tests, structured errors, and automation.

## Technology Stack
Python 3.11 provides a portable typed core; FastAPI provides OpenAPI-backed HTTP endpoints; Typer provides operator-friendly commands; SQLite provides a zero-service evidence store. CloudForge instead uses Terraform, Docker, NGINX, and shell-based verification.

## Setup
```bash
python -m venv .venv
. .venv/bin/activate
pip install -e '.[dev]'
```
Copy `.env.example` to `.env` only for local overrides; `.env` is ignored.

## Usage
```bash
python -m app.cli --help
uvicorn app.api:app --host 127.0.0.1 --port 8000
```
CloudForge users should follow `docs/deployment.md`.

## Testing
```bash
pytest -q
```
Tests exercise domain behavior and failure paths without paid infrastructure.

## Security
Inputs are bounded and validated, secrets are accepted through the environment rather than source, errors avoid sensitive internals, and CI runs tests. See [security](docs/security.md) and [threat model](docs/threat-model.md).

## Limitations
The local topology demonstrates boundaries but is not a managed-cloud production environment or compliance certification.

## Contributing
Read [CONTRIBUTING.md](CONTRIBUTING.md), add tests for behavior changes, and avoid real personal or secret data in fixtures.
