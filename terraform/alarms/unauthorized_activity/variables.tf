variable "environment_name" {
  type        = "string"
  description = "Interpolated into the alarm names so it's visible in the Subject line of notifications from SNS. Should be set to something like 'servicename-env' e.g. 'secops-staging'"
}

variable "cloudtrail_log_group" {
  type = "string"
}

variable "alarm_actions" {
  type = "list"
}
