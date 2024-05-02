variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the existing EC2 key pair"
  default = "dpp"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for remote state"
  default = "terraform.s3.22-04-24"
}

variable "name" {
  description = "testing_terraform"
}