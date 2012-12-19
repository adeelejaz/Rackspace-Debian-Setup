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

	adduser --system --no-create-home --disabled-login --disabled-password --group nginx

fi

echo "* Backing up nginx.conf"

cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

echo "* Updating nginx.conf"

cat <<EOF > /etc/nginx/nginx.conf
user nginx www-data;
worker_processes 4;
pid /var/run/nginx.pid;

events {
	worker_connections 768;
	# multi_accept on;
}

http {
# Basic Settings
	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;
	# server_tokens off;

	# server_names_hash_bucket_size 64;
	# server_name_in_redirect off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

# Logging Settings
log_format gzip '$remote_addr - $remote_user [$time_local]  '
                '"$request" $status $bytes_sent '
                '"$http_referer" "$http_user_agent" "$gzip_ratio"';

	access_log /var/log/nginx/access.log gzip buffer=32k;
	error_log /var/log/nginx/error.log notice;

# Gzip Settings
	gzip on;
	gzip_disable "msie6";

	gzip_vary on;
	gzip_proxied any;
	gzip_comp_level 6;
	gzip_buffers 16 8k;
	gzip_http_version 1.1;
	gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

# Virtual Host Configs
	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;

}
EOF

echo ""
