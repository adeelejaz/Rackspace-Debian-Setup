#!/bin/bash

echo ""
echo "*** Setup up a new Website"
echo ""

# Read config file
. ./setup.cfg

echo "Enter the domain name (without www unless required):"
read -p 'Enter 0 to exit: ' domain
if [[ "$domain" != "0" ]] ; then

	if [ ! -d "${vhost}/${domain}" ] ; then

		echo "* Creating Directories"

		mkdir -p ${vhost}/${domain}/{private,public,log,backup}

		chown -R $username:www-data ${vhost}/${domain}

		chmod 2755 ${vhost}/${domain}/public

		echo "* Adding $domain"

		cat <<EOF > /etc/nginx/sites-available/$domain

server {
	server_name $domain;
	return 301 \$scheme://www.${domain}\$request_uri;
}

server {
	listen 80;
	server_name www.${domain};
	root   ${vhost}/${domain}/public;
	index index.php index.html;
	include /etc/nginx/security;

# Logging --
	access_log ${vhost}/${domain}/log/access.log;
	error_log  ${vhost}/${domain}/log/error.log notice;

# serve static files directly
	location = /favicon.ico {
		log_not_found	off;
		access_log		off;
	}

	location = /robots.txt {
		allow			all;
		log_not_found	off;
		access_log		off;
	}

	location ~* \.(js|css|png|jpg|jpeg|gif|ico)\$
		access_log        off;
		expires           max;
	}

	location / {
		try_files \$uri \$uri/ /index.php?\$args;
	}

	location ~ \.php\$ {
		fastcgi_pass unix:/var/run/php5-fpm/${domain}.socket;
		fastcgi_index index.php;
		include /etc/nginx/fastcgi_params;
	}
}

EOF

		echo "* Activate $domain"

		ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/$domain

		echo "* Setup Pool"

		touch /etc/php5/fpm/pool.d/${domain}.conf

		cat <<EOF > /etc/php5/fpm/pool.d/${domain}.conf
[$domain]

listen = /var/run/php5-fpm/${domain}.socket
listen.backlog = -1

; Unix user/group of processes
user = $username
group = www-data

; Choose how the process manager will control the number of child processes.
pm = dynamic
pm.max_children = 75
pm.start_servers = 10
pm.min_spare_servers = 5
pm.max_spare_servers = 20
pm.max_requests = 500

; Pass environment variables
env[HOSTNAME] = \$HOSTNAME
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp

; host-specific php ini settings here
; php_admin_value[open_basedir] = ${vhost}/${domain}/public:/tmp
EOF
		echo "* Done!"

	else

		echo "* Directory already made!"

	fi

fi

echo ""
