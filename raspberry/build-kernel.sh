#!/bin/bash

# by Joerg Neikes 
# version from 14.02.2016
# license GPL3

# for use in /usr/src to compile the /usr/src/linux kernel
# rasberry tools are needed to for this script

# for distcc setup please use thisn on rasp:
# nano /usr/lib/distcc/bin/armv6j-hardfloat-linux-gnueabi-wrapper
# #!/bin/bash
# exec /usr/lib/distcc/bin/armv6j-hardfloat-linux-gnueabi-g${0:$[-2]} "$@"
# cd /usr/lib/distcc/bin 
# rm c++ g++ gcc cc 
# chmod a+x /usr/lib/distcc/bin/armv6j-hardfloat-linux-gnueabi-wrapper
# ln -s armv6j-hardfloat-linux-gnueabi-wrapper cc && ln -s armv6j-hardfloat-linux-gnueabi-wrapper gcc && ln -s armv6j-hardfloat-linux-gnueabi-wrapper g++ && ln -s armv6j-hardfloat-linux-gnueabi-wrapper c++


# Global settings 
raspnew="bcm2709"

# get the hardware we are on
rasphardware=$(grep Hardware /proc/cpuinfo | awk '{ print tolower($3)}')

distcc_hosts="DISTCC_HOSTS=\"192.168.10.72 genarm genarm\""
chost="CHOST=\"armv6j-hardfloat-linux-gnueabi\""
cflags="CFLAGS=\"-O2 -pipe -march=armv6j -mfpu=vfp -mfloat-abi=hard\""
cxxflags="CXXFLAGS=\"\${CFLAGS}\""
distccmake="CC=\"distcc armv6j-hardfloat-linux-gnueabi-gcc\""
distcxxmake="CXX=\"distcc armv6j-hardfloat-linux-gnueabi-g++\""
J="-j5"

# same for all systems
source /etc/profile
cd ${PWD}/linux
echo "We clean up"
make clean


# settings for bcm2709
if [ $rasphardware = $raspnew ]
then
echo "we are on a $raspnew system"
defconfig="${rasphardware}_defconfig"
echo "defconfig is $defconfig"
make ARCH=arm $defconfig
fi


## enabel DISTCC
#DISTCC_HOSTS="192.168.10.72 genarm genarm" CHOST="armv6j-hardfloat-linux-gnueabi" CFLAGS="-O2 -pipe -march=armv6j -mfpu=vfp -mfloat-abi=hard" CXXFLAGS="${CFLAGS}" make CC="distcc armv6j-hardfloat-linux-gnueabi-gcc" CXX="distcc armv6j-hardfloat-linux-gnueabi-g++" ${J}

make CC="distcc armv6j-hardfloat-linux-gnueabi-gcc" CXX="distcc armv6j-hardfloat-linux-gnueabi-g++" ${J} zImage modules dtbs


echo "make modules_install"
make modules_install
cp /usr/src/tools/mkimage/* ${PWD}
cp arch/arm/boot/dts/*.dtb /boot/
cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
cp arch/arm/boot/dts/overlays/README /boot/overlays/

${PWD}/imagetool-uncompressed.py ${PWD}/arch/arm/boot/Image
cp ${PWD}/arch/arm/boot/Image  /boot/kernel7.img

