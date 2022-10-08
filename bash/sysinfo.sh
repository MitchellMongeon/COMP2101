#!/bin/bash
#Script to show info about the PC

#Gathering need info
#Creating FQDN variable for FQDN
fqdn=$(hostname -f)

#OS variable for name & version
source /etc/os-release
OS=$(echo $PRETTY_NAME)

#IP variable
IP=$(hostname -I | awk '{print $1}')

#Vsriable for Root Filesystem
Free=$(df -h /root | grep -v Avail | awk '{print $3}')

#script to show the info

cat <<EOF

echo 'Report for myvm'
====================
echo 'FQDN: $fqdn'
echo 'Operating System: $OS'
echo 'IP address: $IP'
echo 'Root Filesystem Free Space: $Free'
=====================
EOF
