# 1. Network Module
module "network" {
  source          = "../../modules/network"
  name            = "mrk8s-us-east-vpc"
  cidr            = "10.3.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.3.1.0/24", "10.3.2.0/24"]
  private_subnets = ["10.3.10.0/24", "10.3.11.0/24"]
}

# 2. EKS Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "mrk8s-us-east-1"
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

# 3. Database Module (US East Read Replica)
module "database" {
  source              = "../../modules/database"
  identifier          = "mrk8s-us"
  vpc_id              = module.network.vpc_id
  vpc_cidr            = module.network.vpc_cidr_block
  subnet_ids          = module.network.private_subnets
  
  replicate_source_db = "arn:aws:rds:ap-southeast-1:306601824743:db:mrk8s-sg"
  
  db_username         = null
  db_password         = null
  backup_retention_period = 0
}