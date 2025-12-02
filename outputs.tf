output "cluster_name" {
description = "EKS Cluster Name"
value       = module.eks.cluster_name
}

output "cluster_endpoint" {
description = "EKS Cluster Endpoint"
value       = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
description = "Cluster CA certificate"
value       = module.eks.cluster_certificate_authority_data
}

output "node_group_name" {
description = "EKS Node Group Name"
value       = module.eks_node_group.node_group_name
}
