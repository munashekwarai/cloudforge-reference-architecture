terraform { required_version = ">= 1.6" }
module "network" {
  source           = "../../modules/network"
  environment      = "local"
  zones            = { public = "172.30.0.0/24", application = "172.31.0.0/24", data = "172.32.0.0/24" }
  management_cidrs = ["127.0.0.1/32"]
}
module "services" {
  source = "../../modules/service_policy"
  services = {
    proxy    = { zone = "public", run_as_non_root = true, read_only_root = true, healthcheck = true, published_ports = [443], secrets = ["tls_certificate"] }
    app      = { zone = "application", run_as_non_root = true, read_only_root = true, healthcheck = true, published_ports = [], secrets = ["database_password"] }
    database = { zone = "data", run_as_non_root = true, read_only_root = true, healthcheck = true, published_ports = [], secrets = ["database_password"] }
  }
}
output "network_policy" { value = module.network.policy_summary }
output "allowed_ingress" { value = module.network.allowed_ingress }
output "service_policy_violations" { value = module.services.violations }
