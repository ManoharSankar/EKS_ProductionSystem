variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

provider "aws" {
  region = var.region
}
