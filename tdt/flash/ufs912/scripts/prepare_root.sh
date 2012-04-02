#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPKERNELDIR=$4
TMPFWDIR=$5

cp -a $RELEASEDIR/* $TMPROOTDIR

mv $TMPROOTDIR/boot/uImage $TMPKERNELDIR/uImage

mv $TMPROOTDIR/boot/audio.elf $TMPFWDIR/audio.elf
mv $TMPROOTDIR/boot/video.elf $TMPFWDIR/video.elf

mv $TMPROOTDIR/boot/bootlogo.mvi $TMPROOTDIR/etc/bootlogo.mvi
sed -i "s/\/boot\/bootlogo.mvi/\/etc\/bootlogo.mvi/g" $TMPROOTDIR/etc/init.d/rcS

rm -f $TMPROOTDIR/boot/*

echo "/dev/mtdblock3	/boot	jffs2	defaults	0	0" >> $TMPROOTDIR/etc/fstab
#echo "/dev/mtdblock5	/root	jffs2	defaults	0	0" >> $TMPROOTDIR/etc/fstab


cd $TMPROOTDIR/dev/
MAKEDEV="sudo $TMPROOTDIR/sbin/MAKEDEV -p $TMPROOTDIR/etc/passwd -g $TMPROOTDIR/etc/group"
${MAKEDEV} std
${MAKEDEV} fd
${MAKEDEV} hda hdb
${MAKEDEV} sda sdb sdc sdd
${MAKEDEV} scd0 scd1
${MAKEDEV} st0 st1
${MAKEDEV} sg
${MAKEDEV} ptyp ptyq
${MAKEDEV} console
${MAKEDEV} ttyAS0 ttyAS1 ttyAS2 ttyAS3
${MAKEDEV} lp par audio video fb rtc lirc st200 alsasnd 
${MAKEDEV} ppp busmice
${MAKEDEV} input i2c mtd
${MAKEDEV} mme bpamem
${MAKEDEV} dvb
${MAKEDEV} vfd
${MAKEDEV} rc
${MAKEDEV} hdmi_cec
${MAKEDEV} ttyusb
${MAKEDEV} sci
cd -
