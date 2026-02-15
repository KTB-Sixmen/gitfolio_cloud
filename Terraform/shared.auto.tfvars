// 네트워크 변수
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"] // Load Balancer
nat_cidr            = "10.0.3.0/24"
private_subnet_cidrs = [
  "10.0.4.0/24",   // kubernetes
  "10.0.104.0/24", // front
  "10.0.105.0/24", // back
  "10.0.106.0/24", // AI
  "10.0.107.0/24", // jenkins
  "10.0.108.0/24", // argo
  "10.0.109.0/24", // db_master
  "10.0.110.0/24", // db_slave
]

nosql_private_ips = {
  db_master = "10.0.109.14",
  db_slave1 = "10.0.110.38",
  db_slave2 = "10.0.110.39"
}
any_ip = "0.0.0.0/0"
instance_names = [
  "Kubernetes",
  "Front",
  "Back",
  "AI",
  "Jenkins",
  "Argo",
  "DB_Master",
  "DB_Slave"
]

// 인스턴스 변수
instance_types = {
  micro  = "t2.micro",
  low    = "t3.small",
  medium = "t3.medium"
}

// 쿠버네티스 특화 변수들
kubernetes_config = {
  worker_count     = 2               // 워커 노드 수
  pod_network_cidr = "10.244.0.0/16" // Pod 네트워크 CIDR
  service_cidr     = "10.96.0.0/12"  // 서비스 네트워크 CIDR
}

instance_indexes = {
  kubernetes = 0,
  front      = 1,
  back       = 2,
  ai         = 3,
  jenkins    = 4,
  argo       = 5,
  db_master  = 6,
  db_slave   = 7
}
iam_instance_profile = "gitfolio_ec2_iam_profile"

// DB 변수
db_subnet_cidrs   = ["10.0.200.0/24", "10.0.201.0/24"]
identifier        = "gitfolio-mysql"
engine            = "mysql"
engine_version    = "8.0.35"
instance_class    = "db.t3.micro"
allocated_storage = 20
storage_type      = "gp3"
db_name           = "gitfolio_mysql"
db_username       = "root"
db_password       = "dydrkfl11!"
backup_period     = 7
backup_window     = "03:00-04:00"

// 로드밸런서 변수
route53_domain = "*.gitfolio.site"

// ECR 변수
ecr_namespace_name = "gitfolio"
ecr_repo_name = [
  "front",
  "auth",
  "member",
  "resume",
  "payment",
  "notification",
  "chat",
  "ai"
]
tag_mutability   = "MUTABLE"          // 정책 설명
policy_tagStatus = "any"              // 태그 여부(tagged, untagged, any)
policy_countType = "sinceImagePushed" // 대상 선택 방법(imageCountMoreThan = 특정 수 이상, sinceImagePushed = 특정 기간 이전)
policy_countNum  = 7                  // 대상 선택 기준 값

// 기타
private_ips        = null
lb_type            = null
idle_timeout       = null
delete_protection  = null
target_port        = null
target_protocol    = null
health_threshold   = null
health_interval    = null
health_matcher     = null
health_path        = null
health_port        = null
health_protocol    = null
health_timeout     = null
health_unthreshold = null
ecr_index          = null
