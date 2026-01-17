# --- POSTGRESQL RDS ---
resource "aws_db_subnet_group" "postgres" {
  name       = "${var.identifier}-pg-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "db_sg" {
  name   = "${var.identifier}-db-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_db_instance" "postgres" {
  identifier           = "${var.identifier}-db"
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "appdb"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot  = true
}

# --- REDIS ELASTICACHE ---
resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.identifier}-rs-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "redis_sg" {
  name   = "${var.identifier}-redis-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.identifier}-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.redis_sg.id]
}

# --- OUTPUTS ---
output "db_endpoint" { value = aws_db_instance.postgres.endpoint }
output "redis_endpoint" { value = aws_elasticache_cluster.redis.cache_nodes[0].address }