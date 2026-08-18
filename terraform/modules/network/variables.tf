variable "environment" {
  type = string
  validation {
    condition     = contains(["local", "development", "production"], var.environment)
    error_message = "environment must be local, development, or production"
  }
}
variable "zones" {
  type = object({ public = string, application = string, data = string })
  validation {
    condition     = length(distinct(values(var.zones))) == 3
    error_message = "trust-zone CIDRs must be unique"
  }
}
variable "management_cidrs" {
  type = list(string)
  validation {
    condition     = length(var.management_cidrs) > 0
    error_message = "at least one explicit management CIDR is required"
  }
}
