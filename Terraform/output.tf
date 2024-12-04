output "az" {
  description = "AZs of the created AZ"
  value       = local.shared ? module.availability_zones[0].az : null
}

output "amazon_linux_id" {
  description = "Amazon Linux ID of the created AMI"
  value       = local.shared ? module.ami[0].amazon_linux_id : null
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = local.shared ? module.gitfolio_network[0].vpc_id : null
}

output "public_subnet_ids" {
  description = "IDs of the private subnets"
  value       = local.shared ? module.gitfolio_network[0].public_subnet_ids : null
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = local.shared ? module.gitfolio_network[0].private_subnet_ids : null
}

output "security_group_ids" {
  description = "ID of the security group"
  value       = local.shared ? module.gitfolio_network[0].security_group_ids : null
}

output "nosql_id" {
  description = "ID of the NoSQL instance"
  value       = local.shared ? module.gitfolio_nosql[*].nosql_id : null
}
