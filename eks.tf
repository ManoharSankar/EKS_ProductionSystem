resource "aws_eks_cluster" "this" {
  name     = "simple-eks-public"
  version  = "1.31"                # the k8s control plane version you requested
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids         = aws_subnet.public[*].id
    endpoint_public_access = true
    endpoint_private_access = false
    public_access_cidrs = ["0.0.0.0/0"]
  }

  # minimal logging (optional)
  enabled_cluster_log_types = ["api", "audit"]
}

# Wait for cluster to become active
data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.this.name
  depends_on = [aws_eks_cluster.this]
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

# Node group (managed)
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "ng-public-1"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = aws_subnet.public[*].id
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  # Use bottlerocket or amazon-linux-2 AMI type if needed:
  # ami_type = "AL2_x86_64"
  remote_access {
    # optional: configure SSH access via key pair if you want to access nodes
    # ec2_ssh_key = "your-keypair-name"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly
  ]
}
