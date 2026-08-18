terraform { required_version = ">= 1.6" }
module "network" { source = "../../modules/network"; environment = "local"; public_cidr = "172.30.0.0/24"; app_cidr = "172.31.0.0/24"; data_cidr = "172.32.0.0/24" }
output "network_policy" { value = module.network.firewall_rules }
