#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPEXTDIR=$4
TMPKERNELDIR=$5
TMPFWDIR=$6

cp -a $RELEASEDIR/* $TMPROOTDIR

mv $TMPROOTDIR/usr/local/* $TMPEXTDIR

mv $TMPROOTDIR/boot/uImage $TMPKERNELDIR/uImage

mv $TMPROOTDIR/boot/audio.elf $TMPFWDIR/audio.elf
mv $TMPROOTDIR/boot/video.elf $TMPFWDIR/video.elf

mv $TMPROOTDIR/boot/bootlogo.mvi $TMPROOTDIR/etc/bootlogo.mvi
sed -i "s/\/boot\/bootlogo.mvi/\/etc\/bootlogo.mvi/g" $TMPROOTDIR/etc/init.d/rcS

rm -f $TMPROOTDIR/boot/*

echo "/dev/mtdblock2	/boot	jffs2	defaults	0	0" >> $TMPROOTDIR/etc/fstab
echo "/dev/mtdblock3	/usr/local	jffs2	defaults	0	0" >> $TMPROOTDIR/etc/fstab


if [  -e $CURDIR/extras/dev_at7500.tar.gz ]; then
  sudo tar -xzf $CURDIR/extras/dev_at7500.tar.gz -C $TMPROOTDIR/dev/
fi
