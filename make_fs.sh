#!/bin/bash
apt-get install squashfs-tools -y
mkdir image/live
rm image/live/filesystem.squashfs
sudo mksquashfs chroot/ image/live/filesystem.squashfs -e boot
