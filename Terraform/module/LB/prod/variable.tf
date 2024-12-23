variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets"
  type        = list(string)
}

variable "any_ip" {
  description = "IP address for anywhere"
  type        = string
}

variable "listener_arn" {
  description = "ARN of the https listener"
  type        = string
}

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

variable "ingress_id" {
  description = "ID of ingress instance"
  type        = string
}

variable "master_id" {
  description = "ID of master instance"
  type        = string
}
