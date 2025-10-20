output "bastion_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "Public IP of the bastion host"
}

output "rds_endpoint" {
  value       = aws_db_instance.postgres[0].endpoint
  description = "RDS Postgres endpoint (host)"
  depends_on  = [aws_db_instance.postgres]
}

output "rds_secret_arn" {
  value       = aws_secretsmanager_secret.db_creds.arn
  description = "ARN of the Secrets Manager secret storing DB credentials"
}
