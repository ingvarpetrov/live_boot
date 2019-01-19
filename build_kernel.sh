#! /bin/bash -e 


echo "Setting Environmental Variables."

TX_BASE_DIR=$(pwd)
export KERNEL_SOURCE=$TX_BASE_DIR/sources/kernel
export BIN_DIR=$TX_BASE_DIR/__bin
export KERNEL_OUT=$BIN_DIR/kernel

export ROOTFS_PATH=$BIN_DIR/rootfs
export BOOT_DIR=$BIN_DIR/p1

export BOOTLOADER_OUT=$BIN_DIR/boot_partition

export MODULE_OUT_PATH=$KERNEL_OUT/module_deploy
export HEADER_OUT_PATH=$KERNEL_OUT/header_deploy

#export DEFAULT_CONFIG=bcm2835_defconfig
#export DEFAULT_CONFIG=multi_v7_defconfig
#export DEFAULT_CONFIG=bcm2709_defconfig
#export DEFAULT_CONFIG=defconfig
export DEFAULT_CONFIG=mvebu_v8_lsp_defconfig


#export BUILD_TAG=v4.14.89
#export BUILD_TAG=v4.19.12
#export BUILD_TAG=v4.14.91
export BUILD_TAG=linux-4.4.52-armada-17.10


#export KERNEL_SOURCE_GIT="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
export KERNEL_SOURCE_GIT="https://github.com/MarvellEmbeddedProcessors/linux-marvell"

# Get kernel Source
if [[ ! -d $KERNEL_SOURCE ]]; then
git clone --depth 1 -b $BUILD_TAG $KERNEL_SOURCE_GIT $KERNEL_SOURCE
fi


pushd $KERNEL_SOURCE
#wget --content-disposition http://wiki.espressobin.net/tiki-download_file.php?fileId=168
#wget --content-disposition http://wiki.espressobin.net/tiki-download_file.php?fileId=169

#git apply 0003-dts-espressobin-add-emmc-support.patch
#git apply 0004-dts-espressobin-swapped-wan-and-lan1-port-mapping-fo.patch
popd

#cp deps/kernel/$DEFAULT_CONFIG $KERNEL_SOURCE/arch/arm/configs/

## Check Toolchain
export TCH_DIR=__bin/toolchain
if [[ ! -d $TCH_DIR ]]; then
echo "please install toolchain using ./set_toolchain.sh"
exit
fi

source $TCH_DIR/exports
export CROSS_COMPILE=$CROSS_COMPILE
export ARCH=$ARCH

cd $KERNEL_SOURCE
  make  -j$(nproc) mrproper
  make O=$KERNEL_OUT -j$(nproc) $DEFAULT_CONFIG
  make O=$KERNEL_OUT -j$(nproc) menuconfig
  make O=$KERNEL_OUT -j$(nproc) Image dtbs modules



echo "Kernel Build Finished"


mkdir -p $BOOTLOADER_OUT
cp $KERNEL_OUT/arch/arm64/boot/{Image,dts/marvell/armada-3720-community.dtb} $BOOTLOADER_OUT