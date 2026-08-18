output "trust_zones" { value = local.trust_zones }
output "allowed_ingress" { value = concat(local.ingress_rules, local.management_rules) }
output "explicitly_denied_paths" { value = local.denied_paths }
output "policy_summary" {
  value = {
    environment       = var.environment
    public_entrypoint = "443/tcp"
    database_exposure = "application zone only"
    default_posture   = "deny unless listed"
  }
}
