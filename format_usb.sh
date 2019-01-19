#!/bin/bash

TX_BASE_DIR=$(pwd)
export DEPS_DIR=$TX_BASE_DIR/deps
export MOUNT_DIR="/mnt/usb"


# Check if we are running this script as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo privileges!" 1>&2
   exit 1
fi

ls -l /dev/disk/by-id/usb* | grep -Eio '(/sd?..)'
if ! [ $? -eq 0 ]
then
  echo "No USB Flash drives found" >&2
  exit 1
fi

DEVICES_COUNT=$(ls -l /dev/disk/by-id/usb* | grep -Eio '(/sd.{1}$)' | wc -l)
if  [ $DEVICES_COUNT != 1 ]
then
	echo "more than one USB Flash drives attached"
	exit 1
fi

TARGET_DEVICE="/dev$(ls -l /dev/disk/by-id/usb* | grep -Eio '(/sd.{1}$)')"

echo "USB Flash drive" $TARGET_DEVICE  "found"

read -p "Proceed? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if  [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Interrupted"
    exit 0
fi

echo "Removing old partitions"
wipefs -a $TARGET_DEVICE
dd if=/dev/zero of=$TARGET_DEVICE  bs=512  count=1000

echo "create partition"
parted -s $TARGET_DEVICE mklabel msdos mkpart primary ext4 1M 100% set 1 boot on
sudo mkfs.ext4  ${TARGET_DEVICE}1
e2label ${TARGET_DEVICE}1 LIVE-USB
sync

echo "copying Bootloader files files"

mkdir -p $MOUNT_DIR/boot/extlinux

mount ${TARGET_DEVICE}1 $MOUNT_DIR
cp -a $DEPS_DIR/bootloader/boot/ $MOUNT_DIR

apt-get install extlinux -y
extlinux -i $MOUNT_DIR/boot/extlinux
dd if=$DEPS_DIR/bootloader/mbr.bin of=${TARGET_DEVICE}

sync
umount $MOUNT_DIR
