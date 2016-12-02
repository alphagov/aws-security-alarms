variable "environment_name" {
  type = "string"
}

variable "cloudtrail_s3_bucket_name" {
  type = "string"
}

variable "cloudtrail_s3_bucket_prefix" {
  type = "string"
}

module "aws_security_alarms" {
  source                      = "../terraform"
  cloudtrail_s3_bucket_name   = "${var.cloudtrail_s3_bucket_name}"
  cloudtrail_s3_bucket_prefix = "${var.cloudtrail_s3_bucket_prefix}"
}

module "unexpected_ip_access" {
  source               = "../terraform/alarms/unexpected_ip_access"
  cloudtrail_log_group = "${module.aws_security_alarms.cloudtrail_log_group}"
  alarm_actions        = ["${module.aws_security_alarms.security_alerts_topic}"]
  environment_name     = "${var.environment_name}"
}

module "root_activity" {
  source               = "../terraform/alarms/root_activity"
  cloudtrail_log_group = "${module.aws_security_alarms.cloudtrail_log_group}"
  alarm_actions        = ["${module.aws_security_alarms.security_alerts_topic}"]
  environment_name     = "${var.environment_name}"
}

module "unauthorized_activity" {
  source               = "../terraform/alarms/unauthorized_activity"
  cloudtrail_log_group = "${module.aws_security_alarms.cloudtrail_log_group}"
  alarm_actions        = ["${module.aws_security_alarms.security_alerts_topic}"]
  environment_name     = "${var.environment_name}"
}
