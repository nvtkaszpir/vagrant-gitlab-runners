#!/bin/bash
#
# notice, this file is executed by Vagrant with sudo

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install virt-what libpam-systemd acpid
apt-get -y upgrade
# remove all kernels to save some space
dpkg -l |grep linux-image|awk '{print $2}'|xargs apt-get remove --purge -y
dpkg -l |grep linux-headers|awk '{print $2}'|xargs apt-get remove --purge -y

apt-get -y dist-upgrade


if [ "$(virt-what)" != "lxc" ]; then

# install new kernels
apt-get install -y --install-recommends linux-generic-hwe-16.04

# aggressive storage tweaks
grep -q 'noatime,discard' /etc/fstab \
||	sed -i 's|error|noatime,discard,error|g' /etc/fstab

# aggressive disk tuning
cat > /etc/sysctl.d/99-tune.conf << EOFSYSCTL
vm.dirty_background_ratio = 50
vm.dirty_expire_centisecs = 30000
vm.dirty_ratio = 80
vm.dirty_writeback_centisecs = 1000
vm.vfs_cache_pressure = 50
vm.swappiness = 1
EOFSYSCTL

fi


apt-get remove -y ntp
apt-get install -y chrony

# cleanup
apt-get -y autoremove

# now reboot system
