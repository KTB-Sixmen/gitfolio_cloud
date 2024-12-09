resource "aws_instance" "jenkins" {
  ami           = var.ami_id
  instance_type = var.instance_types["medium"]
  subnet_id     = var.private_subnet_ids[var.instance_indexes["jenkins"]]
  vpc_security_group_ids = [var.security_group_ids["base"], var.security_group_ids["cicd"]]
  private_ip = var.private_ips["jenkins"]
  
  tags = {
    Name        = "Gitfolio Jenkins"
    Environment = terraform.workspace
    Service     = "jenkins"
    Type        = "ec2"
  }
# 추후 추가 예정
#   root_block_device {
#     volume_size = 30  # Jenkins는 빌드 아티팩트를 위한 충분한 공간 필요
#     volume_type = "gp3"
#   }

}

resource "aws_instance" "argo" {
  ami           = var.ami_id
  instance_type = var.instance_types["medium"]
  subnet_id     = var.private_subnet_ids[var.instance_indexes["argo"]]
  vpc_security_group_ids = [var.security_group_ids["cicd"]]
  private_ip = var.private_ips["argo"]

  tags = {
    Name        = "Gitfolio ArgoCD"
    Environment = terraform.workspace
    Service     = "argocd"
    Type        = "ec2"
  }

}
