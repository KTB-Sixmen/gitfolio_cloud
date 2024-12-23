// Instance
module "gitfolio_front" {
  source = "./module/node/front"
  count  = local.dev ? 1 : 0

  private_subnet_ids   = data.terraform_remote_state.shared.outputs.private_subnet_ids
  security_group_ids   = data.terraform_remote_state.shared.outputs.security_group_ids
  private_ips          = var.private_ips
  iam_instance_profile = var.iam_instance_profile

  ami_id           = data.terraform_remote_state.shared.outputs.amazon_linux_id
  instance_types   = var.instance_types
  instance_indexes = var.instance_indexes
}

module "gitfolio_back" {
  source = "./module/node/back"
  count  = local.dev ? 3 : 0

  private_subnet_ids   = data.terraform_remote_state.shared.outputs.private_subnet_ids
  security_group_ids   = data.terraform_remote_state.shared.outputs.security_group_ids
  private_ips          = var.private_ips
  iam_instance_profile = var.iam_instance_profile

  ami_id           = data.terraform_remote_state.shared.outputs.amazon_linux_id
  instance_types   = var.instance_types
  instance_indexes = var.instance_indexes

  node_index = count.index
}

module "gitfolio_ai" {
  source = "./module/node/ai"
  count  = local.dev ? 1 : 0

  private_subnet_ids   = data.terraform_remote_state.shared.outputs.private_subnet_ids
  security_group_ids   = data.terraform_remote_state.shared.outputs.security_group_ids
  private_ips          = var.private_ips
  iam_instance_profile = var.iam_instance_profile

  ami_id           = data.terraform_remote_state.shared.outputs.amazon_linux_id
  instance_types   = var.instance_types
  instance_indexes = var.instance_indexes
}

// cicd shared 에서 상태 참조함
module "gitfolio_cicd" {
  source = "./module/node/cicd"
  count  = local.dev ? 1 : 0

  security_group_ids   = data.terraform_remote_state.shared.outputs.security_group_ids
  instance_types       = var.instance_types
  private_subnet_ids   = data.terraform_remote_state.shared.outputs.private_subnet_ids
  instance_indexes     = var.instance_indexes
  ami_id               = data.terraform_remote_state.shared.outputs.amazon_linux_id # AMI ID도 shared에서 가져옵니다
  private_ips          = var.private_ips
  iam_instance_profile = var.iam_instance_profile
}

// ============================================================================================================

// Application Load Balancer
module "gitfolio_alb_dev" {
  source = "./module/LB/dev"
  count  = local.dev ? 1 : 0

  vpc_id             = data.terraform_remote_state.shared.outputs.vpc_id
  public_subnet_ids  = data.terraform_remote_state.shared.outputs.public_subnet_ids
  any_ip             = var.any_ip
  security_group_ids = data.terraform_remote_state.shared.outputs.security_group_ids

  frontend_id             = module.gitfolio_front[0].instance_id
  backend_auth_id         = module.gitfolio_back[0].instance_id
  ai_id                   = module.gitfolio_ai[0].instance_id
  mongo_id                = data.terraform_remote_state.shared.outputs.nosql_id[0]
  redis_id                = data.terraform_remote_state.shared.outputs.nosql_id[1]
  backend_resume_id       = module.gitfolio_back[1].instance_id
  backend_notification_id = module.gitfolio_back[2].instance_id
  jenkins_id              = module.gitfolio_cicd[0].instance_id

  route53_domain     = var.route53_domain
  lb_type            = var.lb_type
  idle_timeout       = var.idle_timeout
  delete_protection  = var.delete_protection
  target_port        = var.target_port
  target_protocol    = var.target_protocol
  health_threshold   = var.health_threshold
  health_interval    = var.health_interval
  health_matcher     = var.health_matcher
  health_path        = var.health_path
  health_port        = var.health_port
  health_protocol    = var.health_protocol
  health_timeout     = var.health_timeout
  health_unthreshold = var.health_unthreshold
}

// ============================================================================================================

module "gitfolio_route53_dev" {
  source = "./module/Route53"
  count  = local.dev ? 1 : 0

  route53_domain = var.route53_domain
  alb_dns_name   = module.gitfolio_alb_dev[0].alb_dns_name
  alb_zone_id    = module.gitfolio_alb_dev[0].alb_zone_id
}
