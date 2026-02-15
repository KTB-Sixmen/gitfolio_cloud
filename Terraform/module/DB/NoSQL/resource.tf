locals {
  index = var.node_index == 0 ? "master" : "slave"
}

resource "aws_instance" "nosql" {
  ami                    = var.ami_id
  instance_type          = var.instance_types["micro"]
  subnet_id              = var.private_subnet_ids[var.instance_indexes[format("db_%s", local.index)]]
  vpc_security_group_ids = [var.security_group_ids["base"], var.security_group_ids["nosql"]]
  private_ip             = var.private_ips[format("db_%s%s", local.index, local.index == "slave" ? var.node_index : "")]
  iam_instance_profile   = var.iam_instance_profile

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name        = var.node_index == 0 ? "Gitfolio DB Master" : "Gitfolio DB Slave${var.node_index}",
    Environment = terraform.workspace,
    Service     = local.index == "master" ? "master" : "slave",
    Type        = "db"
    Index       = var.node_index
  }
}

