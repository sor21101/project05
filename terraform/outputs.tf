output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.app.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of EC2 instance"
  value       = aws_instance.app.public_dns
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "ubuntu_ami_id" {
  description = "Ubuntu AMI Id"
  value       = data.aws_ami.ubuntu.id
}