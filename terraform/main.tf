module "cloudwatch_config" {
  source               = "./cloudwatch_config"
  cloudtrail_log_group = "${aws_cloudwatch_log_group.cloudtrail_log_group.name}"
  alarm_actions        = ["${aws_sns_topic.security_alerts.arn}"]
  environment_name     = "${var.environment_name}"
  admin_whitelist      = ["${var.admin_whitelist}"]
}

resource "aws_sns_topic" "security_alerts" {
  name = "security-alerts-topic"
}

resource "aws_cloudtrail" "cloudtrail" {
  name = "CloudTrail-all-regions"
  s3_bucket_name = "${aws_s3_bucket.cloudtrail_bucket.id}"
  s3_key_prefix = "${var.cloudtrail_s3_bucket_prefix}"
  include_global_service_events = true
  is_multi_region_trail = true
  cloud_watch_logs_role_arn = "${aws_iam_role.cloud_watch_logs_role.arn}"
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}"
}

resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name = "CloudTrail/DefaultLogGroup"
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

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "${var.cloudtrail_s3_bucket_name}"
  force_destroy = true
  versioning = {
    enabled = true
  }
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.cloudtrail_s3_bucket_name}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.cloudtrail_s3_bucket_name}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
