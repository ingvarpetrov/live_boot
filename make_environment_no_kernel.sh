#!/bin/bash
# build chroot
apt-get install debootstrap schroot -y
rm -rf MediaServerStudioProfessionalEvaluation2017
rm -rf MediaServerStudioProfessionalEvaluation2017.tar.gz 

rm -rf chroot
mkdir chroot
MIRROR="http://ftp.ca.debian.org/debian"
sudo debootstrap --variant=buildd --variant=minbase --arch amd64 jessie chroot/ $MIRROR 
# create scroot config
rm -rf /etc/schroot/chroot.d/gpusb.conf
cat <<EOF >/etc/schroot/chroot.d/gpusb.conf
[gpusb]
description=Debian Jessie
directory=$(pwd)/chroot
root-users=root
type=directory
users=root
EOF

schroot -c gpusb /bin/bash  <<'EOF'
CURRENT_FOLDER=$(pwd)
apt-key update
apt-get update
apt-get install nano mesa-common-dev cmake libx11-dev smbclient wget pkg-config live-boot libpthread-stubs0-dev libpciaccess-dev libxfixes3 kmod pciutils xz-utils -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"


smbget smb://ansible:PS5[ct@192.168.129.15/hevc_dev/imss/MediaServerStudioProfessionalEvaluation2017.tar.gz
tar -xzf MediaServerStudioProfessionalEvaluation2017.tar.gz
cd MediaServerStudioProfessionalEvaluation2017

tar -xzf SDK2017Production16.5.tar.gz 
cd SDK2017Production16.5/Generic


echo "remove other libdrm/libva"
find /usr -name "libdrm*" | xargs rm -rf
find /usr -name "libva*" | xargs rm -rf

echo "Remove old MSS install files ..."
rm -rf /opt/intel/mediasdk
rm -rf /opt/intel/common
rm -rf /opt/intel/opencl


echo "install user mode components"
#unpack the generic package
tar -xvzf intel-linux-media_generic*.tar.gz
tar -xvJf intel-opencl-16.5*.xz
tar -xvJf intel-opencl-devel-16.5*.xz

#put the generic components in standard locations

/bin/cp -r etc/* /etc
/bin/cp -r lib/* /lib
/bin/cp -r opt/* /opt
/bin/cp -r usr/* /usr

#ensure that new libraries can be found
echo '/usr/lib64' > /etc/ld.so.conf.d/libdrm_intel.conf
echo '/usr/local/lib' >> /etc/ld.so.conf.d/libdrm_intel.conf
ldconfig

echo "install kernel build dependencies"
apt-get -y install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc g++


sh -c "echo \"LIBVA_DRIVER_NAME=iHD\" >> /etc/environment"
sh -c "echo \"LIBVA_DRIVERS_PATH=/opt/intel/mediasdk/lib64/\" >> /etc/environment"
sh -c "echo \"LD_LIBRARY_PATH=\"/usr/lib64\;/usr/local/lib\"\" >> /etc/environment"
 cat /etc/environment

usermod -a -G video root


cd ..

cp /opt/intel/mediasdk/opensource/libdrm/*/libdrm-2.4.66.tar.bz2 .
tar xf libdrm-2.4.66.tar.bz2
cd libdrm-2.4.66
./configure --prefix=/usr/local
make -j$(nproc)
make install

cd ..
cp /opt/intel/mediasdk/opensource/libva/*/libva-1.67.0.pre1.tar.bz2 .
tar xf libva-1.67.0.pre1.tar.bz2
cd libva-1.67.0.pre1
./configure --prefix=/usr/local --with-drivers-path=/opt/intel/mediasdk/lib64
make -j$(nproc)
make install


smbget smb://ansible:PS5[ct@192.168.129.15/hevc_dev/imss/system_analyzer.py -o /opt/intel/mediasdk/system_analyzer.py

python2.7 /opt/intel/mediasdk/system_analyzer.py

cd /opt/intel/mediasdk/samples/ 
./sample_multi_transcode -i::h265 streams/test_stream.265 -o::h265 /dev/null

#final touches
cp $CURRENT_FOLDER/issue /etc/issue
cp $CURRENT_FOLDER/getty@.service /lib/systemd/system/getty@.service
cp $CURRENT_FOLDER/hostname /etc/hostname
rm -rf /etc/debian_chroot
cp /opt/intel/mediasdk/tools/metrics_monitor/_bin/libcttmetrics.so /opt/intel/mediasdk/lib/lin_x64/
exit
EOF

