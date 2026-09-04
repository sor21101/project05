#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

AWS_REGION="${aws_region}"
ECR_REPOSITORY_URL="${ecr_repository_url}"
ECR_REGISTRY=$(echo "$ECR_REPOSITORY_URL" | cut -d/ -f1)
IMAGE_URI="$ECR_REPOSITORY_URL:latest"

apt-get update -y

apt-get -o DPkg::Lock::Timeout=300 install -y \
  docker.io \
  wget \
  awscli

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

# ECR 이미지가 이미 존재하면 최신 애플리케이션 실행
if aws ecr get-login-password --region "$AWS_REGION" \
  | docker login \
      --username AWS \
      --password-stdin "$ECR_REGISTRY" \
  && docker pull "$IMAGE_URI"; then

  docker rm -f nginx project05-app 2>/dev/null || true

  docker run -d \
    --name project05-app \
    --restart unless-stopped \
    -p 80:8080 \
    "$IMAGE_URI"

else
  # 최초 CI/CD 배포 전 ECR 이미지가 없는 경우 임시 서비스
  docker run -d \
    --name nginx \
    --restart unless-stopped \
    -p 80:80 \
    nginx:alpine
fi

cd /tmp

wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

dpkg -i -E ./amazon-cloudwatch-agent.deb

rm -f amazon-cloudwatch-agent.deb
