#!/bin/bash

echo ""
echo "*** Append Sources to sources.list"
echo ""

if grep -q "deb http://packages.dotdeb.org squeeze all" "/etc/apt/sources.list"; then

	echo "* No need to append sources"

else

	cat <<EOF >> /etc/apt/sources.list

deb http://packages.dotdeb.org squeeze all
deb-src http://packages.dotdeb.org squeeze all

deb http://packages.dotdeb.org squeeze-php54 all
deb-src http://packages.dotdeb.org squeeze-php54 all
EOF

	echo "* Add Dotdeb key"

	wget -q http://www.dotdeb.org/dotdeb.gpg
	cat dotdeb.gpg | apt-key add -
	rm dotdeb.gpg

fi

echo ""
