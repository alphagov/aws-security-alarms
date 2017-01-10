resource "aws_sns_topic" "security_alerts" {
  name = "security-alerts-topic"
}

resource "aws_cloudtrail" "cloudtrail" {
  name = "CloudTrail-all-regions"
  s3_bucket_name = "${var.cloudtrail_s3_bucket_name}"
  s3_key_prefix = "${var.cloudtrail_s3_bucket_prefix}"
  include_global_service_events = true
  is_multi_region_trail = true
  cloud_watch_logs_role_arn = "${aws_iam_role.cloud_watch_logs_role.arn}"
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}"
  enable_log_file_validation = true
}

resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name = "CloudTrail/LogGroup"
  retention_in_days = 90
}

resource "aws_iam_role" "cloud_watch_logs_role" {
  name = "CloudWatch-for-CloudTrail"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloud_watch_policy" {
  name   = "CloudWatch-policy"
  role   = "${aws_iam_role.cloud_watch_logs_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream"
      ],
      "Resource": [
        "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}"
      ]
    }
  ]
}
EOF
}

output "cloudtrail_log_group" {
  value = "${aws_cloudwatch_log_group.cloudtrail_log_group.id}"
}

output "security_alerts_topic" {
  value = "${aws_sns_topic.security_alerts.arn}"
}
