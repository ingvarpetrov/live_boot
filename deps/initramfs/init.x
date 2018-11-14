#!/bin/busybox sh

[ -e /dev/mem ] || mknod -m 660 /dev/mem c 1 1

# Mount the /proc and /sys filesystems.
mount -t proc none /proc
mount -t sysfs none /sys
mount -t efivarfs none /sys/firmware/efi/efivars

[ -d /dev ] || mkdir -m 0755 /dev
[ -d /root ] || mkdir -m 0700 /root
[ -d /sys ] || mkdir /sys
[ -d /proc ] || mkdir /proc
[ -d /tmp ] || mkdir /tmp

mkdir -p /var/lock
mount -t sysfs -o nodev,noexec,nosuid none /sys 
mount -t proc -o nodev,noexec,nosuid none /proc 
tmpfs_size="10M"
if [ -e /etc/udev/udev.conf ]; then
 . /etc/udev/udev.conf
fi
mount -t tmpfs -o size=$tmpfs_size,mode=0755 udev /dev

[ -e /dev/console ] || mknod -m 0600 /dev/console c 5 1
[ -e /dev/null ] || mknod /dev/null c 1 3


[ -e /dev/fd0 ] || mknod /dev/fd0 b 2 0
[ -e /dev/fd1 ] || mknod /dev/fd1 b 2 1
[ -e /dev/hda ] || mknod /dev/hda b 3 0
[ -e /dev/hda1 ] || mknod /dev/hda1 b 3 1
[ -e /dev/hda2 ] || mknod /dev/hda2 b 3 2
[ -e /dev/hda3 ] || mknod /dev/hda3 b 3 3
[ -e /dev/hda4 ] || mknod /dev/hda4 b 3 4
[ -e /dev/hda5 ] || mknod /dev/hda5 b 3 5
[ -e /dev/hda6 ] || mknod /dev/hda6 b 3 6
[ -e /dev/hda7 ] || mknod /dev/hda7 b 3 7
[ -e /dev/hda8 ] || mknod /dev/hda8 b 3 8
[ -e /dev/hdb ] || mknod /dev/hdb b 3 64
[ -e /dev/hdb1 ] || mknod /dev/hdb1 b 3 65
[ -e /dev/hdb2 ] || mknod /dev/hdb2 b 3 66
[ -e /dev/hdb3 ] || mknod /dev/hdb3 b 3 67
[ -e /dev/hdb4 ] || mknod /dev/hdb4 b 3 68
[ -e /dev/hdb5 ] || mknod /dev/hdb5 b 3 69
[ -e /dev/hdb6 ] || mknod /dev/hdb6 b 3 70
[ -e /dev/hdb7 ] || mknod /dev/hdb7 b 3 71
[ -e /dev/hdb8 ] || mknod /dev/hdb8 b 3 72
[ -e /dev/hdc ] || mknod /dev/hdc b 22 0
[ -e /dev/hdc1 ] || mknod /dev/hdc1 b 22 1
[ -e /dev/hdc2 ] || mknod /dev/hdc2 b 22 2
[ -e /dev/hdc3 ] || mknod /dev/hdc3 b 22 3
[ -e /dev/hdc4 ] || mknod /dev/hdc4 b 22 4
[ -e /dev/hdc5 ] || mknod /dev/hdc5 b 22 5
[ -e /dev/hdc6 ] || mknod /dev/hdc6 b 22 6
[ -e /dev/hdc7 ] || mknod /dev/hdc7 b 22 7
[ -e /dev/hdc8 ] || mknod /dev/hdc8 b 22 8
[ -e /dev/hdd ] || mknod /dev/hdd b 22 64
[ -e /dev/hdd1 ] || mknod /dev/hdd1 b 22 65
[ -e /dev/hdd2 ] || mknod /dev/hdd2 b 22 66
[ -e /dev/hdd3 ] || mknod /dev/hdd3 b 22 67
[ -e /dev/hdd4 ] || mknod /dev/hdd4 b 22 68
[ -e /dev/hdd5 ] || mknod /dev/hdd5 b 22 69
[ -e /dev/hdd6 ] || mknod /dev/hdd6 b 22 70
[ -e /dev/hdd7 ] || mknod /dev/hdd7 b 22 71
[ -e /dev/hdd8 ] || mknod /dev/hdd8 b 22 72
[ -e /dev/sda ] || mknod /dev/sda b 8 0
[ -e /dev/sda1 ] || mknod /dev/sda1 b 8 1
[ -e /dev/sda2 ] || mknod /dev/sda2 b 8 2
[ -e /dev/sda3 ] || mknod /dev/sda3 b 8 3
[ -e /dev/sda4 ] || mknod /dev/sda4 b 8 4
[ -e /dev/sda5 ] || mknod /dev/sda5 b 8 5
[ -e /dev/sda6 ] || mknod /dev/sda6 b 8 6
[ -e /dev/sda7 ] || mknod /dev/sda7 b 8 7
[ -e /dev/sda8 ] || mknod /dev/sda8 b 8 8
[ -e /dev/sdb ] || mknod /dev/sdb b 8 16
[ -e /dev/sdb1 ] || mknod /dev/sdb1 b 8 17
[ -e /dev/sdb2 ] || mknod /dev/sdb2 b 8 18
[ -e /dev/sdb3 ] || mknod /dev/sdb3 b 8 19
[ -e /dev/sdb4 ] || mknod /dev/sdb4 b 8 20
[ -e /dev/sdb5 ] || mknod /dev/sdb5 b 8 21
[ -e /dev/sdb6 ] || mknod /dev/sdb6 b 8 22
[ -e /dev/sdb7 ] || mknod /dev/sdb7 b 8 23
[ -e /dev/sdb8 ] || mknod /dev/sdb8 b 8 24
[ -e /dev/sr0 ] || mknod /dev/sr0 b 11 0
[ -e /dev/sr1 ] || mknod /dev/sr1 b 11 1
[ -e /dev/tty ] || mknod /dev/tty c 5 0
[ -e /dev/console ] || mknod /dev/console c 5 1
[ -e /dev/tty1 ] || mknod /dev/tty1 c 4 1
[ -e /dev/tty2 ] || mknod /dev/tty2 c 4 2
[ -e /dev/tty3 ] || mknod /dev/tty3 c 4 3
[ -e /dev/tty4 ] || mknod /dev/tty4 c 4 4
[ -e /dev/ram ] || mknod /dev/ram b 1 1
[ -e /dev/mem ] || mknod /dev/mem c 1 1
[ -e /dev/kmem ] || mknod /dev/kmem c 1 2
[ -e /dev/null ] || mknod /dev/null c 1 3
[ -e /dev/zero ] || mknod /dev/zero c 1 5


mkdir -p /mnt/usb
mount /dev/sda1 /mnt/usb


# Set up network interface and pull rootfs.
ifconfig eth0 up
#udhcpc -t 5 -q -s /dhcp.helper

mkdir -p /mnt/ram
##########################3
sh

set -- $(cat /mnt/usb/boot/boot.xml | grep -oE '<Filename>.*<\/Filename>' | sed -e 's/<[^>]*>//g')
FS_TYPE=$(awk -F"\"" ' /BootSequence/ {print $8}' /mnt/usb/boot/boot.xml)
echo "FS_TYPE: $FS_TYPE"

if  [  "$FS_TYPE" == "ingvarpack" ]; then
mkdir -p /mnt/ram
mount none /mnt/ram -t tmpfs -o size=1500m

for var in "$@"
do
    echo $var
    cd /mnt/ram
    zcat /mnt/usb/live/$var | cpio -idmuv
done
fi
# Clean up.
umount /mnt/usb
umount /proc
umount /sys

[ -e /dev/mem ] || mknod -m 660 /dev/mem c 1 1

sh
# Boot the real thing.
exec switch_root /mnt/ram /sbin/init
