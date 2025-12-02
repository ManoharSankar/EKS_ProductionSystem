module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.30.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  tags = {
    Project = var.cluster_name
  }
}

module "eks_managed_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.30.0"

  cluster_name    = module.eks.cluster_name
  cluster_version = module.eks.cluster_version
  subnet_ids      = module.vpc.private_subnets

  name = "managed-ng"

  instance_types = ["t2.medium"]

  desired_size = 2
  min_size     = 1
  max_size     = 3

  tags = {
    Name    = "managed-ng"
    Project = var.cluster_name
  }
}
