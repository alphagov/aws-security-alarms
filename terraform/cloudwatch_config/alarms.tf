data "template_file" "ip_rule" {
  template = "{$.sourceIPAddress != cloud* && $.sourceIPAddress != AWS* && $.sourceIPAddress != $${ips} }"
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

resource "aws_cloudwatch_log_metric_filter" "root-activity" {
  name = "root-user-activity"
  pattern = "{$.userIdentity.type = Root && $.sourceIPAddress != support.amazonaws.com}"
  log_group_name = "${var.cloudtrail_log_group}"

  metric_transformation {
    name = "RootAccessEventCount"
    namespace = "CloudTrailMetrics"
    value = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "root-activity-alarm" {
  alarm_name = "${var.environment_name}.root-activity-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "RootAccessEventCount"
  namespace = "CloudTrailMetrics"
  period = "300"
  statistic = "Sum"
  threshold = "1"
  alarm_description = "Alarms on Root user activity."
  insufficient_data_actions = []
  alarm_actions = ["${var.alarm_actions}"]
}

resource "aws_cloudwatch_log_metric_filter" "unauthorized" {
  name = "unauthorized-activity"
  pattern = "{($.eventName = ConsoleLogin && $.errorMessage = Failed*) || $.errorCode = *UnauthorizedOperation || $.errorCode = AccessDenied*}"
  log_group_name = "${var.cloudtrail_log_group}"

  metric_transformation {
    name = "UnauthorizedAccessEventCount"
    namespace = "CloudTrailMetrics"
    value = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "unauthorized-activity-alarm" {
  alarm_name = "${var.environment_name}.unauthorized-activity-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "UnauthorizedAccessEventCount"
  namespace = "CloudTrailMetrics"
  period = "300"
  statistic = "Sum"
  threshold = "1"
  alarm_description = "Alarms on unauthorized user activity."
  insufficient_data_actions = []
  alarm_actions = ["${var.alarm_actions}"]
}
