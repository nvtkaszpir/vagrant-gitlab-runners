#!/bin/bash
#
# notice, this file is executed by Vagrant with sudo
# also notice, docker requires new kernels
echo "Phase: docker.sh"

sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce
sudo systemctl enable docker
sudo systemctl start docker

# clean docker images at 5 in the morning daily
echo '10 5 * * * root docker system prune -a -f --volumes' > /etc/cron.d/docker-prune
