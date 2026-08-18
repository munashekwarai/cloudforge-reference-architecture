variable "services" {
  type = map(object({ zone = string, run_as_non_root = bool, read_only_root = bool, healthcheck = bool, published_ports = list(number), secrets = list(string) }))
}
