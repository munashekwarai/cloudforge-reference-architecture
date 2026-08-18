locals {
  public_services = [for name, service in var.services : name if length(service.published_ports) > 0]
  violations = concat(
    [for name, service in var.services : "${name}:must_run_as_non_root" if !service.run_as_non_root],
    [for name, service in var.services : "${name}:must_use_read_only_root" if !service.read_only_root],
    [for name, service in var.services : "${name}:must_have_healthcheck" if !service.healthcheck],
    [for name, service in var.services : "${name}:data_service_must_not_publish_ports" if service.zone == "data" && length(service.published_ports) > 0]
  )
}
check "service_baseline" {
  assert {
    condition     = length(local.violations) == 0
    error_message = "service baseline violations: ${join(", ", local.violations)}"
  }
}
