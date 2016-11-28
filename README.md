# CloudWatch Metrics and Alarms for CloudTrail logs #

_Work in progress:_ We're currently investigating the best ways to monitor our AWS usage. This is one option we're testing out.

Terraform to setup CloudTrail for sending logs into CloudWatch. Creates metrics and alarms in CloudWatch which trigger notifications to be sent via SNS.

## Alarms ##
  * *unexpected-ip-access:* Triggered by API calls made from IP addresses not set in `var.admin_whitelist`.
  * *root-activity* Triggered by API calls made by the *Root* user account.
  * *unauthorized* Triggered by failed logins from the AWS console. Or API calls which are now allowed for that credential.
