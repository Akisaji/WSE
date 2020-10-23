#add aws provider
provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

#create iam role for lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#create lambda function
#assuming the lambda adds the tag
resource "aws_lambda_function" "scan_file" {
  filename      = var.filename
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.handler
  source_code_hash = filebase64sha256(var.filename)
}

#create s3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "portal-file-uploads"
  acl    = "private"
}

#add policy to s3 bucket
resource "aws_s3_bucket_policy" "b" {
  bucket = "${aws_s3_bucket.bucket.id}"

  policy = <<POLICY
 {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":     "Allow",
      "Action":     "s3:GetObject",
      "Resource":    "arn:aws:s3:::portal-file-uploads/*",
      "Principal":   "*",
      "Condition": {  "StringEquals": {"s3:ExistingObjectTag/${var.tag}": "${var.tag_value}" } }
    }
  ]
}
POLICY
}

#add trigger to bucket
resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = "${aws_s3_bucket.bucket.id}"
  lambda_function {
    lambda_function_arn = "${aws_lambda_function.scan_file.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "file-prefix"
    filter_suffix       = "file-extension"                                   
  }
}

#add permission for the lambda
resource "aws_lambda_permission" "allow_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.scan_file.function_name}"
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::${aws_s3_bucket.bucket.id}"
}

#upload a file to test
#the path to this file doesn't exist
resource "aws_s3_bucket_object" "file_upload" {
  bucket = aws_s3_bucket.b.id
  key    = var.object_key
  source = var.object_source
}
