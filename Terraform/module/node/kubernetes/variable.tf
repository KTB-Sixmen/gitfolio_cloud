variable "private_subnet_ids" {
  description = "IDs of the private subnets"
  type        = list(string)
}

variable "instance_types" {
  description = "EC2 instance types"
  type        = map(string)
}

variable "instance_indexes" {
  description = "EC2 instance indexs"
  type        = map(number)
}

variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
}

variable "private_ip" {
  description = "Private IP for subnet"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "IAM instance profile"
  type        = string
}

variable "worker_count" {
  description = "Number of Kubernetes worker nodes"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags for the EC2 instances"
  type        = map(string)
}
