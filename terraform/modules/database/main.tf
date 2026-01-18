# --- SECURITY GROUP ---
resource "aws_security_group" "db_sg" {
  # REVERTED: Matching the exact name/description currently in AWS
  name        = "${var.identifier}-db-sg-final" 
  description = "Allow access to RDS and Redis"
  vpc_id      = var.vpc_id

  # PostgreSQL Access
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Redis Access
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- RDS SUBNET GROUP ---
resource "aws_db_subnet_group" "db_group" {
  # REVERTED: Matching the exact name used in AWS
  name       = "${var.identifier}-subnets-final"
  subnet_ids = var.subnet_ids
}

# --- RDS INSTANCE (Primary or Replica) ---
resource "aws_db_instance" "this" {
  identifier           = var.identifier
  instance_class       = "db.t3.micro"
  db_subnet_group_name = aws_db_subnet_group.db_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot  = true

  replicate_source_db = var.replicate_source_db
  
  engine            = var.replicate_source_db == null ? "postgres" : null
  username          = var.replicate_source_db == null ? var.db_username : null
  password          = var.replicate_source_db == null ? var.db_password : null
  allocated_storage = var.replicate_source_db == null ? 20 : null
  
  backup_retention_period = var.backup_retention_period
}

# --- REDIS SUBNET GROUP ---
resource "aws_elasticache_subnet_group" "redis_subnets" {
  name       = "${var.identifier}-redis-subnets-final"
  subnet_ids = var.subnet_ids
}

# --- REDIS REPLICATION GROUP ---
resource "aws_elasticache_replication_group" "this" {
  replication_group_id = "${var.identifier}-redis"
  description          = "Redis for ${var.identifier}"
  node_type            = "cache.t3.micro"
  port                 = 6379
  engine               = "redis"
  engine_version       = "7.0"
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnets.name
  security_group_ids   = [aws_security_group.db_sg.id]
  
  num_cache_clusters         = 1
  automatic_failover_enabled = false
}