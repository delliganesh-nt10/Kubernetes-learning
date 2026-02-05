output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "rds_db_name" {
  value = aws_db_instance.mysql.db_name
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}
