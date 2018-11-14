#!/bin/bash
set -e -x

# Check if we are running this script as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo privileges!" 1>&2
   exit 1
fi

qemu-system-x86_64 -nographic -m 2G -hdb /dev/sdb -usb -usbdevice disk:/dev/sdb
