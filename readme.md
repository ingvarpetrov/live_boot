# Create Live USB with Intel Media SDK

This project contains a set of shell scripts that do the following:
* build Debian Jessie file system
* install Intel Media SDK libraries, include files, and compiled samples
* compile Linux 4.4 kernel with Media SDK support
* format USB flash drive
  * install Extlinux bootloader onto the flash drive
  * compress Debian filesystem into squashfs binary
  * copy squashfs.filesystem and supporting files onto USB flash drive

# Usage
## Build environment
```
sudo ./make_environment.sh 
```
The script uses debootstrap tool to create minimal Debian Jessie environment. It fetches Intel Media Studio Professional Evaluation from Inca Networks file server. Kernel configuration is also stored on the file server.
to make changes into the environment (add some executables, etc.) run 
```
sudo schroot -c gpusb
```
and do your thing...
## Make bootable usb stick
```
sudo ./format_usb.sh
```
make sure that you have only one USB Stick plugged into the system
## Create Squashfs filesystem
```
sudo ./make_fs.sh
```
## Copy files onto the USB Stick
```
sudo ./copy_live_content.sh
```

