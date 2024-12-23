locals {
  shared = terraform.workspace == "shared"
  dev    = terraform.workspace == "dev"
  prod   = terraform.workspace == "prod"
}

module "ami" {
  source = "./module/AMI"
  count  = local.shared ? 1 : 0
}

module "availability_zones" {
  source = "./module/AZ"
  count  = local.shared ? 1 : 0
}

module "gitfolio_network" {
  source = "./module/network"
  count  = local.shared ? 1 : 0

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  nat_subnet_cidr      = var.nat_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs      = var.db_subnet_cidrs
  availability_zones   = module.availability_zones[0].az
  any_ip               = var.any_ip

  instance_names = var.instance_names
}

// ============================================================================================================

// DB
module "gitfolio_rds" {
  source = "./module/DB/RDS"
  count  = local.shared ? 1 : 0

  vpc_id                = module.gitfolio_network[0].vpc_id
  private_ips           = var.private_ips
  availability_zones    = module.availability_zones[0].az
  security_group_ids    = module.gitfolio_network[0].security_group_ids
  rds_subnet_group_name = module.gitfolio_network[0].rds_subnet_group_name

  identifier        = var.identifier
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  backup_period     = var.backup_period
  backup_window     = var.backup_window
}

module "gitfolio_nosql" {
  source = "./module/DB/NoSQL"
  count  = local.shared ? 3 : 0

  vpc_id               = module.gitfolio_network[0].vpc_id
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_ids   = module.gitfolio_network[0].private_subnet_ids
  security_group_ids   = module.gitfolio_network[0].security_group_ids
  private_ips          = var.nosql_private_ips
  iam_instance_profile = var.iam_instance_profile

  ami_id           = module.ami[0].amazon_linux_id
  instance_types   = var.instance_types
  instance_indexes = var.instance_indexes

  node_index = count.index
}

// ============================================================================================================

// Container
module "gitfolio_ecr" {
  source = "./module/ECR"
  count  = local.shared ? 8 : 0

  ecr_index          = count.index
  ecr_namespace_name = var.ecr_namespace_name
  ecr_repo_name      = var.ecr_repo_name
  tag_mutability     = var.tag_mutability
  policy_tagStatus   = var.policy_tagStatus
  policy_countType   = var.policy_countType
  policy_countNum    = var.policy_countNum
}
