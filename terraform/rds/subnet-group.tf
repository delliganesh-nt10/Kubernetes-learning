resource "aws_db_subnet_group" "this" {
  name       = "flask-notes-db-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Project = "flask-notes"
  }
}
