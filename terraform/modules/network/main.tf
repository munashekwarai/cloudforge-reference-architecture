variable "environment" { type = string }
variable "public_cidr" { type = string }
variable "app_cidr" { type = string }
variable "data_cidr" { type = string }
locals {
  trust_zones = { public = var.public_cidr, application = var.app_cidr, data = var.data_cidr }
  firewall_rules = [
    { from = "internet", to = "public", ports = [443] },
    { from = "public", to = "application", ports = [8080] },
    { from = "application", to = "data", ports = [5432] }
  ]
}
output "trust_zones" { value = local.trust_zones }
output "firewall_rules" { value = local.firewall_rules }
