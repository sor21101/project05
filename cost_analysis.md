# 비용 비교하기
본 프로젝트는 단순히 최저 비용의 인프라를 구축하는 것이 아닌 비용 증가에 따라 어떤 운영 안정성을 확보할 수 있는지 비교하는 것을 목표로 함

## 비용 산정 기준
- region : ap-northeast-2 (seoul)
- pricing : On-Demand
- 월 사용시간 : 730
- 평상시 EC2 1대 운영
- ALB 소규모 트래픽 가정
- RDS PostgreSQL Single-AZ
- 실 청구액이 아닌 AWS Pricing Calculator 예상금액

## 최종 인프라 비용
월별 비용
- EC2 | t3.micro x 1 | $9.49
- ALB | x 1 | $16.66
- RDS | PostgreSQL db.t4g.micro, Single-AZ, 20GB | $20.87
- Cloudwatch | Custom Metric + Alarm | $0.60
- ECR | 1GB Storage | $0.10
= Total $47.71

한달 약 48달러

## 초기 인프라 비용
월별 비용
- EC2 | t3.micro x 1 | $9.49
= Total $9.49 + EBS

한달 약 9.5달러

## 초기와 최종 비교
EC2를 제외한 4가지 추가로 초기에서 약 4~5배 증가했지만
단일 서버 장애, 트래픽 증가, 데이터 관리, 수동 배포 등 초기 구조의 주요 운영 위험을 줄일 수 있었음

## 비용 증가 원인
최종 구성에서 가장 큰 지출이 되는 항목은
= RDS, ALB

EC2 자체(t3.micro)는 약 $9.49 이지만
- RDS PostgreSQL(db.t4g.micro) : $20.87
- ALB : $16.66
가 추가되면서 전체적으로 비용 상승

즉 서버 성능 자체보다 데이터 안정성과 서비스 가용성을 확보하기 위한 관리형 서비스 비용이 더 큰 비용 비중을 차지해버림

## 비용 최소화를 위한 선택
- ASG min 1
- ASG max 2
- RDS Single-AZ
- db.t4g.micro
- k8s, nat gateway X
- ECR Lifecycle Policy
- On-Demand 기준 비교

## 결론
초기 구조는 월 약 $9.5 + @로 매우 저렴하지만, EC2 한 대에 장애가 발생하면 서비스가 멈춰버리는 구조

최종 구조는 월 약 $48로 증가하지만,
- 장애 대응
- Auto Scaling
- Monitoring
- DB 분리
- 자동백업
- CI/CD
의 기능을 확보할 수 있었음

따라서
- 최소 비용만을 추구하기 보다는
- 추가 비용을 통해 어떤 운영 위험을 제거할 수 있는지를 기준으로
- 인프라를 단계적으로 개선함


비용을 최소화하는 것만으로는 안정적인 운영이 어렵고,
반대로 모든 고가용성 기능을 때려박으면 소규모 서비스에서는 어마무시한 지출 발생 가능성 높음

따라서 서비스 규모와 장애 허용 수준에 따라 기능과 비용 사이에서 저울질하여 선택적으로 도입하는 것이 중요함