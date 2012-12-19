#!/bin/bash

echo ""
echo "*** Add User"
echo ""

# Read config file
. ./setup.cfg

# Check for user
egrep "^$username" /etc/passwd > /dev/null

if [ $? -eq 0 ]; then

	echo "* $username exists!"

else

	echo "* Adding User"

	pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)

	useradd -m -p $pass $username

	chown $username /home/$username
	chgrp $username /home/$username

	echo "* Adding User to sudoers"

	echo "$username ALL=(ALL) ALL" >> /etc/sudoers

fi

echo ""
