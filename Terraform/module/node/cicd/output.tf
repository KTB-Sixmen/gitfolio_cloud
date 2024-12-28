output "instance_id" {
  description = "The ID of the Jenkins EC2 instance"
  value       = aws_instance.jenkins.id
}
