/*
output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.app.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of EC2 instance"
  value       = aws_instance.app.public_dns
}
*/
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "ubuntu_ami_id" {
  description = "Ubuntu AMI Id"
  value       = data.aws_ami.ubuntu.id
}

output "alb_dns_name" {
  description = "DNS name of Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group Name"
  value       = aws_autoscaling_group.app.name
}

output "red_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "PostgreSQL RDS port"
  value       = aws_db_instance.postgres.port
}

output "rds_database_name" {
  description = "PostgreSQL database name"
  value       = aws_db_instance.postgres.db_name
}