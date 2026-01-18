# 1. Network Module (Local Ireland VPC)
module "network" {
  source          = "../../modules/network"
  name            = "mrk8s-ie-vpc"
  cidr            = "10.2.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b"]
  public_subnets  = ["10.2.1.0/24", "10.2.2.0/24"]
  private_subnets = ["10.2.10.0/24", "10.2.11.0/24"]
}

# 2. EKS Module (Ireland Cluster)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "mrk8s-eu-west-1"
  cluster_version = "1.29"

  vpc_id                         = module.network.vpc_id
  subnet_ids                     = module.network.private_subnets
  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    nodes = {
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 2
      desired_size   = 2
    }
  }
}

# 3. Database Module (Cross-Region Replica)
module "database" {
  source      = "../../modules/database"
  identifier  = "mrk8s-ie"
  vpc_id      = module.network.vpc_id
  vpc_cidr    = module.network.vpc_cidr_block
  
  # Crucial: uses Ireland subnets created by the network module above
  subnet_ids  = module.network.private_subnets
  
  # Singapore Primary ARN
  replicate_source_db = "arn:aws:rds:ap-southeast-1:306601824743:db:mrk8s-sg"
  
  # Replicas inherit credentials from Primary
  db_username = null
  db_password = null
  
  # Only primary needs retention > 0
  backup_retention_period = 0
}

# --- OUTPUTS ---
output "endpoints" {
  value = {
    eks_cluster      = module.eks.cluster_name
    replica_postgres = module.database.db_endpoint
    replica_redis    = module.database.redis_endpoint
  }
}