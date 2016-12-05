resource "aws_cloudwatch_log_metric_filter" "root-activity" {
  name = "root-user-activity"
  pattern = "{$.userIdentity.type = Root && $.sourceIPAddress != *.amazonaws.com}"
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
