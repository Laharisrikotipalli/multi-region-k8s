output "db_arn" {
  value = aws_db_instance.this.arn
}

output "db_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "redis_endpoint" {
  value = aws_elasticache_replication_group.this.primary_endpoint_address
}