resource "random_password" "rds_master" {
  length           = 16
  override_special = true
}

resource "aws_secretsmanager_secret" "db_creds" {
  name = "knova/${var.environment}/rds-credentials"
  description = "RDS master credentials for ${var.environment}"
  tags = { Environment = var.environment }

  provisioner "local-exec" {
    when    = destroy
    command = "aws secretsmanager delete-secret --secret-id ${self.id} --force-delete-without-recovery || true"
  }
}

resource "aws_secretsmanager_secret_version" "db_creds_version" {
  secret_id     = aws_secretsmanager_secret.db_creds.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.rds_master.result
    dbname   = var.db_name
  })
}

resource "aws_db_subnet_group" "rds_subnets" {
  name       = "knova-${var.environment}-rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags = { Name = "knova-${var.environment}-rds-subnet-group" }
}

resource "aws_security_group" "rds_sg" {
  name        = "knova-${var.environment}-rds-sg"
  vpc_id      = aws_vpc.this.id
  description = "Allow DB access from within VPC and bastion for admin"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "Allow Postgres from bastion"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "knova-${var.environment}-rds-sg" }
}

resource "aws_db_instance" "postgres" {
  count                      = var.create_rds ? 1 : 0
  identifier                 = "knova-${var.environment}-pg"
  engine                     = "postgres"
  engine_version             = "15"
  instance_class             = var.db_instance_class
  allocated_storage          = var.db_allocated_storage
  db_name                   = var.db_name
  username                   = var.db_username
  password                   = random_password.rds_master.result
  db_subnet_group_name       = aws_db_subnet_group.rds_subnets.name
  vpc_security_group_ids     = [aws_security_group.rds_sg.id]
  skip_final_snapshot        = true
  multi_az                   = true
  publicly_accessible        = false
  deletion_protection        = false
  apply_immediately          = false
  backup_retention_period    = 0
  backup_window              = "03:00-04:00"
  maintenance_window         = "Mon:04:00-Mon:05:00"

  tags = {
    Name        = "knova-${var.environment}-postgres"
    Environment = var.environment
  }
}
