output "cluster_name" {
  value = aws_eks_cluster.main.name
}
output "cluster_sg_id" {
  value = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.vpc_config[0].endpoint_public_access
}
