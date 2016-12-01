variable "environment_name" {
  type        = "string"
  description = "Interpolated into the alarm names so it's visible in the Subject line of notifications from SNS. Should be set to something like 'servicename-env' e.g. 'secops-staging'"
}

variable "cloudtrail_log_group" {
  type = "string"
}

# See https://sites.google.com/a/digital.cabinet-office.gov.uk/gds-internal-it/news/aviationhouse-sourceipaddresses for details.
variable "admin_whitelist" {
  type = "list"
  default = [
    "80.194.77.90",
    "80.194.77.100",
    "85.133.67.244",
    "93.89.81.78"
  ]
}

variable "alarm_actions" {
  type = "list"
}
