#!/bin/sh

[ -e /var/dhcp_ip ] && consul agent -dev -config-dir /etc/consul.d/ -bind $(cat /var/dhcp_ip) -node $(cat /etc/machine-id)
