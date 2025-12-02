module "eks" {
source = "terraform-aws-modules/eks/aws"
version = "19.15.3"


cluster_name = var.cluster_name
cluster_version = var.cluster_version


vpc_id = module.vpc.vpc_id
subnet_ids = module.vpc.public_subnets


cluster_endpoint_public_access = true


eks_managed_node_groups = {
worker_ng = {
desired_size = var.desired_size
max_size = var.max_size
min_size = var.min_size


instance_types = var.instance_types
subnets = module.vpc.public_subnets
}
}
}