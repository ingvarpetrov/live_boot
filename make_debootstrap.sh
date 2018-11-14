#!/bin/bash
set -e -x

# Check if we are running this script as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo privileges!" 1>&2
   exit 1
fi

CURRENT_FOLDER=$(pwd)
CHROOT_FOLDER=__bin/chroot

# build chroot
apt-get install debootstrap schroot -y

rm -rf $CHROOT_FOLDER
mkdir -p $CHROOT_FOLDER

MIRROR="http://ftp.ca.debian.org/debian"
sudo debootstrap --variant=minbase --arch amd64 jessie $CHROOT_FOLDER $MIRROR 
# create scroot config
rm -rf /etc/schroot/chroot.d/gpusb.conf
cat <<EOF >/etc/schroot/chroot.d/gpusb.conf
[gpusb]
description=Debian Jessie
directory=$(pwd)/$CHROOT_FOLDER
root-users=root
type=directory
users=root
EOF

schroot -c gpusb /bin/bash  <<'EOF'
CURRENT_FOLDER=$(pwd)
apt-key update
apt-get update
apt-get install nano wget sudo net-tools openssh-server htop -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
echo "install kernel build dependencies"
chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

#final touches

cp -a $CURRENT_FOLDER/deps/rootfs/* /

#remove unnecessary locales
#apt-get install localepurge
#dpkg-reconfigure localepurge
#apt-get remove localepurge
#apt-get purge localepurge


rm -rf /etc/debian_chroot
exit
EOF



rm -rf $CURRENT_FOLDER/__bin/layer_base_os
mkdir -p $CURRENT_FOLDER/__bin/layer_base_os
cp -r $CURRENT_FOLDER/$CHROOT_FOLDER/* $CURRENT_FOLDER/__bin/layer_base_os/
