variable "lambda_args" {
  type        = "list"
  description = "Parameter sets to configure AWS Lambda used with associated Cloudwatch Events Rule"
}

variable "default_lambda_args" {
  type        = "map"
  description = "Default parameters"
  default     = {}
}
