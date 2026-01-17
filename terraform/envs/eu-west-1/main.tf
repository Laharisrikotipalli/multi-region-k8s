provider "aws" {
  region = "eu-west-1"
}

# 1. Network (Ireland)
module "network" {
  source = "../../modules/network"
  name   = "mrk8s-ie-vpc"
  cidr   = "10.2.0.0/16"
  azs    = ["eu-west-1a", "eu-west-1b"]
  
  public_subnets  = ["10.2.1.0/24", "10.2.2.0/24"]
  private_subnets = ["10.2.10.0/24", "10.2.11.0/24"]
}

# 2. EKS (Ireland)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "mrk8s-eu-west-1"
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

# 3. Redis (Ireland)
module "redis" {
  source     = "../../modules/database"
  identifier = "mrk8s-redis-ie"
  vpc_id     = module.network.vpc_id
  vpc_cidr   = module.network.vpc_cidr_block
  subnet_ids = module.network.private_subnets
}

output "redis_endpoint_ie" {
  value = module.redis.redis_endpoint
}