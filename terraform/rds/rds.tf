resource "aws_db_instance" "mysql" {
  identifier = "flask-notes-mysql"

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"   # minimal but real

  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  skip_final_snapshot = true
  publicly_accessible = false

  tags = {
    Project = "flask-notes"
  }
}
