variable "region" {
  description = "AWS region for the EKS deployment"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name_prefix" {
  description = "Prefix for the EKS cluster name"
  type        = string
  default     = "public-eks"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30" # Adjust as needed
}

variable "instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t2.medium"
}