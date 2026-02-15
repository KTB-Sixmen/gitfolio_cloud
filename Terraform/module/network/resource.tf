# resource "aws_vpc" "gitfolio" {
#   cidr_block           = var.vpc_cidr
#   enable_dns_hostnames = true

#   tags = {
#     Name = "Gitfolio VPC"
#   }
# }

# resource "aws_subnet" "public" {
#   count                   = length(var.public_subnet_cidrs)
#   vpc_id                  = aws_vpc.gitfolio.id
#   cidr_block              = var.public_subnet_cidrs[count.index]
#   availability_zone       = var.availability_zones[count.index % 2]
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "Gitfolio lb subnet${count.index + 1}"
#   }
# }

# resource "aws_subnet" "nat" {
#   vpc_id            = aws_vpc.gitfolio.id
#   cidr_block        = var.nat_subnet_cidr
#   availability_zone = var.availability_zones[1]

#   tags = {
#     Name = "Gitfolio NAT subnet"
#   }
# }

# resource "aws_subnet" "private" {
#   count             = length(var.private_subnet_cidrs)
#   vpc_id            = aws_vpc.gitfolio.id
#   cidr_block        = var.private_subnet_cidrs[count.index]
#   availability_zone = var.availability_zones[count.index % 2]

#   tags = {
#     Name = "Gitfolio ${var.instance_names[count.index]} subnet"
#   }
# }

# resource "aws_subnet" "rds" {
#   count             = length(var.db_subnet_cidrs)
#   vpc_id            = aws_vpc.gitfolio.id
#   cidr_block        = var.db_subnet_cidrs[count.index]
#   availability_zone = var.availability_zones[count.index]

#   tags = {
#     Name = "Gitfolio RDS subnet${count.index}"
#   }
# }

# resource "aws_db_subnet_group" "rds" {
#   subnet_ids = aws_subnet.rds[*].id

#   tags = {
#     Name = "Gitfolio RDS subnet group"
#   }
# }

# resource "aws_eip" "nat_eip" {
#   domain = "vpc"

#   tags = {
#     Name = "Gitfolio NAT EIP"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.gitfolio.id

#   tags = {
#     Name = "Gitfolio Internet Gateway"
#   }
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.nat.id

#   tags = {
#     Name = "Gitfolio NAT Gateway"
#   }

#   depends_on = [aws_eip.nat_eip, aws_internet_gateway.igw]
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.gitfolio.id

#   route {
#     cidr_block = var.any_ip
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "Gitfolio public route table"
#   }
# }

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.gitfolio.id

#   route {
#     cidr_block     = var.any_ip
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name = "Gitfolio private route table"
#   }
# }

# resource "aws_route_table_association" "public" {
#   count          = length(aws_subnet.public)
#   subnet_id      = aws_subnet.public[count.index].id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "nat" {
#   subnet_id      = aws_subnet.nat.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "private" {
#   count          = length(aws_subnet.private)
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "rds" {
#   count          = length(aws_subnet.rds)
#   subnet_id      = aws_subnet.rds[count.index].id
#   route_table_id = aws_route_table.private.id
# }

resource "aws_security_group" "base" {
  name   = "base_sg"
  vpc_id = aws_vpc.gitfolio.id

  dynamic "ingress" {
    for_each = {
      "HTTP"  = 80,
      "HTTPS" = 443,
    }

    content {
      description = ingress.key
      from_port   = ingress.value
      to_port     = ingress.value + 1
      protocol    = "tcp"
      cidr_blocks = [var.any_ip]
    }
  }

  # ingress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = [var.any_ip]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.any_ip]
  }

  tags = {
    Name = "Gitfolio base security group"
  }
}

# resource "aws_security_group" "app" {
#   name   = "app_sg"
#   vpc_id = aws_vpc.gitfolio.id

#   dynamic "ingress" {
#     for_each = {
#       "kafka1"         = 9092,
#       "kafka2"         = 29092,
#       "zookeeper"      = 2181,
#       "Sentry webhook" = 8000
#     }

#     content {
#       description = ingress.key
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "tcp"
#       cidr_blocks = [var.any_ip]
#     }
#   }

#   tags = {
#     Name = "Gitfolio app security group"
#   }
# }

# resource "aws_security_group" "cicd" {
#   name   = "cicd_sg"
#   vpc_id = aws_vpc.gitfolio.id

#   dynamic "ingress" {
#     for_each = {
#       "Jenkins"       = 8080,
#       "Prometheus"    = 9090,
#       "Grafana"       = 3000,
#       "Node Exporter" = 9100,
#     }

#     content {
#       description = ingress.key
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "tcp"
#       cidr_blocks = [var.any_ip]
#     }
#   }

#   tags = {
#     Name = "Gitfolio CI/CD security group"
#   }
# }

# resource "aws_security_group" "k8s_master" {
#   name   = "k8s_master_sg"
#   vpc_id = aws_vpc.gitfolio.id

#   dynamic "ingress" {
#     for_each = {
#       "kubectl api"             = 6443,
#       "etcd api"                = 2379,
#       "etcd peer"               = 2380,
#       "kubelet api"             = 10250,
#       "kube-controller-manager" = 10257,
#       "kube-scheduler"          = 10259,
#       "bgp"                     = 179,
#       "typha"                   = 5473,
#     }

#     content {
#       description = ingress.key
#       from_port   = ingress.value
#       to_port     = ingress.value + 1
#       protocol    = "tcp"
#       cidr_blocks = [var.any_ip]
#     }
#   }

#   ingress {
#     description = "vxlan"
#     from_port   = 4789
#     to_port     = 4789
#     protocol    = "udp"
#     cidr_blocks = [var.any_ip]
#   }

#   tags = {
#     Name = "Gitfolio k8s master node security group"
#   }
# }

# resource "aws_security_group" "k8s_worker" {
#   name   = "k8s_worker_sg"
#   vpc_id = aws_vpc.gitfolio.id

#   dynamic "ingress" {
#     for_each = {
#       "kubelet api"   = 10250,
#       "ingress-nginx" = 10254,
#       "bgp"           = 179,
#       "typha"         = 5473,
#     }

#     content {
#       description = ingress.key
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "tcp"
#       cidr_blocks = [var.any_ip]
#     }
#   }

#   ingress {
#     description = "NodePort"
#     from_port   = 30000
#     to_port     = 32767
#     protocol    = "tcp"
#     cidr_blocks = [var.any_ip]
#   }

#   ingress {
#     description = "vxlan"
#     from_port   = 4789
#     to_port     = 4789
#     protocol    = "udp"
#     cidr_blocks = [var.any_ip]
#   }

#   tags = {
#     Name = "Gitfolio k8s worker node security group"
#   }
# }

# resource "aws_security_group" "rds" {
#   name   = "rds_sg"
#   vpc_id = aws_vpc.gitfolio.id

#   ingress {
#     description     = "MySQL"
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     cidr_blocks     = [var.any_ip]
#     security_groups = [aws_security_group.app.id]
#   }

#   tags = {
#     Name = "Gitfolio MySQL security group"
#   }
# }

# resource "aws_security_group" "nosql" {
#   name   = "nosql_sg"
#   vpc_id = aws_vpc.gitfolio.id

#   dynamic "ingress" {
#     for_each = {
#       "MongoDB" = 27017,
#       "Redis"   = 6379,
#     }

#     content {
#       description = ingress.key
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "tcp"
#       cidr_blocks = [var.any_ip]
#     }
#   }

#   tags = {
#     Name = "Gitfolio NoSQL security group"
#   }
# }
