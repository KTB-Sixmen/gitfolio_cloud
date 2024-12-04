variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "nat_subnet_cidr" {
  description = "CIDR block for the nat subnet"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for the database subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Available zones for subnet"
  type        = list(string)
}

variable "any_ip" {
  description = "IP address for anywhere"
  type        = string
}

variable "instance_names" {
  description = "EC2 instance name"
  type        = list(string)
}
