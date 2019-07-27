#!/bin/bash
# see:
# https://github.com/lavabit/robox/issues/11
# https://github.com/lavabit/robox/issues/54

# older distros got dns entries in /etc/network/interfaces

if [ -f '/etc/network/interfaces' ]; then
  sed -i -e '/dns-nameserver/d'  /etc/network/interfaces
  echo "Fixed networking via /etc/network/interfaces"
fi

# new distros use netplan
# exit if we are not on modern ubuntu version

if [ -d '/etc/netplan' ]; then

# Reset netplan config, not really needed; just to clearly indicate no fixed dns is used
tee <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
      dhcp6: false
      optional: true
      nameservers:
        addresses: []
EOF
netplan generate
systemctl restart systemd-networkd.service
systemctl restart ifplugd.service

# Remove fixed DNS entries and disable DNSSEC, disable flaky caching, or emdns
tee <<EOF > /etc/systemd/resolved.conf
[Resolve]
DNS=
FallbackDNS=
Domains=
#LLMNR=no
#MulticastDNS=no
DNSSEC=no
Cache=no
DNSStubListener=yes
EOF

systemctl daemon-reload
systemctl restart systemd-resolved

echo "Fixed networking via /etc/netplan"

# verify with: systemd-resolve --status
fi

# you better restart vm after changes.
