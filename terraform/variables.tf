# Provider variables
variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}

variable "environment_name" {
  type        = "string"
  description = "Interpolated into the alarm names so it's visible in the Subject line of notifications from SNS. Should be set to something like 'servicename-env' e.g. 'secops-staging'"
}

variable "cloudtrail_s3_bucket_name" {}
variable "cloudtrail_s3_bucket_prefix" {}


# See https://sites.google.com/a/digital.cabinet-office.gov.uk/gds-internal-it/news/aviationhouse-sourceipaddresses for details.
variable "admin_whitelist" {
  default = [
    "80.194.77.90",
    "80.194.77.100",
    "85.133.67.244",
    "93.89.81.78"
  ]
}
