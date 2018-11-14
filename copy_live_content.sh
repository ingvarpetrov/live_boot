#!/bin/bash
TARGET="/mnt/usb"
BIN="__bin"
mount /dev/disk/by-label/gpusb ${TARGET}
#sudo ./make_fs.sh

rm -rf ${TARGET}/*

mkdir -p ${TARGET}/boot/extlinux
cp $BIN/kernel/linux-4.4/arch/x86_64/boot/bzImage ${TARGET}/vmlinuz
cp $BIN/initrd ${TARGET}/initrd
cp $BIN/layer_base_os.tar.gz ${TARGET}/


cp deps/boot/boot.xml $TARGET/
cp -r deps/boot/extlinux/* ${TARGET}/boot/extlinux/
cp deps/boot/ldlinux.sys /${TARGET}
sync
extlinux -i ${TARGET}/boot/extlinux

umount ${TARGET}
