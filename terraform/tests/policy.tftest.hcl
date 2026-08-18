run "local_policy_is_segmented" {
  command = plan
  module { source = "./environments/local" }
  assert {
    condition     = output.network_policy.database_exposure == "application zone only"
    error_message = "database exposure changed"
  }
  assert {
    condition     = length(output.allowed_ingress) == 4
    error_message = "unexpected ingress rule count"
  }
  assert {
    condition     = length(output.service_policy_violations) == 0
    error_message = "service baseline violation"
  }
}
