#!/bin/bash

echo ""
echo "*** Add User"
echo ""

echo "* Adding User"

pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)

useradd -m -p $pass $username

chown $username /home/$username
chgrp $username /home/$username

echo "* Adding User to sudoers"

echo "$username ALL=(ALL) ALL" >> /etc/sudoers

echo ""
