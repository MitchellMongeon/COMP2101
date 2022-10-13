#!/bin/bash

# Testing if the Host has lxd installed
which lxd >/dev/null
if [ $? -eq 0 ]; then
	#Checking to see if lxd is installed first
	echo "lxd is already installed"
	if [ $? -ne 0 ]; then
		#If lxd was not installed this will install lxd
		echo "lxd needs to be installed"
		sudo snap install lxd
		if [ $? -ne 0 ]; then
			#Failed to installed lxd and exits with an error message
			echo "Failed to install lxd please try again"
			exit 1
		fi
	fi
fi

#Testing if lxdbr0 exists
ip a | grep -q -w -o lxdbr0
if [ $? -eq 0 ]; then
	echo "lxdbr0 exists"
	if [ $? -ne 0 ]; then
		#If there is no lxdbr0 this will set it up
		echo "lxdbr0 is being setup"
		lxd init --auto
	fi
fi

#testing if a container is running
lxc list | grep -q -w -o COMP2101-S22
if [ $? -eq 0 ]; then
	echo "A container with the name COMP2101-S22 exsts"
	if [ $? -ne 0 ]; then
		#If there is no contaner with the name COMP2101-S22 one will be made
		echo "A container with the name COMP2101-S22 has been made"
		lxc launch ubuntu:22.04 COMP2101-S22
	fi
fi

#updating /etc/hosts for COMP2101-S22
#Variable for the ip of the contaner of COMP2101-S22
compip="$(lxc list | grep COMP2101-S22 | awk '{print $6}')"

#COMP2201-S22 name put into a variable
name="COMP2101-S22"

#Variable for COMP2101-S22 with its ip
comp_input="${compip} ${name}"

#Variable for checking comp2101 in hosts
hosts="(grep -n $comp_input /etc/hosts | cut -f1 -d:)"

#Testing to see if /etc/hosts in configured
grep -q -n "$comp_input" /etc/hosts
if [ $? -eq 1 ]; then
	#inputting COMP2101 into /hosts
	echo "/etc/hosts has been updated with COMP2101-S22"
	echo "$comp_input" | sudo tee -a /etc/hosts
else
	echo "COMP2101-S22 is already in /etc/hosts"
fi

#Installing Apache2 in COMP2101

#cheching to see if COMP2101 has apache2 installed
lxc exec COMP2101-S22 -- dpkg -l apache2 | grep -q apache2
if [ $? -ne 0 ]; then
	echo "apache2 will be set up now on COMP2101-S22"
	lxc exec COMP2101-S22 -- apt install apache2
	lxc exec COMP2101-S22 -- ufw allow 'Apache'
else
	echo "apache2 is already installed on comp2101-S22"
fi

#run the commands to curl to COMP to see if it works
curl -I -s http://COMP2101-S22 | grep -q HTTP
if [ $? -eq 0 ]; then
	echo "curl worked"
else
	echo "curl falied"
fi 
