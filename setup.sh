#!/bin/bash

# Check for root access
if [ $(id -u) -ne 0 ]; then
	echo "Must be run as root"
	exit
fi

# @todo: Check if just want to add one website

# Run scripts
./0_fix.sh &&
./1_firewall.sh &&
./2_sources.sh &&
./3_update.sh

echo "Done!"
echo ""
