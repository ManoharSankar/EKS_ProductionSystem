output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "Cluster CA Certificate"
  value       = module.eks.cluster_certificate_authority_data
}

output "managed_node_group_name" {
  description = "EKS Managed Node Group Name"
  value       = keys(module.eks.managed_node_groups)[0]
}

output "managed_node_group_arn" {
  description = "EKS Managed Node Group ARN"
  value       = module.eks.managed_node_groups_arns["eks-managed-ng"]
}
