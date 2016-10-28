#!/bin/bash

# by Joerg Neikes 
# version from 28.10.2016
# license GPL 2

# for use in /usr/src to compile the /usr/src/linux kernel
# rasberry tools are needed to for this script

# Global settings 
raspnew="bcm2709"
raspold="bcmrpi"

# make default config
echo "Do you want default configs? If so write \"YES\""
read defaultconfigs

# get the hardware we are on
rasphardware=$(grep Hardware /proc/cpuinfo | awk '{ print tolower($3)}')

distcc_hosts="DISTCC_HOSTS=\"192.168.10.72\""
chost="CHOST=\"armv6j-hardfloat-linux-gnueabi\""
cflags="CFLAGS=\"-O2 -pipe -march=armv6j -mfpu=vfp -mfloat-abi=hard\""
cxxflags="CXXFLAGS=\"\${CFLAGS}\""
distccmake="CC=\"distcc armv6j-hardfloat-linux-gnueabi-gcc\""
distcxxmake="CXX=\"distcc armv6j-hardfloat-linux-gnueabi-g++\""


# same for all systems
source /etc/profile
cd ${PWD}/linux
# echo "We clean up"
# make clean

# settings for bcm2709
if [ $rasphardware = $raspnew ]
then 
echo "we are on a $raspnew system"
defconfig="${rasphardware}_defconfig"
KERNEL="kernel7"
if [ ${defaultconfigs} = "YES" ]
then
echo "defconfig is $defconfig"
make $defconfig
fi
J="-j4"
sleep 2
make $J zImage modules dtbs

## enable DISTCC
#DISTCC_HOSTS="192.168.10.72 genarm genarm" CHOST="armv6j-hardfloat-linux-gnueabi" CFLAGS="-O2 -pipe -march=armv6j -mfpu=vfp -mfloat-abi=hard" CXXFLAGS="${CFLAGS}" make CC="distcc armv6j-hardfloat-linux-gnueabi-gcc" CXX="distcc armv6j-h$
# make CC="distcc armv6j-hardfloat-linux-gnueabi-gcc" CXX="distcc armv6j-hardfloat-linux-gnueabi-g++" ${J} zImage modules dtbs

else 
echo "we are on a $raspold system"
defconfig="${raspold}_defconfig"
KERNEL="kernel"
if [ ${defaultconfigs} = "YES" ]
then
echo "defconfig is $defconfig"
make $defconfig
fi
J="-j1"
sleep 2
make $J zImage modules dtbs

## enable DISTCC
#DISTCC_HOSTS="192.168.10.72 genarm genarm" CHOST="armv6j-hardfloat-linux-gnueabi" CFLAGS="-O2 -pipe -march=armv6j -mfpu=vfp -mfloat-abi=hard" CXXFLAGS="${CFLAGS}" make CC="distcc armv6j-hardfloat-linux-gnueabi-gcc" CXX="distcc armv6j-h$
# make CC="distcc armv6j-hardfloat-linux-gnueabi-gcc" CXX="distcc armv6j-hardfloat-linux-gnueabi-g++" ${J} zImage modules dtbs

fi

echo "make modules_install"
make modules_install

cp arch/arm/boot/dts/*.dtb /boot/
cp arch/arm/boot/dts/overlays/*.dtb /boot/overlays/
cp arch/arm/boot/dts/overlays/README /boot/overlays/
scripts/mkknlimg arch/arm/boot/zImage /boot/$KERNEL.img


