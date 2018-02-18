data "aws_iam_policy_document" "event-driven-lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "event-driven-lambda" {
  count              = "${length(var.lambda_args)}"
  name               = "${lookup(var.lambda_args[count.index],"function_name")}"
  assume_role_policy = "${data.aws_iam_policy_document.event-driven-lambda.json}"
}

resource "aws_lambda_function" "event-driven-lambda" {
  count            = "${length(var.lambda_args)}"
  filename         = "${lookup(var.lambda_args[count.index],"filename")}"
  function_name    = "${lookup(var.lambda_args[count.index],"function_name")}"
  role             = "${aws_iam_role.event-driven-lambda.*.arn[count.index]}"
  handler          = "${lookup(var.lambda_args[count.index],"handler",var.default_lambda_args["handler"])}"
  source_code_hash = "${lookup(var.lambda_args[count.index],"source_code_hash")}"
  runtime          = "${lookup(var.lambda_args[count.index],"runtime",var.default_lambda_args["runtime"])}"
  timeout          = "${lookup(var.lambda_args[count.index],"timeout",var.default_lambda_args["timeout"])}"
}

resource "aws_iam_role_policy" "event-driven-lambda" {
  count  = "${length(var.lambda_args)}"
  name   = "${lookup(var.lambda_args[count.index],"function_name")}"
  role   = "${element(aws_iam_role.event-driven-lambda.*.name,count.index)}"
  policy = "${lookup(var.lambda_args[count.index],"iam_role_policy_document",var.default_lambda_args["iam_role_policy_document"])}"
}

resource "aws_cloudwatch_event_rule" "event-driven-lambda" {
  count               = "${length(var.lambda_args)}"
  name                = "${lookup(var.lambda_args[count.index],"rule_name")}"
  event_pattern       = "${lookup(var.lambda_args[count.index],"event_pattern","")}"
  schedule_expression = "${lookup(var.lambda_args[count.index],"schedule","")}"
}

resource "aws_lambda_permission" "event-driven-lambda" {
  count         = "${length(var.lambda_args)}"
  statement_id  = "AllowExecutionFromCloudWatch${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.event-driven-lambda.*.arn[count.index]}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.event-driven-lambda.*.arn[count.index]}"
}

resource "aws_cloudwatch_event_target" "event-driven-lambda" {
  count     = "${length(var.lambda_args)}"
  rule      = "${aws_cloudwatch_event_rule.event-driven-lambda.*.name[count.index]}"
  target_id = "${aws_lambda_function.event-driven-lambda.*.function_name[count.index]}"
  arn       = "${aws_lambda_function.event-driven-lambda.*.arn[count.index]}"
}
