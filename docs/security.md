# CloudForge Security Design

- Default posture is deny unless an ingress path is explicitly listed.
- Only the TLS proxy publishes a loopback host port; internal networks prevent direct host routing to application and data services.
- Proxy and app run without root, drop Linux capabilities, use read-only roots, temporary writable paths, health checks, and `no-new-privileges`.
- NGINX permits TLS 1.2/1.3, disables tickets and version disclosure, adds HSTS/content/referrer headers, and bounds upstream timeouts.
- Secrets are files under ignored `.secrets/`, not image layers or literal Compose environment values.
- Terraform validates environment and CIDR choices and checks the service baseline.
- Structured request logs carry request IDs without logging secrets.

Production requires managed certificate renewal, managed secrets, immutable image digests, vulnerability/SBOM scanning, authenticated administration, cloud-native firewall realization, encrypted databases/backups, centralized logs, alerting, patching, and periodic access review.
