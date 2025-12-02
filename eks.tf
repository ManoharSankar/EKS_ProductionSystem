# EKS Cluster definition
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.1.0" 

  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id                   = module.vpc.vpc_id
  # Pass ONLY the public subnets to the EKS cluster
  subnet_ids               = module.vpc.public_subnets

  # EKS control plane endpoint access
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false 

  # EKS Managed Node Group configuration
  eks_managed_node_groups = {
    public_nodes = {
      name           = "public-node-group"
      instance_types = [var.instance_type]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }

  tags = {
    Environment = "Dev"
    Project     = "PublicEKS"
  }
}