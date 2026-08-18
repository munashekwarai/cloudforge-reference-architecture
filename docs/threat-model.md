# CloudForge Threat Model

| Threat | Implemented control | Residual production control |
|---|---|---|
| Direct database exposure | Data-only internal network; no published port; explicit Terraform deny | Cloud firewall/security group and continuous exposure scan |
| Proxy compromise reaching data | Proxy does not join data network | Workload identity, host isolation, patched/pinned proxy image |
| Application compromise | App is the only data bridge; non-root/read-only/cap-drop | Least-privilege DB role, egress policy, runtime detection |
| Secret disclosure | File-mounted ignored secrets; no literal passwords | Managed secret store, rotation, audit, short-lived identity |
| TLS downgrade or key misuse | TLS 1.2/1.3, local file boundary | Trusted automated issuance, protected keys, renewal monitoring |
| Configuration drift | Terraform modules, environment roots, native tests, Compose topology tests | Remote state controls, plan approval, drift detection |
| Unhealthy deployment | Layered health checks and smoke test | SLOs, external probes, rollback automation |
| Backup failure or theft | Restricted dump command and documented drill | Encryption, off-host immutable retention, restore evidence |
| Container privilege escalation | Non-root, read-only, no-new-privileges, cap-drop | Seccomp/AppArmor, signed images, patched host |

CloudForge does not claim that a local Docker topology proves cloud enforcement, compliance, or disaster recovery. The policy must be translated to the selected platform and tested there.
