resource "aws_instance" "master" {
  ami           = var.ami_id
  instance_type = var.instance_types["medium"]
  subnet_id     = var.private_subnet_ids[var.instance_indexes["kubernetes"]]
  vpc_security_group_ids = [var.security_group_ids["base"], var.security_group_ids["k8s_master"]]
  private_ip = var.private_ips["master"]
  iam_instance_profile   = var.iam_instance_profile
  
  tags = {
    Name = "Gitfolio Kubernetes master node"
    Environment = terraform.workspace
    Service = "master"        # aws_ec2.yaml에서 이 태그로 그룹핑
    Type = "kubernetes"
  }
}

resource "aws_instance" "ingress" {
  count = var.worker_count
  ami           = var.ami_id
  instance_type = var.instance_types["low"]
  subnet_id     = var.private_subnet_ids[var.instance_indexes["kubernetes"]]
  vpc_security_group_ids = [var.security_group_ids["base"], var.security_group_ids["k8s_worker"]]
  private_ip = var.private_ips["ingress${ count.index + 1 }"]
  iam_instance_profile   = var.iam_instance_profile
  
  tags = {
    Name = "Gitfolio Kubernetes worker node${ count.index }"
    Environment = terraform.workspace
    Service = "worker"        # aws_ec2.yaml에서 이 태그로 그룹핑
    Type = "kubernetes"
  }
}
