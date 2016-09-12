#!/bin/bash
mkdir /etc/exim4/dkim
cp /dkim/* /etc/exim4/dkim/
chgrp -R Debian-exim /etc/exim4/dkim
chmod -R 640 /etc/exim4/dkim
update-exim4.conf
service exim4 start
sleep infinity