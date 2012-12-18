#!/bin/bash

echo ""
echo "*** Setup Firewall"
echo ""

# Read config file
. ./setup.cfg

echo "* Creating rules file"

cat <<EOF > /etc/iptables.rules
*filter

-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -j ACCEPT

-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport $ssh_port -j ACCEPT

-A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

-A INPUT -j REJECT
-A FORWARD -j REJECT

COMMIT
EOF

echo "* Creating Boot Script for Firewall"

cat <<EOF > /etc/network/if-pre-up.d/iptables
#!/bin/sh

iptables-restore < /etc/iptables.rules
EOF

chmod +x /etc/network/if-pre-up.d/iptables

echo ""

echo ""
echo "*** Update SSH Port"
echo ""

# Remove if file present
if [ -f "sshd_config" ]; then
	echo "* Removing temp sshd_config file"

	rm sshd_config
fi

touch sshd_config
while read line; do

	# Replace line containing port
	if [[ $line =~ ^Port* ]]
	then
		line="Port $ssh_port"
	fi

	# Append
	echo $line >> sshd_config

done < /etc/ssh/sshd_config

# Move and replate
echo "* Updated sshd_config"

mv sshd_config /etc/ssh/sshd_config

echo ""
