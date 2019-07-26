#!/bin/bash
#
# notice, this file is executed by Vagrant with sudo
# also notice, docker requires new kernels
echo "Phase: docker.sh"

export DEBIAN_FRONTEND=noninteractive
# docker community edition
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository -y \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce

# clean docker images at 5 in the morning daily
echo '10 5 * * * root docker system prune -a -f --volumes' > /etc/cron.d/docker-prune
