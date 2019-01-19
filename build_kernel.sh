#! /bin/bash -e 


echo "Setting Environmental Variables."

TX_BASE_DIR=$(pwd)
export KERNEL_SOURCE=$TX_BASE_DIR/sources/kernel
export BIN_DIR=$TX_BASE_DIR/__bin
export KERNEL_OUT=$BIN_DIR/kernel


export BOOTLOADER_OUT=$BIN_DIR/boot_partition

export MODULE_OUT=$KERNEL_OUT/module_deploy
#export HEADER_OUT_PATH=$KERNEL_OUT/header_deploy

export DEFAULT_CONFIG=defconfig


#export BUILD_TAG=v4.14.89
export BUILD_TAG=v4.19.12
#export BUILD_TAG=v4.14.91


export KERNEL_SOURCE_GIT="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"

# Get kernel Source
if [[ ! -d $KERNEL_SOURCE ]]; then
git clone --depth 1 -b $BUILD_TAG $KERNEL_SOURCE_GIT $KERNEL_SOURCE
fi

# Download and apply patches
pushd $KERNEL_SOURCE
#wget --content-disposition http://...
#git apply .....patch
popd

mkdir -p $MODULE_OUT
cd $KERNEL_SOURCE
  make  -j$(nproc) mrproper
  make O=$KERNEL_OUT -j$(nproc) $DEFAULT_CONFIG
  make O=$KERNEL_OUT -j$(nproc) menuconfig
  make O=$KERNEL_OUT -j$(nproc) bzImage modules
  make O=$KERNEL_OUT modules_install INSTALL_MOD_PATH=$MODULE_OUT
echo "Kernel Build Finished"


mkdir -p $BOOTLOADER_OUT

cp $KERNEL_OUT/arch/x86/boot/bzImage $BOOTLOADER_OUT

