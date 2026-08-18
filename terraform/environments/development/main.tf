terraform { required_version = ">= 1.6" }
variable "management_cidrs" { type = list(string) }
module "network" {
  source           = "../../modules/network"
  environment      = "development"
  zones            = { public = "10.20.0.0/24", application = "10.20.10.0/24", data = "10.20.20.0/24" }
  management_cidrs = var.management_cidrs
}
output "reviewable_policy" { value = module.network.allowed_ingress }
