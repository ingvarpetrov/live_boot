#!/bin/bash
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
    exit 0
fi

echo "Removing old partitions"
dd if=/dev/zero of=$TARGET_DEVICE  bs=512  count=1000
echo "create partition"
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${TARGET_DEVICE}
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +1GB # 100 MB boot parttion
  a # make a partition bootable
  1 # bootable partition is partition 1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF
echo "label partition"
mkfs -t ext2  ${TARGET_DEVICE}1 
tune2fs -L gpusb ${TARGET_DEVICE}1
echo "copying files"

mkdir /mnt/usb

TARGET="/mnt/usb"
mount ${TARGET_DEVICE}1 ${TARGET}
sync
mkdir -p ${TARGET}/boot/extlinux ${TARGET}/live

apt-get install extlinux -y

extlinux -i ${TARGET}/boot/extlinux
dd if=deps/boot/mbr.bin of=${TARGET_DEVICE}
umount /mnt/usb
