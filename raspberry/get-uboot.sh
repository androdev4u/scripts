#!/bin/bash

SCRIPTDIR=$(dirname "$0")

EXPORTDIR="${SCRIPTDIR}/u-boot"

raspold="bcm2708"
raspnew="bcm2709"
cpurasp2="5"
cpurasp3="4"

GITTOUSE="git://git.denx.de/u-boot.git"

# The Gits to chose from:

# git clone git://git.denx.de/u-boot.git ${EXPORTDIR} # no keyboard
# git clone -b rpi git://github.com/gonzoua/u-boot-pi.git u-boot-pi 

# git clone git://github.com/swarren/u-boot.git
# git checkout -b rpi_dev origin/rpi_dev


# Do you really want to run?

echo "Run the script? Write \"Yes\" !"
read RUN

if [ $RUN != Yes ] ; then
exit 0
fi


# if the ${EXPORTDIR} is there we do nothing, otherwise we check u-boot out.
if [ ! -d "${EXPORTDIR}" ]; then
git clone ${GITTOUSE} ${EXPORTDIR}
fi


# Get the hardware settings
rasphardware=$(grep Hardware /proc/cpuinfo | awk '{ print tolower($3)}')
cpurev=$(grep "CPU revision" /proc/cpuinfo | head -n 1 | awk '{ print ($4)}')


# choosing the right rasp config

cd ${EXPORTDIR}

if [[ $rasphardware == $raspold ]] ; then 
echo RASPI1
#make rpi_defconfig
#make all
fi

if [[ $rasphardware == $raspnew && $cpurev  == $cpurasp2 ]]  ; then 
echo RASPI2
#make rpi_2_defconfig
#make all
fi


if [[ $rasphardware == $raspnew && $cpurev  == $cpurasp3 ]] ; then 
echo RASPI3
#make rpi_3_32b_defconfig
#make all
fi
