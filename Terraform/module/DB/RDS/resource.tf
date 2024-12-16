resource "aws_db_instance" "mysql" {
  identifier        = var.identifier
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  maintenance_window      = "Mon:04:00-Mon:05:00"
  backup_retention_period = var.backup_period
  backup_window           = var.backup_window
  copy_tags_to_snapshot   = true

  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.security_group_ids["rds"]]
  db_subnet_group_name   = var.rds_subnet_group_name

  tags = {
    Name        = "Gitfolio MySQL",
    Environment = terraform.workspace,
    Service     = "db",
    Type        = "mysql"
  }
}

resource "aws_db_instance" "mysql_replica" {
  identifier          = format("%s-replica", var.identifier)
  instance_class      = var.instance_class
  replicate_source_db = var.identifier
  storage_type        = var.storage_type
  storage_encrypted   = true

  maintenance_window    = "Tue:04:00-Tue:05:00"
  copy_tags_to_snapshot = true

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name        = "Gitfolio MySQL Read Replica",
    Environment = terraform.workspace,
    Service     = "db",
    Type        = "mysql-read-replica"
  }
}
