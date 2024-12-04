resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_types["low"]
  subnet_id              = var.private_subnet_ids[var.instance_indexes["back"]]
  vpc_security_group_ids = [var.security_group_ids["base"], var.security_group_ids["back"]]
  private_ip             = var.private_ips["back${ var.node_index + 1 }"]
  iam_instance_profile   = var.iam_instance_profile
  
  tags = {
    Name = "Gitfolio BE${ var.node_index + 1 }"
    Environment = terraform.workspace
    Service = "back"
    Index = var.node_index + 1
    Type = "ec2"
  }
}