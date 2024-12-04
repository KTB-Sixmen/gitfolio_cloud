locals {
  shared     = terraform.workspace == "shared"
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
  source                = "./module/network"
  count                 = local.shared ? 1 : 0
  
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  nat_subnet_cidr       = var.nat_cidr
  private_subnet_cidrs  = var.private_subnet_cidrs
  db_subnet_cidrs       = var.db_subnet_cidrs
  availability_zones    = module.availability_zones[0].az
  any_ip                = var.any_ip

  instance_names        = var.instance_names
}

// ============================================================================================================

// Instance
module "gitfolio_front" {
  source               = "./module/node/front"
  count                = local.shared ? 0 : 1

  private_subnet_ids   = data.terraform_remote_state.shared.outputs.private_subnet_ids
  security_group_ids   = data.terraform_remote_state.shared.outputs.security_group_ids
  private_ips          = var.private_ips
  iam_instance_profile = var.iam_instance_profile

  ami_id               = data.terraform_remote_state.shared.outputs.amazon_linux_id
  instance_types       = var.instance_types
  instance_indexes     = var.instance_indexes
}

module "gitfolio_back" {
  source               = "./module/node/back"
  count                = local.shared ? 0 : 4

  private_subnet_ids   = data.terraform_remote_state.shared.outputs.private_subnet_ids
  security_group_ids   = data.terraform_remote_state.shared.outputs.security_group_ids
  private_ips          = var.private_ips
  iam_instance_profile = var.iam_instance_profile

  ami_id               = data.terraform_remote_state.shared.outputs.amazon_linux_id
  instance_types       = var.instance_types
  instance_indexes     = var.instance_indexes

  node_index           = count.index
}

module "gitfolio_ai" {
  source               = "./module/node/ai"
  count                = local.shared ? 0 : 1

  private_subnet_ids   = data.terraform_remote_state.shared.outputs.private_subnet_ids
  security_group_ids   = data.terraform_remote_state.shared.outputs.security_group_ids
  private_ips          = var.private_ips
  iam_instance_profile = var.iam_instance_profile

  ami_id               = data.terraform_remote_state.shared.outputs.amazon_linux_id
  instance_types       = var.instance_types
  instance_indexes     = var.instance_indexes
}

module "gitfolio_k8s" {
  source               = "./module/node/kubernetes"
  count                = local.shared ? 0 : 0

  private_subnet_ids   = data.terraform_remote_state.shared.outputs.private_subnet_ids
  security_group_ids   = data.terraform_remote_state.shared.outputs.security_group_ids
  private_ips          = var.private_ips
  iam_instance_profile = var.iam_instance_profile

  ami_id               = data.terraform_remote_state.shared.outputs.amazon_linux_id
  instance_types       = var.instance_types
  instance_indexes     = var.instance_indexes
}

// ============================================================================================================

// DB
module "gitfolio_rds" {
  source                 = "./module/DB/RDS"
  count                  = local.shared ? 1 : 0

  vpc_id                 = module.gitfolio_network[0].vpc_id
  private_ips            = var.private_ips
  availability_zones     = module.availability_zones[0].az
  security_group_ids     = module.gitfolio_network[0].security_group_ids
  rds_subnet_group_name  = module.gitfolio_network[0].rds_subnet_group_name

  identifier             = var.identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
}

module "gitfolio_nosql" {
  source               = "./module/DB/NoSQL"
  count                = local.shared ? 2 : 0

  vpc_id               = module.gitfolio_network[0].vpc_id
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_ids   = module.gitfolio_network[0].private_subnet_ids
  security_group_ids   = module.gitfolio_network[0].security_group_ids
  private_ips          = var.nosql_private_ips
  iam_instance_profile = var.iam_instance_profile

  ami_id               = module.ami[0].amazon_linux_id
  instance_types       = var.instance_types
  instance_indexes     = var.instance_indexes

  node_index           = count.index
}

// ============================================================================================================

// Application Load Balancer
module "gitfolio_alb" {
  source               = "./module/LB"
  count                = local.shared ? 0 : 1

  vpc_id               = data.terraform_remote_state.shared.outputs.vpc_id
  public_subnet_ids    = data.terraform_remote_state.shared.outputs.public_subnet_ids
  any_ip               = var.any_ip
  frontend_id          = module.gitfolio_front[0].instance_id
  backend_auth_id      = module.gitfolio_back[0].instance_id
  ai_id                = module.gitfolio_ai[0].instance_id
  mongo_id             = data.terraform_remote_state.shared.outputs.nosql_id[0]
  redis_id             = data.terraform_remote_state.shared.outputs.nosql_id[1]
  backend_resume_id    = module.gitfolio_back[1].instance_id
  backend_notification_id = module.gitfolio_back[2].instance_id
  k8s_id               = null#module.gitfolio_k8s[0].instance_id

  route53_domain       = var.route53_domain
  lb_type              = var.lb_type
  idle_timeout         = var.idle_timeout
  delete_protection    = var.delete_protection
  target_port          = var.target_port
  target_protocol      = var.target_protocol
  health_threshold     = var.health_threshold
  health_interval      = var.health_interval
  health_matcher       = var.health_matcher
  health_path          = var.health_path
  health_port          = var.health_port
  health_protocol      = var.health_protocol
  health_timeout       = var.health_timeout
  health_unthreshold   = var.health_unthreshold
}

// ============================================================================================================

module "gitfolio_route53" {
  source               = "./module/Route53"
  count                = local.shared ? 0 : 1

  route53_domain       = var.route53_domain
  alb_dns_name         = module.gitfolio_alb[0].alb_dns_name
  alb_zone_id          = module.gitfolio_alb[0].alb_zone_id
}

// ============================================================================================================

// Container
module "gitfolio_ecr" {
  source             = "./module/ECR"
  count              = local.shared ? 8 : 0
  
  ecr_index          = count.index
  ecr_namespace_name = var.ecr_namespace_name
  ecr_repo_name      = var.ecr_repo_name
  tag_mutability     = var.tag_mutability
  policy_tagStatus   = var.policy_tagStatus
  policy_countType   = var.policy_countType
  policy_countNum    = var.policy_countNum
}