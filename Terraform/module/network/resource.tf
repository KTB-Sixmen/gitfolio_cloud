locals {
  shared = terraform.workspace == "shared"
}

resource "aws_vpc" "gitfolio" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  
  tags = {
    Name = "Gitfolio VPC"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.gitfolio.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % 2]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "Gitfolio ${ terraform.workspace } lb subnet${ count.index + 1 }"
  }
}

resource "aws_subnet" "nat" {
  vpc_id            = aws_vpc.gitfolio.id
  cidr_block        = var.nat_subnet_cidr
  availability_zone = var.availability_zones[1]
  
  tags = {
    Name = "Gitfolio NAT subnet"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.gitfolio.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % 2]
  
  tags = {
    Name = "Gitfolio ${var.instance_names[count.index]} subnet"
  }
}

resource "aws_subnet" "rds" {
  count             = length(var.db_subnet_cidrs)
  vpc_id            = aws_vpc.gitfolio.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = {
    Name = "Gitfolio RDS subnet${count.index}"
  }
}

resource "aws_db_subnet_group" "rds" {
  subnet_ids = aws_subnet.rds[*].id

  tags = {
    Name = "Gitfolio RDS subnet group"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  
  tags = {
    Name = "Gitfolio NAT EIP"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.gitfolio.id

  tags = {
    Name = "Gitfolio Internet Gateway"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.nat.id

  tags = {
    Name = "Gitfolio NAT Gateway"
  }

  depends_on = [ aws_eip.nat_eip, aws_internet_gateway.igw ]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.gitfolio.id

  route {
    cidr_block = var.any_ip
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Gitfolio public route table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.gitfolio.id

  route {
    cidr_block     = var.any_ip
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Gitfolio private route table"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "nat" {
 subnet_id      = aws_subnet.nat.id
 route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "rds" {
  count          = length(aws_subnet.rds)
  subnet_id      = aws_subnet.rds[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "base" {
  name = "base_sg"
  vpc_id = aws_vpc.gitfolio.id

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 81
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 444
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "ICMP"
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = [var.any_ip]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.any_ip]
  }

  tags = {
    Name = "Gitfolio base security group"
  }
}

resource "aws_security_group" "back" {
  name = "back_sg"
  vpc_id = aws_vpc.gitfolio.id

  ingress {
    description = "kafka1"
    from_port = 9092
    to_port = 9092
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "kafka2"
    from_port = 29092
    to_port = 29092
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "zookeeper"
    from_port = 2181
    to_port = 2181
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  tags = {
    Name = "Gitfolio backend security group"
  }
}

resource "aws_security_group" "discord_bot" {
  name = "discord_bot_sg"
  vpc_id = aws_vpc.gitfolio.id

  ingress {
    description = "Sentry webhook"
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }
  
  tags = {
    Name = "Gitfolio backend security group"
  }
}

resource "aws_security_group" "cicd" {
  name = "cicd_sg"
  vpc_id = aws_vpc.gitfolio.id

  tags = {
    Name = "Gitfolio CI/CD security group"
  }
}

resource "aws_security_group" "k8s_master" {
  name = "k8s_master_sg"
  vpc_id = aws_vpc.gitfolio.id
  
  ingress {
    description = "Kubernetes API"
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "etcd API"
    from_port = 2379
    to_port = 2380
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "Kubelet API"
    from_port = 10250
    to_port = 10250
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "kube-scheduler"
    from_port = 10259
    to_port = 10259
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "kube-controller-manager"
    from_port = 10257
    to_port = 10257
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "kubernetes-dashboard"
    from_port = 8001
    to_port = 8001
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  tags = {
    Name = "Gitfolio k8s master node security group"
  }
}

resource "aws_security_group" "k8s_worker" {
  name = "k8s_worker_sg"
  vpc_id = aws_vpc.gitfolio.id
  ingress {
    description = "Kubelet API"
    from_port = 10250
    to_port = 10250
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "NodePort"
    from_port = 30000
    to_port = 32767
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  tags = {
    Name = "Gitfolio k8s worker node security group"
  }
}

resource "aws_security_group" "rds" {
  name = "rds_sg"
  vpc_id = aws_vpc.gitfolio.id

  ingress {
    description = "MySQL"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
    security_groups = [aws_security_group.back.id]
  }

  tags = {
    Name = "Gitfolio MySQL security group"
  }
}

resource "aws_security_group" "mongo" {
  name = "mongo_sg"
  vpc_id = aws_vpc.gitfolio.id

  ingress {
    description = "MongoDB"
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  tags = {
    Name = "Gitfolio MongoDB security group"
  }
}

resource "aws_security_group" "redis" {
  name = "redis_sg"
  vpc_id = aws_vpc.gitfolio.id

  ingress {
    description = "Redis"
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = [var.any_ip]
  }

  tags = {
    Name = "Gitfolio Redis security group"
  }
}