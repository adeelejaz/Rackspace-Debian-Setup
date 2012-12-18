#!/bin/bash

echo ""
echo "*** Update & Upgrade"
echo ""

echo "* Configure Timezone"

dpkg-reconfigure tzdata

echo "* Configure Locales"

dpkg-reconfigure locales

echo "* Run apt-get"

read -p 'Do you want to continue [Y/n]? ' wish
if ! [[ "$wish" == "y" || "$wish" == "Y" ]] ; then
    exit
fi

aptitude -q update
aptitude -q upgrade
aptitude -q autoclean

echo ""
