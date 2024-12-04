output "instance_id" {
  description = "ID of the instance"
  value       = aws_instance.frontend.id
}