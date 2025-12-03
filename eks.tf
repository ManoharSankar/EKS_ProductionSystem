locals {
  cluster_name = "tf-eks-ap-south-1"
  subnet_ids   = aws_subnet.public[*].id
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.31"

  vpc_config {
    subnet_ids             = local.subnet_ids
    endpoint_public_access = true
  }

  tags = {
    Name = local.cluster_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_attach_cluster,
    aws_iam_role_policy_attachment.cluster_attach_service
  ]
}

resource "aws_eks_node_group" "ng_public" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "ng-public"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = local.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.medium"]
  ami_type       = "AL2_x86_64"

  tags = {
    Name = "ng-public"
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}
