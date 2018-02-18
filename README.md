# Event-driven AWS Lambda
This module allows to deploy AWS Lambda functions with AWS CloudWatch event rules<br><br>

<b>Input variables</b><br>
- `lambda_args` - Parameter sets to configure AWS Lambda used with associated Cloudwatch Events Rule
- `default_lambda_args` - (Optional) Default parameters

<b>Output variables</b><br>
- `iam_role_arns` - List of IAM roles associated with deployed Lambda functions
- `lambda_function_names` - List of names associated with deployed Lambda functions
- `lambda_function_arns` - List of deployed Lambda functions ARN
- `iam_role_policy_ids` - List of IAM role policy id associated with deployed Lambda functions
- `iam_role_policy_names` - List of IAM role policy names associated with deployed Lambda functions
- `cloudwatch_event_rule_arns` - List of ARN of deployed CloudWatch Event Rules
- `cloudwatch_event_rule_names` - List of names of deployed CloudWatch Event Rules
- `lambda_permission_ids` - List of id of Lambda permissions associated with deployed Lambda functions


<b>Example of usage</b><br>

```js

module "event-driven-lambda" {
  source      = "samsonov90/event_driven_lambda/aws"
  lambda_args = [
    {
      function_name    = "ingestor"
      source           = "ingestor/main.py"
      filename         = "ingestor.zip"
      template         = "ingestor.json"
      source_code_hash = "ingestor_source_code_hash"
      timeout          = "300"
      rule_name        = "ingestor-schedule"
      schedule         = "rate(1 day)"
    },
    {
      function_name    = "alarm"
      source           = "alarm/main.py"
      filename         = "alarm.zip"
      template         = "alarm.json"
      source_code_hash = "alarm_source_code_hash"
      rule_name        = "alarm-event-pattern"
      event_pattern    = <<PATTERN
      {
        "source": [
          "aws.ec2",
        ],
        "detail-type": [
          "EC2 Instance State-change Notification",
        ],
        "detail": {
          "state": [
            "running",
          ]
        }
      }
      PATTERN
    },
  ]
  default_lambda_args = {
      handler                  = "main.handler"
      timeout                  = "10"
      runtime                  = "python2.7"
      iam_role_policy_document = "default_iam_role_policy_document"
  }
}

```


Author
------
Created and maintained by [Sergey_Samsonov](https://github.com/SamsonovDev)
