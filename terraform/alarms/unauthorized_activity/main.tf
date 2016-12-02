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
