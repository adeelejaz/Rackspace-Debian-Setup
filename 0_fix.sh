
# Fix the Nova-agent error
# Detail: https://bugs.launchpad.net/openstack-guest-agents/+bug/894102

echo ""
echo "*** Nova-Agent Fix"
echo ""

# Remove if file present
if [ -f "nova-agent" ]; then
	echo "* Removing temp nova-agent file"

	rm nova-agent
fi

if grep -q "### BEGIN INIT INFO" "/etc/init.d/nova-agent"; then
	echo "* No need to update Nova-Agent"
else
	count=0
	touch nova-agent
	while read line; do

		# 3. This should be an empty line, insert stuff there
		if [ $count == 2 ]; then
			cat <<EOF >> nova-agent
### BEGIN INIT INFO
# Provides: Nova-Agent
# Required-Start: \$remote_fs \$syslog
# Required-Stop: \$remote_fs \$syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start daemon at boot time
# Description: Enable service provided by daemon.
### END INIT INFO
EOF
			count=0
		fi

		# 2. Look for last line
		if [ $count == 1 ]; then
			count=2;
		fi

		# 1. Look for second last line
		if [ "$line" == "# pidfile: /var/run/nova-agent.pid" ]; then
			count=1;
		fi

		# Append
		echo $line >> nova-agent

	done < /etc/init.d/nova-agent

	# Move and replate
	echo "* Updated Nova-Agent"

	mv nova-agent /etc/init.d/nova-agent
fi

echo ""
