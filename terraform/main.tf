
resource "aws_lambda_function" "lamed-sample-native-image" {
  function_name = "lamed-sample-native-image"
  filename = var.native_image_zip_path
  source_code_hash = filebase64sha256(var.native_image_zip_path)
  role          = aws_iam_role.lamed_sample_app.arn
  handler       = "not-used-by-lamed"  # lamed ignores this
  runtime       = "provided"
  memory_size   = 512
  timeout       = 300
}

# resource "aws_lambda_function" "lamed-sample-uberjar" {
#   function_name = "lamed-sample-uberjar"
#   filename = var.uberjar_path
#   source_code_hash = filebase64sha256(var.uberja_path)
#   role          = aws_iam_role.lamed_sample_app.arn
#   handler       = "not-used-by-lamed"
#   runtime       = "provided"
#   memory_size   = 512
#   timeout       = 300
# }

data "aws_iam_policy_document" "lamed_sample_app" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "lamed_sample_app" {
  name = "lamed_sample_app"

  assume_role_policy = data.aws_iam_policy_document.lamed_sample_app.json
}

#
# Lambda logs
#


data "aws_iam_policy_document" "lambda_logs" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}
resource "aws_iam_policy" "lambda_logs" {
  name = "moloch-handler-logs"
  path = "/"
  description = "IAM policy for logging to enable cloudwatch logging from lambda"

  policy = data.aws_iam_policy_document.lambda_logs.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lamed_sample_app.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}

