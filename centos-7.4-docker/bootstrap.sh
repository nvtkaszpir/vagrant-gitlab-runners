#!/bin/bash
#
# notice, this file is executed by Vagrant with sudo

# kernel mainline
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum install -y yum-plugin-fastestmirror
yum --enablerepo=elrepo-kernel install -y kernel-ml
grub2-set-default 1

yum update -y
yum install -y acpid chrony
systemctl enable acpid
systemctl start acpid
systemctl enable chronyd
systemctl start chronyd

yum autoremove -y

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

# now reboot system to load new kernel, in vagrant this is handled by the plugin
