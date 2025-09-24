variable "prefix" {
  description = "Name prefix for AWS resources"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
