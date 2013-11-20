#!/bin/bash

# Check for root access
if [ $(id -u) -ne 0 ]; then
	echo "Must be run as root"
	exit
fi

# @todo: Check if just want to add one website

# Run scripts
./1_firewall.sh &&
./2_sources.sh &&
./3_update.sh &&
./4_user.sh &&
./5_profile.sh &&
./6_mariadb.sh &&
./7_nginx.sh &&
./8_php.sh &&
./9_conf.sh

echo "Done!"
echo ""
