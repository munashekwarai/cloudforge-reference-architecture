# CloudForge Architecture

## System context

CloudForge models three trust zones. Only NGINX publishes a loopback-bound host port; the application and PostgreSQL networks are internal. NGINX can reach the application but cannot directly join the data network. The non-root, read-only application is the sole bridge to PostgreSQL. Database credentials enter through a mounted secret file rather than Compose environment values. Terraform outputs make the intended cross-zone ports reviewable independently of the local runtime.

## Component diagram

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

## Data and control flow

The solid arrows show runtime data or control flow. Dotted arrows, where present, describe policy rather than runtime connectivity. Domain decisions remain independent of CLI and HTTP delivery so they can be tested without binding sockets or paid services. Inputs are validated before persistence or outbound I/O, and evidence is retained at the point where the system makes an operational decision.

## Trust boundaries

1. **External input boundary:** network targets, telemetry, identity requests, documents, logs, or field records are untrusted.
2. **Domain boundary:** validated values enter deterministic policy and state-transition logic.
3. **Persistence boundary:** parameterized or structured writes protect stored operational evidence.
4. **Operator boundary:** alerts, conflict choices, infrastructure deployment, and other consequential actions remain explicit operator responsibilities.

## Failure behavior

Adapters return explicit errors or states rather than manufacturing successful results. Timeouts and unavailable dependencies affect only the relevant operation. The limitations documented in the README define what cannot be inferred from the available evidence.
