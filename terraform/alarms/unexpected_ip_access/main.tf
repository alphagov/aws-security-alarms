data "template_file" "ip_rule" {
  template = "{$.userIdentity.type = IAMUser && $.sourceIPAddress != *amazonaws.com && $.sourceIPAddress != AWS* && $.sourceIPAddress != $${ips} }"
  vars {
    ips = "${join(" && $.sourceIPAddress != ", var.admin_whitelist)}"
  }
}

resource "aws_cloudwatch_log_metric_filter" "unexpected-ip-access" {
  name = "${var.environment_name}.unexpected-ip-access"
  pattern = "${data.template_file.ip_rule.rendered}"
  log_group_name = "${var.cloudtrail_log_group}"

  metric_transformation {
    name = "UnexpectedIPAccessEventCount"
    namespace = "CloudTrailMetrics"
    value = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "unexpected-ip-access-alarm" {
  alarm_name = "${var.environment_name}.unexpected-ip-access-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "UnexpectedIPAccessEventCount"
  namespace = "CloudTrailMetrics"
  period = "300"
  statistic = "Sum"
  threshold = "1"
  alarm_description = "Alarms on access from unexpected IP addresses"
  insufficient_data_actions = []
  alarm_actions = ["${var.alarm_actions}"]
}
