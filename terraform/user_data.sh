#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update -y

apt-get -o DPkg::Lock::Timeout=300 install -y docker.io wget

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

docker run -d \
    --name nginx \
    --restart unless-stopped \
    -p 80:80 \
    nginx:alpine

cd /tmp

wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

dpkg -i -E ./amazon-cloudwatch-agent.deb

rm -f amazon-cloudwatch-agent.deb