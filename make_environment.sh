#!/bin/bash
# build chroot
apt-get install debootstrap schroot -y

rm -rf chroot
mkdir chroot
MIRROR="http://ftp.ca.debian.org/debian"
sudo debootstrap --variant=buildd --variant=minbase --arch amd64 jessie chroot/ $MIRROR 
# create scroot config
rm -rf /etc/schroot/chroot.d/gpusb.conf
cat <<EOF >/etc/schroot/chroot.d/gpusb.conf
[gpusb]
description=Debian Jessie
directory=$(pwd)/chroot
root-users=root
type=directory
users=root
EOF

schroot -c gpusb /bin/bash  <<'EOF'
CURRENT_FOLDER=$(pwd)
apt-key update
apt-get update
apt-get install nano smbclient wget live-boot pciutils -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"



echo "install kernel build dependencies"
apt-get -y install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc g++

echo "download 4.4 kernel"
if [ ! -f ./linux-4.4.tar.xz ]; then
     wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.4.tar.xz
fi
tar -xJf linux-4.4.tar.xz
cd linux-4.4

echo "build 4.4 kernel" 
make olddefconfig
make -j$(nproc)
make modules_install
make install

#usermod -a -G video root


cd ..

#final touches
cp $CURRENT_FOLDER/issue /etc/issue
cp $CURRENT_FOLDER/getty@.service /lib/systemd/system/getty@.service
cp $CURRENT_FOLDER/hostname /etc/hostname
rm -rf /etc/debian_chroot
exit
EOF

