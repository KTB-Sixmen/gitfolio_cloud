locals {
  index = var.node_index == 0 ? "mongo" : "redis"
}

resource "aws_instance" "nosql" {
  ami                    = var.ami_id
  instance_type          = var.instance_types["micro"]
  subnet_id              = var.private_subnet_ids[var.instance_indexes[local.index]]
  vpc_security_group_ids = [var.security_group_ids["base"], var.security_group_ids[local.index]]
  private_ip             = var.private_ips[local.index]
  iam_instance_profile   = var.iam_instance_profile

  root_block_device {
    volume_size = 20
  }
  
  tags = {
    Name = var.node_index == 0 ? "Gitfolio MongoDB" : "Gitfolio Redis",
    Environment = terraform.workspace,
    Service = local.index,
    Type = "db"
  }
}

