output "cluster_name" {
value = module.eks.cluster_name
}


output "cluster_endpoint" {
value = module.eks.cluster_endpoint
}


output "node_group_arn" {
  value = module.eks.eks_managed_node_groups["worker_ng"].arn
}

