#!/bin/bash
set -e -x

# Check if we are running this script as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo privileges!" 1>&2
   exit 1
fi

CURRENT_FOLDER=$(pwd)
KERNEL_FOLDER=__bin/kernel
SCHROOT_INSTANCE=gpusb


rm -rf $KERNEL_FOLDER
mkdir -p $KERNEL_FOLDER

cd $CURRENT_FOLDER/$KERNEL_FOLDER
echo "download 4.4 kernel"
if [ ! -f ./linux-4.4.tar.xz ]; then
     wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.4.tar.xz
fi
tar -xJf linux-4.4.tar.xz
cd linux-4.4

cp $CURRENT_FOLDER/deps/kernel/.config .

echo "build 4.4 kernel" 
#make olddefconfig
make -j$(nproc)
cd $CURRENT_FOLDER

schroot -c $SCHROOT_INSTANCE /bin/bash  <<'EOF'
CURRENT_FOLDER=$(pwd)


make modules_install
#make install
cd $KERNEL_FOLDER/linux-4.4

rm -rf /etc/debian_chroot
exit
EOF


