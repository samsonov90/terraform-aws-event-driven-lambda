output "iam_role_arns" {
  value = ["${aws_iam_role.event-driven-lambda.*.arn}"]
}

output "lambda_function_names" {
  value = ["${aws_lambda_function.event-driven-lambda.*.function_name}"]
}

output "lambda_function_arns" {
  value = ["${aws_lambda_function.event-driven-lambda.*.arn}"]
}

output "iam_role_policy_ids" {
  value = ["${aws_iam_role_policy.event-driven-lambda.*.id}"]
}

output "iam_role_policy_names" {
  value = ["${aws_iam_role_policy.event-driven-lambda.*.name}"]
}

output "cloudwatch_event_rule_arns" {
  value = ["${aws_cloudwatch_event_rule.event-driven-lambda.*.arn}"]
}

output "cloudwatch_event_rule_names" {
  value = ["${aws_cloudwatch_event_rule.event-driven-lambda.*.name}"]
}

output "lambda_permission_ids" {
  value = ["${aws_lambda_permission.event-driven-lambda.*.id}"]
}
