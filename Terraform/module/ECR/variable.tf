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