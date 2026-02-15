module "gitfolio_master" {
  source = "./module/node/kubernetes"
  count  = local.prod ? 1 : 0

  private_subnet_ids = data.terraform_remote_state.shared.outputs.private_subnet_ids
  security_group_ids = [
    data.terraform_remote_state.shared.outputs.security_group_ids["base"],
    data.terraform_remote_state.shared.outputs.security_group_ids["k8s_master"],
  ]
  private_ip           = var.private_ips["master${count.index + 1}"]
  iam_instance_profile = var.iam_instance_profile

  ami_id           = data.terraform_remote_state.shared.outputs.amazon_linux_id
  instance_types   = var.instance_types
  instance_indexes = var.instance_indexes

  tags = {
    Name    = "Gitfolio k8s master node${count.index + 1}"
    Service = "master"
    DB      = false
    Index   = 0
  }
}

module "gitfolio_ingress" {
  source = "./module/node/kubernetes"
  count  = local.prod ? 1 : 0

  private_subnet_ids = data.terraform_remote_state.shared.outputs.private_subnet_ids
  security_group_ids = [
    data.terraform_remote_state.shared.outputs.security_group_ids["base"],
    data.terraform_remote_state.shared.outputs.security_group_ids["k8s_worker"],
  ]
  private_ip           = var.private_ips["ingress${count.index + 1}"]
  iam_instance_profile = var.iam_instance_profile

  ami_id           = data.terraform_remote_state.shared.outputs.amazon_linux_id
  instance_types   = var.instance_types
  instance_indexes = var.instance_indexes

  tags = {
    Name    = "Gitfolio k8s ingress node${count.index + 1}"
    Service = "worker"
    Ingress = true
    Index   = count.index + 1
  }
}

module "gitfolio_worker" {
  source = "./module/node/kubernetes"
  count  = local.prod ? 6 : 0

  private_subnet_ids = data.terraform_remote_state.shared.outputs.private_subnet_ids
  security_group_ids = [
    for key, value in data.terraform_remote_state.shared.outputs.security_group_ids : value
    if key != "k8s_master" && key != "rds"
  ]
  private_ip           = null
  iam_instance_profile = var.iam_instance_profile

  ami_id           = data.terraform_remote_state.shared.outputs.amazon_linux_id
  instance_types   = var.instance_types
  instance_indexes = var.instance_indexes

  tags = {
    Name    = "Gitfolio k8s worker node${count.index + 1}"
    Service = "worker"
    Ingress = false
    DB      = false
    Index   = count.index + 1
  }
}

module "gitfolio_db" {
  source = "./module/node/kubernetes"
  count  = local.prod ? 3 : 0

  private_subnet_ids = data.terraform_remote_state.shared.outputs.private_subnet_ids
  security_group_ids = [
    data.terraform_remote_state.shared.outputs.security_group_ids["base"],
    data.terraform_remote_state.shared.outputs.security_group_ids["k8s_worker"],
    data.terraform_remote_state.shared.outputs.security_group_ids["nosql"]
  ]
  private_ip           = var.private_ips["db${count.index + 1}"]
  iam_instance_profile = var.iam_instance_profile

  ami_id           = data.terraform_remote_state.shared.outputs.amazon_linux_id
  instance_types   = var.instance_types
  instance_indexes = var.instance_indexes

  tags = {
    Name    = "Gitfolio k8s db node${count.index + 1}"
    Service = "worker"
    Ingress = false
    DB      = true
    Index   = count.index + 1
  }
}

// ============================================================================================================

// Application Load Balancer
module "gitfolio_alb" {
  source = "./module/LB/prod"
  count  = local.prod ? 1 : 0

  vpc_id            = data.terraform_remote_state.shared.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.shared.outputs.public_subnet_ids
  any_ip            = var.any_ip

  listener_arn = data.terraform_remote_state.dev.outputs.listener_arn
  master_id    = module.gitfolio_master[0].instance_id
  ingress_id   = module.gitfolio_ingress[0].instance_id

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

module "gitfolio_route53" {
  source = "./module/Route53"
  count  = local.prod ? 1 : 0

  route53_domain = var.route53_domain
  alb_dns_name   = module.gitfolio_alb[0].alb_dns_name
  alb_zone_id    = module.gitfolio_alb[0].alb_zone_id
}
