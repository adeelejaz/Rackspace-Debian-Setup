#!/bin/bash

echo ""
echo "*** Adding Sources"
echo ""

echo "* Adding dotdeb.list to sources.list.d"

cat <<EOF >> /etc/apt/sources.list.d/dotdeb.list

deb http://packages.dotdeb.org wheezy all
deb-src http://packages.dotdeb.org wheezy all

deb http://packages.dotdeb.org wheezy-php55 all
deb-src http://packages.dotdeb.org wheezy-php55 all
EOF

if grep -q "deb http://packages.dotdeb.org squeeze all" "/etc/apt/sources.list"; then

	echo "* No need to append sources"

else

	cat <<EOF >> /etc/apt/sources.list

deb http://packages.dotdeb.org wheezy all
deb-src http://packages.dotdeb.org wheezy all

deb http://packages.dotdeb.org wheezy-php55 all
deb-src http://packages.dotdeb.org wheezy-php55 all
EOF

	echo "* Add Dotdeb key"

	wget -q http://www.dotdeb.org/dotdeb.gpg
	cat dotdeb.gpg | apt-key add -
	rm dotdeb.gpg

fi

echo "* Adding mariadb.list to sources.list.d"

apt-get install python-software-properties
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db

cat <<EOF >> /etc/apt/sources.list.d/dotdeb.list

deb http://ftp.osuosl.org/pub/mariadb/repo/5.5/debian wheezy main
deb-src http://ftp.osuosl.org/pub/mariadb/repo/5.5/debian wheezy main
EOF

echo ""
