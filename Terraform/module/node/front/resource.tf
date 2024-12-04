resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_types["micro"]
  subnet_id              = var.private_subnet_ids[var.instance_indexes["front"]]
  vpc_security_group_ids = [var.security_group_ids["base"], var.security_group_ids["discord_bot"]]
  private_ip             = var.private_ips["front"]
  iam_instance_profile   = var.iam_instance_profile
  
  tags = {
    Name = "Gitfolio Frontend",
    Environment = terraform.workspace,
    Service = "front"
    Type = "ec2"
  }
}
