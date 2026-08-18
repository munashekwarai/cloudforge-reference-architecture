locals {
  trust_zones = {
    public      = { cidr = var.zones.public, internet_routable = true }
    application = { cidr = var.zones.application, internet_routable = false }
    data        = { cidr = var.zones.data, internet_routable = false }
  }
  ingress_rules = [
    { name = "https_to_proxy", source = "internet", destination = "public", protocol = "tcp", ports = [443] },
    { name = "proxy_to_application", source = "public", destination = "application", protocol = "tcp", ports = [8080] },
    { name = "application_to_postgres", source = "application", destination = "data", protocol = "tcp", ports = [5432] }
  ]
  management_rules = [for cidr in var.management_cidrs : {
    name = "management_https", source = cidr, destination = "public", protocol = "tcp", ports = [443]
  }]
  denied_paths = ["internet_to_application", "internet_to_data", "public_to_data", "data_to_public"]
}
