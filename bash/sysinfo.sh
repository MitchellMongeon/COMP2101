#!/bin/bash
#Script to show info about the PC

#shows FQDN of the PC
echo 'FQDN:' $(hostname -A |awk '{print $1}')

#Shows more information on the PC
echo 'Host Information:' &(hostnamectl | grep -v heardware)

#shows the current IPv4 and IPv6 addresses
echo 'IP Addresses:' &(ip a | grep inet | tail -n 5 |head -n 4 | awk '{print $2}' | cut -d / -f1)

#shows information about the Filesystem
echo 'Root Filesystem Status:' 
df -h /dev/sda3
