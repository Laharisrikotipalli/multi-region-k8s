# 1. Network Module
module "network" {
  source          = "../../modules/network"
  name            = "mrk8s-sg-vpc"
  cidr            = "10.1.0.0/16"
  azs             = ["ap-southeast-1a", "ap-southeast-1b"]
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets = ["10.1.10.0/24", "10.1.11.0/24"]
}

# 2. EKS Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "mrk8s-ap-southeast-1"
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

# 3. Database Module (Singapore Primary)
module "database" {
  source      = "../../modules/database"
  identifier  = "mrk8s-sg"
  vpc_id      = module.network.vpc_id
  vpc_cidr    = module.network.vpc_cidr_block
  subnet_ids  = module.network.private_subnets
  
  db_username = var.db_username
  db_password = var.db_password
  
  is_primary              = true 
  backup_retention_period = 7  # MUST be 7 for replicas to work
}

output "primary_db_arn" {
  value = module.database.db_arn
}