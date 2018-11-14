#!/bin/bash
# unpack chroot initrd into temp dir
set -x 
# Check if we are running this script as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo privileges!" 1>&2
   exit 1
fi



START_PATH=$(pwd)

rm -rf __bin/_initramfs/initrd
mkdir -p __bin/_initramfs/inca/bin
cd __bin/_initramfs

[[ -d busybox ]] || git clone -b 1_26_stable https://github.com/mirror/busybox.git
cd busybox
cp -r $START_PATH/deps/busybox/.config .
make -j$(nproc)
make install
cp -r _install/* ../inca/ 
cd ..

cd inca
cp -r $START_PATH/deps/initramfs/* .

#mkdir -p $START_PATH/__bin/tftpboot/boot/
find . | cpio -H newc -o | gzip -9 > $START_PATH/__bin/initrd

cd $START_PATH
