data "aws_iam_policy" "eks_cluster" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy" "eks_service" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

data "aws_iam_policy" "worker_node" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "ecr_read" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "cni" {
  arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Cluster Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role-ap-south-1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = { Service = "eks.amazonaws.com" },
      Effect   = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_attach_cluster" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = data.aws_iam_policy.eks_cluster.arn
}

resource "aws_iam_role_policy_attachment" "cluster_attach_service" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = data.aws_iam_policy.eks_service.arn
}

# Node Group Role
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role-ap-south-1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = { Service = "ec2.amazonaws.com" },
      Effect   = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_attach_worker" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = data.aws_iam_policy.worker_node.arn
}

resource "aws_iam_role_policy_attachment" "node_attach_ecr" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = data.aws_iam_policy.ecr_read.arn
}

resource "aws_iam_role_policy_attachment" "node_attach_cni" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = data.aws_iam_policy.cni.arn
}
