provider "aws" {
  region = "ap-southeast-1"
}

# 1. Network (Singapore)
module "network" {
  source = "../../modules/network"
  name   = "mrk8s-sg-vpc"
  cidr   = "10.1.0.0/16"
  azs    = ["ap-southeast-1a", "ap-southeast-1b"]
  
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets = ["10.1.10.0/24", "10.1.11.0/24"]
}

# 2. EKS (Singapore)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "mrk8s-ap-southeast-1"
  cluster_version = "1.29"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnets
  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    nodes = {
      instance_types = ["t3.medium"]
      min_size     = 1
      max_size     = 2
      desired_size = 2
    }
  }
}

# 3. Redis (Singapore)
module "redis" {
  source     = "../../modules/database"
  identifier = "mrk8s-redis-sg"
  vpc_id     = module.network.vpc_id
  vpc_cidr   = module.network.vpc_cidr_block
  subnet_ids = module.network.private_subnets
}

output "redis_endpoint_sg" {
  value = module.redis.redis_endpoint
}
module "database" {
  source      = "../../modules/database"
  identifier  = "mrk8s-sg"
  vpc_id      = module.network.vpc_id
  vpc_cidr    = module.network.vpc_cidr_block
  subnet_ids  = module.network.private_subnets
  
  # PostgreSQL Credentials
  db_username = "dbadmin"
  db_password = "YourSecurePassword123!" # In production, use Secrets Manager
}

output "singapore_endpoints" {
  value = {
    postgres = module.database.db_endpoint
    redis    = module.database.redis_endpoint
  }
}