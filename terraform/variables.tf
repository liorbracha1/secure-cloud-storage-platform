variable "bucket_name" {
  description = "The name of the secure cloud S3 bucket"
  type        = string
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-central-1"
}
