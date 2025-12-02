# -----------------------------

# VPC MODULE

# -----------------------------

module "vpc" {
source  = "terraform-aws-modules/vpc/aws"
version = "5.0.0"

name = "eks-vpc"
cidr = "10.0.0.0/16"

azs            = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

enable_dns_hostnames = true
enable_dns_support   = true

tags = {
"kubernetes.io/cluster/eks-cluster" = "shared"
}

public_subnet_tags = {
"kubernetes.io/role/elb" = "1"
}

private_subnet_tags = {
"kubernetes.io/role/internal-elb" = "1"
}
}

# -----------------------------

# IAM ROLE - EKS CLUSTER

# -----------------------------

resource "aws_iam_role" "eks_cluster_role" {
name = "eks-cluster-role"

assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [{
Action = "sts:AssumeRole"
Effect = "Allow"
Principal = { Service = "eks.amazonaws.com" }
}]
})
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
role       = aws_iam_role.eks_cluster_role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# -----------------------------

# IAM ROLE - MANAGED NODE GROUP

# -----------------------------

resource "aws_iam_role" "eks_node_role" {
name = "eks-node-role"

assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [{
Effect = "Allow"
Principal = { Service = "ec2.amazonaws.com" }
Action = "sts:AssumeRole"
}]
})
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
role       = aws_iam_role.eks_node_role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
role       = aws_iam_role.eks_node_role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_registry" {
role       = aws_iam_role.eks_node_role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# -----------------------------

# EKS CLUSTER

# -----------------------------

module "eks" {
source  = "terraform-aws-modules/eks/aws"
version = "20.8.5"

cluster_name    = "eks-cluster"
cluster_version = "1.31"

vpc_id     = module.vpc.vpc_id
subnet_ids = module.vpc.public_subnets

cluster_endpoint_public_access = true

enable_cluster_creator_admin_permissions = true

tags = {
Environment = "dev"
Terraform   = "true"
}
}


# -----------------------------

# EKS MANAGED NODE GROUP

# -----------------------------

module "eks_managed_node_group" {
source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
version = "20.8.5"

cluster_name = module.eks.cluster_name
name         = "eks-managed-ng"
iam_role_arn = aws_iam_role.eks_node_role.arn   # <- use iam_role_arn, not node_role_arn

subnet_ids = module.vpc.private_subnets

instance_types = ["t2.medium"]

desired_size = 2
min_size = 1
max_size = 3

capacity_type = "ON_DEMAND"


tags = {
Name = "eks-managed-ng"
}
}

