# This creates the "umbrella" for your global database
resource "aws_rds_global_cluster" "ecommerce" {
  global_cluster_identifier = "global-ecommerce-db"
  engine                   = "aurora-postgresql"
  engine_version           = "15.3" # Must match across all regions
  database_name            = "ecomdb"
  storage_encrypted        = true
}

output "global_cluster_id" {
  value = aws_rds_global_cluster.ecommerce.id
}