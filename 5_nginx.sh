#!/bin/bash

echo ""
echo "*** Installing nginx"
echo ""

apt-get -q install nginx

# Check for user
egrep "^nginx" /etc/passwd > /dev/null

if [ $? -eq 0 ]; then

	echo "* nginx user exists!"

else

	echo "* Adding nginx user"

	adduser --system --no-create-home nginx

fi

echo ""
