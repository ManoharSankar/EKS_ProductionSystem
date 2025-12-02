module "vpc" {
source = "terraform-aws-modules/vpc/aws"
version = "5.0.0"


name = "eks-vpc"
cidr = var.vpc_cidr


azs = var.azs
public_subnets = var.public_subnets


enable_nat_gateway = false
enable_dns_hostnames = true


tags = {
"kubernetes.io/cluster/${var.cluster_name}" = "shared"
}


public_subnet_tags = {
"kubernetes.io/cluster/${var.cluster_name}" = "shared"
"kubernetes.io/role/elb" = "1"
}
}