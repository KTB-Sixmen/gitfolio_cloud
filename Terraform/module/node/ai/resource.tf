resource "aws_instance" "ai" {
  ami                    = var.ami_id
  instance_type          = var.instance_types["micro"]
  subnet_id              = var.private_subnet_ids[var.instance_indexes["ai"]]
  vpc_security_group_ids = [var.security_group_ids["base"]]
  private_ip             = var.private_ips["ai"]
  iam_instance_profile   = "gitfolio_ec2_iam_profile"
  
  tags = {
    Name = "Gitfolio AI"
    Environment = terraform.workspace
    Service = "ai"
    Type = "ec2"
  }
}