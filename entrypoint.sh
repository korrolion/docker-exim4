#!/bin/bash
set -e

mkdir -p /etc/exim4/dkim
cp /dkim/* /etc/exim4/dkim/
chgrp -R Debian-exim /etc/exim4/dkim
chmod -R 640 /etc/exim4/dkim


opts=(
	dc_local_interfaces "[0.0.0.0]:${PORT:-25} ; [::0]:${PORT:-25}"
	dc_other_hostnames ''
	dc_relay_nets "$(ip addr show dev eth0 | awk '$1 == "inet" { print $2 }')${RELAY_NETWORKS}"
    dc_eximconfig_configtype 'internet'
)

conf='/etc/exim4/update-exim4.conf.conf'

sedExpr=''
for ((i = 0; i < ${#opts[@]}; i += 2)); do
	key=${opts[$i]}
	value=${opts[$i+1]}
	echo "${key} = ${value} \n"

	if ! grep -qE "^#?${key}=" "$conf"; then
		echo >&2 "error: '$key' not found in '$conf'"
		exit 1
	fi

	sed_escaped_value="$(echo "$value" | sed 's/[\/&]/\\&/g')"
	sedExpr+=$'\n\t'"s/^#?(${key})=.*/\1='${sed_escaped_value}'/;"
done

set -x
sed -ri "$sedExpr"$'\n' "$conf"
update-exim4.conf -v

exec "$@"
#service exim4 start
#sleep infinity
