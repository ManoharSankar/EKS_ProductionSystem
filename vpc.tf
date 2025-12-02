# Create a VPC with ONLY public subnets across 3 AZs
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name = "${local.cluster_name}-vpc"
  cidr = var.vpc_cidr
  
  # Configuration for 3 Availability Zones
  azs              = local.azs
  
  # CRITICAL: Do not create private subnets
  private_subnets  = []
  
  # Create 3 public subnets, one for each AZ
  public_subnets   = [
    "10.0.10.0/24", 
    "10.0.11.0/24", 
    "10.0.12.0/24"
  ]
  
  # Configure for public access (Internet Gateway, no NAT Gateway)
  enable_nat_gateway     = false # No NAT Gateway required since we have no private subnets
  enable_dns_hostnames   = true
  enable_dns_support     = true

  # Tag for EKS to auto-discover Load Balancer placement in public subnets
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                      = "1"
  }
}