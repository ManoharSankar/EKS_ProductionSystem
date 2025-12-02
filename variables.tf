variable "cluster_name" {
description = "Name of the EKS cluster"
type = string
default = "eks-demo"
}


variable "cluster_version" {
description = "EKS Kubernetes version"
type = string
default = "1.31"
}


variable "vpc_cidr" {
description = "CIDR block for the VPC"
type = string
default = "10.0.0.0/16"
}


variable "public_subnets" {
description = "Public subnet CIDRs"
type = list(string)
default = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "azs" {
description = "Availability zones"
type = list(string)
default = ["ap-south-1a", "ap-south-1b"]
}


variable "desired_size" {
type = number
default = 2
}


variable "min_size" {
type = number
default = 1
}


variable "max_size" {
type = number
default = 3
}


variable "instance_types" {
description = "Instance types for EKS worker nodes"
type = list(string)
default = ["t2.medium"]
}