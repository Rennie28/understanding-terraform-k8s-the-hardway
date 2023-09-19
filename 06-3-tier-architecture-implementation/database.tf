locals {
  db_credentials = {
    endpoint    = aws_db_instance.registration_app_db.address
    db_username = var.db_username
    db_name     = var.db_name
    port        = var.port
    password    = random_password.password.result
  }
}

resource "aws_secretsmanager_secret" "this" {
  name        = "rennietech-mysql-secret-${terraform.workspace}"
  description = "Secret to manage mysql superuser password"
  recovery_window_in_days = 0

}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(local.db_credentials)
}

resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_db_subnet_group" "mysql_subnetgroup" {
  name       = "registrationapp-subnetgroup-${terraform.workspace}"
  subnet_ids = [aws_subnet.database_subnet_1.id, aws_subnet.database_subnet_2.id]

  tags = {
    Name = "registrationapp-subnetgroup-${terraform.workspace}"
  }
}


resource "aws_db_instance" "registration_app_db" {
  allocated_storage      = 20
  db_name                = var.db_name #application team provides this name (webappdb)
  engine                 = "mysql"
  instance_class         = var.instance_class #"db.t3.micro"
  username               = var.db_username
  port                   = var.port
  password               = random_password.password.result
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnetgroup.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
}