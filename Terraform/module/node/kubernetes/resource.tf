resource "aws_instance" "node" {
  ami                    = var.ami_id
  instance_type          = var.instance_types["medium"]
  subnet_id              = var.private_subnet_ids[var.instance_indexes["kubernetes"]]
  vpc_security_group_ids = var.security_group_ids
  private_ip             = var.private_ip
  iam_instance_profile   = var.iam_instance_profile

  tags = merge(
    var.tags,
    {
      Environment = terraform.workspace
      Type        = "kubernetes"
    }
  )
}
