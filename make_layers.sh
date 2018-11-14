#!/bin/bash

CURRENT_FOLDER=$(pwd)
CHROOT_FOLDER=__bin/chroot


rm -rf $CURRENT_FOLDER/__bin/layer_base_os
mkdir -p $CURRENT_FOLDER/__bin/layer_base_os
cp -rp $CURRENT_FOLDER/$CHROOT_FOLDER/* $CURRENT_FOLDER/__bin/layer_base_os/

###fix me
#chmod 4577 $CURRENT_FOLDER/__bin/layer_base_os/usr/bin/sudo
####

cd $CURRENT_FOLDER/__bin/layer_base_os/
rm etc/debian_chroot
rm -rf $CURRENT_FOLDER/__bin/layer_base_os.cpio.gz

find . | fakeroot cpio -H newc -ov | pigz --fast -p$(nproc) > $CURRENT_FOLDER/__bin/layer_base_os.cpio.gz
#find . | fakeroot cpio -H newc -ov | pigz -9 -p$(nproc) > $CURRENT_FOLDER/__bin/layer_base_os.cpio.gz


