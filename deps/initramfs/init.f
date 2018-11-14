#!/bin/busybox sh

[ -d /dev ] || mkdir -m 0755 /dev
[ -d /root ] || mkdir -m 0700 /root
[ -d /sys ] || mkdir /sys
[ -d /proc ] || mkdir /proc
[ -d /tmp ] || mkdir /tmp
mkdir -p /var/lock
mount -t sysfs -o nodev,noexec,nosuid sysfs /sys
mount -t proc -o nodev,noexec,nosuid proc /proc

# Note that this only becomes /dev on the real filesystem if udev's scripts
# are used; which they will be, but it's worth pointing out
tmpfs_size="10M"
if [ -e /etc/udev/udev.conf ]; then
        . /etc/udev/udev.conf
fi
if ! mount -t devtmpfs -o size=$tmpfs_size,mode=0755 udev /dev; then
        echo "W: devtmpfs not available, falling back to tmpfs for /dev"
        mount -t tmpfs -o size=$tmpfs_size,mode=0755 udev /dev
        [ -e /dev/console ] || mknod -m 0600 /dev/console c 5 1
        [ -e /dev/null ] || mknod /dev/null c 1 3
fi
mkdir /dev/pts
mount -t devpts -o noexec,nosuid,gid=5,mode=0620 devpts /dev/pts || true
mount -t tmpfs -o "nosuid,size=20%,mode=0755" tmpfs /run

mknod /dev/fd0 b 2 0
mknod /dev/fd1 b 2 1
mknod /dev/hda b 3 0
mknod /dev/hda1 b 3 1
mknod /dev/hda2 b 3 2
mknod /dev/hda3 b 3 3
mknod /dev/hda4 b 3 4
mknod /dev/hda5 b 3 5
mknod /dev/hda6 b 3 6
mknod /dev/hda7 b 3 7
mknod /dev/hda8 b 3 8
mknod /dev/hdb b 3 64
mknod /dev/hdb1 b 3 65
mknod /dev/hdb2 b 3 66
mknod /dev/hdb3 b 3 67
mknod /dev/hdb4 b 3 68
mknod /dev/hdb5 b 3 69
mknod /dev/hdb6 b 3 70
mknod /dev/hdb7 b 3 71
mknod /dev/hdb8 b 3 72
mknod /dev/hdc b 22 0
mknod /dev/hdc1 b 22 1
mknod /dev/hdc2 b 22 2
mknod /dev/hdc3 b 22 3
mknod /dev/hdc4 b 22 4
mknod /dev/hdc5 b 22 5
mknod /dev/hdc6 b 22 6
mknod /dev/hdc7 b 22 7
mknod /dev/hdc8 b 22 8
mknod /dev/hdd b 22 64
mknod /dev/hdd1 b 22 65
mknod /dev/hdd2 b 22 66
mknod /dev/hdd3 b 22 67
mknod /dev/hdd4 b 22 68
mknod /dev/hdd5 b 22 69
mknod /dev/hdd6 b 22 70
mknod /dev/hdd7 b 22 71
mknod /dev/hdd8 b 22 72
mknod /dev/sda b 8 0
mknod /dev/sda1 b 8 1
mknod /dev/sda2 b 8 2
mknod /dev/sda3 b 8 3
mknod /dev/sda4 b 8 4
mknod /dev/sda5 b 8 5
mknod /dev/sda6 b 8 6
mknod /dev/sda7 b 8 7
mknod /dev/sda8 b 8 8
mknod /dev/sdb b 8 16
mknod /dev/sdb1 b 8 17
mknod /dev/sdb2 b 8 18
mknod /dev/sdb3 b 8 19
mknod /dev/sdb4 b 8 20
mknod /dev/sdb5 b 8 21
mknod /dev/sdb6 b 8 22
mknod /dev/sdb7 b 8 23
mknod /dev/sdb8 b 8 24
mknod /dev/sr0 b 11 0
mknod /dev/sr1 b 11 1
mknod /dev/tty c 5 0
mknod /dev/console c 5 1
mknod /dev/tty1 c 4 1
mknod /dev/tty2 c 4 2
mknod /dev/tty3 c 4 3
mknod /dev/tty4 c 4 4
mknod /dev/ram b 1 1
mknod /dev/mem c 1 1
mknod /dev/kmem c 1 2
mknod /dev/null c 1 3
mknod /dev/zero c 1 5



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
