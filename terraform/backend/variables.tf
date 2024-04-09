variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default = "acit-assignment3-bucket1"
}

variable "dynamodb_name" {
    description = "DynamoDB table name"
    type        = string
    default = "assignment3-dynamodb"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}