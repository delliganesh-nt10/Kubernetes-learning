resource "aws_security_group" "rds" {
  name        = "flask-notes-rds-sg"
  description = "Allow MySQL from EKS VPC"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "flask-notes"
  }
}
