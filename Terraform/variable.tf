// 네트워크 변수
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "nat_cidr" {
  description = "CIDR block for the nat subnet"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
}

variable "nosql_private_ips" {
  description = "Private IPs for NoSQL subnets"
  type        = map(string)
}

variable "elastic_ip_names" {
  description = "Elastic IPs for public subnets"
  type        = map(string)
}

variable "any_ip" {
  description = "IP address for anywhere"
  type        = string
}

variable "instance_names" {
  description = "EC2 instance name"
  type        = list(string)
}

// 인스턴스 변수
variable "instance_types" {
  description = "EC2 instance types"
  type        = map(string)
}

variable "instance_indexes" {
  description = "EC2 instance indexs"
  type        = map(number)
}

variable "private_ips" {
  description = "Private IPs for subnets"
  type        = map(string)
}

variable "iam_instance_profile" {
  description = "IAM instance profile"
  type        = string
}

// 데이터베이스 변수
variable "db_subnet_cidrs" {
  description = "CIDR blocks for the database subnets"
  type        = list(string)
}

variable identifier {
  description = "RDS instance name"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "Database instance type"
  type        = string
}

variable "allocated_storage" {
  description = "Database allocated storage"
  type        = number
}

variable "storage_type" {
  description = "Database storage type"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
}

// 로드 밸런서 변수
variable "route53_domain" {
  description = "Domain for route53"
  type        = string
}

variable "lb_type" {
  description = "Type of load balancer"
  type        = string
}

variable "idle_timeout" {
  description = "Idle timeout for load balancer"
  type        = number
}

variable "delete_protection" {
  description = "Delete protection of load balancer"
  type        = bool
}

variable "target_port" {
  description = "Port for target group to map"
  type        = map(number)
}

variable "target_protocol" {
  description = "Protocol for target group to map"
  type        = string
}

variable "health_threshold" {
  description = "Number of times to check healthiness for load balancer health check"
  type        = number
}

variable "health_interval" {
  description = "Health check interval time(second) for load balancer"
  type        = number
}

variable "health_matcher" {
  description = "Code of correct connection for load balancer"
  type        = string
}

variable "health_path" {
  description = "Path for load balancer health check"
  type        = string
}

variable "health_port" {
  description = "Port for load balancer health check"
  type        = string
}

variable "health_protocol" {
  description = "Protocol for load balancer health check"
  type        = string
}

variable "health_timeout" {
  description = "Time duration for health check failure"
  type        = number
}

variable "health_unthreshold" {
  description = "Number of times to determine unhealthiness"
  type        = number
}

// ECR 변수
variable "ecr_namespace_name" {
  description  = "Namespace of the ECR repository"
  type         = string
}

variable "ecr_repo_name" {
  description  = "Name of the ECR repository"
  type         = list(string)
}

variable "tag_mutability" {
  description  = "Attribute which image tage is mutable"
  type         = string
}

variable "policy_tagStatus" {
  description  = "Tag status of ECR lifesycle policy"
  type         = string
}

variable "policy_countType" {
  description  = "Count type of ECR lifecycle policy"
  type         = string
}

variable "policy_countNum" {
  description  = "Count number of ECR lifecycle policy"
  type         = number
}

variable "ecr_index" {
  description = "Index of ECR"
  type        = number
}


variable "kubernetes_config" {
  type = object({
    worker_count       = number
    pod_network_cidr   = string
    service_cidr       = string
  })
  description = "Kubernetes configuration settings"
}