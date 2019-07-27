#!/bin/bash
#
# notice, this file is executed by Vagrant with sudo
echo "Phase: build-tools.sh"

#sudo yum -y install gcc gcc-c++ make openssl-devel rpmbuild
#sudo yum -y install libxml2 libxml2-devel libxslt libxslt-devel
sudo yum -y groupinstall 'Development Tools'

sudo yum -y install java-1.8.0-openjdk-devel
