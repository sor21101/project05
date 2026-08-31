# 1단계 최소 인프라 구축 완료

Terraform을 이용해 AWS에 초기 인프라 구축 성공

## 구성

- VPC
- Public Subnet
- Internet Gateway
- Route table
- Security Group
- EC2 (Ubuntu 24.04 LTS, t3.micro, gp3 8GB)
- Docker
- Nginx Container

## 검증

- terraform validate 성공적
- terraform plan/apply를 통해 인프라 생성 확인
- ssh로 ec2 접속 확인
- Docker container 정상 실행 확인
- EC2 public ip로 nginx 웹서비스 정상 확인

## 현 구조의 한계
현재는 그저 단일 EC2구조이므로 서버 장애 발생 시 서비스 전체가 멈추는 단일 장애점이 존재함
또한 별도의 모니터링이나 ASG구성이 없어 장애 탐지와 트래픽 증가에 대한 대응 불가
