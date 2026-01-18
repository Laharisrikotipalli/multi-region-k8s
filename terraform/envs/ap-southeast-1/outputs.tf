output "db_endpoint" {
  value = module.database.db_endpoint
}

output "redis_endpoint" {
  value = module.database.redis_endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}