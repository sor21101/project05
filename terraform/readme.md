# terraform

## 현재 구성

- VPC
- Public Subnet
- Internet Gateway
- Route table
- Security Group
- EC2 (Ubuntu 24.04 LTS, t3.micro, gp3 8GB)
- Docker
- Nginx Container

## 사전 준비

- terraform, AWS CLI 설치
- AWS 인증 설정
- EC2 Key pair 생성
- terraform.tfvars 생성 및 작성

## 현재 단계

v1 base (EC2 + Docker)



terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform output ec2_public_ip로 IP 확인
브라우저에서 http://EC2_PUBLIC_IP 접속
필요하면 SSH로도 접속 확인