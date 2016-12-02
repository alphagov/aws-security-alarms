# CloudWatch Metrics and Alarms for CloudTrail logs #

_Work in progress:_ We're currently investigating the best ways to monitor our AWS usage. This is one option we're testing out.

Terraform to setup CloudTrail for sending logs into CloudWatch. Creates metrics and alarms in CloudWatch which trigger notifications to be sent via SNS.

## Alarms ##
  * *unexpected-ip-access:* Triggered by API calls made from IP addresses not set in `var.admin_whitelist`.
  * *root-activity* Triggered by API calls made by the *Root* user account.
  * *unauthorized* Triggered by failed logins from the AWS console. Or API calls which are now allowed for that credential.

## Usage ##

Example: [all-alarms.tf](examples/all-alarms.tf) sets up cloudtrail and enables the alarms provided here.

Configure CloudTrail, CloudWatch and SNS:

```
module "aws-security-alarms" {
  source = "github.com/alphagov/aws-security-alarms//terraform"
  cloudtrail_s3_bucket_name = "some-bucket-to-store-cloudtrail-logs-in"
  cloudtrail_s3_bucket_prefix = "bucket-sub-directory"
}
```

Enable individual alarms:

```
module "unexpected-ip-access" {
  source = "github.com/alphagov/aws-security-alarms//terraform/alarms/unexpected_ip_access"
  cloudtrail_log_group = "${module.aws-security-alarms.cloudtrail_log_group}"
  alarm_actions = ["${module.aws-security-alarms.security-alerts-topic}"]
  environment_name = "test"
}
```

