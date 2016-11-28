variable "environment_name" {
  type = "string"
}
variable "cloudtrail_log_group" {
  type = "string"
}
variable "admin_whitelist" {
  type = "list"
}
variable "alarm_actions" {
  type = "list"
}
