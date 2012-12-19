#!/bin/bash

echo ""
echo "*** Install PHP FPM"
echo ""

# Read config file
. ./setup.cfg

apt-get install php5 php5-fpm php5-common $php_modules

echo "* Create PHP FPM Socket"

mkdir -p /var/run/php5-fpm/
