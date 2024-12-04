variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Available zones for subnet"
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

variable "private_ips" {
  description = "Private IPs for subnets"
  type        = map(string)
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = map(string)
}

variable "rds_subnet_group_name" {
  description = "RDS subnet group name"
  type        = string
}